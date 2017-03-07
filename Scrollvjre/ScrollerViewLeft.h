//
//  ScrollerViewLeft.h
//  Scrollvjre
//
//  Created by Macx on 17/2/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollViewDelegate.h"

@interface ScrollerViewLeft : UIView

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,strong)UIScrollView *scrollview;

@property(nonatomic,strong)id <ScrollViewDelegate>delegate;

//滚动时
-(void)scrollViewing:(CGFloat)f :(BOOL)havedelegate;
//结束滚动时
-(void)scrollViewing:(CGFloat)f :(BOOL)havedelegate :(BOOL)isleft;
//滚动结束时图片处理
-(void)imaVwithImage:(BOOL)isleft;
//滚动时的缩放
-(void)imaVstartScale:(CGFloat)scale;
//滚动结束时的缩放
-(void)imaVstopScale:(CGFloat)scale;

-(void)reloadData;//数据

-(void)reloadUI;//UI

@end
