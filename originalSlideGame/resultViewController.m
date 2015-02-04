//
//  resultViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "resultViewController.h"
#import "playViewController.h"
#import "listCollectionViewController.h"

@interface resultViewController ()

@end

@implementation resultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    self.twitterImage.image = [UIImage imageNamed:@"mihonSample"];
    self.resultTime.text = self.result;
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    self.playingArrayCount = [self.divPicturesData count];
    
    ////////////////////// ゲームの記録が更新されたかどうかを判断 ////////////////////////////

    // 3×3のパズルで初クリア
    if (self.playingArrayCount == 10) {
        NSArray *normalFinalList = [userDefault arrayForKey:@"normalFinalList"];
        NSMutableArray *normalFinalListMutable = [normalFinalList mutableCopy];
        
        NSArray *thisGameArray = normalFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        [thisGameArrayMutable addObject:self.result]; // 配列の最後にタイムを追加する
        
NSLog(@"%d",[thisGameArrayMutable count]);
        
        normalFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
        
NSLog(@"%d",[normalFinalListMutable[self.pathNo] count]);
        
        
        [userDefault setObject:normalFinalListMutable forKey:@"normalFinalList"]; // 保存し直す
        
        
NSLog(@"3×3初クリア！タイムは%@", thisGameArrayMutable[10]);
  
        // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
        [userDefault setObject:normalFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
    }
    
    
    
    // 3×3でクリア履歴あり
    if (self.playingArrayCount == 11) {
        NSArray *normalFinalList = [userDefault arrayForKey:@"normalFinalList"];
        NSMutableArray *normalFinalListMutable = [normalFinalList mutableCopy];
        
        NSArray *thisGameArray = normalFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        
        if ([self.divPicturesData[10] floatValue] > self.result.floatValue) {
            [thisGameArrayMutable replaceObjectAtIndex:10 withObject:self.result]; // 記録更新

            normalFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
            
            [userDefault setObject:normalFinalListMutable forKey:@"normalFinalList"];
NSLog(@"3×3記録更新！タイムは%@",normalFinalListMutable[0][10]);
        }else if([self.divPicturesData[10] floatValue] < self.result.floatValue){
        
NSLog(@"3×3記録更新ならず。過去のベストは%@", normalFinalListMutable[0][10]);
        // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
        [userDefault setObject:normalFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
        }
    }
    
    
  
//    // 4×4で初クリア
    if (self.playingArrayCount == 17) {
        NSArray *hardFinalList = [userDefault arrayForKey:@"hardFinalList"];
        NSMutableArray *hardFinalListMutable = [hardFinalList mutableCopy];
        
        NSArray *thisGameArray = hardFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        [thisGameArrayMutable addObject:self.result]; // 配列の最後にタイムを追加する
        
        //NSLog(@"%d",[thisGameArrayMutable count]);
        
        hardFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
        
        //NSLog(@"%d",[normalFinalListMutable[self.pathNo] count]);
        
        
        [userDefault setObject:hardFinalListMutable forKey:@"hardFinalList"]; // 保存し直す
        
        
        //NSLog(@"3×3初クリア！タイムは%@", thisGameArrayMutable[10]);
        
        // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
        [userDefault setObject:hardFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
    }
    
    
   
    // 4×4でクリア履歴あり
    if (self.playingArrayCount == 18) {
        NSArray *hardFinalList = [userDefault arrayForKey:@"hardFinalList"];
        NSMutableArray *hardFinalListMutable = [hardFinalList mutableCopy];
        
        NSArray *thisGameArray = hardFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        
        if ([self.divPicturesData[17] floatValue] > self.result.floatValue ) {
            [thisGameArrayMutable replaceObjectAtIndex:17 withObject:self.result]; // 記録更新
            
            hardFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
            
            [userDefault setObject:hardFinalListMutable forKey:@"hardFinalList"];
            NSLog(@"3×3記録更新！タイムは%@",hardFinalListMutable[0][17]);
        }else if([self.divPicturesData[17] floatValue] < self.result.floatValue){
            
            NSLog(@"3×3記録更新ならず。過去のベストは%@", hardFinalListMutable[0][17]);
            // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
            [userDefault setObject:hardFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
        }
    }

    
    [userDefault synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // retryBtnが押されたときだけ実行するようにsenderにtagをつけて条件処理する
    if ([sender tag] == 2) {
         listCollectionViewController *listCollectionView = [segue destinationViewController];
        listCollectionView.playingArrayCount = self.playingArrayCount;
        listCollectionView.pathNo = self.pathNo;
    }
    
}

- (IBAction)retryBtn:(id)sender {
}

- (IBAction)goTitleBtn:(id)sender {
    
}
@end
