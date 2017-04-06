//
//  RecordTool.h
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/30.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RecordTool;
@protocol RecordToolDelegate <NSObject>
@optional
-(void)recordTool:(RecordTool *)recordTool didStartRecoring:(CGFloat)value;
-(void)recordTool:(RecordTool *)recordTool didFinishedPlayer:(AVAudioPlayer *)player;
@end

@interface RecordTool : NSObject

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;
/** 开始录音 */
- (void)startRecording;
/** 停止录音 */
- (void)stopRecording;
/** 播放录音文件 */
- (void)playRecordingFile;
/** 停止播放录音文件 */
- (void)stopPlaying;
/** 暂停播放录音文件 */
- (void)pausePlaying;
/** 销毁录音文件 */
- (void)destructionRecordingFile;
/** 销毁定时器对象 */
- (void)invalidateTimer;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;
/** 更新音量参数的代理 */
@property (nonatomic, assign) id<RecordToolDelegate> delegate;

@end
