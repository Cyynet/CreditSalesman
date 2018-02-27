//
//  CreditSuccessCell.m
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/25.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import "CreditSuccessCell.h"
#import <Masonry.h>
@implementation CreditSuccessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.label];
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(ZHFit(40));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(ZHFit(155));
            make.height.mas_equalTo(ZHFit(146));
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image.mas_bottom).with.offset(ZHFit(30));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(ZHFit(155));
            make.height.mas_equalTo(ZHFit(22));
        }];
        
    }
    return self;
}


- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"征信成功"]];
    }
    return _image;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"获取报告成功";
        _label.textColor = UIColorWithRGB(0x2F2F2F);
        _label.font = fontSize(16);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
