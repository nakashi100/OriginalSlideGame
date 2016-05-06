//
//  resultViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "FlatUIKit.h"
#import <iAd/iAd.h>
#import <MoPub/MPAdView.h>


@interface resultViewController : UIViewController <ADInterstitialAdDelegate, MPAdViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;

- (IBAction)retryBtn:(id)sender;
@property (weak, nonatomic) IBOutlet FUIButton *retryBtn2;

- (IBAction)goTitleBtn:(id)sender;
@property (weak, nonatomic) IBOutlet FUIButton *goTitleBtn2;

@property (weak, nonatomic) IBOutlet UILabel *resultTime;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property NSString *result; // タイムを受け取る
@property NSInteger pathNo; // パスNo.(配列の何番目か)を受け取る
@property NSMutableArray *divPicturesData; // プレイ中のゲーム配列を受け取る
@property int playingArrayCount; // プレイ中のゲーム配列の個数(10コor17コ)※リダイレクト先を変えるため
@property ADInterstitialAd *iAdInterstitial;

@property (nonatomic, retain) MPAdView *adView; // Mopub

@end
