//
//  hardPlayViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/02/02.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import <iAd/iAd.h>
#import <MoPub/MPAdView.h>


@interface hardPlayViewController : UIViewController <FUIAlertViewDelegate, MPAdViewDelegate>

- (IBAction)playButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property UIBarButtonItem *trashBtn; // 削除ボタン
@property (weak, nonatomic) IBOutlet UILabel *timeLapLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property NSMutableArray *randNums;

@property NSInteger pathNo; // CollectionViewからセルの番号を引継ぐ
@property NSArray *divPicturesData; // CollectionViewから該当するゲームの配列を引継ぐ

@property FUIAlertView *deleteAlertView;


// 正解判定用のハコことなるview (tagなし)
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;
@property (weak, nonatomic) IBOutlet UIView *view10;
@property (weak, nonatomic) IBOutlet UIView *view11;
@property (weak, nonatomic) IBOutlet UIView *view12;
@property (weak, nonatomic) IBOutlet UIView *view13;
@property (weak, nonatomic) IBOutlet UIView *view14;
@property (weak, nonatomic) IBOutlet UIView *view15;
@property (weak, nonatomic) IBOutlet UIView *view16;

// ハコに入れる画像用のimage (tag 21〜36)
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (weak, nonatomic) IBOutlet UIImageView *image9;
@property (weak, nonatomic) IBOutlet UIImageView *image10;
@property (weak, nonatomic) IBOutlet UIImageView *image11;
@property (weak, nonatomic) IBOutlet UIImageView *image12;
@property (weak, nonatomic) IBOutlet UIImageView *image13;
@property (weak, nonatomic) IBOutlet UIImageView *image14;
@property (weak, nonatomic) IBOutlet UIImageView *image15;
@property (weak, nonatomic) IBOutlet UIImageView *image16;

// 見本用 (tag )
@property (weak, nonatomic) IBOutlet UIImageView *mihon9;

// tap判定用の透明view (tag 1〜16)

// 管理用の配列
@property NSMutableArray *viewArray1;
@property NSMutableArray *viewArray2;
@property NSMutableArray *viewArray3;
@property NSMutableArray *viewArray4;
@property NSMutableArray *viewArray5;
@property NSMutableArray *viewArray6;
@property NSMutableArray *viewArray7;
@property NSMutableArray *viewArray8;
@property NSMutableArray *viewArray9;
@property NSMutableArray *viewArray10;
@property NSMutableArray *viewArray11;
@property NSMutableArray *viewArray12;
@property NSMutableArray *viewArray13;
@property NSMutableArray *viewArray14;
@property NSMutableArray *viewArray15;
@property NSMutableArray *viewArray16;

// 分割画像用のプロパティ
@property UIImage *pic0;    // 完成画像
@property UIImage *pic1;    // 分割画像
@property UIImage *pic2;
@property UIImage *pic3;
@property UIImage *pic4;
@property UIImage *pic5;
@property UIImage *pic6;
@property UIImage *pic7;
@property UIImage *pic8;
@property UIImage *pic9;
@property UIImage *pic10;
@property UIImage *pic11;
@property UIImage *pic12;
@property UIImage *pic13;
@property UIImage *pic14;
@property UIImage *pic15;
@property UIImage *pic16;

// タイマーで使用するプロパティ
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property NSTimer *myTimer;  // 一定間隔でなにかする為のタイマー
@property BOOL isStart;      // タイマーが動いているかのフラグ
@property BOOL isFstCalled;  // タイマーがはじめて呼ばれたフラグ
@property float second;       // 秒を表す変数
@property float timerCount;
@property NSString *playTime;

@property (weak, nonatomic) IBOutlet UIView *sampleView;
@property (weak, nonatomic) IBOutlet UIImageView *samplePic;
@property (weak, nonatomic) IBOutlet UIImageView *sampleImageView;

- (IBAction)testBtn:(id)sender; // ゲームを中断するためのボタン
@property (weak, nonatomic) IBOutlet UIButton *testBtn2;
@property (weak, nonatomic) IBOutlet UIView *forHideView4;
@property (weak, nonatomic) IBOutlet UILabel *bestTimeLabel;

@property (nonatomic, retain) MPAdView *adView; // Mopub

@end
