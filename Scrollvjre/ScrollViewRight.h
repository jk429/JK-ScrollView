//
//  ScrollViewRight.h
//  Scrollvjre
//
//  Created by Macx on 17/3/1.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollViewDelegate.h"

@interface ScrollViewRight : UIView

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,strong)UIScrollView *scrollview;

@property(nonatomic,strong)id <ScrollViewDelegate>delegate;
//滚动时的缩放
-(void)scrollViewing:(CGFloat)f :(BOOL)havedelegate;
//滚动结束时的缩放
-(void)scrollViewing:(CGFloat)f :(BOOL)havedelegate :(BOOL)isleft;
//滚动结束时图片处理
-(void)imaVwithImage:(BOOL)isleft;
//滚动时
-(void)imaVstartScale:(CGFloat)scale;
//结束滚动时
-(void)imaVstopScale:(CGFloat)scale;

-(void)reloadData;//数据

-(void)reloadUI;//UI

@end
