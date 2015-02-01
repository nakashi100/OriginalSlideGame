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
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
///////////// 検証用(あとで消す //////////////////////
NSArray *divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
NSArray *nowPlaying = [userDefault arrayForKey:@"nowPlaying"];
    
NSLog(@"配列の個数は%d",[divPicDataFinal count]);
NSLog(@"nowPlayingは%d",[nowPlaying count]);
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



@end
