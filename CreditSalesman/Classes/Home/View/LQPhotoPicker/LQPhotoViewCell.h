//
//  LQPhotoViewCell.h
//  LQPhotoPicker
//
//  Created by lawchat on 15/9/22.
//  Copyright (c) 2015年 Fillinse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQPhotoViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property(nonatomic,strong) UIImageView *BigImgView;

- (void)setBigImgViewWithImage:(UIImage *)img;


@end
