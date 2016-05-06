//
//  resultViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/27.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "resultViewController.h"
#import "playViewController.h"
#import "listCollectionViewController.h"
#import "FlatUIKit.h"

@interface resultViewController ()

@end

@implementation resultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // SNSシェアができるかの確認
    //    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    //        NSLog(@"FB利用できるよ");
    //    }else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
    //        NSLog(@"FB利用できないよ");
    //    }
    //
    //    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
    //        NSLog(@"t利用できるよ");
    //    }else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
    //        NSLog(@"t利用できないよ");
    //    }
    
    
    // iad
    [self loadiAdInterstitial];
    
    // Mopub
    // TODO: Replace this test id with your personal ad unit id
    MPAdView* adView = [[MPAdView alloc] initWithAdUnitId:@"29563a19274e455aafea194624766952"
                                                     size:MOPUB_BANNER_SIZE];
    self.adView = adView;
    self.adView.delegate = self;
    
    // Positions the ad at the bottom, with the correct size
    self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width)/2, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    
    // Loads the ad over the network
    [self.adView loadAd];

}

- (void)viewWillAppear:(BOOL)animated{
    //NSLog(@"result%d",self.pathNo);
    
    // 画面のレイアウト
    self.messageLabel.text = @"Congratulations!";
    self.messageLabel.font = [UIFont boldFlatFontOfSize:32];
    self.resultTime.font = [UIFont boldFlatFontOfSize:25];
    
    self.twitterImage.image = [UIImage imageNamed:@"twitter"];
    // self.facebookImage.image = [UIImage imageNamed:@"facebook"];
    NSString *resultTime = [NSString stringWithFormat:@"TIME: %@", self.result];
    self.resultTime.text = resultTime;
    
    // TITLEボタン
    self.goTitleBtn2.buttonColor = [UIColor peterRiverColor]; // ボタンの色
    self.goTitleBtn2.shadowColor = [UIColor belizeHoleColor]; // ボタンのシャドー色
    self.goTitleBtn2.shadowHeight = 3.0f; // ボタンのシャドー高度
    self.goTitleBtn2.cornerRadius = 6.0f; // ボタンの角丸みの半径
    self.goTitleBtn2.titleLabel.font = [UIFont boldFlatFontOfSize:18]; // ボタンの文字ファンド
    [self.goTitleBtn2 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal]; // 通常状態の文字色
    [self.goTitleBtn2 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted]; // ハイライト状態の文字色
    
    // RETRYボタン
    self.retryBtn2.buttonColor = [UIColor peterRiverColor]; // ボタンの色
    self.retryBtn2.shadowColor = [UIColor belizeHoleColor]; // ボタンのシャドー色
    self.retryBtn2.shadowHeight = 3.0f; // ボタンのシャドー高度
    self.retryBtn2.cornerRadius = 6.0f; // ボタンの角丸みの半径
    self.retryBtn2.titleLabel.font = [UIFont boldFlatFontOfSize:18]; // ボタンの文字ファンド
    [self.retryBtn2 setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal]; // 通常状態の文字色
    [self.retryBtn2 setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted]; // ハイライト状態の文字色
    
    
    // twitterとfacebookボタンにタップジェスチャービューをつける
    self.twitterImage.userInteractionEnabled = YES;
    self.facebookImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *fbTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(facebook_Tapped:)];
    [self.facebookImage addGestureRecognizer:fbTapGesture]; // ビューにジェスチャーを追加
    
    UITapGestureRecognizer *twitterTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twitter_Tapped:)];
    [self.twitterImage addGestureRecognizer:twitterTapGesture]; // ビューにジェスチャーを追加
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    self.playingArrayCount = [self.divPicturesData count];
    
    ////////////////////// ゲームの記録が更新されたかどうかを判断 ////////////////////////////

    // 3×3のパズルで初クリア
    if (self.playingArrayCount == 10) {
        NSArray *normalFinalList = [userDefault arrayForKey:@"normalFinalList"];
        NSMutableArray *normalFinalListMutable = [normalFinalList mutableCopy];
        
        NSArray *thisGameArray = normalFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        [thisGameArrayMutable addObject:self.result]; // 配列の最後にタイムを追加する
        
        //NSLog(@"%d",[thisGameArrayMutable count]);
        
        normalFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
        
        //NSLog(@"%d",[normalFinalListMutable[self.pathNo] count]);
        
        [userDefault setObject:normalFinalListMutable forKey:@"normalFinalList"]; // 保存し直す
        
        
        //NSLog(@"3×3初クリア！タイムは%@", thisGameArrayMutable[10]);
  
        // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
        [userDefault setObject:normalFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
    }
    
    
    
    // 3×3でクリア履歴あり
    else if (self.playingArrayCount == 11) {
        NSArray *normalFinalList = [userDefault arrayForKey:@"normalFinalList"];
        NSMutableArray *normalFinalListMutable = [normalFinalList mutableCopy];
        
        NSArray *thisGameArray = normalFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        
        if ([self.divPicturesData[10] floatValue] > self.result.floatValue) {
            [thisGameArrayMutable replaceObjectAtIndex:10 withObject:self.result]; // 記録更新

            normalFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
            
            [userDefault setObject:normalFinalListMutable forKey:@"normalFinalList"];
            [userDefault setObject:normalFinalListMutable[self.pathNo] forKey:@"nowPlaying"]; //今回追加
            
            // NSLog(@"3×3記録更新！タイムは%@",normalFinalListMutable[0][10]);
        }else if([self.divPicturesData[10] floatValue] < self.result.floatValue){
            // NSLog(@"3×3記録更新ならず。過去のベストは%@", normalFinalListMutable[0][10]);
            // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
            [userDefault setObject:normalFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
        }
    }
    
    
    // 4×4で初クリア
    else if (self.playingArrayCount == 17) {
        NSArray *hardFinalList = [userDefault arrayForKey:@"hardFinalList"];
        NSMutableArray *hardFinalListMutable = [hardFinalList mutableCopy];
        
        NSArray *thisGameArray = hardFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        [thisGameArrayMutable addObject:self.result]; // 配列の最後にタイムを追加する
        
        // NSLog(@"%d",[thisGameArrayMutable count]);
        
        hardFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
        
        // NSLog(@"%d",[normalFinalListMutable[self.pathNo] count]);
        
        [userDefault setObject:hardFinalListMutable forKey:@"hardFinalList"]; // 保存し直す
        
        // NSLog(@"3×3初クリア！タイムは%@", thisGameArrayMutable[10]);
        // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
        [userDefault setObject:hardFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
    }
    
   
    // 4×4でクリア履歴あり
    else if (self.playingArrayCount == 18) {
        NSArray *hardFinalList = [userDefault arrayForKey:@"hardFinalList"];
        NSMutableArray *hardFinalListMutable = [hardFinalList mutableCopy];
        
        NSArray *thisGameArray = hardFinalList[self.pathNo];
        NSMutableArray *thisGameArrayMutable = [thisGameArray mutableCopy];
        
        
        if ([self.divPicturesData[17] floatValue] > self.result.floatValue ) {
            [thisGameArrayMutable replaceObjectAtIndex:17 withObject:self.result]; // 記録更新
            
            hardFinalListMutable[self.pathNo] = thisGameArrayMutable;  // 元のリストの配列と新しい配列を入れ替える
            
            [userDefault setObject:hardFinalListMutable forKey:@"hardFinalList"];
            [userDefault setObject:hardFinalListMutable[self.pathNo] forKey:@"nowPlaying"]; // 今回追加
            // NSLog(@"3×3記録更新！タイムは%@",hardFinalListMutable[0][17]);
        }else if([self.divPicturesData[17] floatValue] < self.result.floatValue){
            // NSLog(@"3×3記録更新ならず。過去のベストは%@", hardFinalListMutable[0][17]);
            // RETRYしたときにプレイ中のデータを保持してプレイ画面でゲーム再構築する
            [userDefault setObject:hardFinalListMutable[self.pathNo] forKey:@"nowPlaying"];
        }
    }

    [userDefault synchronize];
    
    // 今回はfacebookシェアは入れない
    self.facebookImage.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // retryBtnが押されたときだけ実行するようにsenderにtagをつけて条件処理する
    if ([sender tag] == 2) {
         listCollectionViewController *listCollectionView = [segue destinationViewController];
    
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSArray *playingGame = [userDefault arrayForKey:@"nowPlaying"];
        
        listCollectionView.playingArrayCount = [playingGame count];
        listCollectionView.pathNo = self.pathNo;
    }
}

- (IBAction)retryBtn:(id)sender {
}

- (IBAction)goTitleBtn:(id)sender {
}

- (void)facebook_Tapped:(UITapGestureRecognizer *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        [self postToFacebook];
    }else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        NSLog(@"Facebook利用できません");
    }
}

- (void)twitter_Tapped:(UITapGestureRecognizer *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        [self postToTwitter];
    }else if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        NSLog(@"twitter利用できません");
    }
}


//Facebookへ投稿
- (void)postToFacebook {
    UIImage *playingPic = [UIImage imageWithData:self.divPicturesData[0]];
    
    SLComposeViewController *slc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [slc setInitialText:@"You can enjoy your original puzzle games!!"];
    [slc addImage:playingPic];
    // [slc addURL:[NSURL URLWithString:@"http://testリリース後に書く"]];
    [self presentViewController:slc animated:YES completion:nil];
}


//Twitterへ投稿
- (void)postToTwitter {
    UIImage *playingPic = [UIImage imageWithData:self.divPicturesData[0]];
    
    SLComposeViewController *slc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [slc setInitialText:@"You can create your original puzzles using your favorite photos! Let's enjoy!!"];
    [slc addImage:playingPic];
    // [slc addURL:[NSURL URLWithString:@"http://nexseed.net/"]]; // リリース後に記載
    [self presentViewController:slc animated:YES completion:nil];
}


////LINEへ投稿
//- (IBAction)postToLine:(id)sender {
//    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];
//    [pasteboard setData:UIImagePNGRepresentation([UIImage imageNamed:POST_IMG_NAME]) forPasteboardType:@"public.png"];
//    NSString *LineUrlString = [NSString stringWithFormat:@"line://msg/image/%@", pasteboard.name];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LineUrlString]];
//}



#pragma mark - iAd Interstitial Ad

// iAdインタースティシャル広告読み込み
- (void)loadiAdInterstitial
{
    self.iAdInterstitial = [[ADInterstitialAd alloc] init];
    self.iAdInterstitial.delegate = self;
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
    [self requestInterstitialAdPresentation];
    // NSLog(@"1");
}


// iAdインタースティシャル広告がロードされた時に呼ばれる
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    if (self.iAdInterstitial.loaded) {
        [self.iAdInterstitial presentFromViewController:self];
    }
    // NSLog(@"2");
}

// iAdインタースティシャル広告がアンロードされた時に呼ばれる
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    self.iAdInterstitial = nil;
    // NSLog(@"3");
}

// iAdインタースティシャル広告の読み込み失敗時に呼ばれる
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    self.iAdInterstitial = nil;
    // NSLog(@"4");
}

// iAdインタースティシャル広告が閉じられた時に呼ばれる
- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd
{
    self.iAdInterstitial = nil;
    // NSLog(@"5");
}


// Mopub
#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}


@end
