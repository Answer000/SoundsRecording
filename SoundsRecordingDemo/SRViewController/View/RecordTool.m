//
//  RecordTool.m
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/30.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import "RecordTool.h"

@interface RecordTool () <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;
/** 定时器 */
@property (nonatomic, strong) NSTimer *updateVolumeTimer;

@property (nonatomic, strong) AVAudioSession *session;

@end

#define RecordFielName @"record.caf"
@implementation RecordTool

#pragma mark - 单例
static id instance;
+ (instancetype)sharedRecordTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

#pragma mark-  getter
-(AVAudioSession *)session{
    if (!_session) {
        _session = [AVAudioSession sharedInstance];
    }
    return _session;
}

-(NSTimer *)updateVolumeTimer{
    if (!_updateVolumeTimer) {
        _updateVolumeTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateVolume) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_updateVolumeTimer forMode:NSRunLoopCommonModes];
        [_updateVolumeTimer fire];
    }
    return _updateVolumeTimer;
}

- (void)startRecording {
    /*******录音时停止播放 删除曾经生成的文件*********/
    [self stopPlaying];
    [self destructionRecordingFile];
    
    /*******定时器开始*********/
    [self resumeTimer];
    /*******真机环境下需要的代码*********/
    NSError *sessionError;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(self.session == nil){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [self.session setActive:YES error:nil];
    }
    [self.recorder record];
}

- (void)updateVolume {
    [self.recorder updateMeters];
    CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 20);
    
    if ([_delegate respondsToSelector:@selector(recordTool:didStartRecoring:)]) {
        [_delegate recordTool:self didStartRecoring:normalizedValue];
    }
}

#pragma mark-  停止录音
- (void)stopRecording {
    if ([self.recorder isRecording]) {
        /*****停止录音******/
        [self.recorder stop];
        /*****暂停计时器******/
        [self pauseTimer];
    }
}

- (void)playRecordingFile {
    //*********** 播放时停止录音 ***********
    [self.recorder stop];
    //*********** 正在播放就返回 ***********
    if ([self.player isPlaying]) return;
    
    /*****复位定时器******/
    [self resumeTimer];
    /*****播放录音******/
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:NULL];
    self.player.delegate = self;
    self.player.enableRate = YES;
    [self.session setActive:YES error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)stopPlaying {
    [self.player stop];
}

- (void)pausePlaying {
    [self.player pause];
}

#pragma mark - 懒加载
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        //***********获取沙盒地址***********
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:RecordFielName];
        _recordFileUrl = [NSURL fileURLWithPath:filePath];
        //********设置录音的一些参数*********
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        //***********音频格式***********
        setting[AVFormatIDKey] = @(kAudioFormatAppleIMA4);
        //*****录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）****
        setting[AVSampleRateKey] = @(96000);
        //***********音频通道数 1 或 2***********
        setting[AVNumberOfChannelsKey] = @(1);
        //***********线性音频的位深度  8、16、24、32***********
        setting[AVLinearPCMBitDepthKey] = @(8);
        //***********录音的质量***********
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:setting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        
        [_recorder prepareToRecord];
    }
    return _recorder;
}

#pragma mark-  销毁录音
-(void)destructionRecordingFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.recordFileUrl) {
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag) {
        [self.session setActive:NO error:nil];
    }
}

#pragma mark-  AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        /******播放成功，暂停定时器******/
        [self pauseTimer];
        if ([_delegate respondsToSelector:@selector(recordTool:didFinishedPlayer:)]) {
            [_delegate recordTool:self didFinishedPlayer:player];
        }
    }
}

#pragma mark-  销毁定时器
-(void)invalidateTimer{
    [self.updateVolumeTimer invalidate];
    self.updateVolumeTimer = nil;
}
#pragma mark-  暂停定时器
-(void)pauseTimer{
    if (!self.updateVolumeTimer.isValid) {
        return;
    }
    [self.updateVolumeTimer setFireDate:[NSDate distantFuture]];
}
#pragma mark-  复位定时器
-(void)resumeTimer{
    if (!self.updateVolumeTimer.isValid) {
        return;
    }
    [self.updateVolumeTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

@end
