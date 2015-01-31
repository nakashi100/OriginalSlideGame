//
//  pictureViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pictureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *displayPictureView;


- (IBAction)createPictureBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *createPictureBtn2;

- (IBAction)remakeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *remakeBtn2;

- (IBAction)finishBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn2;

@property NSMutableArray *divPicData2; // 一時的に作成したデータを保存するための配列
@property NSArray *divPicDataFinal; // 完成したゲームリストを格納するための配列

@end
