//
//  ImageCell.m
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/10.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.image];
    }
    return self;
}


- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, ZHFit(180))];
    }
    return _image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
