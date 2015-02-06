//
//  resultViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;
- (IBAction)retryBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *retryBtn2;
- (IBAction)goTitleBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *resultTime;

@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;


@property NSString *result; // タイムを受け取る
@property NSInteger pathNo; // パスNo.(配列の何番目か)を受け取る
@property NSMutableArray *divPicturesData; // プレイ中のゲーム配列を受け取る
@property int playingArrayCount; // プレイ中のゲーム配列の個数(10コor17コ)※リダイレクト先を変えるため


@end
