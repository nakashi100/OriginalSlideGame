//
//  confirmPicViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/31.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "confirmPicViewController.h"

@interface confirmPicViewController ()

@end

@implementation confirmPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.divPicData2 = [userDefault arrayForKey:@"divPicData"];
    NSMutableArray *divPicData2 = [self.divPicData2 mutableCopy]; //追加できるようArrayをMutableArrayに変換
    
    
    UIImage *displayPicImage = [UIImage imageWithData:divPicData2[0]];  // 写真のデータをdataからimageに変換
    self.displayPicView.image = displayPicImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)fixPicBtn:(id)sender {
}
@end
