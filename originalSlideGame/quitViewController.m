//
//  quitViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/28.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "quitViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface quitViewController ()

@end

@implementation quitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)continueBtn:(id)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)quitBtn:(id)sender {
}
@end
