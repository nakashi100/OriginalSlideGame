//
//  pictureViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/26.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "pictureViewController.h"

@interface pictureViewController ()

@end

@implementation pictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.finishBtn2.hidden = YES;
    self.remakeBtn2.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createPictureBtn:(id)sender {
    
//NSLog(@"%@",sender);
    
    UIActionSheet *pictureActionSeet = [[UIActionSheet alloc]initWithTitle:@"Select"
                                                                  delegate:self cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Camera",@"Photo Library", nil];
    [pictureActionSeet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self showCamera:buttonIndex];
            break;
        case 1:
            [self showCamera:buttonIndex];
            break;
        default:
            NSLog(@"Cancel button was tapped");
            break;
    }
}


- (IBAction)showCamera:(NSInteger)isCamera {
    // カメラが使用可能か判断
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSLog(@"カメラ機能へアクセスできません");
        return;
    }
    
    // UIImagePickerControllerのインスタンスを生成
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    
    // デリゲートを設定
    imagePickerController.delegate = self;
    
    switch (isCamera) {
        case 0:
            // 画像の取得先をカメラに設定
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            // 画像の取得先をフォトライブラリに設定
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    
    // 撮影画面をモーダルビューとして表示
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
    
    /************************************************
     // カメラにボタンを配置したい場合
     UIButton *button = [UIButton new];
     button.frame = CGRectMake(50, 50, 100, 50);
     button.backgroundColor = [UIColor redColor];
     button.titleLabel.text = @"hogehoge";
     [imagePickerController.view addSubview:button];
     *************************************************/
}


// 画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    // 画像の取得がカメラからかフォトライブラリからかで処理を分散
    //    switch([picker sourceType]){
    //        case UIImagePickerControllerSourceTypePhotoLibrary:
    //            break;
    //        case UIImagePickerControllerSourceTypeCamera:
    //            UIImageWriteToSavedPhotosAlbum(image, self, @selector(targetImage:didFinishSavingWithError:contextInfo:), NULL);
    //            break;
    //        default:
    //            break;
    //    }
    
    
    
    
    //////////////   画像のリサイズ (320(短い)×●●(320以上))を作成  ///////////////
    
    // 取得した画像の縦サイズ、横サイズを取得する
    int imageW = image.size.width;
    int imageH = image.size.height;
    
    // リサイズする倍率を作成する
    float scale;
    if(imageH > imageW){
        scale = 320.0f/imageW;
    }else{
        scale = 320.0f/imageH;
    }
    
    // リサイズ後のサイズ
    CGSize size = CGSizeMake(imageW * scale, imageH * scale);
    
    // グラフィックコンテキストへの描画
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationDefault); //画像リサイズの補完方法を指定
    [image drawInRect:CGRectMake(0, 0,size.width, size.height)]; //drawInRectは指定した矩形にフィットするようにスケーリングして画像全体を描画する
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    ////////////////////////    画像のトリミング    /////////////////////////////
    
    // 切り抜き元となる画像を用意する
    int imageMijikai;
    
    if (resultImage.size.height > resultImage.size.width) {
        imageMijikai = resultImage.size.width;
    } else{
        imageMijikai = resultImage.size.height;
    }
    
    
    // 切り抜く位置を指定するCGRectを作成する
    // 今回は、画像の中心部分を短いほうの辺で切り取る(なお簡略化のため、imageW,imageHともに320以上と仮定)
    int posX = (resultImage.size.width - imageMijikai) / 2;
    int posY = (resultImage.size.height - imageMijikai) / 2;
    CGRect trimArea = CGRectMake(posX, posY, imageMijikai, imageMijikai);
    
    // CoreGraphicsの機能を用いて、切り抜いた画像を作成する
    CGImageRef srcImageRef = [resultImage CGImage];
    CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, trimArea);
    UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef];
    
    
    /////////////////////////////////////////////////////////////////////////
    
    // 取得した画像を画面上へ表示
    self.displayPictureView.image = trimmedImage;
    
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 画像を分割
    [self divImage:trimmedImage];
    
    // 初期ボタンやviewを非表示にし、新たなボタンを表示する
    [self.createPictureBtn2 removeFromSuperview];
    [self.explainLabel removeFromSuperview];
    self.finishBtn2.hidden = NO;
    self.remakeBtn2.hidden = NO;
}



// 画像を分割して配列に保存するメソッド
- (NSMutableArray *)divImage:(UIImage *)image
{
    int DVICOUNT = 3;   // 3×3にする場合
    
    CGImageRef srcImageRef = [image CGImage];
    
    CGFloat blockWith = image.size.width / DVICOUNT;
    CGFloat blockHeight = image.size.height / DVICOUNT;
    
    NSMutableArray *divImages = [[NSMutableArray alloc] init];
    
    for (int heightCount=0; heightCount < DVICOUNT; heightCount++) {
        for(int widthCount=0; widthCount < DVICOUNT; widthCount++){
            CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, CGRectMake(widthCount*blockWith, heightCount*blockHeight, blockWith, blockHeight));
            
            
            UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef
                                     scale:[UIScreen mainScreen].scale orientation:image.imageOrientation]; //orientationは画像の向きの情報
            
            [divImages addObject:trimmedImage];            
        }
    }
    
    
    // UserDefaultsで引継ぐためにimageをdata型に変換して配列に格納し直す
    NSData *mihonPic = UIImageJPEGRepresentation(image, 1.0);
    NSMutableArray *divPicData = [NSMutableArray array];
    [divPicData addObject:mihonPic];    //divPicData[0]には見本画像を格納
    
    for(int i=0; i < [divImages count]; i++){
        NSData *data = UIImageJPEGRepresentation(divImages[i], 1.0);
        [divPicData addObject:data];    // divPicData[1]〜[n]には分割画像を格納
    }
    
    
    
/*********************************************************************************
         写真の表示と保存の向きの問題のため、配列し直す
 *********************************************************************************/
    self.divPicData2 = [NSMutableArray array];
    
    
    if (image.imageOrientation == 0) {
        self.divPicData2 = divPicData;
    }

    if(image.imageOrientation == 1){
        self.self.divPicData2[0] = divPicData[0];
        self.divPicData2[1] = divPicData[9];
        self.divPicData2[2] = divPicData[8];
        self.divPicData2[3] = divPicData[7];
        self.divPicData2[4] = divPicData[6];
        self.divPicData2[5] = divPicData[5];
        self.divPicData2[6] = divPicData[4];
        self.divPicData2[7] = divPicData[3];
        self.divPicData2[8] = divPicData[2];
        self.divPicData2[9] = divPicData[1];
    }
    
    if(image.imageOrientation == 2){
        self.divPicData2[0] = divPicData[0];
        self.divPicData2[1] = divPicData[3];
        self.divPicData2[2] = divPicData[6];
        self.divPicData2[3] = divPicData[9];
        self.divPicData2[4] = divPicData[2];
        self.divPicData2[5] = divPicData[5];
        self.divPicData2[6] = divPicData[8];
        self.divPicData2[7] = divPicData[1];
        self.divPicData2[8] = divPicData[4];
        self.divPicData2[9] = divPicData[7];
    }
    
    if(image.imageOrientation == 3){
        self.divPicData2[0] = divPicData[0];
        self.divPicData2[1] = divPicData[7];
        self.divPicData2[2] = divPicData[4];
        self.divPicData2[3] = divPicData[1];
        self.divPicData2[4] = divPicData[8];
        self.divPicData2[5] = divPicData[5];
        self.divPicData2[6] = divPicData[2];
        self.divPicData2[7] = divPicData[9];
        self.divPicData2[8] = divPicData[6];
        self.divPicData2[9] = divPicData[3];
    }
    
    
//     UserDefautで画像のデータを保存
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:self.divPicData2 forKey:@"divPicData"];
//    [userDefault synchronize];
    
    return divImages;
}




- (IBAction)remakeBtn:(id)sender {
    [self createPictureBtn:@"creatPictureBtn"];
}


- (IBAction)finishBtn:(id)sender{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    // UserDefautで保存したゲームリスト配列を呼び出したいが、空の場合は空のリストを生成する(これをしないとError)
    if ([userDefault arrayForKey:@"divPicDataFinal"] == nil) {
        NSArray *sampleArray = [NSArray array];
        [userDefault setObject:sampleArray forKey:@"divPicDataFinal"];
    }
    
    self.divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
    NSMutableArray *divPicDataFinal2 = [self.divPicDataFinal mutableCopy]; //追加できるようArrayをMutableArrayに変換
    [divPicDataFinal2 addObject:self.divPicData2]; // ゲームリスト配列の最後に今回作成したものを追加
    
    [userDefault setObject:divPicDataFinal2 forKey:@"divPicDataFinal"]; // UserDefaultで保存し直す
    [userDefault synchronize];
}
@end
