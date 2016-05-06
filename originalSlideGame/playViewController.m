//
//  playViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/24.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "playViewController.h"
#import "resultViewController.h"
#import "titleViewController.h"
#import "FlatUIKit.h"

//アラート画面のタグを宣言
static const NSInteger firstAlertTag = 1;
static const NSInteger secondAlertTag = 2;

@interface playViewController ()

@end

@implementation playViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ゲームリスト画面以外から来た場合(self.divPicturesDataが空の場合)は、forKey:nowPlayingでゲーム配列をセットする(result時か作成時に保存している)
    if(!self.divPicturesData){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        self.divPicturesData = [userDefault arrayForKey:@"nowPlaying"];
    }
    
    // 写真のデータをdata型からimage型に変換する
    for (int i=0; i<10; i++) {
        // self.pic0 = [UIImage imageWithData:self.divPicturesData[0]]; //やりたい処理はこれの繰り返し
        NSString *picNum = [NSString stringWithFormat:@"pic%d", i];
        [self setValue:[UIImage imageWithData:self.divPicturesData[i]] forKey:picNum]; // このクラス(self)のプロパティにvalueをセットする
    }
    
    // 写真のimageを各viewにセットする
    for (int i=1; i<10; i++) {
        //　self.image1.image = self.pic1; //やりたい処理はこれの繰り返し
        NSString *imageViewNum = [NSString stringWithFormat:@"image%d", i]; //こっちがうまくいかない
        NSString *picNum = [NSString stringWithFormat:@"pic%d", i]; //こっちはOK
        
        UIImageView *imageView = [self valueForKey:imageViewNum]; //これがself.image1(UIImageView型)となる
        UIImage *pic = [self valueForKey:picNum]; //これがself.pic1(UIImage型)となる
        
        imageView.image = pic; //写真をセット
    }
    
    //タイマーの初期設定
    self.isStart = NO;
    self.isFstCalled = NO;
    
    // Mopub
    // TODO: Replace this test id with your personal ad unit id
    MPAdView* adView = [[MPAdView alloc] initWithAdUnitId:@"0fd404de447942edb7610228cb412614"
                                                     size:MOPUB_BANNER_SIZE];
    self.adView = adView;
    self.adView.delegate = self;
    
    // Positions the ad at the bottom, with the correct size
    self.adView.frame = CGRectMake(0, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    
    // Loads the ad over the network
    [self.adView loadAd];

}


- (void)viewWillAppear:(BOOL)animated{
    // NSLog(@"play%d",self.pathNo);
    
    // 画面のレイアウト
    self.timeLabel.font = [UIFont flatFontOfSize:20];
    self.timeLapLabel.font = [UIFont flatFontOfSize:20];
    
    UIImage *playImage = [UIImage imageNamed:@"play2"];
    [self.playBtn setBackgroundImage:playImage forState:UIControlStateNormal];
    
    UIImage *sampleImage = [UIImage imageNamed:@"hint"];
    self.samplePic.image = sampleImage;
    
    UIImage *testImage = [UIImage imageNamed:@"pause1"];
    [self.testBtn2 setBackgroundImage:testImage forState:UIControlStateNormal];
    
    
    // ナビゲーションバーに削除ボタンを設置
    self.trashBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAlert)];
    self.navigationItem.rightBarButtonItem = self.trashBtn;
    
    // デフォルトゲームは削除できないようにnavigationの削除ボタンを非表示&無効にする
    if(self.pathNo == 0){
        [self.trashBtn setEnabled:NO];
        self.trashBtn.tintColor = [UIColor colorWithWhite:0 alpha:0];
    }
    self.testBtn2.hidden = YES;
    self.sampleView.hidden = YES;
    
    
    // ベストタイムの更新(resultページからリダイレクトできた場合にもベストタイムを参照できるようにする)
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *normalFinalList = [userDefault arrayForKey:@"normalFinalList"];
    int countArray = [normalFinalList[self.pathNo] count];
    
    if (countArray == 11) {
        NSString *bestTime = [NSString stringWithFormat:@"( BEST: %6.2f )",[normalFinalList[self.pathNo][10] floatValue]];
        self.bestTimeLabel.text = bestTime;
        self.bestTimeLabel.font = [UIFont boldFlatFontOfSize:14];
    }else if(countArray == 10){
        self.bestTimeLabel.text = nil;
    }
    
    // スワイプによる戻りを無効化する
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)playButton:(id)sender {
    
    // navigationの削除ボタンを非表示&無効にする
    [self.trashBtn setEnabled:NO];
    self.trashBtn.tintColor = [UIColor colorWithWhite:0 alpha:0];
    
    // ボタンを非表示→表示に切り替える
    self.testBtn2.hidden = NO;
    self.sampleView.hidden = NO;
    
    // image9(tag:19)を削除する
     [[self.view viewWithTag:19] removeFromSuperview];
    
 
    // image1〜8の中の数字を並び替える
    int pattern = [self createRndArray];
    // int pattern = 9; // テスト用
    [self puzzlePattern:pattern];
    
    // タイマーを起動する
    [self timerStart];
    
    // STARTボタンを消す
    UIView *playBtn = [self.view viewWithTag:40];
    [playBtn removeFromSuperview];
    
    // forHideビューを消して、各種ボタンが表示・タップできるようにする
    [self.forHideView4 removeFromSuperview];
}


//重複しない乱数を発生させるメソッド(1〜8)
-(int)createRndArray{
    
    //配列を初期化
    self.randNums = [NSMutableArray array];
    //要素になる数字
    NSInteger num;
    
    //要素を満たすまで繰り返す
    while (self.randNums.count < 8) {
        //乱数
        num = arc4random() % 8 + 1;
        
        //要素を検索
        NSUInteger index = [self.randNums indexOfObject:@(num)];
        
        if(index == NSNotFound){
            [self.randNums addObject:@(num)];
        }
    }
    return [self.randNums[0] intValue];
}



/*********************************************************************************
                                スライドした時の処理
*********************************************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // NSLog(@"タッチしたビューは、%@", touch.view);
    // CGPoint location = [[touches anyObject] locationInView:self];
    // NSLog(@"タッチした座標は、%@", location);
    
    
    switch (touch.view.tag) {
        //--------------------------------------------------------------------------
        case 1:
            
            if([self.viewArray2[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray1[1] intValue] xzahyo:(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray2 = [@[self.viewArray1[0],self.viewArray1[1],self.viewArray1[2]]mutableCopy];
                self.viewArray1 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray4[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray1[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray4 = [@[self.viewArray1[0],self.viewArray1[1],self.viewArray1[2]]mutableCopy];
                self.viewArray1 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 2:
            
            if([self.viewArray1[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray2[1] intValue] xzahyo:-(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray1 = [@[self.viewArray2[0],self.viewArray2[1],self.viewArray2[2]]mutableCopy];
                self.viewArray2 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray3[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray2[1] intValue] xzahyo:(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray3 = [@[self.viewArray2[0],self.viewArray2[1],self.viewArray2[2]]mutableCopy];
                self.viewArray2 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray5[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray2[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray5 = [@[self.viewArray2[0],self.viewArray2[1],self.viewArray2[2]]mutableCopy];
                self.viewArray2 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 3:
            
            if([self.viewArray2[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray3[1] intValue] xzahyo:-(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray2 = [@[self.viewArray3[0],self.viewArray3[1],self.viewArray3[2]]mutableCopy];
                self.viewArray3 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray6[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray3[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray6 = [@[self.viewArray3[0],self.viewArray3[1],self.viewArray3[2]]mutableCopy];
                self.viewArray3 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 4:
            
            if([self.viewArray1[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray4[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray1 = [@[self.viewArray4[0],self.viewArray4[1],self.viewArray4[2]]mutableCopy];
                self.viewArray4 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray5[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray4[1] intValue] xzahyo:(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray5 = [@[self.viewArray4[0],self.viewArray4[1],self.viewArray4[2]]mutableCopy];
                self.viewArray4 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray7[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray4[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray7 = [@[self.viewArray4[0],self.viewArray4[1],self.viewArray4[2]]mutableCopy];
                self.viewArray4 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 5:
            
            if([self.viewArray2[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray5[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray2 = [@[self.viewArray5[0],self.viewArray5[1],self.viewArray5[2]]mutableCopy];
                self.viewArray5 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray4[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray5[1] intValue] xzahyo:-(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray4 = [@[self.viewArray5[0],self.viewArray5[1],self.viewArray5[2]]mutableCopy];
                self.viewArray5 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray6[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray5[1] intValue] xzahyo:(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray6 = [@[self.viewArray5[0],self.viewArray5[1],self.viewArray5[2]]mutableCopy];
                self.viewArray5 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray8[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray5[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray8 = [@[self.viewArray5[0],self.viewArray5[1],self.viewArray5[2]]mutableCopy];
                self.viewArray5 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 6:
            
            if([self.viewArray3[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray6[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray3 = [@[self.viewArray6[0],self.viewArray6[1],self.viewArray6[2]]mutableCopy];
                self.viewArray6 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray5[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray6[1] intValue] xzahyo:-(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray5 = [@[self.viewArray6[0],self.viewArray6[1],self.viewArray6[2]]mutableCopy];
                self.viewArray6 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray9[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray6[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray9 = [@[self.viewArray6[0],self.viewArray6[1],self.viewArray6[2]]mutableCopy];
                self.viewArray6 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 7:
            
            if([self.viewArray4[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray7[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray4 = [@[self.viewArray7[0],self.viewArray7[1],self.viewArray7[2]]mutableCopy];
                self.viewArray7 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray8[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray7[1] intValue] xzahyo:(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray8 = [@[self.viewArray7[0],self.viewArray7[1],self.viewArray7[2]]mutableCopy];
                self.viewArray7 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 8:
            
            if([self.viewArray5[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray8[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray5 = [@[self.viewArray8[0],self.viewArray8[1],self.viewArray8[2]]mutableCopy];
                self.viewArray8 = [@[@0,@0,@0]mutableCopy];
                
            }
            
            if([self.viewArray7[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray8[1] intValue] xzahyo:-(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray7 = [@[self.viewArray8[0],self.viewArray8[1],self.viewArray8[2]]mutableCopy];
                self.viewArray8 = [@[@0,@0,@0]mutableCopy];
                
            }
            
            if([self.viewArray9[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray8[1] intValue] xzahyo:(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray9 = [@[self.viewArray8[0],self.viewArray8[1],self.viewArray8[2]]mutableCopy];
                self.viewArray8 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        case 9:
            
            if([self.viewArray6[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray9[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+2)];
                
                // 配列の中身を入れ替える
                self.viewArray6 = [@[self.viewArray9[0],self.viewArray9[1],self.viewArray9[2]]mutableCopy];
                self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray8[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray9[1] intValue] xzahyo:-(self.image1.frame.size.width+2) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray8 = [@[self.viewArray9[0],self.viewArray9[1],self.viewArray9[2]]mutableCopy];
                self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
        //--------------------------------------------------------------------------
        
        // 完成画像(見本)を表示する
        case 100:
            self.sampleImageView.image = self.pic0;
            break;

        default:
            break;
    }
    
    [self judge];
}



// スライドを動かすメソッド (tag番号とx座標とy座標を指定する)
- (IBAction)slide:(int)test xzahyo:(int)xzahyo yzahyo:(int)yzahyo{
    [UIView animateWithDuration:0.08f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         int xx = [self.view viewWithTag:test].frame.origin.x;
                         int yy = [self.view viewWithTag:test].frame.origin.y;
                         
                         CGRect rect = CGRectMake(xx + xzahyo, yy + yzahyo, self.image1.frame.size.width, self.image1.frame.size.height);
                         [[self.view viewWithTag:test] setFrame:rect];
                     }
                     completion:^(BOOL finished){
                         // [[self.view viewWithTag:test] setBackgroundColor:[UIColor redColor]];
                     }
     ];
}


// パズル完成後の処理
- (void)judge {
    if(([self.viewArray1[2]intValue] == 1) && ([self.viewArray2[2]intValue] == 2) && ([self.viewArray3[2]intValue] == 3) && ([self.viewArray4[2]intValue] == 4) && ([self.viewArray5[2]intValue] == 5) && ([self.viewArray6[2]intValue] == 6) && ([self.viewArray7[2]intValue] == 7) && ([self.viewArray8[2]intValue] == 8)){
        
        // タイマーを止めて、タイムとプレイ中のゲーム配列を次ページへ引継ぐ
        [self.myTimer invalidate];
        resultViewController *resultView = [self.storyboard instantiateViewControllerWithIdentifier:@"resultView"];
        resultView.result = self.playTime;
        resultView.divPicturesData = self.divPicturesData;
        resultView.pathNo = self.pathNo;
        
        // Resultページへモーダルで遷移させる
        [self presentViewController:resultView animated:YES completion:nil];
    }
}



// タイマー機能メソッド
- (void)timerStart {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                               target:self
                                             selector:@selector(timer)  // 0.01秒毎にtimerを呼び出す
                                             userInfo:nil
                                              repeats:YES];
    self.isStart = YES;
    self.isFstCalled = YES;
}


- (void)timer{
    self.timerCount = self.timerCount + 0.01f; // 0.01秒ずつ足してゆく
    self.second = fmodf(self.timerCount, 10000); //00.00←ここのための処理。timerCount % 60(余剰)をsecondに入れたいが、float(double)では%が使えないのでfmodf(0,0)というのを使用
    // self.minute = self.timerCount / 60; //00:00:00.00←ここのための処理。timerCount ÷ 60 を minute に入れる
    
    // ラベルに表示する
    self.playTime = [NSString stringWithFormat:@"%6.2f", self.second]; //%05.2f は5桁で記述・小数点以下は2桁・不足は0で補う言う意味
    self.timerLabel.text = self.playTime;
}


// 完成画像(見本)を閉じる処理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    switch (touch.view.tag) {
        case 100:
            self.sampleImageView.image = nil;
            break;

        default:
            break;
    }
}



/*********************************************************************************
                ゲームの削除処理
 *********************************************************************************/

- (void)deleteAlert{

    self.deleteAlertView = [[FUIAlertView alloc] initWithTitle:@"Delete"
                                                          message:@"Do you want to delete this puzzle?"
                                                         delegate:self
                                                cancelButtonTitle:@"NO"
                                                otherButtonTitles:@"DELETE", nil];
    self.deleteAlertView.delegate = self;
    
    // タイトルの文字色の設定
    self.deleteAlertView.titleLabel.textColor = [UIColor cloudsColor];
    // タイトルの文字フォントの設定
    self.deleteAlertView.titleLabel.font = [UIFont boldFlatFontOfSize:18];
    // メッセージの文字色の設定
    self.deleteAlertView.messageLabel.textColor = [UIColor cloudsColor];
    // メッセージの文字フォントの設定
    self.deleteAlertView.messageLabel.font = [UIFont boldFlatFontOfSize:14];
    // オーバーレイ背景色の設定
    self.deleteAlertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    // 背景色の設定
    self.deleteAlertView.alertContainer.backgroundColor = [UIColor belizeHoleColor];
    // ボタン色の設定
    self.deleteAlertView.defaultButtonColor = [UIColor cloudsColor];
    // ボタンシャドー色の設定
    self.deleteAlertView.defaultButtonShadowColor = [UIColor asbestosColor];
    // ボタンの文字フォントの設定
    self.deleteAlertView.defaultButtonFont = [UIFont boldFlatFontOfSize:18];
    // ボタンの文字色の設定
    self.deleteAlertView.defaultButtonTitleColor = [UIColor asbestosColor];
    
    [self.deleteAlertView show];
    // 複数のdeleteAlertViewを管理するためにtagを使用
    self.deleteAlertView.tag = firstAlertTag;
}

// デリゲート処理
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == firstAlertTag){
        switch (buttonIndex) {
            case 1: // 1番目が押されたとき
                [self deleteGame];
                
                self.deleteAlertView.delegate = nil;
                break;
            
            default: // キャンセルが押されたとき
                break;
        }
    }
    
    if(alertView.tag == secondAlertTag){
        switch (buttonIndex) {
            case 1: // 1番目が押されたとき
                if(self.isFstCalled){
                    [self timerStart];
                    self.isStart = self.isStart;
                }
                break;
            
            default: // キャンセルが押されたとき
                // タイトル画面に戻る(unwindsegue manual)
                [self performSegueWithIdentifier:@"titleViewReturn" sender:self];
                break;
        }
    }
}

- (void)deleteGame {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSArray *normalFinalList = [userDefault arrayForKey:@"normalFinalList"];
    NSMutableArray *normalFinalListnew = [normalFinalList mutableCopy];
    [normalFinalListnew removeObjectAtIndex:self.pathNo];
    [userDefault setObject:normalFinalListnew forKey:@"normalFinalList"];
        

    titleViewController *titleViewController = [self.navigationController viewControllers][0];
    // titleViewController *titleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"titleView"];
    titleViewController.deletedFlag = YES;
    
    [self.navigationController popToRootViewControllerAnimated:NO]; // タイトル画面に戻る
    // [self.navigationController popViewControllerAnimated:YES];

}


/*********************************************************************************
                ゲームを止めるor続けるポップアップ画面
 *********************************************************************************/

- (IBAction)testBtn:(id)sender {
    
    // タイマーを止める
    if ((self.isStart) && (self.isFstCalled)) {
        [self.myTimer invalidate];
        self.isStart = !self.isStart;
    }
    
    
    // アラートビューの作成
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Break"
                                                          message:@"Do you want to continue or quit?"
                                                         delegate:self
                                                cancelButtonTitle:@"QUIT"
                                                otherButtonTitles:@"CONTINUE", nil];
    // タイトルの文字色の設定
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    // タイトルの文字フォントの設定
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:18];
    // メッセージの文字色の設定
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    // メッセージの文字フォントの設定
    alertView.messageLabel.font = [UIFont boldFlatFontOfSize:14];
    // オーバーレイ背景色の設定
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    // 背景色の設定
    alertView.alertContainer.backgroundColor = [UIColor belizeHoleColor];
    // ボタン色の設定
    alertView.defaultButtonColor = [UIColor cloudsColor];
    // ボタンシャドー色の設定
    alertView.defaultButtonShadowColor = [UIColor concreteColor];
    // ボタンの文字フォントの設定
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:18];
    // ボタンの文字色の設定
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    // 複数のAlertViewを管理するためにtagを使用
    
    [alertView show];
    alertView.tag = secondAlertTag;
}








/*********************************************************************************
                    解ける配列パターン(8種類以上もちたい)
 *********************************************************************************/
-(void)puzzlePattern:(int )num {
    
    switch (num) {
        case 1: // クリア
            self.image1.image = self.pic3;
            self.image2.image = self.pic6;
            self.image3.image = self.pic8;
            self.image4.image = self.pic4;
            self.image5.image = self.pic2;
            self.image6.image = self.pic5;
            self.image7.image = self.pic7;
            self.image8.image = self.pic1;
            
            self.viewArray1 = [@[@1,@11,@3]mutableCopy];
            self.viewArray2 = [@[@1,@12,@6]mutableCopy];
            self.viewArray3 = [@[@1,@13,@8]mutableCopy];
            self.viewArray4 = [@[@1,@14,@4]mutableCopy];
            self.viewArray5 = [@[@1,@15,@2]mutableCopy];
            self.viewArray6 = [@[@1,@16,@5]mutableCopy];
            self.viewArray7 = [@[@1,@17,@7]mutableCopy];
            self.viewArray8 = [@[@1,@18,@1]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];     //view9が最初に空になるので配列には{0,0,0}を入れておく
            
            break;
            
        case 2: //クリア
            self.image1.image = self.pic8;
            self.image2.image = self.pic7;
            self.image3.image = self.pic1;
            self.image4.image = self.pic2;
            self.image5.image = self.pic4;
            self.image6.image = self.pic3;
            self.image7.image = self.pic5;
            self.image8.image = self.pic6;
            
            self.viewArray1 = [@[@1,@11,@8]mutableCopy];
            self.viewArray2 = [@[@1,@12,@7]mutableCopy];
            self.viewArray3 = [@[@1,@13,@1]mutableCopy];
            self.viewArray4 = [@[@1,@14,@2]mutableCopy];
            self.viewArray5 = [@[@1,@15,@4]mutableCopy];
            self.viewArray6 = [@[@1,@16,@3]mutableCopy];
            self.viewArray7 = [@[@1,@17,@5]mutableCopy];
            self.viewArray8 = [@[@1,@18,@6]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 3: // クリア
            self.image1.image = self.pic7;
            self.image2.image = self.pic3;
            self.image3.image = self.pic1;
            self.image4.image = self.pic5;
            self.image5.image = self.pic8;
            self.image6.image = self.pic2;
            self.image7.image = self.pic6;
            self.image8.image = self.pic4;
            
            self.viewArray1 = [@[@1,@11,@7]mutableCopy];
            self.viewArray2 = [@[@1,@12,@3]mutableCopy];
            self.viewArray3 = [@[@1,@13,@1]mutableCopy];
            self.viewArray4 = [@[@1,@14,@5]mutableCopy];
            self.viewArray5 = [@[@1,@15,@8]mutableCopy];
            self.viewArray6 = [@[@1,@16,@2]mutableCopy];
            self.viewArray7 = [@[@1,@17,@6]mutableCopy];
            self.viewArray8 = [@[@1,@18,@4]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 4: // クリア
            self.image1.image = self.pic6;
            self.image2.image = self.pic4;
            self.image3.image = self.pic5;
            self.image4.image = self.pic3;
            self.image5.image = self.pic8;
            self.image6.image = self.pic7;
            self.image7.image = self.pic1;
            self.image8.image = self.pic2;
            
            self.viewArray1 = [@[@1,@11,@6]mutableCopy];
            self.viewArray2 = [@[@1,@12,@4]mutableCopy];
            self.viewArray3 = [@[@1,@13,@5]mutableCopy];
            self.viewArray4 = [@[@1,@14,@3]mutableCopy];
            self.viewArray5 = [@[@1,@15,@8]mutableCopy];
            self.viewArray6 = [@[@1,@16,@7]mutableCopy];
            self.viewArray7 = [@[@1,@17,@1]mutableCopy];
            self.viewArray8 = [@[@1,@18,@2]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 5: // クリア
            self.image1.image = self.pic3;
            self.image2.image = self.pic6;
            self.image3.image = self.pic5;
            self.image4.image = self.pic4;
            self.image5.image = self.pic7;
            self.image6.image = self.pic2;
            self.image7.image = self.pic1;
            self.image8.image = self.pic8;
            
            self.viewArray1 = [@[@1,@11,@3]mutableCopy];
            self.viewArray2 = [@[@1,@12,@6]mutableCopy];
            self.viewArray3 = [@[@1,@13,@5]mutableCopy];
            self.viewArray4 = [@[@1,@14,@4]mutableCopy];
            self.viewArray5 = [@[@1,@15,@7]mutableCopy];
            self.viewArray6 = [@[@1,@16,@2]mutableCopy];
            self.viewArray7 = [@[@1,@17,@1]mutableCopy];
            self.viewArray8 = [@[@1,@18,@8]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 6:  // クリア
            self.image1.image = self.pic8;
            self.image2.image = self.pic4;
            self.image3.image = self.pic6;
            self.image4.image = self.pic5;
            self.image5.image = self.pic2;
            self.image6.image = self.pic3;
            self.image7.image = self.pic7;
            self.image8.image = self.pic1;
            
            self.viewArray1 = [@[@1,@11,@8]mutableCopy];
            self.viewArray2 = [@[@1,@12,@4]mutableCopy];
            self.viewArray3 = [@[@1,@13,@6]mutableCopy];
            self.viewArray4 = [@[@1,@14,@5]mutableCopy];
            self.viewArray5 = [@[@1,@15,@2]mutableCopy];
            self.viewArray6 = [@[@1,@16,@3]mutableCopy];
            self.viewArray7 = [@[@1,@17,@7]mutableCopy];
            self.viewArray8 = [@[@1,@18,@1]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 7: // クリア
            self.image1.image = self.pic3;
            self.image2.image = self.pic1;
            self.image3.image = self.pic8;
            self.image4.image = self.pic6;
            self.image5.image = self.pic4;
            self.image6.image = self.pic7;
            self.image7.image = self.pic5;
            self.image8.image = self.pic2;
            
            self.viewArray1 = [@[@1,@11,@3]mutableCopy];
            self.viewArray2 = [@[@1,@12,@1]mutableCopy];
            self.viewArray3 = [@[@1,@13,@8]mutableCopy];
            self.viewArray4 = [@[@1,@14,@6]mutableCopy];
            self.viewArray5 = [@[@1,@15,@4]mutableCopy];
            self.viewArray6 = [@[@1,@16,@7]mutableCopy];
            self.viewArray7 = [@[@1,@17,@5]mutableCopy];
            self.viewArray8 = [@[@1,@18,@2]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 8: // クリア
            self.image1.image = self.pic6;
            self.image2.image = self.pic1;
            self.image3.image = self.pic3;
            self.image4.image = self.pic4;
            self.image5.image = self.pic8;
            self.image6.image = self.pic2;
            self.image7.image = self.pic5;
            self.image8.image = self.pic7;
            
            self.viewArray1 = [@[@1,@11,@6]mutableCopy];
            self.viewArray2 = [@[@1,@12,@1]mutableCopy];
            self.viewArray3 = [@[@1,@13,@3]mutableCopy];
            self.viewArray4 = [@[@1,@14,@4]mutableCopy];
            self.viewArray5 = [@[@1,@15,@8]mutableCopy];
            self.viewArray6 = [@[@1,@16,@2]mutableCopy];
            self.viewArray7 = [@[@1,@17,@5]mutableCopy];
            self.viewArray8 = [@[@1,@18,@7]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 9: // テスト用なので削除する
            self.image1.image = self.pic1;
            self.image2.image = self.pic2;
            self.image3.image = self.pic3;
            self.image4.image = self.pic4;
            self.image5.image = self.pic5;
            self.image6.image = self.pic6;
            self.image7.image = self.pic7;
            self.image8.image = self.pic8;
            
            self.viewArray1 = [@[@1,@11,@1]mutableCopy];
            self.viewArray2 = [@[@1,@12,@2]mutableCopy];
            self.viewArray3 = [@[@1,@13,@3]mutableCopy];
            self.viewArray4 = [@[@1,@14,@4]mutableCopy];
            self.viewArray5 = [@[@1,@15,@5]mutableCopy];
            self.viewArray6 = [@[@1,@16,@6]mutableCopy];
            self.viewArray7 = [@[@1,@17,@7]mutableCopy];
            self.viewArray8 = [@[@1,@18,@8]mutableCopy];
            self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        default:
            break;
    }
}

// Mopub
#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


@end
