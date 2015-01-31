//
//  confirmPicViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/31.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface confirmPicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *displayPicView;
- (IBAction)fixPicBtn:(id)sender;


@property NSArray *divPicData2;
@property NSMutableArray *divPicDataFinal; // ゲームリストを格納

@end
