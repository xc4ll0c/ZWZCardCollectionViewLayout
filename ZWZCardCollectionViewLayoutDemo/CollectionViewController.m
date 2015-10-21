//
//  CollectionViewController.m
//  ZWZCardCollectionViewLayoutDemo
//
//  Created by wenZheng Zhang on 15/10/21.
//  Copyright © 2015年 ZWZ. All rights reserved.
//

#import "CollectionViewController.h"
#import "ZWZCardCollectionViewLayout.h"
#import "PhotoCell.h"

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) NSArray *photoNames;
@property (nonatomic) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZWZCardCollectionViewLayout *cardLayout = (ZWZCardCollectionViewLayout *)self.collectionView.collectionViewLayout;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    cardLayout.itemSize = CGSizeMake(screenSize.width - 60, screenSize.height - 64 * 2 * (self.scrollDirection == UICollectionViewScrollDirectionVertical ? 2 : 1));
    cardLayout.widthMinScale                                = 0.8;
    cardLayout.heightMinScale                               = 0.8;
    cardLayout.shouldCenterItem                             = YES;
    cardLayout.scrollDirection                              = self.scrollDirection;
    cardLayout.distanceToAchieveMinScale                    = 300;
    cardLayout.shouldMiantainItemSpaceWhenScrolling         = YES;
    cardLayout.minimumInterItemSpacing                      = 10;
    cardLayout.centerLineWidth                              = 50;
    cardLayout.shouldChangeAlpha                            = YES;
    cardLayout.minAlpha                                     = 0.5;
    cardLayout.shouldFillextraSpaceToCenterFirstAndLastItem = YES;
    cardLayout.pagingEnabled = NO;
    
    self.photoNames = @[@"pig1", @"pig2", @"pig3", @"pig4", @"pig5"];
    self.datas = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 5; i++) {
        [self.datas addObject:self.photoNames];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.datas[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.photoImageView.image = [UIImage imageNamed:self.datas[indexPath.section][indexPath.row]];
    return cell;
}

@end
