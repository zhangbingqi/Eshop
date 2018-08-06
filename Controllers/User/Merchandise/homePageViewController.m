//
//  homePageViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/20.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "homePageViewController.h"
#define MYBLUE (( [UIColor colorWithRed:63.0/256 green:226.0/256 blue:231.0/256 alpha:1.0] ))

@interface homePageViewController () <UITableViewDataSource,UITableViewDelegate>

@property NSArray* merchandiseSort;

@end

@implementation homePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.merchandiseSort = @[@"Mac",@"iPhone",@"iPad",@"Apple Watch",@"iPod touch",@"配件"];
    self.title = @"选购";
    screenSize *instanceOfScreenSize = [[screenSize alloc] init];
    CGRect rect = CGRectMake(0,20, instanceOfScreenSize.width, instanceOfScreenSize.height);
    showMerchandiseTableView *merchandiseTable = [[showMerchandiseTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    merchandiseTable.delegate = self;
    merchandiseTable.dataSource = self;
    NSString * tcid = @"asdf";
    [merchandiseTable registerClass:[merchandiseTableViewCell class]forCellReuseIdentifier:tcid];
    [self.view addSubview:merchandiseTable];
   // self.view.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor= MYBLUE;
    // Do any additional setup after loading the view.
}


// 返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    merchandiseTableViewCell *cell = [[merchandiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asdf"];
    if(indexPath.row==0){
        screenSize *instanceOfScreenSize = [[screenSize alloc] init];
        UIImage *homeFig = [UIImage imageNamed:@"homePage.png"];
        UIImageView *homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, instanceOfScreenSize.width, instanceOfScreenSize.width/16*9)];
        homeImage.image = homeFig;
        [cell addSubview:homeImage];
    }
    else{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellLabel.text=self.merchandiseSort[indexPath.row-1];
    cell.cellImage.image=[UIImage imageNamed:self.merchandiseSort[indexPath.row-1]];
    }
    return cell;
}

//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.merchandiseSort.count+1;
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 返回每个 Cell 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    screenSize *instanceOfScreenSize = [[screenSize alloc] init];
    if(indexPath.row==0){
        return instanceOfScreenSize.width/16*9;
    }
    return (instanceOfScreenSize.height-88)/4;
};

//选择事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0){
        secondLevelDirectoryViewController *secondLevelDirectory = [[secondLevelDirectoryViewController alloc]init];
        secondLevelDirectory.merchandiseMenusName = self.merchandiseSort[indexPath.row-1];
        secondLevelDirectory.currentUserID = self.currentUserID;
        [self.navigationController pushViewController:secondLevelDirectory animated:YES];
    }
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
