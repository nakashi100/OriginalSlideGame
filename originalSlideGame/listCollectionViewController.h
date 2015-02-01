//
//  listCollectionViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/30.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSArray *divPicDataFinal;
@property int count; // divPicDataFinal配列の個数

@end
