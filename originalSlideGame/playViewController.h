//
//  playViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/24.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playViewController : UIViewController
- (IBAction)playButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;


@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (weak, nonatomic) IBOutlet UIImageView *image9;


@property (weak, nonatomic) IBOutlet UIImageView *mihon9;


@property NSMutableArray *randNums;


@end
