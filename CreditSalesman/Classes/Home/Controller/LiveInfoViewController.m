//
//  LiveInfoViewController.m
//  
//
//  Created by 正和 on 2017/3/30.
//
//

#import "LiveInfoViewController.h"

@interface LiveInfoViewController ()

@end

@implementation LiveInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"居住信息";
    
    self.titles = [NSMutableArray arrayWithObjects:@"  住宅电话",@"*选择省市",@"*详细地址", nil];
    
    //1. 添加右侧保存按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //2. 隐藏tableView组尾
    self.tableView.tableFooterView.hidden = YES;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [BaseTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
        }
        
        if (indexPath.row == 1) {
            
            if (NULLString(self.address) || [self.address isEqualToString:@"请选择省市区"]) {
                
                self.address = [self appendStringWithProv:self.dataDictionary[@"liveprov"] City:self.dataDictionary[@"livecity"] andArea:self.dataDictionary[@"livearea"]];
            }
            
            cell.detailTextLabel.text = !NULLString(self.address) ? self.address : @"请选择省市区";
            self.address = cell.detailTextLabel.text;
            cell.accessoryView = ArrowView;
        }
        
        if (indexPath.row == 2) {
            
            _liveTownField = [UITextField addFieldWithFrame:textFieldFrame delegate:self];
            _liveTownField.placeholder = @"包含街道/单元/门牌号等详细地址";
            _liveTownField.text = !NULLString(self.livetown) ? self.livetown :self.dataDictionary[@"livetown"];
            self.livetown = _liveTownField.text;
            [cell.contentView addSubview:_liveTownField];
            
        }
    }
    
    return cell;
}

/**
 返回省市区的中文名
 @return <#return value description#>
 */
- (NSString *)appendStringWithProv:(NSString *)prov City:(NSString *)city andArea:(NSString *)area{
    
    //如果请求下来数据为空,就直接返回nil
    if (NULLString(prov)) return nil;
    
    NSString *str1 = [[prov componentsSeparatedByString:@","] firstObject];
    NSString *str2 = [[city componentsSeparatedByString:@","] firstObject];
    
    
    self.liveProv = prov;
    self.liveCity = city;
    self.liveArea = area;
    
    return [NSString stringWithFormat:@"%@ %@ %@",str1,str2,area];
}

@end
