//
//  secondLevelDirectoryViewController.m
//  EShopCMBTraining
//
//  Created by qiukaibin  on 2018/7/23.
//  Copyright © 2018年 ZBQTraining. All rights reserved.
//

#import "secondLevelDirectoryViewController.h"
#import "showMerchandiseTableView.h"
#import "merchandiseTableViewCell.h"

#define WIDTH  (([[UIScreen mainScreen] bounds].size.width))
#define HEIGHT  (([[UIScreen mainScreen] bounds].size.height))

@interface secondLevelDirectoryViewController () <UITableViewDataSource,UITableViewDelegate>

@property NSArray * sortList;

@end

@implementation secondLevelDirectoryViewController

- (instancetype)init{
    if(self = [super init]){
        
//        NSDictionary *conditionDict = [[NSDictionary alloc] initWithObjectsAndKeys: userName,@"accountName", nil];
//        EShopDatabase *db=[EShopDatabase shareInstance];
//        NSArray *result = [db selectAllColumnFromTable:@"user" where:condition];
//        self.sortList = selectAllColumnFro
        return self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = CGRectMake(0,20, WIDTH, HEIGHT);
    showMerchandiseTableView *merchandiseTable = [[showMerchandiseTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    merchandiseTable.delegate = self;
    merchandiseTable.dataSource = self;
    //  ww.separatorStyle = YES;
    NSString * tcid = @"asdf";
    [merchandiseTable registerClass:[merchandiseTableViewCell class]forCellReuseIdentifier:tcid];
    [self.view addSubview:merchandiseTable];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    // Do any additional setup after loading the view.
}


//每个section的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    merchandiseTableViewCell *cell = [[merchandiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asdf"];
    if(indexPath.row==0){
        UIImage *homeFig = [UIImage imageNamed:@"homePage.png"];
        UIImageView *homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/16*9)];
        homeImage.image = homeFig;
        [cell addSubview:homeImage];
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellLabel.text=self.merchandiseMenusName;
       // cell.cellImage.image=[UIImage imageNamed:self.merchandiseSort[indexPath.row-1]];
    }
    return cell;
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
