//
//  LQPhotoPickerViewController.m
//  LQPhotoPicker
//
//  Created by lawchat on 15/9/22.
//  Copyright (c) 2015年 Fillinse. All rights reserved.
//

#import "LQPhotoPickerViewController.h"
#import "LQPhotoViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LQImgPickerActionSheet.h"
#import "JJPhotoManeger.h"
#import "UIAlertViewTool.h"

#import "SessionTool.h"

#define photoWidth ([UIScreen mainScreen].bounds.size.width - 60) /3
#define photoHeight photoWidth * 1.184

@interface LQPhotoPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LQImgPickerActionSheetDelegate,JJPhotoDelegate>
{
    NSString *pushImgName;
}

@property(nonatomic,strong) LQImgPickerActionSheet *imgPickerActionSheet;

@property(nonatomic,strong) UICollectionView *pickerCollectionView;
@property(nonatomic,assign) CGFloat collectionFrameY;

//图片选择器
@property(nonatomic,strong) UIViewController *showActionSheetViewController;

@end

@implementation LQPhotoPickerViewController

static NSString * const reuseIdentifier = @"LQPhotoViewCell";

- (NSMutableArray *)photosDesArr {
    
    if (!_photosDesArr) {
        
        _photosDesArr = [NSMutableArray array];
    }
    return _photosDesArr;
}

- (NSMutableArray *)photoIdArr {
    
    if (!_photoIdArr) {
        
        _photoIdArr = [NSMutableArray array];
    }
    return _photoIdArr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)LQPhotoPicker_initPickerView {
    
    _showActionSheetViewController = self;
    
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    self.pickerCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    
    if (_LQPhotoPicker_superView) {
        [_LQPhotoPicker_superView addSubview:self.pickerCollectionView];
    }
    else{
        [self.view addSubview:self.pickerCollectionView];
    }
    

    self.pickerCollectionView.delegate = self;
    self.pickerCollectionView.dataSource = self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    
    if(_LQPhotoPicker_smallImageArray.count == 0)
    {
        _LQPhotoPicker_smallImageArray = [NSMutableArray array];
    }
    if(_LQPhotoPicker_smallDataImageArray.count == 0)
    {
        _LQPhotoPicker_smallDataImageArray = [NSMutableArray array];
    }
    if(_LQPhotoPicker_bigImageArray.count == 0)
    {
        _LQPhotoPicker_bigImageArray = [NSMutableArray array];
    }
    pushImgName = @"plus.png";
    
    _pickerCollectionView.scrollEnabled = NO;
    
    //从服务器请求数据
    [self initServerData];
}

- (void)initServerData {
    
    NSArray *arr = [SessionTool GetInstance].infoDic[@"images"];
    
    if (arr.count == 0) {
        return;
    }
    
    NSMutableArray *filePathArray = [NSMutableArray array];
    
     //1.2拿到对应的文字描述 和图片ID
    for (NSDictionary *dict in [SessionTool GetInstance].infoDic[@"images"]) {
        
        NSString *image_type = [[dict[@"image_type"] componentsSeparatedByString:@","] lastObject];
        NSString *ID = dict[@"id"];
        
        [filePathArray addObject:dict[@"image_url"]];
        [self.photosDesArr addObject:image_type];
        [self.photoIdArr addObject:ID];
    }

    NSString *filePath = [filePathArray componentsJoinedByString:@","];
    
    NSDictionary *params = @{
                             @"filePath":filePath
                            };
    
    [HttpTool postFileWithParams:params success:^(id responseObject) {
        
        for (int i = 0; i < filePathArray.count; i ++) {
            
            //取到key值
            NSString *key = filePathArray[i];
            
            //1.1取到value值,转data
            NSData *data = [[NSData alloc] initWithBase64EncodedString:responseObject[key] options:0];
            
            //1.2 转换成图片
            UIImage *image = [UIImage imageWithData:[NSData dataWithData:data]];
            
            //2. 放进数组(data数组)
            [_LQPhotoPicker_smallDataImageArray addObject:data];
            
            //3.放进图片数组
            [_LQPhotoPicker_smallImageArray addObject:image];
            
            //            //赋值给大图data数组
            //            _LQPhotoPicker_smallDataImageArray = imageArray;
            //
            //            //赋值给大图data数组
            //            _LQPhotoPicker_smallImageArray = imageArray;
        }
        
        [self.pickerCollectionView reloadData];
        
//        NSLog(@"批量下载图片%@",responseObject);
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _LQPhotoPicker_smallImageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Register nib file for the cell
    UINib *nib = [UINib nibWithNibName:@"LQPhotoViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"LQPhotoViewCell"];
    // Set up the reuse identifier
    LQPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"LQPhotoViewCell" forIndexPath:indexPath];

    if (indexPath.row == _LQPhotoPicker_smallImageArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:pushImgName]];
        cell.closeButton.hidden = YES;
    }else{
        [cell.profilePhoto setImage:_LQPhotoPicker_smallImageArray[indexPath.item]];
        cell.closeButton.hidden = NO;
    }
    [cell setBigImgViewWithImage:nil];
    
    //没有任何图片
    if (_LQPhotoPicker_smallImageArray.count > 0) {
        
        if (indexPath.row < _photosDesArr.count) {
            
            cell.desLabel.text = _photosDesArr[indexPath.row];
            cell.desLabel.hidden = NO;
        }else{
            cell.desLabel.hidden = YES;
        }
    }

    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeCollectionViewHeight];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(photoWidth,photoHeight);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - 图片cell点击事件
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (_LQPhotoPicker_smallImageArray.count)) {
        [self.view endEditing:YES];
        //添加新图片
        [self addNewImg];
    }
    else{
    
        //点击放大查看
        LQPhotoViewCell *cell = (LQPhotoViewCell*)[_pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if (!cell.BigImgView || !cell.BigImgView.image) {

//            [cell setBigImgViewWithImage:[self getBigIamgeWithALAsset:_LQPhotoPicker_selectedAssetArray[index]]];
               [cell setBigImgViewWithImage:_LQPhotoPicker_smallImageArray[index]];
        }
        
        JJPhotoManeger *mg = [JJPhotoManeger maneger];
        mg.delegate = self;
        [mg showLocalPhotoViewer:@[cell.BigImgView] selecImageindex:0];
    }
}

#pragma mark - 选择图片
- (void)addNewImg {
    
    /**
     @"公积金",                GJJ
     @"社保",                  SB
     @"工资流水",               GZLS
     @"工作证明",               GZZM
     @"保单材料",               BDCL
     @"房产材料",               FCCL
     @"房贷还款流水",            FDHKLS
     @"住址证明",                ZZZM
     @"其他(征信授权书、征信报告等)", OTHER
     */
    [UIAlertViewTool showAlertViewWith:self title:@"选择资料类型" message:nil CallBackBlock:^(NSInteger btnIndex) {
        
        //有值的话去掉相机
        if (btnIndex) {
            
            //选择照片类型
            [self chooseItemWithIndex:btnIndex];
        }
    } destructiveButtonTitle:@"取消" otherButtonTitles:
     @"公积金",
     @"社保",
     @"工资流水",
     @"工作证明",
     @"保单材料",
     @"房产材料",
     @"房贷还款流水",
     @"住址证明",
     @"其他(征信授权书、征信报告等)",
     nil];
   
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender {
    
    NSDictionary *param = @{
                             @"id":self.photoIdArr[sender.tag],
                             @"apply_loan_key":[SessionTool GetInstance].infoDic[@"apply_loan_key"]
                           };
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@DelImageById.spring",kOuternet] params:param success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            
            [_LQPhotoPicker_smallImageArray removeObjectAtIndex:sender.tag];
            [_LQPhotoPicker_smallDataImageArray removeObjectAtIndex:sender.tag];
//            [_LQPhotoPicker_selectedAssetArray removeObjectAtIndex:sender.tag];
            [self.photosDesArr removeObjectAtIndex:sender.tag];
            [self.photoIdArr removeObjectAtIndex:sender.tag];
            
            [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
            
            for (NSInteger item = sender.tag; item <= _LQPhotoPicker_smallImageArray.count; item++) {
                LQPhotoViewCell *cell = (LQPhotoViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
                cell.closeButton.tag --;
                cell.profilePhoto.tag --;
                //        //没有任何图片
                //        if (_LQPhotoPicker_smallImageArray.count == 0) {
                //            cell.desLabel.hidden = YES;
                //        }
            }
            
            [self changeCollectionViewHeight];
        }
        
    } failure:^(NSError *error) {
    
    }];
    
}

#pragma mark - 选择照片类型
- (void)chooseItemWithIndex:(NSInteger )index {
  
    NSArray *nameArr = @[@"取消",@"公积金",@"社保",@"工资流水",@"工作证明",@"保单材料",@"房产材料",@"房贷还款流水",@"住址证明",@"其他(征信授权书、征信报告等)"];
    
    NSArray *codeArr = @[@"qx",@"GJJ",@"SB",@"GZLS",@"GZZM",@"BDCL",@"FCCL",@"FDHKLS",@"ZZZM",@"OTHER"];
    
    NSString *fileName = [NSString stringWithFormat:@"%@,%@",codeArr[index],nameArr[index]];
    
    NSLog(@"name=%@,code=%@,第%lu张图片",nameArr[index],codeArr[index],(unsigned long)_LQPhotoPicker_smallImageArray.count);
    
    
    if (_LQPhotoPicker_smallImageArray.count == _LQPhotoPicker_imgMaxCount) {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                             
                                                      message:@"选择图片数量已达上限"
                             
                                                     delegate:nil
                             
                                            cancelButtonTitle:@"知道了"
                             
                                            otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[LQImgPickerActionSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_LQPhotoPicker_selectedAssetArray) {
        _imgPickerActionSheet.arrSelected = _LQPhotoPicker_selectedAssetArray;
    }
    _imgPickerActionSheet.maxCount = _LQPhotoPicker_imgMaxCount;
    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController andFileName:fileName loanKey:self.loanKey custNo:self.cust_no];
  
}

#pragma mark - LQImgPickerActionSheetDelegate (返回选择的图片：缩略图，压缩原长宽比例大图)

- (void)getSelectDataImg:(NSData *)dataImg thumbnailImgImage:(UIImage *)thumbnailImg photoDes:(NSString *)photoDes photoId:(NSString *)photoId {
    
    //小图片Image数组
    [_LQPhotoPicker_smallImageArray addObject:thumbnailImg];
    
    //小图片data数组
    [_LQPhotoPicker_smallDataImageArray addObject:dataImg];
    
    //图片描述
    [self.photosDesArr addObject:photoDes];
    
    //图片ID
    [self.photoIdArr addObject:photoId];
    
    //刷新列表
    [self.pickerCollectionView reloadData];
}

#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight {
    
    NSUInteger row = (_LQPhotoPicker_smallImageArray.count / 3) + 1;
    
    if (_collectionFrameY) {
        
         _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width, (photoHeight + 10) * row);
    }else{
        
        _pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (photoHeight + 20)* row);
    }
    if (_LQPhotoPicker_delegate && [_LQPhotoPicker_delegate respondsToSelector:@selector(LQPhotoPicker_pickerViewFrameChanged)]) {
        [_LQPhotoPicker_delegate LQPhotoPicker_pickerViewFrameChanged];
    }
}

- (void)LQPhotoPicker_updatePickerViewFrameY:(CGFloat)Y {
    
    _collectionFrameY = Y;
    
    NSUInteger row = (_LQPhotoPicker_smallImageArray.count / 3) + 1;
    _pickerCollectionView.frame = CGRectMake(0, Y, [UIScreen mainScreen].bounds.size.width, (photoHeight + 10) * row);
}

#pragma mark - 防止奔溃处理
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex {
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (NSData*)getBigIamgeDataWithALAsset:(ALAsset*)set {
    
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    
    return UIImageJPEGRepresentation(img, 0.5);
}

- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set {
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    NSData *imageData = [self getBigIamgeDataWithALAsset:set];
    
    [_LQPhotoPicker_bigImgDataArray addObject:imageData];
    
    return [UIImage imageWithData:imageData];
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

#pragma mark - 获得选中图片各个尺寸
- (NSMutableArray*)LQPhotoPicker_getALAssetArray {
    return _LQPhotoPicker_selectedAssetArray;
}

- (NSMutableArray*)LQPhotoPicker_getBigImageArray {
    
    _LQPhotoPicker_bigImageArray = [NSMutableArray array];
        _LQPhotoPicker_bigImgDataArray = [NSMutableArray array];
        for (ALAsset *set in _LQPhotoPicker_selectedAssetArray) {
            [_LQPhotoPicker_bigImageArray addObject:[self getBigIamgeWithALAsset:set]];
        }
    return _LQPhotoPicker_bigImageArray;
}

- (NSMutableArray*)LQPhotoPicker_getBigImageDataArray {
    _LQPhotoPicker_bigImageArray = [NSMutableArray array];
        _LQPhotoPicker_bigImgDataArray = [NSMutableArray array];
        for (ALAsset *set in _LQPhotoPicker_selectedAssetArray) {
            [_LQPhotoPicker_bigImageArray addObject:[self getBigIamgeWithALAsset:set]];
        }

    return _LQPhotoPicker_bigImgDataArray;
}

- (NSMutableArray*)LQPhotoPicker_getSmallImageArray {
    return _LQPhotoPicker_smallImageArray;
}

- (NSMutableArray*)LQPhotoPicker_getSmallDataImageArray {
    _LQPhotoPicker_smallDataImageArray = [NSMutableArray array];
        for (UIImage *smallImg in _LQPhotoPicker_smallImageArray) {
            NSData *smallImgData = UIImagePNGRepresentation(smallImg);
            [_LQPhotoPicker_smallDataImageArray addObject:smallImgData];
        }
    return _LQPhotoPicker_smallDataImageArray;
}

- (CGRect)LQPhotoPicker_getPickerViewFrame {
    return self.pickerCollectionView.frame;
}

@end
