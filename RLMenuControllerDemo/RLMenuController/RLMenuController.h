//
//  RLMenuController.h
//  StarProject
//
//  Created by Roy lee on 16/2/17.
//  Copyright © 2016年 xmrk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLMacro.h"

typedef NS_ENUM(NSInteger, RLMenuControllerAnimation) {
    RLMenuControllerAnimationFade,  // by default
    RLMenuControllerAnimationUp,
    RLMenuControllerAnimationDown,
    RLMenuControllerAnimationLeft,
    RLMenuControllerAnimationRight,
};

@class RLMenuItem;
@interface RLMenuController : NSObject

@property(nonatomic, getter=isMenuVisible) BOOL menuVisible;	    // default is NO
@property(nonatomic, assign) RLMenuControllerAnimation animation;
@property(nonatomic, readonly) CGRect menuFrame;
@property(nonatomic, copy) NSArray<RLMenuItem *> *menuItems;
@property(nonatomic, weak) id delegate;  // the target to perform an action of a menu item(RLMenuItem class)
@property(nonatomic, strong, readonly) UIView * targetView; // a view for touch to show the menu

+ (RLMenuController *)sharedMenuController;

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated;

- (void)setMenuVisible:(BOOL)menuVisible animation:(RLMenuControllerAnimation)animation;

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView delegate:(id)delegate;

@end




@interface RLMenuItem : NSObject

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;

@property(nonatomic,copy) NSString *title;
@property(nonatomic)      SEL       action;

@end



