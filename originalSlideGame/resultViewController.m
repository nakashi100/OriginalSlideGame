//
//  resultViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "resultViewController.h"

@interface resultViewController ()

@end

@implementation resultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.twitterImage.image = [UIImage imageNamed:@"mihonSample"];
    
    self.resultTime.text = self.result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)retryBtn:(id)sender {
    // Playページへモーダルで遷移させる
//    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
//    [self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)goTitleBtn:(id)sender {
    // Titleページへモーダルで遷移させる
//    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"titleView"];
//    [self presentViewController:controller animated:YES completion:nil];
    
}
@end
