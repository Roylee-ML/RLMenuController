//
//  UIView+Common.h
//  StarProject
//
//  Created by Roy lee on 16/2/17.
//  Copyright © 2016年 xmrk. All rights reserved.
//

#import <UIKit/UIKit.h>

/// State of the gesture
typedef NS_ENUM(NSUInteger, UI_GestureRecognizerState) {
    UI_GestureRecognizerStateBegan, ///< gesture start
    UI_GestureRecognizerStateMoved, ///< gesture moved
    UI_GestureRecognizerStateEnded, ///< gesture end
    UI_GestureRecognizerStateCancelled, ///< gesture cancel
};

@interface UIView (Common)
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

CGFloat UIScreenScale();

/**
 touch block for easy handle. eg.
 
 UIView * eg_view = [UIView new];
 [eg_view setTouchBlock:^(UIView * view, UI_GestureRecognizerState state, NSSet * touches, UIEvent * event) {
 // set backgroundcolor for different gesture state
 if (state == UI_GestureRecognizerStateBegan) {
 weak_self.timeLable.backgroundColor = [UIColor grayColor];    // color for highlighted
 }else {
 weak_self.timeLable.backgroundColor = [UIColor whiteColor];   // color for normal
 }
 }];
 */
@property (nonatomic, copy) void (^touchBlock)(UIView *view, UI_GestureRecognizerState state, NSSet *touches, UIEvent *event);

@end
