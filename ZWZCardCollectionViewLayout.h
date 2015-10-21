//
//  ZWZCardCollectionViewLayout.h
//  ZWZCardCollectionViewLayoutDemo
//
//  Created by wenZheng Zhang on 15/10/21.
//  Copyright © 2015年 ZWZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWZCardCollectionViewLayout : UICollectionViewLayout

/*!
 *  The item's width minimum scale. The default value is 0.95
 */
@property (nonatomic) CGFloat widthMinScale;

/*!
 *  The item's height minimum scale. The default value is 0.95
 */
@property (nonatomic) CGFloat heightMinScale;

/*!
 *  The distance from item's center to the center line of collection view which achieves the minimal item's scale. The defalut is 400
 */
@property (nonatomic) CGFloat distanceToAchieveMinScale;

/*!
 *  The minimum space between two item. The default value is 20
 */
@property (nonatomic) NSInteger minimumInterItemSpacing;

/*!
 *  A Boolean value that determines whether to center item when collection view stops scrolling. The default value is NO
 */
@property (nonatomic) BOOL shouldCenterItem;

/*!
 *  The scroll direction. The default value UICollectionViewScrollDirectionHorizontal
 */
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

/*!
 *  The collection view center line width. A larger value will make the item stay in their maximun scale for longer scrollling distance. The default value is 0
 */
@property (nonatomic) CGFloat centerLineWidth;

/*!
 *  A Boolean value that determines whether to maintain inter item space when applaying scale and scrolling. TThe default value is YES
 */
@property (nonatomic) BOOL shouldMiantainItemSpaceWhenScrolling;

/*!
 *  A Boolean value that determines whether to change item's alpha when scollring. The default value is NO
 */
@property (nonatomic) BOOL shouldChangeAlpha;

/*!
 *  Minimum alpha for item. The default value is 0.3. Effective when shouldChangeAlpha setting to YES
 */
@property (nonatomic) CGFloat minAlpha;

/*!
 *  The item's size
 */
@property (nonatomic) CGSize itemSize;

/*!
 *  A Boolean value that determines whether to fill extra space to center first and last item. The default value is NO
 */
@property (nonatomic) BOOL shouldFillextraSpaceToCenterFirstAndLastItem;

/*!
 *  A Boolean value that determines whether paging is enabled for the collection view.
 If the value of this property is YES, the collection view stops on multiples of the collection view’s item when the user scrolls. The default value is NO
 */
@property (nonatomic) BOOL pagingEnabled;

@end
