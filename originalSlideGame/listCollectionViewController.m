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
#import "hardPlayViewController.h"

@interface listCollectionViewController ()

@end

@implementation listCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = @"LIST";
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.divPicDataFinal = [userDefault arrayForKey:@"divPicDataFinal"];
    self.count = [self.divPicDataFinal count];
    
    
    // ナビゲーションバーに追加ボタンを設置
    self.addBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGame)];
    self.navigationItem.rightBarButtonItem = self.addBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.count;  // 最後のセルにはcreateを促すようなものを入れる
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    gameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameCell" forIndexPath:indexPath];
    
//    if (indexPath.row < self.count){
        NSArray *picData = self.divPicDataFinal[indexPath.row];
        UIImage *pic0 = [UIImage imageWithData:picData[0]];  // 写真のデータをdataからimageに変換
        cell.samplePicView.image = pic0;
//    }
//    
//    if (indexPath.row == self.count) {
//        cell.samplePicView.image = [UIImage imageNamed:@"add_sample"];
//    }
    
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
    

    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    hardPlayViewController *hardPlayView = [self.storyboard instantiateViewControllerWithIdentifier:@"hardPlayView"];
    NSArray *thisGameArray  = self.divPicDataFinal[indexPath.row]; // playViewかhardPlayViewに遷移するかを判定
    int arrayCount = [thisGameArray count];
    
    if (arrayCount == 10) {
        playView.pathNo =indexPath.row;  // 値渡し
        playView.divPicturesData = self.divPicDataFinal[indexPath.row];  // 値渡し
        [self.navigationController pushViewController:playView animated:YES]; // プレイ画面に遷移
    }else if(arrayCount == 17){
        hardPlayView.pathNo =indexPath.row;
        hardPlayView.divPicturesData = self.divPicDataFinal[indexPath.row];
        [self.navigationController pushViewController:hardPlayView animated:YES];
    }
    
}

// unwindsegueでこの画面に戻すための処理
- (IBAction)listViewReturnActionForSegue:(UIStoryboardSegue *)segue{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int playingArrayCount = [userDefault integerForKey:@"playingArrayCount"];
    
    NSLog(@"引継がれたのは%d",playingArrayCount);
    if (playingArrayCount == 10) {
        playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
        [self.navigationController pushViewController:playView animated:YES];
        
        [self goPlayView];
        
    }else if(playingArrayCount == 17){
        hardPlayViewController *hardPlayView = [self.storyboard instantiateViewControllerWithIdentifier:@"hardPlayView"];
        [self.navigationController pushViewController:hardPlayView animated:YES];
        
        [self goHardPlayView];
    }
}

- (void)goPlayView{
    playViewController *playView = [self.storyboard instantiateViewControllerWithIdentifier:@"playView"];
    [self.navigationController pushViewController:playView animated:YES];
}

- (void)goHardPlayView{
    hardPlayViewController *hardPlayView = [self.storyboard instantiateViewControllerWithIdentifier:@"hardPlayView"];
    [self.navigationController pushViewController:hardPlayView animated:YES];
}


// addボタンが押されたらゲーム作成画面に遷移
- (void)addGame{
    pictureViewController *pictureView = [self.storyboard instantiateViewControllerWithIdentifier:@"pictureView"];
    [self.navigationController pushViewController:pictureView animated:YES];
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
