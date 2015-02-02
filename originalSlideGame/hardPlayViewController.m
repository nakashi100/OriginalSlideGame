//
//  hardPlayViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/02/02.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "hardPlayViewController.h"

@interface hardPlayViewController ()

@end

@implementation hardPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ////// 実際はタイトル画面で初期ゲームを作成し、list画面からデータを引継ぐ ///////////////
    // divPicData[0](1つのゲーム配列)に1〜9の数字をセットして配列を作り、その配列自体をdivPicDataFinal[0](ゲーム配列リスト)に保存する
    NSMutableArray *divPicData = [NSMutableArray array]; // ゲーム配列
    
    for (int i=0; i<17; i++) {
        NSString *picText = [NSString stringWithFormat:@"sample%d",i];
        UIImage *picImage = [UIImage imageNamed:picText];
        
        NSData *picData = UIImageJPEGRepresentation(picImage, 1.0);
        [divPicData addObject:picData];
    }
    
    
    self.divPicturesData = divPicData;
    
    //    NSLog(@"配列は%dコ",[self.divPicturesData count]);
    //     NSLog(@"配列は%@",self.divPicturesData[16]);
    ////////////////////////////////////

    
    
    
    
    // ゲームリスト画面以外から来た場合(self.divPicturesDataが空の場合)は、forKey:nowPlayingでゲーム配列をセットする(result時か作成時に保存している)
    if(!self.divPicturesData){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        self.divPicturesData = [userDefault arrayForKey:@"nowPlaying"];
    }
    
    
    // 写真のデータをdata型からimage型に変換する
    for (int i=0; i<17; i++) {
        // self.pic0 = [UIImage imageWithData:self.divPicturesData[0]]; //やりたい処理はこれの繰り返し
        NSString *picNum = [NSString stringWithFormat:@"pic%d", i];
        [self setValue:[UIImage imageWithData:self.divPicturesData[i]] forKey:picNum]; // このクラス(self)のプロパティにvalueをセットする
    }
    
    // 写真のimageを各viewにセットする
    for (int i=1; i<17; i++) {
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
    
    //    見本画像をセットする
    //    self.mihon9.image = [UIImage imageNamed:@"mihonSample"];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    // ナビゲーションバーに削除ボタンを設置
    self.trashBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(alert)];
    self.navigationItem.rightBarButtonItem = self.trashBtn;
    
    // デフォルトゲームは削除できないようにnavigationの削除ボタンを非表示&無効にする
    if(self.pathNo == 0){
        [self.trashBtn setEnabled:NO];
        self.trashBtn.tintColor = [UIColor colorWithWhite:0 alpha:0];
    }
    self.testBtn2.hidden = YES;
    self.sampleView.hidden = YES;
    
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
    
    
    // image16(tag:36)を削除する
    [[self.view viewWithTag:36] removeFromSuperview];
    
    
    /**********************************************************************************
     // image1〜8の中の数字(sample1〜9)を並び替える
     [self createRndArray];
     
     //    NSString *randPic1 = [NSString stringWithFormat:@"sample%@", self.randNums[0]];
     //    NSString *randPic2 = [NSString stringWithFormat:@"sample%@", self.randNums[1]];
     //    NSString *randPic3 = [NSString stringWithFormat:@"sample%@", self.randNums[2]];
     //    NSString *randPic4 = [NSString stringWithFormat:@"sample%@", self.randNums[3]];
     //    NSString *randPic5 = [NSString stringWithFormat:@"sample%@", self.randNums[4]];
     //    NSString *randPic6 = [NSString stringWithFormat:@"sample%@", self.randNums[5]];
     //    NSString *randPic7 = [NSString stringWithFormat:@"sample%@", self.randNums[6]];
     //    NSString *randPic8 = [NSString stringWithFormat:@"sample%@", self.randNums[7]];
     //
     //    self.image1.image = [UIImage imageNamed:randPic1];
     //    self.image2.image = [UIImage imageNamed:randPic2];
     //    self.image3.image = [UIImage imageNamed:randPic3];
     //    self.image4.image = [UIImage imageNamed:randPic4];
     //    self.image5.image = [UIImage imageNamed:randPic5];
     //    self.image6.image = [UIImage imageNamed:randPic6];
     //    self.image7.image = [UIImage imageNamed:randPic7];
     //    self.image8.image = [UIImage imageNamed:randPic8];
     
     
     // スライドしたときの処理で使用する配列を作成する
     // array[0]はスライド空判定(0が空・1が空でない)、array[1]はimageがもつtagの番号、array[2]はtagの値(パズル完成の判定に用いる))
     self.viewArray1 = [@[@1,@11,self.randNums[0]]mutableCopy];
     self.viewArray2 = [@[@1,@12,self.randNums[1]]mutableCopy];
     self.viewArray3 = [@[@1,@13,self.randNums[2]]mutableCopy];
     self.viewArray4 = [@[@1,@14,self.randNums[3]]mutableCopy];
     self.viewArray5 = [@[@1,@15,self.randNums[4]]mutableCopy];
     self.viewArray6 = [@[@1,@16,self.randNums[5]]mutableCopy];
     self.viewArray7 = [@[@1,@17,self.randNums[6]]mutableCopy];
     self.viewArray8 = [@[@1,@18,self.randNums[7]]mutableCopy];
     self.viewArray9 = [@[@0,@0,@0]mutableCopy];     //view9が最初に空になるので配列には{0,0,0}を入れておく
     
     //うまくできない
     //    for (int i=1; i<10; i++) {
     //        NSString *testArray = [NSString stringWithFormat:@"viewArray%d",i];
     //        NSLog(@"%@",testArray);
     //    }
     **********************************************************************************/
    
    
    // image1〜8の中の数字を並び替える
    int pattern = 2; // 実際にはrand関数を使ってpatternをランダムに指定する
    [self puzzlePattern:pattern];
    
    
    // タイマーを起動する
    [self timerStart];
    
    
    // STARTボタンを消す
    UIView *playBtn = [self.view viewWithTag:40];
    [playBtn removeFromSuperview];
    
    // forHideビューを消して、各種ボタンが表示・タップできるようにする
    [self.forHideView4 removeFromSuperview];
    
}





/*********************************************************************************
 スライドした時の処理
 *********************************************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    //    NSLog(@"タッチしたビューは、%@", touch.view);
    //    CGPoint location = [[touches anyObject] locationInView:self];
    //    NSLog(@"タッチした座標は、%@", location);
    
    
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
        case 30:
            self.sampleImageView.image = self.pic0;
            break;
            
            
        default:
            break;
    }
    
    [self judge];
}



// スライドを動かすメソッド (tag番号とx座標とy座標を指定する)
- (IBAction)slide:(int)test xzahyo:(int)xzahyo yzahyo:(int)yzahyo{
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         int xx = [self.view viewWithTag:test].frame.origin.x;
                         int yy = [self.view viewWithTag:test].frame.origin.y;
                         
                         
                         CGRect rect = CGRectMake(xx + xzahyo, yy + yzahyo, self.image1.frame.size.width, self.image1.frame.size.height);
                         [[self.view viewWithTag:test] setFrame:rect];
                     }
                     completion:^(BOOL finished){
                         //                         [[self.view viewWithTag:test] setBackgroundColor:[UIColor redColor]];
                     }
     ];
    
}


// パズル完成後の処理
- (void)judge {
    if(([self.viewArray1[2]intValue] == 1) && ([self.viewArray2[2]intValue] == 2) && ([self.viewArray3[2]intValue] == 3) && ([self.viewArray4[2]intValue] == 4) && ([self.viewArray5[2]intValue] == 5) && ([self.viewArray6[2]intValue] == 6) && ([self.viewArray7[2]intValue] == 7) && ([self.viewArray8[2]intValue] == 8)){
        
        
        
//        // タイマーを止めて、タイムとプレイ中のゲーム配列を次ページへ引継ぐ
//        [self.myTimer invalidate];
//        resultViewController *resultView = [self.storyboard instantiateViewControllerWithIdentifier:@"resultView"];
//        resultView.result = self.playTime;
//        resultView.divPicturesData = self.divPicturesData;
        
//        // Resultページへモーダルで遷移させる
//        [self presentViewController:resultView animated:YES completion:nil];
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
    //    self.minute = self.timerCount / 60; //00:00:00.00←ここのための処理。timerCount ÷ 60 を minute に入れる
    
    // ラベルに表示する
    self.playTime = [NSString stringWithFormat:@"%6.2f", self.second]; //%05.2f は5桁で記述・小数点以下は2桁・不足は0で補う言う意味
    self.timerLabel.text = self.playTime;
    
    // 過去のベストタイムと比較して、最高タイムだったら配列に格納して使ってもよいかも
}


// 完成画像(見本)を閉じる処理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    switch (touch.view.tag) {
        case 30:
            self.sampleImageView.image = nil;
            break;
            
        default:
            break;
    }
}




/*********************************************************************************
 ゲームの削除処理
 *********************************************************************************/

- (void)alert{
    // アラートビューを作成
    // キャンセルボタンを表示しない場合はcancelButtonTitleにnilを指定
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Delete this puzzle"
                          message:@"Do you want to delete this puzzle game?"
                          delegate:self
                          cancelButtonTitle:@"NO"
                          otherButtonTitles:@"DELETE", nil];
    
    [alert show];  // アラートビューを表示
}

// デリゲート処理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1: // 1番目が押されたとき
            [self deleteGame];
            break;
            
        default: // キャンセルが押されたとき
            break;
    }
}

- (void)deleteGame {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
    NSMutableArray *divPicDataFinalnew = [divPicDataFinal mutableCopy];
    [divPicDataFinalnew removeObjectAtIndex:self.pathNo];
    [userDefault setObject:divPicDataFinalnew forKey:@"divPicDataFinal"];
    
    BOOL deletedFlag = YES;
    [userDefault setBool:deletedFlag forKey:@"deletedFlag"]; // ここからの遷移だと明確にするため
    
    [userDefault synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:NO]; // タイトル画面に戻る
    
    //        [self.navigationController popViewControllerAnimated:YES];
    
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
    
    // 透明のViewを作成
    UIView *wholeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    wholeView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    wholeView.tag = 104;
    
    
    // 中央のViewを作成
    UIView *uiAdd = [[UIView alloc] initWithFrame:CGRectMake(53, 143, 214, 234)];
    uiAdd.backgroundColor = [UIColor whiteColor];
    uiAdd.tag = 101;
    uiAdd.userInteractionEnabled = YES; // タッチイベントを取れるようにする
    
    // Continueボタンを作成
    UIButton *continueBtn = [[UIButton alloc]initWithFrame:CGRectMake(84, 192, 153, 42)];
    continueBtn.backgroundColor = [UIColor blueColor];
    continueBtn.tag = 102;
    continueBtn.userInteractionEnabled = YES;
    [continueBtn setTitle:@"CONTINUE" forState:UIControlStateNormal ];
    
    // Quitボタンを作成
    UIButton *quitBtn = [[UIButton alloc]initWithFrame:CGRectMake(84, 292, 153 , 42)];
    quitBtn.backgroundColor = [UIColor blueColor];
    quitBtn.tag = 103;
    quitBtn.userInteractionEnabled = YES;
    [quitBtn setTitle:@"QUIT" forState:UIControlStateNormal ];
    
    // ボタンがタップされたときの動作を定義する
    [continueBtn addTarget:self action:@selector( onTapButton1: ) forControlEvents:UIControlEventTouchUpInside ];
    [quitBtn addTarget:self action:@selector( onTapButton2: ) forControlEvents:UIControlEventTouchUpInside ];
    
    
    // サブビューに作ったUIViewを追加する
    [self.view addSubview:uiAdd];
    [self.view addSubview:wholeView];
    [self.view addSubview:continueBtn];
    [self.view addSubview:quitBtn];
    
    
}


- ( void )onTapButton1:( id )sender
{
    if(self.isFstCalled){
        [self timerStart];
        self.isStart = self.isStart;
    }
    
    // viewを画面から削除
    UIView *uiAdd = [self.view viewWithTag:101];
    UIView *wholeView = [self.view viewWithTag:104];
    UIView *continueBtn = [self.view viewWithTag:102];
    UIView *quitBtn = [self.view viewWithTag:103];
    [uiAdd removeFromSuperview];
    [wholeView removeFromSuperview];
    [continueBtn removeFromSuperview];
    [quitBtn removeFromSuperview];
}

- ( void )onTapButton2:( id )sender
{
    
    // viewを画面から削除
    UIView *uiAdd = [self.view viewWithTag:101];
    UIView *wholeView = [self.view viewWithTag:104];
    UIView *continueBtn = [self.view viewWithTag:102];
    UIView *quitBtn = [self.view viewWithTag:103];
    [uiAdd removeFromSuperview];
    [wholeView removeFromSuperview];
    [continueBtn removeFromSuperview];
    [quitBtn removeFromSuperview];
    
    
    // タイトル画面に戻る(unwindsegue manual)
    [self performSegueWithIdentifier:@"titleViewReturn" sender:self];
    
}





/*********************************************************************************
 解ける配列パターン(8種類以上もちたい)
 *********************************************************************************/
-(void)puzzlePattern:(int )num {
    
    switch (num) {
        case 1: // テスト用なので削除する
            self.image1.image = self.pic1;
            self.image2.image = self.pic2;
            self.image3.image = self.pic3;
            self.image4.image = self.pic4;
            self.image5.image = self.pic5;
            self.image6.image = self.pic6;
            self.image7.image = self.pic7;
            self.image8.image = self.pic8;
            self.image8.image = self.pic9;
            self.image8.image = self.pic10;
            self.image8.image = self.pic11;
            self.image8.image = self.pic12;
            self.image8.image = self.pic13;
            self.image8.image = self.pic14;
            self.image8.image = self.pic15;
            self.image8.image = self.pic16;
            
            self.viewArray1 = [@[@1,@11,@1]mutableCopy];
            self.viewArray2 = [@[@1,@12,@2]mutableCopy];
            self.viewArray3 = [@[@1,@13,@3]mutableCopy];
            self.viewArray4 = [@[@1,@14,@4]mutableCopy];
            self.viewArray5 = [@[@1,@15,@5]mutableCopy];
            self.viewArray6 = [@[@1,@16,@6]mutableCopy];
            self.viewArray7 = [@[@1,@17,@7]mutableCopy];
            self.viewArray8 = [@[@1,@18,@8]mutableCopy];
            self.viewArray9 = [@[@1,@19,@9]mutableCopy];
            self.viewArray10 = [@[@1,@20,@10]mutableCopy];
            self.viewArray11 = [@[@1,@21,@11]mutableCopy];
            self.viewArray12 = [@[@1,@22,@12]mutableCopy];
            self.viewArray13 = [@[@1,@23,@13]mutableCopy];
            self.viewArray14 = [@[@1,@24,@14]mutableCopy];
            self.viewArray15 = [@[@1,@25,@15]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];  //view16が最初に空になるので配列には{0,0,0}を入れておく
            
            break;
            
        default:
            break;
    }
    
}





@end
