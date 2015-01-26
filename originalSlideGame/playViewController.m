//
//  playViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/24.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "playViewController.h"

@interface playViewController ()

@end

@implementation playViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1〜9の数字をimageにセットする
    self.image1.image = [UIImage imageNamed:@"sample1"];
    self.image2.image = [UIImage imageNamed:@"sample2"];
    self.image3.image = [UIImage imageNamed:@"sample3"];
    self.image4.image = [UIImage imageNamed:@"sample4"];
    self.image5.image = [UIImage imageNamed:@"sample5"];
    self.image6.image = [UIImage imageNamed:@"sample6"];
    self.image7.image = [UIImage imageNamed:@"sample7"];
    self.image8.image = [UIImage imageNamed:@"sample8"];
    self.image9.image = [UIImage imageNamed:@"sample9"];
    
    
    // 見本画像をセットする
    self.mihon9.image = [UIImage imageNamed:@"mihonSample"];
    
    
    // for文でループ処理を使いたいがうまくできない、、、
//    for (int i=1; i<10; i++) {
//        NSString *imageNum = [NSString stringWithFormat:@"image%d", i];
//        NSString *sampleNum = [NSString stringWithFormat:@"sample%d", i];
//        self.imageNum.image = [UIImage imageNamed:sampleNum];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)playButton:(id)sender {
    
    // image9(tag:19)を削除する
     [[self.view viewWithTag:19] removeFromSuperview];
    
    
    // image1〜8を並び替える
    [self createRndArray];
    
    NSString *randPic1 = [NSString stringWithFormat:@"sample%@", self.randNums[0]];
    NSString *randPic2 = [NSString stringWithFormat:@"sample%@", self.randNums[1]];
    NSString *randPic3 = [NSString stringWithFormat:@"sample%@", self.randNums[2]];
    NSString *randPic4 = [NSString stringWithFormat:@"sample%@", self.randNums[3]];
    NSString *randPic5 = [NSString stringWithFormat:@"sample%@", self.randNums[4]];
    NSString *randPic6 = [NSString stringWithFormat:@"sample%@", self.randNums[5]];
    NSString *randPic7 = [NSString stringWithFormat:@"sample%@", self.randNums[6]];
    NSString *randPic8 = [NSString stringWithFormat:@"sample%@", self.randNums[7]];
    
    self.image1.image = [UIImage imageNamed:randPic1];
    self.image2.image = [UIImage imageNamed:randPic2];
    self.image3.image = [UIImage imageNamed:randPic3];
    self.image4.image = [UIImage imageNamed:randPic4];
    self.image5.image = [UIImage imageNamed:randPic5];
    self.image6.image = [UIImage imageNamed:randPic6];
    self.image7.image = [UIImage imageNamed:randPic7];
    self.image8.image = [UIImage imageNamed:randPic8];

    
    
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

}


//重複しない乱数を発生させるメソッド(1〜8)
-(void)createRndArray{
    
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
//    NSLog(@"%@",randNums);
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


// パズル完成を判定するメソッド
- (void)judge{
    if(([self.viewArray1[2]intValue] == 1) && ([self.viewArray2[2]intValue] == 2) && ([self.viewArray3[2]intValue] == 3) && ([self.viewArray4[2]intValue] == 4) && ([self.viewArray5[2]intValue] == 5) && ([self.viewArray6[2]intValue] == 6) && ([self.viewArray7[2]intValue] == 7) && ([self.viewArray8[2]intValue] == 8)){
        NSLog(@"完成");
    }
}


@end
