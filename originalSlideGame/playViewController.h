//
//  playViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/24.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface playViewController : UIViewController <UIAlertViewDelegate>
- (IBAction)playButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property UIBarButtonItem *trashBtn; // 削除ボタン

@property NSMutableArray *randNums;

@property NSInteger pathNo; // CollectionViewからセルの番号を引継ぐ
@property NSArray *divPicturesData; // CollectionViewから該当するゲームの配列を引継ぐ


// ハコことなるview
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;

// ハコに入れるimage (tag 11〜19)
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (weak, nonatomic) IBOutlet UIImageView *image9;


// 見本用 (tag 21〜29)
@property (weak, nonatomic) IBOutlet UIImageView *mihon9;


// tap判定用の透明view (tag 1〜9)


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


// タイマーで使用するプロパティ
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property NSTimer *myTimer;  // 一定間隔でなにかする為のタイマー
@property BOOL isStart;      // タイマーが動いているかのフラグ
@property BOOL isFstCalled;  // タイマーがはじめて呼ばれたフラグ
@property float second;       // 秒を表す変数
@property float timerCount;
@property NSString *playTime;


@property (weak, nonatomic) IBOutlet UIView *sampleView;
@property (weak, nonatomic) IBOutlet UIImageView *sampleImageView;

- (IBAction)testBtn:(id)sender; // ゲームを中断するためのボタン
@property (weak, nonatomic) IBOutlet UIButton *testBtn2;

@property (weak, nonatomic) IBOutlet UIView *forHideView4;

@property (weak, nonatomic) IBOutlet UILabel *bestTimeLabel;

@end
