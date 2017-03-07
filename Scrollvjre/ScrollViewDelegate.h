//
//  ScrollViewDelegate.h
//  Scrollvjre
//
//  Created by Macx on 17/2/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ScrollViewDelegate <NSObject>

-(void)LeftscrollViewing:(CGFloat)f :(BOOL)havedelegate ;//左边滚动时
//左边结束滚动时
-(void)LeftscrollViewing:(CGFloat)f :(BOOL)havedelegate :(BOOL)isleft;
-(void)RightscrollViewing:(CGFloat)f :(BOOL)havedelegate;//右边滚动时
//右边结束滚动时
-(void)RightscrollViewing:(CGFloat)f :(BOOL)havedelegate :(BOOL)isleft;

-(NSInteger)number;//行数
-(void)DidScrooll:(NSUInteger)pageNumber;//滚到哪了
-(void)longPress:(NSUInteger)index;//长按
-(void)tapAction:(NSUInteger)index;//点击
-(UIImageView *)cellImageWithIndex:(NSInteger)index;//cell

@end
