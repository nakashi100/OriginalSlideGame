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
    
    
    // for文でループ処理を使いたいが、、、
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
    
    // image9(tag:9)を削除する
     [[self.view viewWithTag:9] removeFromSuperview];
    
    
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
    
    
//    if ([self.view viewWithTag:9] == nil) {
//        NSLog(@"空です");
//    }
}


//重複しない乱数を発生させる関数(1〜8)
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


/***********************************************************
                    スライドした時の処理
***********************************************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    
    switch (touch.view.tag) {
        case 8:
            if ([self.view viewWithTag:5] == nil) {
                //
            }else if ([self.view viewWithTag:7] == nil) {
                //
            }else if ([self.view viewWithTag:9] == nil) {
                NSLog(@"成功です");
//                [self.view viewWithTag:8] =
            }
            break;
            
        default:
            break;
    }
    
    
//    switch (touch.view.tag)
//        case 8:
////            if ([self.view viewWithTag:19] == nil) {
//                    NSLog(@"成功");
////            }
//            break;
//}


    
}


@end
