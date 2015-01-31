//
//  listCollectionViewController.m
//  originalSlideGame
//
//  Created by 中島 知秀 on 2015/01/30.
//  Copyright (c) 2015年 Tomohide Nakahsima. All rights reserved.
//

#import "listCollectionViewController.h"
#import "gameCollectionViewCell.h"
#import "playViewController.h"
#import "pictureViewController.h"

@interface listCollectionViewController ()

@end

@implementation listCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // Uncomment the following line to preserve selection between presentations
//    // self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
//    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    self.divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
//    self.count = [self.divPicDataFinal count];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
    self.count = [self.divPicDataFinal count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return (self.count+1);  // 最後のセルにはcreateを促すようなものを入れる
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    gameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.count){
        NSString *sampleText = [NSString stringWithFormat:@"No.%ld", indexPath.row];
        cell.sampleLabel.text = sampleText;
    
        NSArray *picData = self.divPicDataFinal[indexPath.row];
        UIImage *pic0 = [UIImage imageWithData:picData[0]];  // 写真のデータをdataからimageに変換
        cell.samplePicView.image = pic0;
    }
    
    if (indexPath.row == self.count) {
        cell.sampleLabel.text = @"Let's create!";  // 最後のセルには「create original game」的なものを入れ、ゲーム作成画面に飛ばす
    }
    
    return cell;
}


// セグエする際にデータを渡す
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSArray *paths = [self.collectionView indexPathsForSelectedItems];
//    NSIndexPath * path = [paths objectAtIndex:0];
//    
//    playViewController *playView = [segue destinationViewController];
//    playView.pathNo =path.row;
//    
//    playView.divPicturesData = self.divPicDataFinal[path.row];
}


// セルがタップされたときの処理(遷移先と値渡し)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.count) {
        playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
        playView.pathNo =indexPath.row;  // 値渡し
        playView.divPicturesData = self.divPicDataFinal[indexPath.row];  // 値渡し
        [self.navigationController pushViewController:playView animated:YES]; // プレイ画面に遷移
    }
    
    if (indexPath.row == self.count) {
        pictureViewController *pictureView = [self.storyboard instantiateViewControllerWithIdentifier:@"pictureView"];
        [self.navigationController pushViewController:pictureView animated:NO]; // ゲーム作成画面に遷移
    }
}


// unwindsegueでこの画面に戻すための処理
- (IBAction)listViewReturnActionForSegue:(UIStoryboardSegue *)segue{
    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    [self.navigationController pushViewController:playView animated:YES];
    
    [self goPlayView];
}

- (void)goPlayView{
    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    [self.navigationController pushViewController:playView animated:YES];
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
