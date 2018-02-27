//
//  TitleAndTextFieldCell.m
//  ZHCreditClient
//
//  Created by zhph_lzq on 2017/4/13.
//  Copyright © 2017年 zhph_lzq. All rights reserved.
//

#import "TitleAndTextFieldCell.h"
#import <Masonry.h>
@implementation TitleAndTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detail];
        [self.contentView addSubview:self.line];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(14);
            make.top.equalTo(self);
            make.width.mas_equalTo(ZHFit(93));
            make.bottom.mas_equalTo(self).offset(-1);
        }];
        
        [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(ZHFit(1));
            make.top.bottom.equalTo(self);
            make.right.equalTo(self).offset(-ZHFit(14));
        }];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"] && object == self.detail) {
        [self textValueChanged:object];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)textValueChanged:(UITextField *)sender {
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(sender.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = UIColorWithRGB(0x3E3E3E);
        _title.font = fontSize(14);
        _title.textAlignment = NSTextAlignmentLeft;
    }
    return _title;
}

- (UITextField *)detail {
    if (!_detail) {
        _detail = [[UITextField alloc] init];
        _detail.textColor = UIColorWithRGB(0x000000);
        _detail.font = fontSize(14);
        _detail.delegate = self;
        [_detail addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [_detail addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _detail;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]initWithFrame:CGRectMake(ZHFit(10), ZHFit(54), kScreenWidth - ZHFit(20), 1)];
        _line.backgroundColor = UIColorWithRGB(0xefefef);
    }
    return _line;
}

-(void)dealloc{
    @try {
        [self.detail removeObserver:self forKeyPath:@"text"];
    }
    @catch (NSException *exception) {
        NSLog(@"没有监听，或者已经被释放，请继续运行");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
