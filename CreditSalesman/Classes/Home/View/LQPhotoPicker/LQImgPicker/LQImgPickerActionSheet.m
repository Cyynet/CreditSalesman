//
//  LQImgPickerActionSheet.m
//  QQImagePicker
//
//  Created by lawchat on 15/9/23.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import "LQImgPickerActionSheet.h"
#import <Photos/Photos.h>

@implementation LQImgPickerActionSheet

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_arrSelected) {
            self.arrSelected = [NSMutableArray array];
        }
        if (!_photoDesArr) {
            self.photoDesArr = [NSMutableArray array];
        }
        if (!_photoIdArr) {
            self.photoIdArr = [NSMutableArray array];
        }
    }
    return self;
}

#pragma mark - 显示选择照片提示sheet
- (void)showImgPickerActionSheetInView:(UIViewController*)controller andFileName:(NSString *)fileName loanKey:(NSString *)loanKey custNo:(NSString *)custNo {
    
    self.fileName = fileName;
    self.loanKey = loanKey;
    self.cust_no = custNo;
    
    viewController = controller;
    //    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    if (!imaPic) {
        imaPic = [[UIImagePickerController alloc] init];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imaPic.sourceType = UIImagePickerControllerSourceTypeCamera;
        imaPic.delegate = self;
        [viewController presentViewController:imaPic animated:YES completion:nil];
    }
    //    }]];
    //    [alertVC addAction:[UIAlertAction actionWithTitle:@"相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [self loadImgDataAndShowAllGroup];
    //    }]];
    
    //    [controller presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - 加载照片数据
- (void)loadImgDataAndShowAllGroup {
    if (!_arrSelected) {
        self.arrSelected = [NSMutableArray array];
    }
    [[MImaLibTool shareMImaLibTool] getAllGroupWithArrObj:^(NSArray *arrObj) {
        if (arrObj && arrObj.count > 0) {
            self.arrGroup = arrObj;
            if ( self.arrGroup.count > 0) {
                MShowAllGroup *svc = [[MShowAllGroup alloc] initWithArrGroup:self.arrGroup arrSelected:self.arrSelected];
                svc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
                if (_arrSelected) {
                    svc.arrSeleted = _arrSelected;
                    svc.mvc.arrSelected = _arrSelected;
                }
                svc.maxCout = _maxCount;
                [viewController presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - 相机拍照得到的UIImage
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSData * imageData;
    
    if (UIImageJPEGRepresentation(theImage, 1).length > 90000) {
        
        imageData = UIImageJPEGRepresentation([self imageWithImage:theImage scaledToSize:CGSizeMake(theImage.size.width * 0.4, theImage.size.height * 0.4)], 0.2);
        
    }else{
        imageData = UIImageJPEGRepresentation(theImage, 1);
    }
    
    if (theImage) {
        //上传到服务器
        
        NSDictionary *params = @{
                                 @"cust_no":self.cust_no,
                                 @"apply_loan_key":self.loanKey,
                                 @"userType":@"saler"
                                 };
        
        [HttpTool UpLoadImageWithUrl:[NSString stringWithFormat:@"%@UpdateFile.spring",kOuternet] Params:params Image:imageData ImageName:self.fileName RequsetSuccessful:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
                
                NSString *ID = responseObject[@"data"][0][@"id"];
                
                [_photoIdArr addObject:ID];
                
                //图片回显
                [_arrSelected addObject:theImage];

                [self finishSelectImg];
            }
            
            NSLog(@"%@",responseObject);
            
        } RequsetFail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    //                // 保存图片到相册中
    //                MImaLibTool *imgLibTool = [MImaLibTool shareMImaLibTool];
    //                [imgLibTool.lib writeImageToSavedPhotosAlbum:[theImage CGImage] orientation:(ALAssetOrientation)[theImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
    //
    //                    if (!error) {
    //
    //                        //获取图片路径
    //                        [imgLibTool.lib assetForURL:assetURL resultBlock:^(ALAsset *asset) {
    //                            if (asset) {
    //
    //                                [_arrSelected addObject:asset];
    //                                [self finishSelectImg];
    //                                [picker dismissViewControllerAnimated:NO completion:nil];
    //                            }
    //                        } failureBlock:^(NSError *error) {
    //
    //                        }];
    //
    //                    }
    //                }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 完成选择后返回的图片Array(ALAsset*)
- (void)finishSelectImg {
    
    //正方形缩略图
    NSMutableArray *thumbnailImgArr = [NSMutableArray array];
    
    for (UIImage *img in _arrSelected) {
        //        CGImageRef cgImg = [img thumbnail];
        //        UIImage* image = [UIImage imageWithCGImage: cgImg];
        [thumbnailImgArr addObject:img];
    }
    
    //描述文字数组
    NSString *str = [[self.fileName componentsSeparatedByString:@","] lastObject];
    [_photoDesArr addObject:str];
    
    NSLog(@"--666-----%@",_photoDesArr);
    
    [self.delegate getSelectDataImg:[_arrSelected lastObject] thumbnailImgImage:[thumbnailImgArr lastObject] photoDes:[_photoDesArr lastObject] photoId:[_photoIdArr lastObject]];

    
//    [self.delegate  getSelectImgWithALAssetArray:_arrSelected thumbnailImgImageArray:thumbnailImgArr photoDesArray:_photoDesArr photoIdArray:_photoIdArr];
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
