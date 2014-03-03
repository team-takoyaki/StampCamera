//
//  StampListViewController.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/03/02.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "StampListViewController.h"
#import "AppManager.h"

@interface StampListViewController ()
@property (nonatomic, strong) NSArray *stamps;
@end

@implementation StampListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppManager *manager = [AppManager sharedManager];
    // 選択したスタンプのindexを初期化する
    [manager setSelectedStampIdx:NOT_SELECTED_STAMP_IDX];
    
    // スタンプの一覧を取得する
    self.stamps = [manager stamps];
    
    // CollectionViewのデリゲートを設定する
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    // StampListViewControllerを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _stamps.count;
}

//Method to create cell at index path
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
        
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *stampName = [_stamps objectAtIndex:indexPath.row];
    [imageView setImage:[UIImage imageNamed:stampName]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Touched stampIdx: %d", (int)indexPath.row);

    // 選択されたスタンプのindexを保存する
    NSInteger idx = (NSInteger)indexPath.row;
    AppManager *manager = [AppManager sharedManager];
    [manager setSelectedStampIdx:idx];
    
    // StampListViewControllerを閉じる
    [self dismissViewControllerAnimated:YES completion:^{
        if (_delegate) {
            [_delegate didDismissStampListViewController];
        }
    }];
}

@end
