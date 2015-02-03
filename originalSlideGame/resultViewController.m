//
//  resultViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "resultViewController.h"
#import "playViewController.h"
#import "listCollectionViewController.h"

@interface resultViewController ()

@end

@implementation resultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    self.twitterImage.image = [UIImage imageNamed:@"mihonSample"];
    self.resultTime.text = self.result;
    
    self.playingArrayCount = [self.divPicturesData count];
    
    // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.divPicturesData forKey:@"nowPlaying"];
    [userDefault synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // retryBtnが押されたときだけ実行するようにsenderにtagをつけて条件処理する
    if ([sender tag] == 2) {
         listCollectionViewController *listCollectionView = [segue destinationViewController];
        listCollectionView.playingArrayCount = self.playingArrayCount;
    }
    
}

- (IBAction)retryBtn:(id)sender {
}

- (IBAction)goTitleBtn:(id)sender {
    
}
@end
