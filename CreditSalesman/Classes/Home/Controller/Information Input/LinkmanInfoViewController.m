//
//  LinkmanInfoViewController.m
//  CreditSalesman
//
//  Created by 正和 on 2017/4/20.
//  Copyright © 2017年 正和. All rights reserved.
//

#import "LinkmanInfoViewController.h"
#import "ZHLinkedPeopleCell.h"

@interface LinkmanInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LinkmanInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZHBackgroundColor;
    self.titles = [NSMutableArray arrayWithArray:infoDictionary[@"others"]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHLinkedPeopleCell *cell = [ZHLinkedPeopleCell cellWithTableView:tableView indexPath:indexPath];
    [cell settingCellWithValue:self.titles IndexPath:indexPath];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * infoDIc=[self.titles objectAtIndex:indexPath.row];
    
    float cellHight=ZHFit(54);
    cellHight = [infoDIc[@"contact_rel"] containsString:@"配偶"]? ZHFit(108):ZHFit(54);
    
    return cellHight+10;
}

@end
