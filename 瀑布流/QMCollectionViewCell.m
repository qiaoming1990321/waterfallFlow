//
//  QMCollectionViewCell.m
//  瀑布流
//
//  Created by 乔明 on 16/3/5.
//  Copyright © 2016年 乔明. All rights reserved.
//

#import "QMCollectionViewCell.h"
#import "QMModel.h"
#import "UIImageView+WebCache.h"

@interface QMCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation QMCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(QMModel *)model
{
    _model = model;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = model.price;
}

@end
