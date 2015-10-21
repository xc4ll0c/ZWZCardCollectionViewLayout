//
//  ZWZCardCollectionViewLayout.m
//  ZWZCardCollectionViewLayoutDemo
//
//  Created by wenZheng Zhang on 15/10/21.
//  Copyright © 2015年 ZWZ. All rights reserved.
//

#import "ZWZCardCollectionViewLayout.h"


@interface ZWZCardCollectionViewLayout ()
@property (nonatomic) NSArray *startIndexs;
@property (nonatomic) NSArray *layoutAttributes;
@property (nonatomic) NSArray *oriFrames;
@property (nonatomic) CGSize contentSize;
@end

@implementation ZWZCardCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commentInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commentInit];
    }
    return self;
}

- (void)commentInit
{
    _widthMinScale                        = 0.95;
    _heightMinScale                       = 0.95;
    _distanceToAchieveMinScale            = 400;
    _minimumInterItemSpacing              = 20;
    _shouldCenterItem                     = NO;
    _scrollDirection                      = UICollectionViewScrollDirectionHorizontal;
    _centerLineWidth                      = 0;
    _shouldMiantainItemSpaceWhenScrolling = YES;
    _shouldChangeAlpha                    = NO;
    _minAlpha                             = 0.3;
    _pagingEnabled                        = NO;
    _shouldFillextraSpaceToCenterFirstAndLastItem = NO;
}

- (void)prepareLayout
{
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    NSMutableArray *oriFrames        = [[NSMutableArray alloc] init];
    NSMutableArray *startIndexs      = [[NSMutableArray alloc] init];
    
    CGFloat collectionViewWidth  = CGRectGetWidth(self.collectionView.bounds);
    CGFloat collectionViewHeight = CGRectGetHeight(self.collectionView.bounds);
    
    CGFloat offset = 0;
    CGFloat contentWidth  = 0;
    CGFloat contentHeight = 0;
    NSInteger startIndex  = 0;
    CGFloat extraSpace    = [self isHorizontalScolling] ? (collectionViewWidth - self.itemSize.width) : (collectionViewHeight - self.itemSize.height);
    if (self.shouldFillextraSpaceToCenterFirstAndLastItem) offset = extraSpace/2;
    
    NSInteger numOfSection = self.collectionView.numberOfSections;
    for (NSInteger i = 0; i < numOfSection; i++) {
        NSInteger numOfItems = [self.collectionView numberOfItemsInSection:i];
        [startIndexs addObject:@(startIndex)];
        for (NSInteger j = 0; j < numOfItems; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            NSInteger index = startIndex + j;
            CGSize size     = self.itemSize;
            UICollectionViewLayoutAttributes *attributes = nil;
            CGRect oriFrame = CGRectMake([self isHorizontalScolling] ? offset : (collectionViewWidth - size.width)/2,
                                         [self isHorizontalScolling] ? (collectionViewHeight - size.height)/2 : offset,
                                         size.width,
                                         size.height);
            
            if (index < self.layoutAttributes.count) {
                attributes = self.layoutAttributes[index];
                attributes.indexPath = indexPath;
            } else {
                attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = oriFrame;
                attributes.transform = CGAffineTransformIdentity;
                attributes.alpha = 1;
            }
            
            offset += ([self isHorizontalScolling] ? size.width : size.height) + self.minimumInterItemSpacing;
            
            if ([self isHorizontalScolling]) {
                contentWidth  += size.width + self.minimumInterItemSpacing;
                contentHeight = contentHeight > size.height ? contentHeight : size.height;
            }
            else {
                contentWidth   = contentWidth > size.width ? contentWidth : size.width;
                contentHeight += size.height + self.minimumInterItemSpacing;
            }
            
            [layoutAttributes addObject:attributes];
            [oriFrames addObject:[NSValue valueWithCGRect:oriFrame]];
        }
        startIndex += numOfItems;
    }
    
    if ([self isHorizontalScolling]) contentWidth -= self.minimumInterItemSpacing;
    else contentHeight -= self.minimumInterItemSpacing;
    
    if (self.shouldFillextraSpaceToCenterFirstAndLastItem) {
        if ([self isHorizontalScolling]) contentWidth += extraSpace;
        else contentHeight += extraSpace;
    }
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
    
    self.layoutAttributes = layoutAttributes;
    self.oriFrames        = oriFrames;
    self.startIndexs      = startIndexs;
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    CGRect viewBounds = self.collectionView.bounds;
    [self.layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        CGRect realRect = attributes.frame;
        if (CGRectIntersectsRect(rect, realRect)) {
            
            CGFloat di = 0;
            
            if ([self isHorizontalScolling]) {
                CGFloat centerx = CGRectGetMidX(viewBounds);
                CGFloat minCenterx = centerx - (self.centerLineWidth/2);
                CGFloat maxCenterx = centerx + (self.centerLineWidth/2);
                
                if (CGRectGetMidX(realRect) >= maxCenterx) {
                    di = CGRectGetMidX(realRect) - maxCenterx;
                } else if (CGRectGetMidX(realRect) <= minCenterx) {
                    di = CGRectGetMidX(realRect) - minCenterx;
                } else di = 0;
                
            } else {
                CGFloat centerY = CGRectGetMidY(viewBounds);
                CGFloat minCenterY = centerY - (self.centerLineWidth/2);
                CGFloat maxCenterY = centerY + (self.centerLineWidth/2);
                
                if (CGRectGetMidY(realRect) >= maxCenterY) {
                    di = CGRectGetMidY(realRect) - maxCenterY;
                } else if (CGRectGetMidY(realRect) <= minCenterY) {
                    di = CGRectGetMidY(realRect) - minCenterY;
                } else di = 0;
            }
            
            CGFloat r = fabs(di) / self.distanceToAchieveMinScale;
            if (r > 1) r = 1;
            
            CGFloat widthMinScale  = self.widthMinScale  + (1 - self.widthMinScale) * (1 - r);
            CGFloat heightMinScale = self.heightMinScale + (1 - self.heightMinScale) * (1 - r);
            
            CGRect oriFrame = [[self.oriFrames objectAtIndex:idx] CGRectValue];
            CGAffineTransform scale = CGAffineTransformMakeScale(widthMinScale, heightMinScale);
            CGAffineTransform transform = scale;
            
            if (self.shouldMiantainItemSpaceWhenScrolling) {
                CGRect sRect = CGRectApplyAffineTransform(oriFrame, scale);
                CGFloat widthChanges  = 0;
                CGFloat heightChanges = 0;
                
                if ([self isHorizontalScolling]) widthChanges = CGRectGetWidth(oriFrame) - CGRectGetWidth(sRect);
                else heightChanges = CGRectGetHeight(oriFrame) - CGRectGetHeight(sRect);
                
                CGAffineTransform translate = CGAffineTransformMakeTranslation(widthChanges/2* (di > 0 ? -1 : 1), heightChanges/2* (di > 0 ? -1 : 1));
                transform = CGAffineTransformConcat(scale, translate);
            }
            
            attributes.frame     = oriFrame;
            attributes.transform = transform;
            
            if (self.shouldChangeAlpha) attributes.alpha = MAX(1 - r, self.minAlpha);
            [layoutAttributes addObject:attributes];
        }
        
    }];
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutAttributes[[self.startIndexs[indexPath.section] integerValue] + indexPath.item];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return [self targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:CGPointZero];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.pagingEnabled) {
        return [self targetContentOffsetForProposedContentOffsetWhenPagingEnabled:proposedContentOffset withScrollingVelocity:velocity];
    } 
    
    if (!_shouldCenterItem) return proposedContentOffset;
    CGRect viewBounds = self.collectionView.bounds;
    
    if ([self isHorizontalScolling]) {
        viewBounds.origin.x = proposedContentOffset.x;
    } else viewBounds.origin.y = proposedContentOffset.y;
    

    NSUInteger targetFrameIndex = [self indexOfClosestFrameForContentOffset:proposedContentOffset];
    NSValue *frameValue         = self.oriFrames[targetFrameIndex];
    CGRect targetRect           = frameValue.CGRectValue;
    
    CGFloat minDi     = CGFLOAT_MAX;
    if ([self isHorizontalScolling]) minDi = CGRectGetMidX(targetRect) - CGRectGetMidX(viewBounds);
    else minDi = CGRectGetMidY(targetRect) - CGRectGetMidY(viewBounds);
    
    if ([self isHorizontalScolling]) {
        CGPoint point = CGPointMake(viewBounds.origin.x + minDi, viewBounds.origin.y);
        CGFloat maxX = self.contentSize.width - CGRectGetWidth(self.collectionView.bounds);
        return CGPointMake(point.x < 0 ? 0 : (point.x > maxX ? maxX : point.x), point.y);
    } else {
        CGPoint point = CGPointMake(viewBounds.origin.x, viewBounds.origin.y + minDi);
        CGFloat maxY = self.contentSize.height - CGRectGetHeight(self.collectionView.bounds);
        return CGPointMake(point.x, point.y < 0 ? 0 : (point.y > maxY ? maxY : point.y));
    }
}

- (CGPoint)targetContentOffsetForProposedContentOffsetWhenPagingEnabled:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect viewBounds = self.collectionView.bounds;
    CGRect collectionViewbounds = self.collectionView.bounds;
    
    if ([self isHorizontalScolling]) {
        viewBounds.origin.x = proposedContentOffset.x;
    } else viewBounds.origin.y = proposedContentOffset.y;
    
    NSUInteger currentCenteredFrameIndex = [self indexOfClosestFrameForContentOffset:self.collectionView.contentOffset];
    NSUInteger targetFrameIndex          = [self indexOfClosestFrameForContentOffset:proposedContentOffset];
    
    CGRect targetRect = CGRectZero;
    if (currentCenteredFrameIndex == targetFrameIndex) {
        NSValue *frameValue = self.oriFrames[targetFrameIndex];
        targetRect = frameValue.CGRectValue;
        
    } else if (currentCenteredFrameIndex - targetFrameIndex) {
        NSInteger di = targetFrameIndex - currentCenteredFrameIndex;
        di /= labs(di);
        NSValue *frameValue = self.oriFrames[currentCenteredFrameIndex + di];
        targetRect = frameValue.CGRectValue;
    }
    
    if ([self isHorizontalScolling]) {
        CGFloat x = targetFrameIndex == 0 ? 0 : CGRectGetMinX(targetRect) - (CGRectGetWidth(collectionViewbounds) - CGRectGetWidth(targetRect))/2;
        CGFloat maxX = self.contentSize.width - CGRectGetWidth(self.collectionView.bounds);
        return CGPointMake(x < 0 ? 0 : (x > maxX ? maxX : x), proposedContentOffset.y);
    } else {
        CGFloat y = targetFrameIndex == 0 ? 0 : CGRectGetMinY(targetRect) - (CGRectGetHeight(collectionViewbounds) - CGRectGetHeight(targetRect))/2;
        CGFloat maxY = self.contentSize.height - CGRectGetHeight(self.collectionView.bounds);
        return CGPointMake(proposedContentOffset.x, y < 0 ? 0 : (y > maxY ? maxY : y));
    }
}

- (NSUInteger)indexOfClosestFrameForContentOffset:(CGPoint)contentOffset
{
    CGRect viewBounds = self.collectionView.bounds;
    
    if ([self isHorizontalScolling]) {
        viewBounds.origin.x = contentOffset.x;
    } else viewBounds.origin.y = contentOffset.y;

    __block CGFloat minDi    = CGFLOAT_MAX;
    __block NSUInteger index = 0;
    [self.oriFrames enumerateObjectsUsingBlock:^(NSValue *frameValue, NSUInteger idx, BOOL *stop) {
        CGRect rect = frameValue.CGRectValue;
        if (CGRectIntersectsRect(viewBounds, rect)) {
            CGFloat di = 0;
            if ([self isHorizontalScolling]) di = CGRectGetMidX(rect) - CGRectGetMidX(viewBounds);
            else di = CGRectGetMidY(rect) - CGRectGetMidY(viewBounds);
            if (fabs(di) < fabs(minDi)) {
                minDi = di;
                index = idx;
            }
        }
    }];
    return index;
}

- (BOOL)isHorizontalScolling
{
    return self.scrollDirection == UICollectionViewScrollDirectionHorizontal;
}

@end
