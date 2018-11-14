//
//  secondLevelDirectoryViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/23.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "secondLevelDirectoryViewController.h"


#define SHPWIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define SHPHEIGHT  (([[UIScreen mainScreen] bounds].size.height))

@interface secondLevelDirectoryViewController () <UITableViewDataSource,UITableViewDelegate>

@property NSArray * sortList;

@end

@implementation secondLevelDirectoryViewController

- (instancetype)init{
    if(self = [super init]){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.merchandiseMenusName;
    
    //取大类下的二级目录名，应优化为distinct查询
    NSDictionary *conditionDict = [[NSDictionary alloc] initWithObjectsAndKeys: self.merchandiseMenusName,@"merchandiseMenusName", nil];
    EShopDatabase *db=[EShopDatabase shareInstance];
    NSArray *result = [db selectAllColumnFromTable:@"merchandise" where:conditionDict];
    NSSet *sortSet = [[NSSet alloc] init];
    for (merchandise *merchandise in result)
    {
        sortSet = [sortSet setByAddingObject:merchandise.sortName];
    }
    self.sortList = [sortSet allObjects];
    
    CGRect rect = CGRectMake(0,20, SHPWIDTH, SHPHEIGHT);
    showMerchandiseTableView *merchandiseTable = [[showMerchandiseTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    merchandiseTable.delegate = self;
    merchandiseTable.dataSource = self;
    NSString * tcid = @"asdf";
    [merchandiseTable registerClass:[merchandiseTableViewCell class]forCellReuseIdentifier:tcid];
    [self.view addSubview:merchandiseTable];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    // Do any additional setup after loading the view.
}


//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortList.count;
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


//每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    secondLevelDirectoryTableViewCell *cell = [[secondLevelDirectoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asdf"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellLabel.text=self.sortList[indexPath.row];
    cell.cellImage.image=[UIImage imageNamed:self.sortList[indexPath.row]];
    return cell;
}


// 返回每个 Cell 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (SHPHEIGHT - 66) / 9;
};

//点击选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailOfMerchandiseViewController *detailOfMerchandise = [[detailOfMerchandiseViewController alloc]init];
    detailOfMerchandise.sortName = self.sortList[indexPath.row];
    detailOfMerchandise.currentUserID = self.currentUserID;
    [self.navigationController pushViewController:detailOfMerchandise animated:YES];
}

//进入下一页时隐藏bottomBar
- (void)viewDidAppear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = YES;
}

//返回时再次显示bottomBar
-(void) viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
