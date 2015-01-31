//
//  titleViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface titleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

- (IBAction)useDefaultReset:(id)sender;

@property BOOL createdFlag;

@end
