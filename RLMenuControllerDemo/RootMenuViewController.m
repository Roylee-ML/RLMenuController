//
//  RootMenuViewController.m
//  RLMenuControllerDemo
//
//  Created by Roy lee on 16/2/17.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "RootMenuViewController.h"
#import "MenuTypeViewController.h"

@interface RootMenuViewController ()

@property (nonatomic, strong) NSArray * animations;

@end

@implementation RootMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"RLMenuControllerAnimation";
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    self.animations = @[@"RLMenuControllerAnimationFade",
                        @"RLMenuControllerAnimationUp",
                        @"RLMenuControllerAnimationDown",
                        @"RLMenuControllerAnimationLeft",
                        @"RLMenuControllerAnimationRight"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.animations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.animations[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MenuTypeViewController * menuVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"menu_type_vc"];
    menuVC.animation = (RLMenuControllerAnimation)indexPath.row;
    [self.navigationController pushViewController:menuVC animated:YES];
}

@end
