//
//  RLMenuController.m
//  StarProject
//
//  Created by Roy lee on 16/2/17.
//  Copyright © 2016年 xmrk. All rights reserved.
//

#import "RLMenuController.h"

#define kMenuItemMinWidth   80.0f
#define kMenuDefaultHeight  35.0f
#define kMenuPaddingInset   15.0f
#define kMenuItemFont       [UIFont systemFontOfSize:13]
#define kContentBackgroundColor  [UIColor darkGrayColor]
#define kShowAnimationDuration  0.25f
#define kHideAnimationDuration  0.25f

@interface RLMenuContentView : UIView

@property (nonatomic, getter=isMenuVisible) BOOL menuVisible;
@property (nonatomic, copy) NSArray<RLMenuItem *> *menuItems;
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, assign) RLMenuControllerAnimation animation;
@property (nonatomic, weak) RLMenuController * menuController;

@end

@implementation RLMenuContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    self.animation = RLMenuControllerAnimationFade; // default
    self.containerView = [UIView new];
    _containerView.backgroundColor = kContentBackgroundColor;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _containerView.layer.cornerRadius = self.layer.cornerRadius;
    _containerView.layer.masksToBounds = YES;
    [self addSubview:_containerView];
    
    return self;
}

- (void)setMenuItems:(NSArray<RLMenuItem *> *)menuItems {
    _menuItems = menuItems;
    for (UIView * subView in self.containerView.subviews) {
        [subView removeFromSuperview];
    }
    // width
    __block CGFloat width = 0, left = 0;
    CGFloat lineWidth = 1.0f/kScreenScale;
    [menuItems enumerateObjectsUsingBlock:^(RLMenuItem * _Nonnull menuItem, NSUInteger idx, BOOL * _Nonnull stop) {
        // item width
        CGFloat itemWidth = [menuItem.title boundingRectWithSize:CGSizeMake(MAXFLOAT, kMenuDefaultHeight)
                                                         options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                                      attributes:@{NSFontAttributeName: kMenuItemFont}
                                                         context:nil].size.width;
        itemWidth = MAX(itemWidth + 30, kMenuItemMinWidth);
        // item view
        UILabel * itemLable = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, itemWidth, kMenuDefaultHeight)];
        itemLable.userInteractionEnabled = YES;
        itemLable.text = menuItem.title;
        itemLable.textAlignment = NSTextAlignmentCenter;
        itemLable.textColor = [UIColor whiteColor];
        [self.containerView addSubview:itemLable];
        // tap action
        @weakify(self)
        [itemLable setTouchBlock:^(UIView * view, UI_GestureRecognizerState state, NSSet * touches, UIEvent * event) {
            @strongify(self);
            if (state == UI_GestureRecognizerStateBegan) {
                view.backgroundColor = [UIColor lightGrayColor];
            }else if (state == UI_GestureRecognizerStateEnded) {
                view.backgroundColor = kContentBackgroundColor;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if (self.menuController.delegate && [self.menuController.delegate respondsToSelector:menuItem.action]) {
                    [self.menuController.delegate performSelector:menuItem.action];
                }
#pragma clang diagnostic pop
                [self hidenAnimation:self.animation];
            }else {
                view.backgroundColor = kContentBackgroundColor;
            }
        }];
        // line
        if (idx < menuItems.count - 1) {
            UIView * line = [UIView new];
            line.backgroundColor = [UIColor blackColor];
            line.width = lineWidth;
            line.left = itemLable.right;
            line.height = kMenuDefaultHeight - 2 * 10;
            line.centerY = itemLable.centerY;
            [self.containerView addSubview:line];
            
            width += lineWidth;
            left += lineWidth;
        }
        
        left += itemLable.right;
        width += itemWidth;
    }];
    self.containerView.width = width;
    self.containerView.height = kMenuDefaultHeight;
    self.width = width;
    self.height = kMenuDefaultHeight;
}

- (void)showMenuAnimation:(RLMenuControllerAnimation)animation {
    if (self.isMenuVisible) {
        return;
    }
    switch (animation) {
        case RLMenuControllerAnimationFade:
            self.containerView.frame = self.bounds;
            self.containerView.alpha = 1;
            break;
        case RLMenuControllerAnimationDown:
            self.containerView.bottom = 0;
            self.containerView.height = 0;
            break;
        case RLMenuControllerAnimationUp:
            self.containerView.top = kMenuDefaultHeight;
            self.containerView.height = 0;
            break;
        case RLMenuControllerAnimationLeft:
            self.containerView.left = self.width;
            self.containerView.width = 0;
            break;
        case RLMenuControllerAnimationRight:
            self.containerView.right = 0;
            self.containerView.width = 0;
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:kShowAnimationDuration animations:^{
        self.containerView.frame = self.bounds;
    }];
    self.menuVisible = YES;
}

- (void)showMenuAnimated:(BOOL)animated {
    if (self.isMenuVisible) {
        return;
    }
    if (animated) {
        [self showMenuAnimation:RLMenuControllerAnimationFade];
    }else {
        self.containerView.alpha = 1;
        self.containerView.frame = self.bounds;
    }
    self.menuVisible = YES;
}

- (void)hidenAnimation:(RLMenuControllerAnimation)animation {
    if (!self.isMenuVisible) {
        return;
    }
    [UIView animateWithDuration:kHideAnimationDuration animations:^{
        switch (animation) {
            case RLMenuControllerAnimationFade:
                self.containerView.alpha = 0;
                break;
            case RLMenuControllerAnimationDown:
                self.containerView.height = 0;
                self.containerView.bottom = 0;
                break;
            case RLMenuControllerAnimationUp:
                self.containerView.height = 0;
                self.containerView.top = kMenuDefaultHeight;
                break;
            case RLMenuControllerAnimationLeft:
                self.containerView.width = 0;
                self.containerView.left = self.width;
                break;
            case RLMenuControllerAnimationRight:
                self.containerView.width = 0;
                self.containerView.right = 0;
                break;
                
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.menuVisible = NO;
}

- (void)hidenAnimated:(BOOL)animated {
    if (!self.isMenuVisible) {
        return;
    }
    if (animated) {
        [self hidenAnimation:RLMenuControllerAnimationFade];
    }else {
        self.containerView.backgroundColor = [kContentBackgroundColor colorWithAlphaComponent:0.0f];
    }
    self.menuVisible = NO;
}

#pragma mark - hit test
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint targetPoint = [self.menuController.targetView convertPoint:point fromView:self];
    BOOL touchOutSide = !CGRectContainsPoint(self.bounds, point);
    BOOL touchTargetView = CGRectContainsPoint(self.menuController.targetView.bounds, targetPoint);
    if (touchOutSide) {
        if (touchTargetView) {
            [self hidenAnimation:self.animation];
            return self;
        }else {
            [self hidenAnimated:YES];
        }
    }
    return [super hitTest:point withEvent:event];
}

@end





@implementation RLMenuItem

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action {
    if (self = [super init]) {
        NSAssert(nil != action, @"action of this item must not be nil");
        self.title = title;
        self.action = action;
    }
    return self;
}

@end




@interface RLMenuController ()

@property (nonatomic, strong) RLMenuContentView * contentView;
@property (nonatomic, assign) CGRect targetRect;
@property (nonatomic, strong, readwrite) UIView * targetView;

@end

@implementation RLMenuController

+ (RLMenuController *)sharedMenuController {
    static dispatch_once_t onceToken;
    static RLMenuController * menu = nil;
    dispatch_once(&onceToken, ^{
        menu = [[RLMenuController alloc]init];
    });
    return menu;
}

- (void)setMenuItems:(NSArray<RLMenuItem *> *)menuItems {
    _menuItems = menuItems;
    self.contentView = [[RLMenuContentView alloc]initWithFrame:CGRectZero];
    self.contentView.menuController = self;
    [self.contentView setMenuItems:menuItems];
}

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView delegate:(id)delegate {
    self.targetRect = targetRect;
    self.targetView = targetView;
    self.delegate = delegate;
}

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated {
    [keyWindow() addSubview:self.contentView];
    // default animation is RLMenuControllerAnimationFade at the top
    CGFloat originX = self.targetRect.origin.x;
    CGFloat originY = MIN(self.targetRect.origin.y, 0);
    CGFloat centerX = originX + self.targetRect.size.width/2;
    CGFloat centerY = originY - (self.contentView.height/2 + kMenuPaddingInset);
    CGPoint center = CGPointMake(centerX, centerY);
    CGPoint windowCenter = [self.targetView convertPoint:center toView:keyWindow()];
    self.contentView.center = windowCenter;
    [self.contentView showMenuAnimated:animated];
}

- (void)setMenuVisible:(BOOL)menuVisible animation:(RLMenuControllerAnimation)animation {
    self.animation = animation;
    [keyWindow() addSubview:self.contentView];
    
    CGFloat centerX = 0;
    CGFloat centerY = 0;
    CGFloat originX = 0, originY = 0;;
    if (animation == RLMenuControllerAnimationFade) {
        originX = self.targetRect.origin.x;
        originY = MIN(self.targetRect.origin.y, 0);
        centerX = originX + self.targetRect.size.width/2;
        centerY = originY - (self.contentView.height/2 + kMenuPaddingInset);
    }else if (animation == RLMenuControllerAnimationUp) {
        originX = self.targetRect.origin.x;
        originY = MIN(self.targetRect.origin.y, 0);
        centerX = originX + self.targetRect.size.width/2;
        centerY = originY - (self.contentView.height/2 + kMenuPaddingInset);
    }else if (animation == RLMenuControllerAnimationDown) {
        originX = self.targetRect.origin.x;
        originY = MAX(self.targetRect.origin.y + self.targetRect.size.height, self.targetView.height);
        centerX = originX + self.targetRect.size.width/2;
        centerY = originY + (self.contentView.height/2 + kMenuPaddingInset);
    }else if (animation == RLMenuControllerAnimationLeft) {
        originX = MIN(self.targetRect.origin.x, 0);
        originY = self.targetRect.origin.y;
        centerX = originX - (self.contentView.width/2 + kMenuPaddingInset);
        centerY = originY + self.targetRect.size.height/2;
    }else if (animation == RLMenuControllerAnimationRight) {
        originX = MAX(self.targetRect.origin.x + self.targetRect.size.width, self.targetView.width);
        originY = self.targetRect.origin.y;
        centerX = originX + (self.contentView.width/2 + kMenuPaddingInset);
        centerY = originY + self.targetRect.size.height/2;
    }
    
    CGPoint center = CGPointMake(centerX, centerY);
    CGPoint windowCenter = [self.targetView convertPoint:center toView:keyWindow()];
    self.contentView.center = [self setContentCenterFitToScreen:windowCenter];
    [self.contentView showMenuAnimation:_animation];
}

// fit the content frame to screen edges
- (CGPoint)setContentCenterFitToScreen:(CGPoint)center {
    CGPoint newCenter = CGPointZero;
    CGFloat minX = center.x - self.contentView.width/2;
    CGFloat minY = center.y - self.contentView.height/2;
    CGFloat maxX = center.x + self.contentView.width/2;
    CGFloat maxY = center.y + self.contentView.height/2;
    // up down
    if (_animation < 3) {
        // fit left and right screen edge
        minX = MAX(kMenuPaddingInset, minX);
        minX = MIN(kScreenWidth - kMenuPaddingInset - self.contentView.width, minX);
        center.x = minX + self.contentView.width/2;
        if (_animation == RLMenuControllerAnimationFade) {  // show frome up
            if (minY < kMenuPaddingInset) { // change to show frome down
                self.animation = RLMenuControllerAnimationDown;
                center.y += (self.contentView.height + 2 * kMenuPaddingInset + self.targetRect.size.height);
            }
        }else if (_animation == RLMenuControllerAnimationUp) {
            if (minY < kMenuPaddingInset) { // change to show frome down
                self.animation = RLMenuControllerAnimationDown;
                center.y += (self.contentView.height + 2 * kMenuPaddingInset + self.targetRect.size.height);
            }
        }else if (_animation == RLMenuControllerAnimationDown) {
            if (maxY > kScreenHeight - kMenuPaddingInset) { // change to show frome up
                self.animation = RLMenuControllerAnimationUp;
                center.y -= (self.contentView.height + 2 * kMenuPaddingInset + self.targetRect.size.height);
            }
        }
    }
    // left right
    else {
        // fit up and down screen edge
        minY = MAX(kMenuPaddingInset, minY);
        minY = MIN(kScreenHeight - kMenuPaddingInset - self.contentView.height, minY);
        center.y = minY + self.contentView.height/2;
        if (_animation == RLMenuControllerAnimationLeft) {
            if (minX < kMenuPaddingInset) { // change to show frome right
                self.animation = RLMenuControllerAnimationRight;
                center.x += (self.contentView.width + 2 * kMenuPaddingInset + self.targetRect.size.width);
            }
        }else if (_animation == RLMenuControllerAnimationRight) {
            if (maxX > kScreenWidth - kMenuPaddingInset) { // change to show frome left
                self.animation = RLMenuControllerAnimationLeft;
                center.x -= (self.contentView.width + 2 * kMenuPaddingInset + self.targetRect.size.width);
            }
        }
    }
    newCenter = center;
    return newCenter;
}

- (BOOL)isMenuVisible {
    return self.contentView.isMenuVisible;
}

UIWindow * keyWindow() {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

@end





