//
//  pictureViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pictureViewController : UIViewController

- (IBAction)createPictureBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *displayPictureView;


@end
