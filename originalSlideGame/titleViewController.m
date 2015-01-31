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
    NSArray *divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
    NSArray *nowPlaying = [userDefault arrayForKey:@"nowPlayingGame"];
    
    NSLog(@"配列の個数は%d",[divPicDataFinal count]);
    NSLog(@"nowPlayingは%d",[nowPlaying count]);
    
//    BOOL createdFlag = [userDefault boolForKey:@"createdFlag"];
//    if(!createdFlag){
//        NSLog(@"フラグあり");
//    listCollectionViewController *con = [self.storyboard instantiateViewControllerWithIdentifier:@"listCollectionView"];
//    [self.navigationController pushViewController:con animated:YES];
//    }
    
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

- (IBAction)listBtn:(id)sender {
}


// unwindsegueでこの画面に戻すための処理
- (IBAction)titleViewReturnActionForSegue:(UIStoryboardSegue *)segue {
}

- (IBAction)title2ViewReturnActionForSegue:(UIStoryboardSegue *)segue{

}

- (void)goPlayView{
    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    [self.navigationController pushViewController:playView animated:YES];
}

- (void)golistCollectionView{
    listCollectionViewController *listCollectionView = [self.storyboard instantiateViewControllerWithIdentifier:@"listCollectionView"];
    [self.navigationController pushViewController:listCollectionView animated:YES];
}

@end
