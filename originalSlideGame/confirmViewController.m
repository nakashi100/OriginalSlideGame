//
//  confirmViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "confirmViewController.h"

@interface confirmViewController ()

@end

@implementation confirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *divPicturesData = [userDefault arrayForKey:@"divPicData"];
    
    // 写真のデータをdataからimageに変換する
    UIImage *pic0 = [UIImage imageWithData:divPicturesData[0]];
    UIImage *pic1 = [UIImage imageWithData:divPicturesData[1]];
    UIImage *pic2 = [UIImage imageWithData:divPicturesData[2]];
    UIImage *pic3 = [UIImage imageWithData:divPicturesData[3]];
    UIImage *pic4 = [UIImage imageWithData:divPicturesData[4]];
    UIImage *pic5 = [UIImage imageWithData:divPicturesData[5]];
    UIImage *pic6 = [UIImage imageWithData:divPicturesData[6]];
    UIImage *pic7 = [UIImage imageWithData:divPicturesData[7]];
    UIImage *pic8 = [UIImage imageWithData:divPicturesData[8]];
    UIImage *pic9 = [UIImage imageWithData:divPicturesData[9]];
    
    
    // 写真のimageデータをオブジェクトにセット
    self.samplePic0.image = pic0;
    self.samplePic1.image = pic1;
    self.samplePic2.image = pic2;
    self.samplePic3.image = pic3;
    self.samplePic4.image = pic4;
    self.samplePic5.image = pic5;
    self.samplePic6.image = pic6;
    self.samplePic7.image = pic7;
    self.samplePic8.image = pic8;
    self.samplePic9.image = pic9;
        
        
        // for文でループ処理を使いたいがうまくできない、、、
//    for(int i=0; i<10; i++){
//        NSString *samplePicNum = [NSString stringWithFormat:@"samplePic%d", i];　//こっちがうまくいかない
//        NSString *sampleNum = [NSString stringWithFormat:@"pic%d", i]; //こっちはOK
//        self.samplePicNum.image = [UIImage imageWithData:sampleNum];
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
