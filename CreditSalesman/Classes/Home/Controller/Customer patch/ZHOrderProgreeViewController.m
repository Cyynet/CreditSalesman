//
//  ZHOrderProgreeViewController.m
//  CreditSalesman
//
//  Created by zhph on 2017/4/27.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "ZHOrderProgreeViewController.h"
#import "ZHProgressTableViewCell.h"
#import "NSString+Extension.h"
#import "ZHProgressModel.h"
#import "MJExtension.h"

@interface ZHOrderProgreeViewController ()<UITableViewDelegate,UITableViewDataSource>
/*请求的数据*/
@property(nonatomic,strong)NSMutableArray * dataArr;

/*tableview*/
@property(nonatomic,strong)UITableView *tableView;

/*请求的数据*/
@property(nonatomic,strong) NSDictionary * dataDic;

@end

@implementation ZHOrderProgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"进度查询";
    self.view.backgroundColor=ZHBackgroundColor;
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self setupTableView];
    
    [self requestData];
    
}

-(NSMutableArray*)dataArr{

    if (!_dataArr) {
        
        _dataArr=[NSMutableArray array];
    }
    
    return _dataArr;

}

#pragma mark tableView创建
- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.backgroundColor = ZHBackgroundColor;
    tableView.dataSource = self;
    tableView.delegate  = self;
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.tableFooterView=[UIView new];
}


#pragma mark 请求数据
-(void)requestData{

     __weak ZHOrderProgreeViewController * weakSelf=self;
        NSDictionary *params = @{
                                 @"apply_loan_key":self.loanKey,
                                 };
        
        [HttpTool PostWithUrl:[NSString stringWithFormat:@"%@GetProgressByApplyLoanKey.spring",kOuternet] params:params success:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"200"]) {
             
                weakSelf.dataArr= [ZHProgressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"progress"]];
                weakSelf.dataDic=responseObject[@"data"];
                weakSelf.tableView.tableHeaderView=[self createTableHeaderViewWithDict:responseObject[@"data"]];
                [weakSelf.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
        }];
}

#pragma mark 获取title
-(NSString*)getTitle:(NSInteger)auditState{

    NSString * title=nil;
    
    switch (auditState) {
            
        case 0://完善资料
            title=@"完善资料";
            break;
        case 1://销售确认
            title=@"销售确认";
            break;
        case 2://审核中
            title=@"审核中";
            break;
        case 3://已放弃
            title=@"已放弃";
            break;
        case 4://已取消
            title=@"已取消";
            break;
        case 5://已拒绝 业务端直接拒绝
        case 11://已拒绝 信审不通过
            title=@"已拒绝";
            break;
        case 6://资料补充
            title=@"资料补充";
            break;
        case 7://审核通过
            title=@"已通过";
            break;
        case 8://面签
            title=@"已签约";
            break;
        case 9://提现中
            title=@"放款中";
            break;
        case 10://已放款
            title=@"已放款";
            break;
        case 12://放款失败
            title=@"放款失败";
            break;

        default:
        break;
    
    }
    
    return title;
}

#pragma mark 创建tableView header
-(UIView*)createTableHeaderViewWithDict:(NSDictionary*)infoDic{

    UIView * header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ZHFit(168))];
    header.backgroundColor=[UIColor clearColor];
    UIView * bgView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ZHFit(148))];
    bgView.backgroundColor=[UIColor whiteColor];
    [header addSubview:bgView];
    
    UILabel * orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(10), 0, kScreenWidth-ZHFit(10)*2, ZHFit(58))];
    orderLabel.textColor=UIColorWithRGB(0x868686);
    orderLabel.font=fontSize(14);
    orderLabel.text=infoDic[@"apply_loan_key"];
    orderLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:orderLabel];
    
    UILabel * statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-ZHFit(10), ZHFit(58))];
    statusLabel.font=fontBoldSize(14);
    statusLabel.textAlignment=NSTextAlignmentRight;
    statusLabel.text=[self getTitle:[infoDic[@"audit_status"] integerValue]];
    statusLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:statusLabel];
    
    UIView *  middleLine =[[UIView alloc]initWithFrame:CGRectMake(ZHFit(10), ZHFit(58), kScreenWidth-ZHFit(10), 1)];
    middleLine.backgroundColor=UIColorWithRGB(0xf0f0f0);
    [bgView addSubview:middleLine];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(10), middleLine.bottom+ZHFit(20), kScreenWidth-ZHFit(10), ZHFit(16))];
    titleLabel.font=fontBoldSize(16);
    titleLabel.text=[[infoDic[@"loan_type"] componentsSeparatedByString:@","] lastObject];
    titleLabel.textColor=UIColorWithRGB(0x414141);
    titleLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:titleLabel];
    
    UILabel * moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(ZHFit(10), titleLabel.bottom+ZHFit(20), kScreenWidth-ZHFit(200), ZHFit(14))];
    moneyLabel.font = fontSize(14);
    moneyLabel.textColor = UIColorWithRGB(0x434343);
    moneyLabel.text=[NSString stringWithFormat:@"申请金额:%@元",infoDic[@"loan_amount"]];
    moneyLabel.attributedText=[NSString changeStringToAttributeString:moneyLabel.text Range:NSMakeRange(0, 5) Color:UIColorWithRGB(0x676767)];
    CGFloat width =[self computeTextSizeHeight:moneyLabel.text Range:CGSizeMake(MAXFLOAT, ZHFit(15))];
    moneyLabel.width=width;
    [bgView addSubview:moneyLabel];
    
    
    UILabel * countLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+ZHFit(20),middleLine.bottom+ZHFit(50), ZHFit(45), ZHFit(20))];
    countLabel.font=fontSize(12);
    countLabel.backgroundColor=[UIColor colorWithRed:141/255.0 green:141/255.0  blue:141/255.0  alpha:1.0];
    countLabel.text=[NSString stringWithFormat:@"%@期",infoDic[@"loan_term"]];
    countLabel.layer.cornerRadius=ZHFit(3);
    countLabel.clipsToBounds=YES;
    countLabel.centerY=moneyLabel.centerY;
    countLabel.textAlignment=NSTextAlignmentCenter;
    countLabel.textColor=UIColorWithRGB(0xffffff);
    [bgView addSubview:countLabel];
    
    UIButton * callBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame=CGRectMake(kScreenWidth-ZHFit(10)-ZHFit(21),middleLine.bottom+ZHFit(15), ZHFit(21), ZHFit(20));
    [callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchDown];
    [callBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [bgView addSubview:callBtn];
    

    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(callBtn.left-ZHFit(100), middleLine.bottom+ZHFit(20),ZHFit(90), ZHFit(16))];
    nameLabel.font=fontSize(16);
    nameLabel.text=infoDic[@"cust_name"];
    nameLabel.textAlignment=NSTextAlignmentRight;
    nameLabel.textColor=UIColorWithRGB(0x414141);
    nameLabel.backgroundColor=[UIColor clearColor];
    [bgView addSubview:nameLabel];
    
    return header;

}

#pragma mark 打电话
-(void)callPhone{

    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", self.dataDic[@"mobile"]];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}

-(CGFloat)computeTextSizeHeight:(NSString *)text Range:(CGSize)size{
    
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontSize(14)} context:nil].size.width;
}

#pragma mark tableView 代理方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZHProgressTableViewCell * cell =[ZHProgressTableViewCell dequeueReusableCellWithTableView:tableView Identifier:indexPath];
    
    bool isFirst = indexPath.row == 0;
    bool isLast = indexPath.row == self.dataArr.count - 1;
    if (self.dataArr.count>indexPath.row) {
        
        [cell setDataSource:self.dataArr isFirst:isFirst isLast:isLast IndexPath:indexPath];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath.row==self.dataArr.count-1? ZHFit(102):ZHFit(86);
}

//设置分割线上下去边线，顶头缩进25
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets UIEgde = UIEdgeInsetsMake(0, ZHFit(50), 0, 0);
    
    if (indexPath.row == self.dataArr.count-1) {
        cell.preservesSuperviewLayoutMargins = NO;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    }else{
        [cell setSeparatorInset:UIEgde];
    }
}

@end
