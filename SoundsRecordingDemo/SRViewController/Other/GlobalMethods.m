//
//  GlobalMethods.m
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/31.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import "GlobalMethods.h"

void AlertWithInputMessage(NSString *message) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil,nil];
    [alert show];
}


