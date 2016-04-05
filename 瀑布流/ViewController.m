//
//  ViewController.m
//  瀑布流
//
//  Created by 乔明 on 16/3/5.
//  Copyright © 2016年 乔明. All rights reserved.
//

#import "ViewController.h"
#import "QMCollectionLayout.h"
#import "QMModel.h"
#import "MJExtension.h"
#import "QMCollectionViewCell.h"


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, QMCollectionLayoutDelegate>

@property (nonatomic, strong) QMCollectionLayout *collectionLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelArr;

@end

@implementation ViewController

-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建布局
    QMCollectionLayout *layout = [[QMCollectionLayout alloc] init];
    layout.delegate = self;
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:@"QMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"QMCollectionViewCell"];
    
    
    NSArray *models = [QMModel objectArrayWithFilename:@"1.plist"];
    [self.modelArr addObjectsFromArray:models];
    
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QMCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    cell.model = _modelArr[indexPath.item];
//    NSInteger tag = 10;
//    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
//    if (label == nil) {
//        label = [[UILabel alloc] init];
//        label.tag = tag;
//        [cell.contentView addSubview:label];
//    }
//    
//    label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
//    [label sizeToFit];
    
    return cell;
}

#pragma mark - <XMGWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(QMCollectionLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    QMModel *model = self.modelArr[index];
    
    return itemWidth * model.h / model.w;
}

- (CGFloat)rowMarginInWaterflowLayout:(QMCollectionLayout *)waterflowLayout
{
    return 20;
}

- (CGFloat)columnCountInWaterflowLayout:(QMCollectionLayout *)waterflowLayout
{
    if (self.modelArr.count <= 20) return 2;
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(QMCollectionLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 10, 30, 20);
}

@end
