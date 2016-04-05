//
//  QMCollectionLayout.m
//  瀑布流
//
//  Created by 乔明 on 16/3/5.
//  Copyright © 2016年 乔明. All rights reserved.
//

#import "QMCollectionLayout.h"

//默认行数
static const NSInteger QMDefaultRowCount = 10;
//默认列数
static const NSInteger QMDefaultColumnCount = 3;
//默认行间距
static const CGFloat QMDefaultRowMar = 10;
//默认列间距
static const CGFloat QMDefaultColumnMar = 10;
//默认边缘间距
static const UIEdgeInsets QMDefaultEdge = {10,10,10,10};

@interface QMCollectionLayout()

//存储cell的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;
//存放当前所有列的高度
@property (nonatomic, strong) NSMutableArray *presentHeights;
//内容的高度
@property (nonatomic, assign) CGFloat contentHeight;
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation QMCollectionLayout
#pragma mark - 常见数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return QMDefaultRowMar;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return QMDefaultColumnMar;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return QMDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return QMDefaultEdge;
    }
}
-(NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

-(NSMutableArray *)presentHeights
{
    if (!_presentHeights) {
        _presentHeights = [NSMutableArray array];
    }
    return _presentHeights;
}

/*
 初始化
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    //初始设置内容高度为0
    self.contentHeight = 0.0;
    //清楚以前计算的高度
    [self.presentHeights removeAllObjects];
    for (int i = 0; i < QMDefaultColumnCount; i++) {
        [self.presentHeights addObject:@(QMDefaultEdge.top)];
    }
    //清楚之前所有布局
    [self.attrsArray removeAllObjects];
    //cell个数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //每个位置的布局
        UICollectionViewLayoutAttributes *attri = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attrsArray addObject:attri];
    }
}

/*
 返回collectionView滑动的高度
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, _contentHeight + self.edgeInsets.bottom);
}

/*
 决定cell的排布
 */
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/*
 返回indexPath位置cell对应的布局属性
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat width = self.collectionView.frame.size.width;
    
    //得到attributes的frame
    CGFloat w = (width - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    //找到最短的那一列的列号
    NSInteger shortComlun = 0;
    CGFloat minComlunHeight = [_presentHeights[0] doubleValue];//假设最短的一列是第一列  ,最短的高度为第一列的高度
    for (int i = 1; i < self.columnCount; i++) {
        if(minComlunHeight > [_presentHeights[i] doubleValue]) {
            minComlunHeight = [_presentHeights[i] doubleValue];
            shortComlun = i;
        }
    }
    CGFloat x = self.edgeInsets.left + (self.columnMargin + w) * shortComlun;
    CGFloat y = minComlunHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attributes.frame = CGRectMake(x, y, w, h);
    
    //更新最短的那列的高度
    _presentHeights[shortComlun] = @(CGRectGetMaxY(attributes.frame));
    
    // 记录内容的高度
    if (_contentHeight < [_presentHeights[shortComlun] doubleValue]) {
        _contentHeight = [_presentHeights[shortComlun] doubleValue];
    }
    return attributes;
}

@end
