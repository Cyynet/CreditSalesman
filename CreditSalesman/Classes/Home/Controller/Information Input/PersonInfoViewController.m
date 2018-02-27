//
//  PersonInfoViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/20.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "AddressTableViewCell.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
@interface PersonInfoViewController ()

/** 左边身份证 */
@property (strong, nonatomic)  UIImageView *leftImage;

/** 右边身份证 */
@property (strong, nonatomic)  UIImageView *rightImage;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去服务器请求身份证图片
    [self initServerData];
    
    self.tableView.height = self.view.height - 104 - 64 - 50;
    
    self.titles = [NSMutableArray arrayWithArray:@[
                                                   
                                                   @[@"姓名",@"身份证号"],
                                                   
                                                   @[@"学历",@"婚姻状况",@" 民族"],
                                                   
                                                   @[@"QQ",@"微信",@"住宅电话"],
                                                   
                                                   @[@"户籍地址"],
                                                   
                                                   @[@"现居地址"]
                                                   ]];
    
    //组头
    self.tableView.tableHeaderView = ({
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ZHFit(170))];
        bgView.backgroundColor = UIColorWithRGB(0xffffff);
        
        CGFloat imageWidth = (self.view.width - 4 * 10) / 2;
        
        /** 左边 */
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, ZHFit(20), imageWidth, ZHFit(105))];
        leftImage.contentMode = UIViewContentModeScaleAspectFill;
        leftImage.clipsToBounds = YES;
        self.leftImage = leftImage;
        [bgView addSubview:leftImage];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftImage.x, leftImage.bottom + ZHFit(12), leftImage.width, ZHFit(13))];
        leftLabel.text = @"身份证正面";
        leftLabel.textColor = UIColorWithRGB(0x959595);
        leftLabel.font = [UIFont boldSystemFontOfSize:12];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:leftLabel];
        
        /** 右边 */
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width / 2 + 10, ZHFit(20), imageWidth, leftImage.height)];
        rightImage.contentMode = UIViewContentModeScaleAspectFill;
        rightImage.clipsToBounds = YES;
        self.rightImage = rightImage;
        [bgView addSubview:rightImage];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightImage.x, leftImage.bottom + ZHFit(12), leftImage.width, ZHFit(13))];
        rightLabel.text = @"身份证反面";
        rightLabel.textColor = UIColorWithRGB(0x959595);
        rightLabel.font = [UIFont boldSystemFontOfSize:12];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:rightLabel];
        
        bgView;
    });
}

- (void)initServerData {
    
    //1.拿到对应的身份证正反面
    NSString *front = [SessionTool GetInstance].infoDic[@"idcard_front_url"];
    NSString *reverse = [SessionTool GetInstance].infoDic[@"idcard_reverse_url"];
    
    NSString *filePath = [NSString stringWithFormat:@"%@,%@",front,reverse];
    
    if (NULLString(front)) {
        return;
    }
    
    NSDictionary *params = @{
                             @"filePath":filePath
                            };
    
    [HttpTool postFileWithParams:params success:^(id responseObject) {
        //1.1取到value值,转data
        NSData *dataLeft = [[NSData alloc] initWithBase64EncodedString:responseObject[front] options:0];
        //1.2 转换成图片
        self.leftImage.image = [UIImage imageWithData:[NSData dataWithData:dataLeft]];
        
        //2.1取到value值,转data
        NSData *dataRight = [[NSData alloc] initWithBase64EncodedString:responseObject[reverse]  options:0];
        //2.2 转换成图片
        self.rightImage.image = [UIImage imageWithData:[NSData dataWithData:dataRight]];
        
    } failure:^(NSError *error) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section < 3) {
        
        cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    }else{
        
        cell = [AddressTableViewCell cellWithTableView:tableView indexPath:indexPath];
    }
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    
    //右侧文字
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = infoDictionary[@"cust_name"];
        }
        else {
            cell.detailTextLabel.text = infoDictionary[@"idcard_no"];
        }
    }
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [[infoDictionary[@"education"] componentsSeparatedByString:@","] lastObject];
        }else if(indexPath.row == 1){
            cell.detailTextLabel.text = [[infoDictionary[@"mar_status"] componentsSeparatedByString:@","] lastObject];
        }else {
            cell.detailTextLabel.text = [[infoDictionary[@"nation"] componentsSeparatedByString:@","] lastObject];
        }
    }
    else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = infoDictionary[@"qq"];
        }else if(indexPath.row == 1){
            cell.detailTextLabel.text = infoDictionary[@"wechat"];
        }else {
            cell.detailTextLabel.text = infoDictionary[@"home_mobile"];
        }
        
    }
    else if (indexPath.section == 3) {
        
        cell.detailTextLabel.text = [NSString appendStringWithProv:infoDictionary[@"reg_prov"] City:infoDictionary[@"reg_city"] andArea:infoDictionary[@"reg_area"] andTown:infoDictionary[@"reg_town"]];
        
    }
    else {
        cell.detailTextLabel.text = [NSString appendStringWithProv:infoDictionary[@"live_prov"] City:infoDictionary[@"live_city"] andArea:infoDictionary[@"live_area"] andTown:infoDictionary[@"live_town"]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section >= 3 ) {
        return ZHFit(105);
    }
    return ZHFit(54);
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = ZHBackgroundColor;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}


@end
