//
//  ViewController.m
//  SoundsRecordingDemo
//
//  Created by 澳蜗科技 on 2017/3/30.
//  Copyright © 2017年 AnswerXu. All rights reserved.
//

#import "ViewController.h"
#import "SRViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SRViewController *srVC = [[SRViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:srVC];
    [self presentViewController:navi animated:YES completion:nil];
}


@end
