# RLMenuController

# Overview

仿照微信朋友圈点赞评论菜单实现的一个功能！实现了四种方向的弹出动画，并作了基本的屏幕边缘frame的自适应弹出。同时，支持点击菜单回收上一个菜单，滚动隐藏菜单功能！

![Demo Overview](https://github.com/Roylee-ML/RLMenuController/blob/master/Sceenshot/wynews_screenshot.gif)

## Basic usage 用法

1.实现原理与用法借鉴系统的`UIMenuController`，定义`RLMenuItem`作为单一属性item，提供数据源，暂时只支持文字样式；菜单的提供由`RLMenuContentView`实现，UI设置以及动画均由这个类在方法`- (void)setMenuItems:(NSArray<RLMenuItem *> *)menuItems`中来来完成，个人可以根据自己需要改写`RLMenuContentView`，实现自己的UI布局方式。
2.方法`- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView delegate:(id)delegate;`中，参数`targetRect`表示弹出菜单的边界矩形范围，默认在此基础上向外增加`kMenuPaddingInset`宽的的insert，参数`targetView`作为弹出菜单的触发事件的view，当点击到`targetView`会自动按设置的动画执行弹出隐藏，点击其他区域自动渐变式隐藏菜单。
3.简单用法：

``` objc
    RLMenuItem * item1 = [[RLMenuItem alloc]initWithTitle:@"菜单1" action:@selector(clickedMenuItem)];
    RLMenuItem * item2 = [[RLMenuItem alloc]initWithTitle:@"菜单2" action:@selector(clickedMenuItem)];
    RLMenuController * menu = [RLMenuController sharedMenuController];
    [menu setMenuItems:@[item1,item2]];
    [menu setTargetRect:targetView.bounds inView:targetView delegate:self];
    [menu setMenuVisible:YES animation:self.animation];
```
## 总结
本demo作为交流学习之用，大家可以借鉴根据自己的需要改写相应实现。
