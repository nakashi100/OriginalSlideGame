//
//  titleViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import <iAd/iAd.h>

@interface titleViewController : UIViewController<ADBannerViewDelegate, ADInterstitialAdDelegate>

@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (weak, nonatomic) IBOutlet FUIButton *playButton;
@property (weak, nonatomic) IBOutlet FUIButton *createButton;

- (IBAction)useDefaultReset:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *useDefaultReset2;

@property int createdFlag; // ゲーム作成後のリダイレクト判定用 1 or 2
@property BOOL deletedFlag; // ゲーム削除後のリダイレクト判定用

@property int pathNo; // ゲーム作成後にpathNoを受け取る

@property (weak, nonatomic) IBOutlet ADBannerView *add_1;


@end
