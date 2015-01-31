//
//  resultViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "resultViewController.h"
#import "playViewController.h"

@interface resultViewController ()

@end

@implementation resultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.twitterImage.image = [UIImage imageNamed:@"mihonSample"];
    
    self.resultTime.text = self.result;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)retryBtn:(id)sender {
    // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.divPicturesData forKey:@"nowPlaying"];
    [userDefault synchronize];
}

- (IBAction)goTitleBtn:(id)sender {
}
@end
