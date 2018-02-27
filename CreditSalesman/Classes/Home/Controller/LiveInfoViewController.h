//
//  LiveInfoViewController.h
//  
//
//  Created by 正和 on 2017/3/30.
//
//

#import "BaseTableViewController.h"

@interface LiveInfoViewController : BaseTableViewController

/** 现居省市区 */
@property (copy, nonatomic) NSString *address;

/**居住：省/直辖市*/
@property (copy, nonatomic) NSString *liveProv;
/**居住：市*/
@property (copy, nonatomic) NSString *liveCity;
/**居住：区*/
@property (copy, nonatomic) NSString *liveArea;


/**居住：镇*/
@property (copy, nonatomic) NSString *livetown;

/** 现地址 镇(详细地址 ) */
@property (strong, nonatomic) UITextField *liveTownField;



@end
