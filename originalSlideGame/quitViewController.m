//
//  quitViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/28.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "quitViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "playViewController.h"

@interface quitViewController ()

@end

@implementation quitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
NSLog(@"テスト1");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)continueBtn:(id)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    
NSLog(@"テスト2");
//    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
}

- (IBAction)quitBtn:(id)sender {
}
@end
