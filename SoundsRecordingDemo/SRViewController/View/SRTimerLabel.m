//
//  SRTimerLabel.m
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/31.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import "SRTimerLabel.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width
#define ScreenH  [UIScreen mainScreen].bounds.size.height

@implementation SRTimerLabel
#pragma mark-  Intial Methods
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    self.textColor = [UIColor darkGrayColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:30];
    self.text = [NSString stringWithFormat:@"00:00:00"];
}

-(void)setSecond:(NSTimeInterval)second{
    _second = second;
    NSInteger hour = second/3600;
    NSInteger min = (NSInteger)(second / 60) % 60;
    NSInteger sec = (NSInteger)second % 60;
    self.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,min,sec];
}
#pragma mark-  System Methods
-(void)layoutSubviews {
    [super layoutSubviews];
    self.center = CGPointMake(ScreenW * 0.5, 150);
    self.bounds = CGRectMake(0, 0, 150, 30);
}

@end
