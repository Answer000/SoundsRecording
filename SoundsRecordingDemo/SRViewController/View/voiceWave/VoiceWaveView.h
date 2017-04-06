//
//  VoiceWaveView.h
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/30.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShowLoadingCircleCallback)(void);

@interface VoiceWaveView : UIView

/**
 *  添加并初始化波纹视图
 *
 *  @param parentView                 父视图
 */
- (void)showInParentView:(UIView *)parentView;

/**
 *  设置波纹个数，默认两个
 *
 *  @param waveNumber                 波纹个数
 */
- (void)setVoiceWaveNumber:(NSInteger)waveNumber;

/**
 *  开始声波动画
 */
- (void)startVoiceWave;

/**
 *  改变音量来改变声波振动幅度
 *
 *  @param volume                  音量大小 大小为0~1
 */
- (void)changeVolume:(CGFloat)volume;

/**
 *  移掉声波
 */
- (void)removeFromParent;

@end
