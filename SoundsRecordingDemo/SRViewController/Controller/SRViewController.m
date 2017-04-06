//
//  SRViewController.m
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/30.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import "SRViewController.h"
#import "SRButton.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceWaveView.h"
#import "RecordTool.h"
#import "SRTimerLabel.h"
#import "GlobalMethods.h"

@interface SRViewController ()<RecordToolDelegate>
@property (nonatomic,strong) VoiceWaveView *voiceWaveViewNew;
@property (nonatomic,strong) UIView *voiceWaveParentViewNew;
@property (nonatomic,strong) RecordTool *recordTool;
@property (nonatomic,strong) SRTimerLabel *timerLabel;
@property (nonatomic,strong) SRButton *recordBtn;
@property (nonatomic,strong) SRButton *cancelBtn;
@property (nonatomic,strong) SRButton *selectBtn;
@end

@implementation SRViewController

- (void)dealloc{
    [self.recordTool invalidateTimer];
}

-(void)setupNavigationBar{
    self.title = @"语音";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftItem setFrame:CGRectMake(0, 0, 50, 20)];
        [leftItem setTitle:@"取消" forState:UIControlStateNormal];
        [leftItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [leftItem.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [leftItem addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
        leftItem;
    })];
}
-(void)leftItemAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-  LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.voiceWaveParentViewNew atIndex:1];
    [self recordTool];
    [self.view addSubview:self.timerLabel];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.selectBtn];
}

#pragma mark-  开始录制声音
-(void)touchUpInsideAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //************开始录制************
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recordTool startRecording];
        });
    }else{
        //************结束录制***********
        double currentTime = self.recordTool.recorder.currentTime;
        if (currentTime < 3) {
            AlertWithInputMessage(@"录制时间不能少于3秒");
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.recordTool stopRecording];
                [self.recordTool destructionRecordingFile];
            });
        } else {
            [sender setHidden:YES];
            [_selectBtn setHidden:NO];
            [_cancelBtn setHidden:NO];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.recordTool stopRecording];
            });
            [self finishedRecording];
        }
    }
}

#pragma mark-  完成录音，开始动画
-(void)finishedRecording{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelBtn.transform = CGAffineTransformMakeTranslation(-100, 0);
        self.selectBtn.transform = CGAffineTransformMakeTranslation(100, 0);
    } completion:nil];
}

#pragma mark-  事件监听
-(void)cancelAction:(UIButton *)sender{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recordTool stopPlaying];
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
    });
    self.timerLabel.second = 0;
    [self.view bringSubviewToFront:self.recordBtn];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelBtn.transform = CGAffineTransformMakeTranslation(0, 0);
        self.selectBtn.transform = CGAffineTransformMakeTranslation(0, 0);
        [self.recordBtn setHidden:NO];
    } completion:^(BOOL finished) {
        [self.cancelBtn setHidden:YES];
        [self.selectBtn setHidden:YES];
    }];
}

-(void)selectAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        /************开始播放**********/
        [self.recordTool playRecordingFile];
    }else{
        
        self.timerLabel.second = self.recordTool.player.currentTime;
        /************暂停播放**********/
        [self.recordTool pausePlaying];
    }
}

#pragma mark-  RecordToolDelegate
-(void)recordTool:(RecordTool *)recordTool didStartRecoring:(CGFloat)value{
    [_voiceWaveViewNew changeVolume:value];
    self.timerLabel.second = self.recordTool.recorder.currentTime;
    if(self.recordTool.player.isPlaying) self.timerLabel.second = self.recordTool.player.currentTime;
}
-(void)recordTool:(RecordTool *)recordTool didFinishedPlayer:(AVAudioPlayer *)player{
    /*********播放成功后,修改播放按钮的选择状态*********/
    _selectBtn.selected = NO;
    self.timerLabel.second = self.recordTool.player.duration;
}

#pragma mark - getters
- (VoiceWaveView *)voiceWaveViewNew{
    if (!_voiceWaveViewNew) {
        self.voiceWaveViewNew = [[VoiceWaveView alloc] init];
        [_voiceWaveViewNew setVoiceWaveNumber:6];
    }
    return _voiceWaveViewNew;
}

- (UIView *)voiceWaveParentViewNew{
    if (!_voiceWaveParentViewNew) {
        self.voiceWaveParentViewNew = [[UIView alloc] init];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _voiceWaveParentViewNew.frame = CGRectMake(0, 100, screenSize.width, 320);
        [self.voiceWaveViewNew showInParentView:self.voiceWaveParentViewNew];
        [self.voiceWaveViewNew startVoiceWave];
    }
    return _voiceWaveParentViewNew;
}

-(RecordTool *)recordTool{
    if (!_recordTool) {
        self.recordTool = [RecordTool sharedRecordTool];
        self.recordTool.delegate = self;
    }
    return _recordTool;
}

-(SRTimerLabel *)timerLabel{
    if (!_timerLabel) {
        self.timerLabel = [[SRTimerLabel alloc] init];
    }
    return _timerLabel;
}

-(SRButton *)recordBtn{
    if (!_recordBtn) {
        self.recordBtn = [[SRButton alloc] init];
        [self.recordBtn addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}
-(SRButton *)selectBtn{
    if (!_selectBtn) {
        self.selectBtn = [SRButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = _recordBtn.frame;
        [self.selectBtn setHidden:YES];
        [self.selectBtn setImage:[UIImage imageNamed:@"drop_record_btn_ok_nor"] forState:UIControlStateNormal];
        [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
-(SRButton *)cancelBtn{
    if (!_cancelBtn) {
        self.cancelBtn = [SRButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = _recordBtn.frame;
        [self.cancelBtn setHidden:YES];
        [self.cancelBtn setImage:[UIImage imageNamed:@"drop_record_btn_del_nor"] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


@end
