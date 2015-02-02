//
//  titleViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "titleViewController.h"
#import "playViewController.h"
#import "listCollectionViewController.h"

@interface titleViewController ()

@end

@implementation titleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *divPicDataCheck = [userDefault arrayForKey:@"divPicDataFinal"];
    
    if(!divPicDataCheck){
        [self defaultGame1]; // デフォルトゲームを作成
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
///////////// 検証用(あとで消す //////////////////////
//NSArray *divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
//NSArray *nowPlaying = [userDefault arrayForKey:@"nowPlaying"];
//    
//NSLog(@"配列の個数は%d",[divPicDataFinal count]);
//NSLog(@"nowPlayingは%d",[nowPlaying count]);
//////////////////////////////////////////////////
    
    // createdFlagがYESということは、ゲームがcreateされているのでplay画面までリダイレクトさせるということ。遷移後はflagはNOにする。
    self.createdFlag = [userDefault boolForKey:@"createdFlag"];
    if (self.createdFlag) {
        [self golistCollectionView];
        [self goPlayView];
        self.createdFlag = NO;
        [userDefault setBool:self.createdFlag forKey:@"createdFlag"];
    }
    
    // ゲーム削除の場合のリダイレクト
    self.deletedFlag = [userDefault boolForKey:@"deletedFlag"];
    if (self.deletedFlag) {
        [self golistCollectionView];
        self.deletedFlag = NO;
        [userDefault setBool:self.createdFlag forKey:@"deletedFlag"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)useDefaultReset:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"UserDefaultリセットしたよー!");
}



// unwindsegueでこの画面に戻すための処理
- (IBAction)titleViewReturnActionForSegue:(UIStoryboardSegue *)segue {
}



// list画面に遷移する
- (void)golistCollectionView{
    listCollectionViewController *listCollectionView = [self.storyboard instantiateViewControllerWithIdentifier:@"listCollectionView"];
    [self.navigationController pushViewController:listCollectionView animated:NO];
}

// play画面に遷移する
- (void)goPlayView{
    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    [self.navigationController pushViewController:playView animated:NO];
}


// デフォルトのゲーム配列作成
- (void)defaultGame1{

    // divPicData[0](1つのゲーム配列)に1〜9の数字をセットして配列を作り、その配列自体をdivPicDataFinal[0](ゲーム配列リスト)に保存する
    NSMutableArray *divPicDataFinal = [NSMutableArray array]; // ゲーム配列リスト
    
    NSMutableArray *divPicData = [NSMutableArray array]; // ゲーム配列
    NSString *picText;
    UIImage *picImage;
    NSData *picData;
    
    for (int i=0; i<10; i++) {
        picText = [NSString stringWithFormat:@"sample%d",i];
        picImage = [UIImage imageNamed:picText];

        picData = UIImageJPEGRepresentation(picImage, 1.0);
        [divPicData addObject:picData];
    }
    
    [divPicDataFinal addObject:divPicData]; // 3×3を追加
    
    
    
    NSMutableArray *divPicData2 = [NSMutableArray array]; // ゲーム配列
    NSString *picText2;
    UIImage *picImage2;
    NSData *picData2;
    
    for (int i=0; i<17; i++) {
        picText2 = [NSString stringWithFormat:@"sample%d",i];
        picImage2 = [UIImage imageNamed:picText2];
        
        picData2 = UIImageJPEGRepresentation(picImage2, 1.0);
        [divPicData2 addObject:picData2];
    }
    
    picImage2 = [UIImage imageNamed:@"sample00"];
    picData2 = UIImageJPEGRepresentation(picImage2, 1.0);
    [divPicData2 replaceObjectAtIndex:0 withObject:picData2]; // 4*4の完成画像と差し替える
    
    [divPicDataFinal addObject:divPicData2]; // 4×4を追加
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:divPicDataFinal forKey:@"divPicDataFinal"];
    [userDefault synchronize];
    
    NSLog(@"%lu",[divPicDataFinal count]);
    NSArray *a = divPicDataFinal[0];
    NSArray *b = divPicDataFinal[1];
    NSLog(@"%d",[a count]);
    NSLog(@"%d",[b count]);
    
}


@end
