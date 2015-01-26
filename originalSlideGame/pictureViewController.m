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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createPictureBtn:(id)sender {
    
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
    
    
    // 取得した画像を画面上へ表示
    self.displayPictureView.image = image;
    
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
    //UserDefautで画像のデータを保存する
//    NSData *prePictureImageData = UIImagePNGRepresentation(self.displayPictureView.image);
    NSData *prePictureImageData = UIImageJPEGRepresentation(self.displayPictureView.image , 1.0);
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:prePictureImageData forKey:@"temporaryPicture"];
    [userDefault synchronize];
}




@end
