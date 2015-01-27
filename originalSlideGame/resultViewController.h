//
//  resultViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *twitterImage;
- (IBAction)retryBtn:(id)sender;
- (IBAction)goTitleBtn:(id)sender;

@end
