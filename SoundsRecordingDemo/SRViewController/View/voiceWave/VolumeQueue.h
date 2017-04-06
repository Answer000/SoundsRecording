//
//  VolumeQueue.h
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/30.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolumeQueue : NSObject

- (void)pushVolume:(CGFloat)volume;
- (void)pushVolumeWithArray:(NSArray *)array;
- (CGFloat)popVolume;
- (void)cleanQueue;

@end

