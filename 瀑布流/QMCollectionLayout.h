//
//  QMCollectionLayout.h
//  瀑布流
//
//  Created by 乔明 on 16/3/5.
//  Copyright © 2016年 乔明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QMCollectionLayout;

@protocol QMCollectionLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(QMCollectionLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(QMCollectionLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(QMCollectionLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(QMCollectionLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(QMCollectionLayout *)waterflowLayout;
@end

@interface QMCollectionLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<QMCollectionLayoutDelegate> delegate;

@end
