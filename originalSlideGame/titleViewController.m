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
#import "hardPlayViewController.h"

@interface titleViewController ()

@end

@implementation titleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *normalGame = [userDefault arrayForKey:@"normalFinalList"];
    
    if(!normalGame){
        [self defaultGame]; // デフォルトゲームを作成
//        NSLog(@"こんにちは");
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    // createdFlagがあるということは、ゲームがcreateされているのでplay画面までリダイレクトさせるということ。遷移後はflagは0にする。
    if (self.createdFlag == 1) {  //3×3の場合
        [self golistCollectionView];
        [self goPlayView];
        self.createdFlag = 0;
    }else if(self.createdFlag == 2) {  //4×4の場合
        [self golistCollectionView];
        [self goHardPlayView];
        self.createdFlag = 0;
    }
    
    // ゲーム削除の場合のリダイレクト
    if (self.deletedFlag) {
        [self golistCollectionView];
        self.deletedFlag = NO;
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

// hardPlay画面に遷移する
- (void)goHardPlayView{
    hardPlayViewController *hardPlayView = [self.storyboard instantiateViewControllerWithIdentifier:@"hardPlayView"];
    [self.navigationController pushViewController:hardPlayView animated:NO];
}


// デフォルトのゲーム配列作成
- (void)defaultGame{

    // divPicData[0](1つのゲーム配列)に1〜9の数字をセットして配列を作り、その配列自体をdivPicDataFinal[0](ゲーム配列リスト)に保存する
    
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
    NSMutableArray *normalFinalList = [NSMutableArray array];
    [normalFinalList addObject:divPicData];
    
    
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
    NSMutableArray *hardFinalList = [NSMutableArray array];
    [hardFinalList addObject:divPicData2];
    
    
    picImage2 = [UIImage imageNamed:@"sample00"];
    picData2 = UIImageJPEGRepresentation(picImage2, 1.0);
    [divPicData2 replaceObjectAtIndex:0 withObject:picData2]; // 4*4の完成画像と差し替える
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:normalFinalList forKey:@"normalFinalList"];
    [userDefault setObject:hardFinalList forKey:@"hardFinalList"];
    [userDefault synchronize];
    
}


@end
