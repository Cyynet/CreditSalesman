//
//  LQImgPickerActionSheet.h
//  QQImagePicker
//
//  Created by lawchat on 15/9/23.
//  Copyright (c) 2015年 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHeadImaView.h"
#import "MImaLibTool.h"
#import "MShowAllGroup.h"

typedef enum {
    
    selectSend = 1,
    selectCancel = 2,
    selectCamera = 3,
    selectPhotoLib = 4
}menuSelectedType;

typedef void (^menuSelectBlock)(id obj,menuSelectedType type);

@protocol LQImgPickerActionSheetDelegate<NSObject>
@optional
//相册完成选择得到的图片
//- (void)getSelectImgWithALAssetArray:(NSArray*)ALAssetArray thumbnailImgImageArray:(NSArray*)thumbnailImgArray photoDesArray:(NSArray *)photoDesArray photoIdArray:(NSArray *)photoIdArray;
- (void)getSelectDataImg:(NSData *)dataImg thumbnailImgImage:(UIImage *)thumbnailImg photoDes:(NSString *)photoDes photoId:(NSString *)photoId;

@end

@interface LQImgPickerActionSheet : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,MShowAllGroupDelegate>
{

    UIImagePickerController *imaPic;

    UIViewController *viewController;
    
}
@property(nonatomic,assign) id<LQImgPickerActionSheetDelegate> delegate;

/** 文件名 */
@property (copy, nonatomic)  NSString *fileName;
/** 进件号 */
@property (copy, nonatomic)  NSString *loanKey;
/** 客户编号*/
@property(nonatomic,copy)   NSString * cust_no;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrTitles;
@property (nonatomic, copy)   menuSelectBlock menuBlock;
@property (nonatomic, strong) NSArray *arrGroup;


@property (nonatomic, strong) NSMutableArray *arrSelected;

//选择的图片数组
@property (nonatomic, strong) NSMutableArray *photoDesArr;
//选择的图片ID数组
@property (nonatomic, strong) NSMutableArray *photoIdArr;

@property(nonatomic,assign)NSInteger maxCount;

- (void)showImgPickerActionSheetInView:(UIViewController*)controller andFileName:(NSString *)fileName loanKey:(NSString *)loanKey custNo:(NSString *)custNo;

@end
