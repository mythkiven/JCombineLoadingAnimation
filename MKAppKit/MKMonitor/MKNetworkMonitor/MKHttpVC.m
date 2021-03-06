/**
 *
 * Created by https://github.com/mythkiven/ on 19/07/01.
 * Copyright © 2019年 mythkiven. All rights reserved.
 *
 */


#import "MKHttpVC.h"
#import "MKHttpDetailVC.h"
#import "MKDebugTool.h"
#import "MKHttpCell.h"

@interface MKHttpVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSArray      *listData;
@end

@implementation MKHttpVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Http"];
   
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[MKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    UIButton *btnclear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclear.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclear setTitle:@"清空" forState:UIControlStateNormal];
    [btnclear addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclear setTitleColor:[MKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithCustomView:btnclear];
    self.navigationItem.rightBarButtonItem = btnright;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
   
    [self reloadHttp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHttp) name:kNotifyKeyReloadHttp object:nil];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearAction {
    [[MKHttpDatasource shareInstance] clear];
    self.listData = nil;
    [self.tableView reloadData];
}

- (void)reloadHttp {
    self.listData = [[[MKHttpDatasource shareInstance] httpArray] copy];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    MKHttpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[MKHttpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    MKHttpModel* model = [self.listData objectAtIndex:indexPath.row];
    [cell setTitle:model.url.host value:model.url.path];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MKHttpModel* model = [self.listData objectAtIndex:indexPath.row];
    MKHttpDetailVC* vc = [[MKHttpDetailVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.detail = model;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
