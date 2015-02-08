//
//  hardPlayViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/02/02.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "hardPlayViewController.h"
#import "resultViewController.h"
#import "titleViewController.h"
#import "FlatUIKit.h"


@interface hardPlayViewController ()

@end

@implementation hardPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
}


- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%d",self.pathNo);
    
    // 画面のレイアウト
    self.timeLabel.font = [UIFont flatFontOfSize:20];
    self.timeLapLabel.font = [UIFont flatFontOfSize:20];
    
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
    
    
    ///////// ベストタイムの更新(resultページからリダイレクトできた場合にもベストタイムを参照できるようにする) ///////////
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *hardFinalList = [userDefault arrayForKey:@"hardFinalList"];
    int countArray = [hardFinalList[self.pathNo] count];
    
    if (countArray == 18) {
        NSString *bestTime = [NSString stringWithFormat:@"( BEST: %6.2f )",[hardFinalList[self.pathNo][17] floatValue]];
        self.bestTimeLabel.text = bestTime;
        self.bestTimeLabel.font = [UIFont boldFlatFontOfSize:14];
    }else if(countArray == 17){
        self.bestTimeLabel.text = nil;
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
    
    
    // image16(tag:36)を削除する
    [[self.view viewWithTag:36] removeFromSuperview];
    
    
    // image1〜8の中の数字を並び替える
//    int pattern = [self createRndArray];
        int pattern = 9; // テスト用
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
    
    //    NSLog(@"タッチしたビューは、%@", touch.view);
    //    CGPoint location = [[touches anyObject] locationInView:self];
    //    NSLog(@"タッチした座標は、%@", location);
    
    
    switch (touch.view.tag) {
            
            //--------------------------------------------------------------------------
        case 1:
            
            if([self.viewArray2[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray1[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray2 = [@[self.viewArray1[0],self.viewArray1[1],self.viewArray1[2]]mutableCopy];
                self.viewArray1 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray5[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray1[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray5 = [@[self.viewArray1[0],self.viewArray1[1],self.viewArray1[2]]mutableCopy];
                self.viewArray1 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 2:
            
            if([self.viewArray1[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray2[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray1 = [@[self.viewArray2[0],self.viewArray2[1],self.viewArray2[2]]mutableCopy];
                self.viewArray2 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray3[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray2[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray3 = [@[self.viewArray2[0],self.viewArray2[1],self.viewArray2[2]]mutableCopy];
                self.viewArray2 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray6[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray2[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray6 = [@[self.viewArray2[0],self.viewArray2[1],self.viewArray2[2]]mutableCopy];
                self.viewArray2 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 3:
            
            if([self.viewArray2[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray3[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray2 = [@[self.viewArray3[0],self.viewArray3[1],self.viewArray3[2]]mutableCopy];
                self.viewArray3 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray4[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray3[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray4 = [@[self.viewArray3[0],self.viewArray3[1],self.viewArray3[2]]mutableCopy];
                self.viewArray3 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray7[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray3[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray7 = [@[self.viewArray3[0],self.viewArray3[1],self.viewArray3[2]]mutableCopy];
                self.viewArray3 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 4:
            
            if([self.viewArray3[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray4[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray3 = [@[self.viewArray4[0],self.viewArray4[1],self.viewArray4[2]]mutableCopy];
                self.viewArray4 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray8[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray4[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray8 = [@[self.viewArray4[0],self.viewArray4[1],self.viewArray4[2]]mutableCopy];
                self.viewArray4 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 5:
            
            if([self.viewArray1[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray5[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray1 = [@[self.viewArray5[0],self.viewArray5[1],self.viewArray5[2]]mutableCopy];
                self.viewArray5 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray6[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray5[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray6 = [@[self.viewArray5[0],self.viewArray5[1],self.viewArray5[2]]mutableCopy];
                self.viewArray5 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray9[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray5[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray9 = [@[self.viewArray5[0],self.viewArray5[1],self.viewArray5[2]]mutableCopy];
                self.viewArray5 = [@[@0,@0,@0]mutableCopy];
            }
            
            
            break;
            //--------------------------------------------------------------------------
        case 6:
            
            if([self.viewArray2[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray6[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray2 = [@[self.viewArray6[0],self.viewArray6[1],self.viewArray6[2]]mutableCopy];
                self.viewArray6 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray5[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray6[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray5 = [@[self.viewArray6[0],self.viewArray6[1],self.viewArray6[2]]mutableCopy];
                self.viewArray6 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray7[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray6[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray7 = [@[self.viewArray6[0],self.viewArray6[1],self.viewArray6[2]]mutableCopy];
                self.viewArray6 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray10[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray6[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray10 = [@[self.viewArray6[0],self.viewArray6[1],self.viewArray6[2]]mutableCopy];
                self.viewArray6 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 7:
            
            if([self.viewArray3[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray7[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray3 = [@[self.viewArray7[0],self.viewArray7[1],self.viewArray7[2]]mutableCopy];
                self.viewArray7 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray6[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray7[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray6 = [@[self.viewArray7[0],self.viewArray7[1],self.viewArray7[2]]mutableCopy];
                self.viewArray7 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray8[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray7[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray8 = [@[self.viewArray7[0],self.viewArray7[1],self.viewArray7[2]]mutableCopy];
                self.viewArray7 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray11[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray7[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray11 = [@[self.viewArray7[0],self.viewArray7[1],self.viewArray7[2]]mutableCopy];
                self.viewArray7 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 8:
            
            if([self.viewArray4[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray8[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray4 = [@[self.viewArray8[0],self.viewArray8[1],self.viewArray8[2]]mutableCopy];
                self.viewArray8 = [@[@0,@0,@0]mutableCopy];
                
            }
            
            if([self.viewArray7[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray8[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray7 = [@[self.viewArray8[0],self.viewArray8[1],self.viewArray8[2]]mutableCopy];
                self.viewArray8 = [@[@0,@0,@0]mutableCopy];
                
            }
            
            if([self.viewArray12[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray8[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray12 = [@[self.viewArray8[0],self.viewArray8[1],self.viewArray8[2]]mutableCopy];
                self.viewArray8 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 9:
            
            if([self.viewArray5[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray9[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray5 = [@[self.viewArray9[0],self.viewArray9[1],self.viewArray9[2]]mutableCopy];
                self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray10[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray9[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray10 = [@[self.viewArray9[0],self.viewArray9[1],self.viewArray9[2]]mutableCopy];
                self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray13[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray9[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray13 = [@[self.viewArray9[0],self.viewArray9[1],self.viewArray9[2]]mutableCopy];
                self.viewArray9 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 10:
            
            if([self.viewArray6[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray10[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray6 = [@[self.viewArray10[0],self.viewArray10[1],self.viewArray10[2]]mutableCopy];
                self.viewArray10 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray9[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray10[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray9 = [@[self.viewArray10[0],self.viewArray10[1],self.viewArray10[2]]mutableCopy];
                self.viewArray10 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray11[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray10[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray11 = [@[self.viewArray10[0],self.viewArray10[1],self.viewArray10[2]]mutableCopy];
                self.viewArray10 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray14[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray10[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray14 = [@[self.viewArray10[0],self.viewArray10[1],self.viewArray10[2]]mutableCopy];
                self.viewArray10 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 11:
            
            if([self.viewArray7[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray11[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray7 = [@[self.viewArray11[0],self.viewArray11[1],self.viewArray11[2]]mutableCopy];
                self.viewArray11 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray10[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray11[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray10 = [@[self.viewArray11[0],self.viewArray11[1],self.viewArray11[2]]mutableCopy];
                self.viewArray11 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray12[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray11[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray12 = [@[self.viewArray11[0],self.viewArray11[1],self.viewArray11[2]]mutableCopy];
                self.viewArray11 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray15[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray11[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray15 = [@[self.viewArray11[0],self.viewArray11[1],self.viewArray11[2]]mutableCopy];
                self.viewArray11 = [@[@0,@0,@0]mutableCopy];
            }
            
            break;
            //--------------------------------------------------------------------------
        case 12:
            
            if([self.viewArray8[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray12[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray8 = [@[self.viewArray12[0],self.viewArray12[1],self.viewArray12[2]]mutableCopy];
                self.viewArray12 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray11[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray12[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray11 = [@[self.viewArray12[0],self.viewArray12[1],self.viewArray12[2]]mutableCopy];
                self.viewArray12 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray16[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray12[1] intValue] xzahyo:0 yzahyo:(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray16 = [@[self.viewArray12[0],self.viewArray12[1],self.viewArray12[2]]mutableCopy];
                self.viewArray12 = [@[@0,@0,@0]mutableCopy];
            }
            
            
            break;
            //--------------------------------------------------------------------------
        case 13:
            
            if([self.viewArray9[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray13[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray9 = [@[self.viewArray13[0],self.viewArray13[1],self.viewArray13[2]]mutableCopy];
                self.viewArray13 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray14[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray13[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray14 = [@[self.viewArray13[0],self.viewArray13[1],self.viewArray13[2]]mutableCopy];
                self.viewArray13 = [@[@0,@0,@0]mutableCopy];
            }
            
            
            break;
            //--------------------------------------------------------------------------
        case 14:
            
            if([self.viewArray10[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray14[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray10 = [@[self.viewArray14[0],self.viewArray14[1],self.viewArray14[2]]mutableCopy];
                self.viewArray14 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray13[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray14[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray13 = [@[self.viewArray14[0],self.viewArray14[1],self.viewArray14[2]]mutableCopy];
                self.viewArray14 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray15[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray14[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray15 = [@[self.viewArray14[0],self.viewArray14[1],self.viewArray14[2]]mutableCopy];
                self.viewArray14 = [@[@0,@0,@0]mutableCopy];
            }
            
             break;
            //--------------------------------------------------------------------------
        case 15:  //完成
            if([self.viewArray11[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray15[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray11 = [@[self.viewArray15[0],self.viewArray15[1],self.viewArray15[2]]mutableCopy];
                self.viewArray15 = [@[@0,@0,@0]mutableCopy];
                
            }
            
            if([self.viewArray14[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray15[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray14 = [@[self.viewArray15[0],self.viewArray15[1],self.viewArray15[2]]mutableCopy];
                self.viewArray15 = [@[@0,@0,@0]mutableCopy];
                
            }
            
            if([self.viewArray16[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray15[1] intValue] xzahyo:(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray16 = [@[self.viewArray15[0],self.viewArray15[1],self.viewArray15[2]]mutableCopy];
                self.viewArray15 = [@[@0,@0,@0]mutableCopy];
            }
            
            
            break;
            //--------------------------------------------------------------------------
        case 16:
            
            if([self.viewArray12[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray16[1] intValue] xzahyo:0 yzahyo:-(self.image1.frame.size.width+1)];
                
                // 配列の中身を入れ替える
                self.viewArray12 = [@[self.viewArray16[0],self.viewArray16[1],self.viewArray16[2]]mutableCopy];
                self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            }
            
            if([self.viewArray15[0] intValue] == 0){
                // タグを動かす
                [self slide:[self.viewArray16[1] intValue] xzahyo:-(self.image1.frame.size.width+1) yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray15 = [@[self.viewArray16[0],self.viewArray16[1],self.viewArray16[2]]mutableCopy];
                self.viewArray16 = [@[@0,@0,@0]mutableCopy];
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
                         //                         [[self.view viewWithTag:test] setBackgroundColor:[UIColor redColor]];
                     }
     ];
    
}


// パズル完成後の処理
- (void)judge {
    if(([self.viewArray1[2]intValue] == 1) && ([self.viewArray2[2]intValue] == 2) && ([self.viewArray3[2]intValue] == 3) && ([self.viewArray4[2]intValue] == 4) && ([self.viewArray5[2]intValue] == 5) && ([self.viewArray6[2]intValue] == 6) && ([self.viewArray7[2]intValue] == 7) && ([self.viewArray8[2]intValue] == 8) && ([self.viewArray9[2]intValue] == 9) && ([self.viewArray10[2]intValue] == 10) && ([self.viewArray11[2]intValue] == 11) && ([self.viewArray12[2]intValue] == 12) && ([self.viewArray13[2]intValue] == 13) && ([self.viewArray14[2]intValue] == 14) && ([self.viewArray15[2]intValue] == 15)){
        
        
        // タイマーを止めて、タイムとプレイ中のゲーム配列を次ページへ引継ぐ
        [self.myTimer invalidate];
        resultViewController *resultView = [self.storyboard instantiateViewControllerWithIdentifier:@"resultView"];
        resultView.result = self.playTime;
        resultView.divPicturesData = self.divPicturesData;
        resultView.pathNo = self.pathNo;
        NSLog(@"%d",self.pathNo);
        
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
    // タイトルの文字色の設定
    self.deleteAlertView.titleLabel.textColor = [UIColor cloudsColor];
    // タイトルの文字フォントの設定
    self.deleteAlertView.titleLabel.font = [UIFont boldFlatFontOfSize:18];
    // メッセージの文字色の設定
    self.deleteAlertView.messageLabel.textColor = [UIColor cloudsColor];
    // メッセージの文字フォントの設定
    self.deleteAlertView.messageLabel.font = [UIFont flatFontOfSize:14];
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
    // 複数のdeleteAlertViewを管理するためにtagを使用
    self.deleteAlertView.tag = 1;
    
    [self.deleteAlertView show];

}

// デリゲート処理
- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        switch (buttonIndex) {
                
            case 1: // 1番目が押されたとき
                [self deleteGame];
                self.deleteAlertView.delegate = nil;
                
                break;
                
            default: // キャンセルが押されたとき
                break;
        }
    }else if(alertView.tag == 2){
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
    
    NSArray *hardFinalList = [userDefault arrayForKey:@"hardFinalList"];
    NSMutableArray *hardFinalListnew = [hardFinalList mutableCopy];
    [hardFinalListnew removeObjectAtIndex:self.pathNo];
    [userDefault setObject:hardFinalListnew forKey:@"hardFinalList"];
    
    
    titleViewController *titleViewController = [self.navigationController viewControllers][0];
    //    titleViewController *titleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"titleView"];
    titleViewController.deletedFlag = YES;

    [self.navigationController popToRootViewControllerAnimated:NO]; // タイトル画面に戻る
    
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
    
    ///////////////////////// アラートビューの作成/////////////////
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
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
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
    alertView.tag = 2;
    
    [alertView show];
    
}







/*********************************************************************************
 解ける配列パターン(8種類以上もちたい)
 *********************************************************************************/
-(void)puzzlePattern:(int )num {
    
    switch (num) {
        case 1: // クリア済
            self.image1.image = self.pic13;
            self.image2.image = self.pic11;
            self.image3.image = self.pic9;
            self.image4.image = self.pic10;
            self.image5.image = self.pic14;
            self.image6.image = self.pic8;
            self.image7.image = self.pic5;
            self.image8.image = self.pic3;
            self.image9.image = self.pic1;
            self.image10.image = self.pic6;
            self.image11.image = self.pic2;
            self.image12.image = self.pic7;
            self.image13.image = self.pic12;
            self.image14.image = self.pic4;
            self.image15.image = self.pic15;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@13]mutableCopy];
            self.viewArray2 = [@[@1,@22,@11]mutableCopy];
            self.viewArray3 = [@[@1,@23,@9]mutableCopy];
            self.viewArray4 = [@[@1,@24,@10]mutableCopy];
            self.viewArray5 = [@[@1,@25,@14]mutableCopy];
            self.viewArray6 = [@[@1,@26,@8]mutableCopy];
            self.viewArray7 = [@[@1,@27,@5]mutableCopy];
            self.viewArray8 = [@[@1,@28,@3]mutableCopy];
            self.viewArray9 = [@[@1,@29,@1]mutableCopy];
            self.viewArray10 = [@[@1,@30,@6]mutableCopy];
            self.viewArray11 = [@[@1,@31,@2]mutableCopy];
            self.viewArray12 = [@[@1,@32,@7]mutableCopy];
            self.viewArray13 = [@[@1,@33,@12]mutableCopy];
            self.viewArray14 = [@[@1,@34,@4]mutableCopy];
            self.viewArray15 = [@[@1,@35,@15]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 2: // クリア済
            self.image1.image = self.pic3;
            self.image2.image = self.pic12;
            self.image3.image = self.pic2;
            self.image4.image = self.pic11;
            self.image5.image = self.pic1;
            self.image6.image = self.pic7;
            self.image7.image = self.pic14;
            self.image8.image = self.pic9;
            self.image9.image = self.pic13;
            self.image10.image = self.pic4;
            self.image11.image = self.pic8;
            self.image12.image = self.pic15;
            self.image13.image = self.pic5;
            self.image14.image = self.pic10;
            self.image15.image = self.pic6;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@3]mutableCopy];
            self.viewArray2 = [@[@1,@22,@12]mutableCopy];
            self.viewArray3 = [@[@1,@23,@2]mutableCopy];
            self.viewArray4 = [@[@1,@24,@11]mutableCopy];
            self.viewArray5 = [@[@1,@25,@1]mutableCopy];
            self.viewArray6 = [@[@1,@26,@7]mutableCopy];
            self.viewArray7 = [@[@1,@27,@14]mutableCopy];
            self.viewArray8 = [@[@1,@28,@9]mutableCopy];
            self.viewArray9 = [@[@1,@29,@13]mutableCopy];
            self.viewArray10 = [@[@1,@30,@4]mutableCopy];
            self.viewArray11 = [@[@1,@31,@8]mutableCopy];
            self.viewArray12 = [@[@1,@32,@15]mutableCopy];
            self.viewArray13 = [@[@1,@33,@5]mutableCopy];
            self.viewArray14 = [@[@1,@34,@10]mutableCopy];
            self.viewArray15 = [@[@1,@35,@6]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 3: // クリア済
            self.image1.image = self.pic15;
            self.image2.image = self.pic2;
            self.image3.image = self.pic7;
            self.image4.image = self.pic14;
            self.image5.image = self.pic10;
            self.image6.image = self.pic5;
            self.image7.image = self.pic11;
            self.image8.image = self.pic6;
            self.image9.image = self.pic8;
            self.image10.image = self.pic9;
            self.image11.image = self.pic4;
            self.image12.image = self.pic13;
            self.image13.image = self.pic12;
            self.image14.image = self.pic3;
            self.image15.image = self.pic1;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@15]mutableCopy];
            self.viewArray2 = [@[@1,@22,@2]mutableCopy];
            self.viewArray3 = [@[@1,@23,@7]mutableCopy];
            self.viewArray4 = [@[@1,@24,@14]mutableCopy];
            self.viewArray5 = [@[@1,@25,@10]mutableCopy];
            self.viewArray6 = [@[@1,@26,@5]mutableCopy];
            self.viewArray7 = [@[@1,@27,@11]mutableCopy];
            self.viewArray8 = [@[@1,@28,@6]mutableCopy];
            self.viewArray9 = [@[@1,@29,@8]mutableCopy];
            self.viewArray10 = [@[@1,@30,@9]mutableCopy];
            self.viewArray11 = [@[@1,@31,@4]mutableCopy];
            self.viewArray12 = [@[@1,@32,@13]mutableCopy];
            self.viewArray13 = [@[@1,@33,@12]mutableCopy];
            self.viewArray14 = [@[@1,@34,@3]mutableCopy];
            self.viewArray15 = [@[@1,@35,@1]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
        
        case 4:
            self.image1.image = self.pic15;
            self.image2.image = self.pic5;
            self.image3.image = self.pic2;
            self.image4.image = self.pic6;
            self.image5.image = self.pic11;
            self.image6.image = self.pic7;
            self.image7.image = self.pic9;
            self.image8.image = self.pic4;
            self.image9.image = self.pic14;
            self.image10.image = self.pic10;
            self.image11.image = self.pic8;
            self.image12.image = self.pic12;
            self.image13.image = self.pic1;
            self.image14.image = self.pic13;
            self.image15.image = self.pic3;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@15]mutableCopy];
            self.viewArray2 = [@[@1,@22,@5]mutableCopy];
            self.viewArray3 = [@[@1,@23,@2]mutableCopy];
            self.viewArray4 = [@[@1,@24,@6]mutableCopy];
            self.viewArray5 = [@[@1,@25,@11]mutableCopy];
            self.viewArray6 = [@[@1,@26,@7]mutableCopy];
            self.viewArray7 = [@[@1,@27,@9]mutableCopy];
            self.viewArray8 = [@[@1,@28,@4]mutableCopy];
            self.viewArray9 = [@[@1,@29,@14]mutableCopy];
            self.viewArray10 = [@[@1,@30,@10]mutableCopy];
            self.viewArray11 = [@[@1,@31,@8]mutableCopy];
            self.viewArray12 = [@[@1,@32,@12]mutableCopy];
            self.viewArray13 = [@[@1,@33,@1]mutableCopy];
            self.viewArray14 = [@[@1,@34,@13]mutableCopy];
            self.viewArray15 = [@[@1,@35,@3]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 5:
            self.image1.image = self.pic12;
            self.image2.image = self.pic7;
            self.image3.image = self.pic1;
            self.image4.image = self.pic8;
            self.image5.image = self.pic9;
            self.image6.image = self.pic4;
            self.image7.image = self.pic10;
            self.image8.image = self.pic14;
            self.image9.image = self.pic11;
            self.image10.image = self.pic2;
            self.image11.image = self.pic6;
            self.image12.image = self.pic5;
            self.image13.image = self.pic3;
            self.image14.image = self.pic13;
            self.image15.image = self.pic15;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@12]mutableCopy];
            self.viewArray2 = [@[@1,@22,@7]mutableCopy];
            self.viewArray3 = [@[@1,@23,@1]mutableCopy];
            self.viewArray4 = [@[@1,@24,@8]mutableCopy];
            self.viewArray5 = [@[@1,@25,@9]mutableCopy];
            self.viewArray6 = [@[@1,@26,@4]mutableCopy];
            self.viewArray7 = [@[@1,@27,@10]mutableCopy];
            self.viewArray8 = [@[@1,@28,@14]mutableCopy];
            self.viewArray9 = [@[@1,@29,@11]mutableCopy];
            self.viewArray10 = [@[@1,@30,@2]mutableCopy];
            self.viewArray11 = [@[@1,@31,@6]mutableCopy];
            self.viewArray12 = [@[@1,@32,@5]mutableCopy];
            self.viewArray13 = [@[@1,@33,@3]mutableCopy];
            self.viewArray14 = [@[@1,@34,@13]mutableCopy];
            self.viewArray15 = [@[@1,@35,@15]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 6:
            self.image1.image = self.pic6;
            self.image2.image = self.pic11;
            self.image3.image = self.pic5;
            self.image4.image = self.pic12;
            self.image5.image = self.pic15;
            self.image6.image = self.pic4;
            self.image7.image = self.pic2;
            self.image8.image = self.pic10;
            self.image9.image = self.pic1;
            self.image10.image = self.pic8;
            self.image11.image = self.pic3;
            self.image12.image = self.pic14;
            self.image13.image = self.pic9;
            self.image14.image = self.pic13;
            self.image15.image = self.pic7;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@6]mutableCopy];
            self.viewArray2 = [@[@1,@22,@11]mutableCopy];
            self.viewArray3 = [@[@1,@23,@5]mutableCopy];
            self.viewArray4 = [@[@1,@24,@12]mutableCopy];
            self.viewArray5 = [@[@1,@25,@15]mutableCopy];
            self.viewArray6 = [@[@1,@26,@4]mutableCopy];
            self.viewArray7 = [@[@1,@27,@2]mutableCopy];
            self.viewArray8 = [@[@1,@28,@10]mutableCopy];
            self.viewArray9 = [@[@1,@29,@1]mutableCopy];
            self.viewArray10 = [@[@1,@30,@8]mutableCopy];
            self.viewArray11 = [@[@1,@31,@3]mutableCopy];
            self.viewArray12 = [@[@1,@32,@14]mutableCopy];
            self.viewArray13 = [@[@1,@33,@9]mutableCopy];
            self.viewArray14 = [@[@1,@34,@13]mutableCopy];
            self.viewArray15 = [@[@1,@35,@7]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 7:
            self.image1.image = self.pic14;
            self.image2.image = self.pic15;
            self.image3.image = self.pic2;
            self.image4.image = self.pic12;
            self.image5.image = self.pic5;
            self.image6.image = self.pic3;
            self.image7.image = self.pic10;
            self.image8.image = self.pic9;
            self.image9.image = self.pic6;
            self.image10.image = self.pic8;
            self.image11.image = self.pic4;
            self.image12.image = self.pic13;
            self.image13.image = self.pic11;
            self.image14.image = self.pic7;
            self.image15.image = self.pic1;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@14]mutableCopy];
            self.viewArray2 = [@[@1,@22,@15]mutableCopy];
            self.viewArray3 = [@[@1,@23,@2]mutableCopy];
            self.viewArray4 = [@[@1,@24,@12]mutableCopy];
            self.viewArray5 = [@[@1,@25,@5]mutableCopy];
            self.viewArray6 = [@[@1,@26,@3]mutableCopy];
            self.viewArray7 = [@[@1,@27,@10]mutableCopy];
            self.viewArray8 = [@[@1,@28,@9]mutableCopy];
            self.viewArray9 = [@[@1,@29,@6]mutableCopy];
            self.viewArray10 = [@[@1,@30,@8]mutableCopy];
            self.viewArray11 = [@[@1,@31,@4]mutableCopy];
            self.viewArray12 = [@[@1,@32,@13]mutableCopy];
            self.viewArray13 = [@[@1,@33,@11]mutableCopy];
            self.viewArray14 = [@[@1,@34,@7]mutableCopy];
            self.viewArray15 = [@[@1,@35,@1]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 8:
            self.image1.image = self.pic4;
            self.image2.image = self.pic15;
            self.image3.image = self.pic8;
            self.image4.image = self.pic7;
            self.image5.image = self.pic1;
            self.image6.image = self.pic9;
            self.image7.image = self.pic14;
            self.image8.image = self.pic2;
            self.image9.image = self.pic13;
            self.image10.image = self.pic6;
            self.image11.image = self.pic11;
            self.image12.image = self.pic3;
            self.image13.image = self.pic5;
            self.image14.image = self.pic10;
            self.image15.image = self.pic12;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@4]mutableCopy];
            self.viewArray2 = [@[@1,@22,@15]mutableCopy];
            self.viewArray3 = [@[@1,@23,@8]mutableCopy];
            self.viewArray4 = [@[@1,@24,@7]mutableCopy];
            self.viewArray5 = [@[@1,@25,@1]mutableCopy];
            self.viewArray6 = [@[@1,@26,@9]mutableCopy];
            self.viewArray7 = [@[@1,@27,@14]mutableCopy];
            self.viewArray8 = [@[@1,@28,@2]mutableCopy];
            self.viewArray9 = [@[@1,@29,@13]mutableCopy];
            self.viewArray10 = [@[@1,@30,@6]mutableCopy];
            self.viewArray11 = [@[@1,@31,@11]mutableCopy];
            self.viewArray12 = [@[@1,@32,@3]mutableCopy];
            self.viewArray13 = [@[@1,@33,@5]mutableCopy];
            self.viewArray14 = [@[@1,@34,@10]mutableCopy];
            self.viewArray15 = [@[@1,@35,@12]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];
            
            break;
            
        case 9: // テスト用
            self.image1.image = self.pic1;
            self.image2.image = self.pic2;
            self.image3.image = self.pic3;
            self.image4.image = self.pic4;
            self.image5.image = self.pic5;
            self.image6.image = self.pic6;
            self.image7.image = self.pic7;
            self.image8.image = self.pic8;
            self.image9.image = self.pic9;
            self.image10.image = self.pic10;
            self.image11.image = self.pic11;
            self.image12.image = self.pic12;
            self.image13.image = self.pic13;
            self.image14.image = self.pic14;
            self.image15.image = self.pic15;
            self.image16.image = self.pic16;
            
            self.viewArray1 = [@[@1,@21,@1]mutableCopy]; //@空欄かどうか,@imageにつけたタグ,@実数
            self.viewArray2 = [@[@1,@22,@2]mutableCopy];
            self.viewArray3 = [@[@1,@23,@3]mutableCopy];
            self.viewArray4 = [@[@1,@24,@4]mutableCopy];
            self.viewArray5 = [@[@1,@25,@5]mutableCopy];
            self.viewArray6 = [@[@1,@26,@6]mutableCopy];
            self.viewArray7 = [@[@1,@27,@7]mutableCopy];
            self.viewArray8 = [@[@1,@28,@8]mutableCopy];
            self.viewArray9 = [@[@1,@29,@9]mutableCopy];
            self.viewArray10 = [@[@1,@30,@10]mutableCopy];
            self.viewArray11 = [@[@1,@31,@11]mutableCopy];
            self.viewArray12 = [@[@1,@32,@12]mutableCopy];
            self.viewArray13 = [@[@1,@33,@13]mutableCopy];
            self.viewArray14 = [@[@1,@34,@14]mutableCopy];
            self.viewArray15 = [@[@1,@35,@15]mutableCopy];
            self.viewArray16 = [@[@0,@0,@0]mutableCopy];  //view16が最初に空になるので配列には{0,0,0}を入れておく
            
            break;
            
        default:
            break;
    }
    
}





@end
