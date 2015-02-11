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
        [self defaultGame]; // 初プレイ時のみデフォルトゲームを作成
    }
    
    self.add_1.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    // NSLog(@"title%d",self.pathNo);
    self.useDefaultReset2.hidden = YES;
    
    //ナビゲーションバーを非表示
     [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    // プレイボタンのレイアウト
    self.playButton.buttonColor = [UIColor peterRiverColor]; // ボタンの色
    self.playButton.shadowColor = [UIColor belizeHoleColor]; // ボタンのシャドー色
    self.playButton.shadowHeight = 3.0f; // ボタンのシャドー高度
    self.playButton.cornerRadius = 6.0f; // ボタンの角丸みの半径
    self.playButton.titleLabel.font = [UIFont boldFlatFontOfSize:17]; // ボタンの文字ファンド
    [self.playButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal]; // 通常状態の文字色
    [self.playButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted]; // ハイライト状態の文字色
    
    // クリエイトボタンのレイアウト
    self.createButton.buttonColor = [UIColor peterRiverColor]; // ボタンの色
    self.createButton.shadowColor = [UIColor belizeHoleColor]; // ボタンのシャドー色
    self.createButton.shadowHeight = 3.0f; // ボタンのシャドー高度
    self.createButton.cornerRadius = 6.0f; // ボタンの角丸みの半径
    self.createButton.titleLabel.font = [UIFont boldFlatFontOfSize:17]; // ボタンの文字ファンド
    [self.createButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal]; // 通常状態の文字色
    [self.createButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted]; // ハイライト状態の文字色
    
    // タイトルラベルのレイアウト
    self.appTitleLabel.text = @"My Slide Puzzle";
    self.appTitleLabel.font = [UIFont boldFlatFontOfSize:33];
    
    
    
    // createdFlagがある場合はゲームがcreateされているので、play画面までリダイレクトさせる。遷移後はflagは0に
    if (self.createdFlag == 1) {  //3×3の場合
        // playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
        // playView.pathNo = self.pathNo;
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
    
    // iAd
    // self.add_1.delegate = self;
}


// 別画面遷移時にはナビゲーションバーを表示
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// UserDefaultsの中身を一括削除際
- (IBAction)useDefaultReset:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    NSLog(@"UserDefaultsリセットしたよー");
}



// unwindsegueでこの画面に戻すための処理
- (IBAction)titleViewReturnActionForSegue:(UIStoryboardSegue *)segue {
}



// list画面に遷移
- (void)golistCollectionView{
    listCollectionViewController *listCollectionView = [self.storyboard instantiateViewControllerWithIdentifier:@"listCollectionView"];
    [self.navigationController pushViewController:listCollectionView animated:NO];
}

// play画面に遷移
- (void)goPlayView{
    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    playView.pathNo = self.pathNo;
    [self.navigationController pushViewController:playView animated:NO];
}

// hardPlay画面に遷移
- (void)goHardPlayView{
    hardPlayViewController *hardPlayView = [self.storyboard instantiateViewControllerWithIdentifier:@"hardPlayView"];
    hardPlayView.pathNo = self.pathNo;
    [self.navigationController pushViewController:hardPlayView animated:NO];
}


// デフォルトのゲーム配列作成
- (void)defaultGame{

    // divPicData[0](1つのゲーム配列)に1〜9の数字をセットして配列を作り、その配列自体をdivPicDataFinal[0](ゲーム配列リスト)に保存する
    // 3×3用ゲーム配列
    NSMutableArray *divPicData = [NSMutableArray array];
    NSString *picText;
    UIImage *picImage;
    NSData *picData;
    
    for (int i=0; i<10; i++) {
        picText = [NSString stringWithFormat:@"normal%d",i];
        picImage = [UIImage imageNamed:picText];

        picData = UIImageJPEGRepresentation(picImage, 1.0);
        [divPicData addObject:picData];
    }
    NSMutableArray *normalFinalList = [NSMutableArray array];
    [normalFinalList addObject:divPicData];
    
    
    // 4×4用ゲーム配列
    NSMutableArray *divPicData2 = [NSMutableArray array];
    NSString *picText2;
    UIImage *picImage2;
    NSData *picData2;
    
    for (int i=0; i<17; i++) {
        picText2 = [NSString stringWithFormat:@"hard%d",i];
        picImage2 = [UIImage imageNamed:picText2];
        
        picData2 = UIImageJPEGRepresentation(picImage2, 1.0);
        [divPicData2 addObject:picData2];
    }
    NSMutableArray *hardFinalList = [NSMutableArray array];
    [hardFinalList addObject:divPicData2];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:normalFinalList forKey:@"normalFinalList"];
    [userDefault setObject:hardFinalList forKey:@"hardFinalList"];
    [userDefault synchronize];
}


#pragma mark - iAd
//// iAdの処理
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    // NSLog(@"iAd取得成功");
//    self.add_1.hidden = NO;
//}
//
////iAd取得失敗
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    // NSLog(@"iAd取得失敗");
//    self.add_1.hidden = YES;
//}


@end
