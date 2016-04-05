//
//  QMCollectionViewCell.h
//  瀑布流
//
//  Created by 乔明 on 16/3/5.
//  Copyright © 2016年 乔明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QMModel;

@interface QMCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) QMModel *model;

@end
