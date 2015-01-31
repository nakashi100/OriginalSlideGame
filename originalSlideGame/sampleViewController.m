//
//  sampleViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/30.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "sampleViewController.h"

@interface sampleViewController ()

@end

@implementation sampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //////////// テスト用 ///////////////////////////////
    NSString *sampleText = [NSString stringWithFormat:@"これは%ld番目だよー", self.pathNo];
    self.sampleLabel.text = sampleText;
    ///////////////////////////////////////////////////

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
