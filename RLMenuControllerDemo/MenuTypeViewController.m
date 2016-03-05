//
//  MenuTypeViewController.m
//  RLMenuControllerDemo
//
//  Created by Roy lee on 16/2/17.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "MenuTypeViewController.h"

@interface MenuTypeViewController ()

@end

@implementation MenuTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RLMenuController";
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UIButton * button0 = [cell viewWithTag:100];
    UIButton * button1 = [cell viewWithTag:101];
    UIButton * button2 = [cell viewWithTag:102];
    CGFloat inset = 15, buttonW = 25;
    if (!button0) {
        button0 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonW, buttonW)];
        button0.backgroundColor = [UIColor greenColor];
        [button0 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        button0.centerY = cell.height/2;
        button0.left = inset;
        [cell addSubview:button0];
    }
    if (!button1) {
        button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonW, buttonW)];
        button1.backgroundColor = [UIColor redColor];
        [button1 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        button1.centerY = cell.height/2;
        button1.centerX = kScreenWidth/2;
        [cell addSubview:button1];
    }
    if (!button2) {
        button2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonW, buttonW)];
        button2.backgroundColor = [UIColor yellowColor];
        [button2 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        button2.centerY = cell.height/2;
        button2.left = kScreenWidth - (inset + buttonW);
        [cell addSubview:button2];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showMenu:(UIButton *)button {
    RLMenuItem * item1 = [[RLMenuItem alloc]initWithTitle:@"菜单1" action:@selector(clickedMenuItem)];
    RLMenuItem * item2 = [[RLMenuItem alloc]initWithTitle:@"菜单2" action:@selector(clickedMenuItem)];
    RLMenuController * menu = [RLMenuController sharedMenuController];
    [menu setMenuItems:@[item1,item2]];
    [menu setTargetRect:button.bounds inView:button delegate:self];
    [menu setMenuVisible:YES animation:self.animation];
}

- (void)clickedMenuItem {
    NSLog(@"点击了菜单.....");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
