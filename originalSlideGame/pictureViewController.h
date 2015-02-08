//
//  pictureViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"


@interface pictureViewController : UIViewController <FUIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *displayPictureView;


- (IBAction)createPictureBtn:(id)sender;
@property (weak, nonatomic) IBOutlet FUIButton *createPictureBtn2;

- (IBAction)remakeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet FUIButton *remakeBtn2;

- (IBAction)finishBtn:(id)sender;
@property (weak, nonatomic) IBOutlet FUIButton *finishBtn2;

- (IBAction)editBtn:(id)sender;
@property (weak, nonatomic) IBOutlet FUIButton *editBtn2;

@property NSMutableArray *divPicData2; // 一時的に作成したデータを保存するための配列
@property NSArray *normalFinalList; // 完成したゲームリストを格納するための配列(ノーマル)
@property NSArray *hardFinalList;

@property int DVICOUNT; // 画像を切る際に3×3か4×4か
@property UIImage *trimmedImage;

@property FUIAlertView *alertView;
@property FUIAlertView *createAlertView;

@end
