//
//  PageView.h
//  Smart
//
//  Created by Macx on 17/3/6.
//  Copyright © 2017年 www.weidixm.com炜迪电子科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScrollerViewLeft.h"
#import "ScrollViewRight.h"

@interface PageView : UIView<ScrollViewDelegate,UIScrollViewDelegate>

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,strong)id <ScrollViewDelegate>delegate;

-(void)reloadData;

-(void)reloadUI;

@end
