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



/****************************************************************
                        スライドした時の処理
****************************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

//    NSLog(@"タッチしたビューは、%@", touch.view);
    
    int aaa = 11;
    
    switch (touch.view.tag) {
            NSLog(@"タッチしたビューは、%@", touch.view);
        
        //--------------------------------------------------------------
        case 8:
            
            if([self.viewArray9[0] intValue] == 0){
                // タグを動かす
                [self push:[self.viewArray8[1] intValue] xzahyo:92 yzahyo:0];
                
                // 配列の中身を入れ替える
                self.viewArray9 = [@[self.viewArray8[0],self.viewArray8[1],self.viewArray8[2]]mutableCopy];
                self.viewArray8 = [@[@0,@0,@0]mutableCopy];
            }
            
            
            
            
            
            
                /********************
                    検証用コード
                ********************/
                // 入れ替え前
//                NSLog(@"前のview%@", self.viewArray8);
//                NSLog(@"後のview%@", self.viewArray9);
                
                //入れ替え後
//                NSLog(@"前のview%@", self.viewArray8);
//                NSLog(@"後のview%@", self.viewArray9);

            break;
            
            
        //--------------------------------------------------------------
        case 9:
            
            break;
            
        //--------------------------------------------------------------
        case 1:
            
            break;
        //--------------------------------------------------------------
        case 2:
            
            break;
        //--------------------------------------------------------------
        case 3:
            
            break;
        //--------------------------------------------------------------
        case 4:
            
            break;
        //--------------------------------------------------------------
        case 5:
            
            break;
        //--------------------------------------------------------------
        case 6:
            
            break;
        //--------------------------------------------------------------
        case 7:
            
            break;
        //--------------------------------------------------------------
        default:
            
            break;
            }
    
    }






// スライドを動かすメソッド (tag番号とx座標とy座標を指定する)
- (IBAction)push:(int)test xzahyo:(int)xzahyo yzahyo:(int)yzahyo {
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect rect = CGRectMake(xzahyo, yzahyo, self.image1.frame.size.width, self.image1.frame.size.height);
                         [[self.view viewWithTag:test] setFrame:rect];
                     }
                     completion:^(BOOL finished){
//                         [[self.view viewWithTag:test] setBackgroundColor:[UIColor redColor]];
                    }
     ];
}

@end
