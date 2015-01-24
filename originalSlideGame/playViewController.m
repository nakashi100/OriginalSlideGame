//
//  playViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/24.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "playViewController.h"

@interface playViewController ()

@end

@implementation playViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playButton:(id)sender {
    // 9のtagを削除する
    [self.view9 removeFromSuperview];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view.tag == 9) {
        [self.view9 removeFromSuperview];
        NSLog(@"成功");
    }else {
        NSLog(@"失敗");
    }
}
@end
