//
//  SRButton.m
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/30.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import "SRButton.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width
#define ScreenH  [UIScreen mainScreen].bounds.size.height

@implementation SRButton

#pragma mark-  Intial Methods
-(instancetype)init {
    if (self = [super init]) {
        UIImage *normalImage = [UIImage imageNamed:@"drop_record_btn_start_nor"];
        UIImage *selectedImage = [UIImage imageNamed:@"drop_record_btn_stop_nor"];
        self.bounds = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
        self.center = CGPointMake(ScreenW * 0.5, ScreenH - 100 - self.bounds.size.height * 0.5);
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self setImage:normalImage forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
        [self setTitle:@"点击开始" forState:UIControlStateNormal];
        [self setTitle:@"点击停止" forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark-  System Methods
-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.frame = CGRectMake(-10, self.bounds.size.width + 5, self.bounds.size.width + 20, self.titleLabel.bounds.size.height);

}


@end
