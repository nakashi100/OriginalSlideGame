//
//  listCollectionViewController.h
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/30.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MoPub/MPAdView.h>


@interface listCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, MPAdViewDelegate>



//@property int count; // divPicDataFinal配列の個数
@property UIBarButtonItem *addBtn; // 追加ボタン

@property int playingArrayCount;

@property NSArray *normalFinalList; // 3×3のパズルだけを格納したリスト配列
@property NSArray *hardFinalList;

@property int pathNo; // リダイレクトされた際に受け取る

@property (nonatomic, retain) MPAdView *adView; // Mopub

@end
