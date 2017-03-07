//
//  ScrollerViewLeft.m
//  Scrollvjre
//
//  Created by Macx on 17/2/28.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ScrollerViewLeft.h"

extern CGFloat XmaxScale; //X最大缩小
extern CGFloat YmaxScale; //Y最大缩小
extern CGFloat minxAlp; //最小清晰度

@interface ScrollerViewLeft ()<UIScrollViewDelegate>
{
    CGFloat kcellW;
    
    
    CGFloat offest;//初始偏移，随滚动改变
    CGFloat offest1;//初始偏移，滚动结束时改变

    BOOL isdrag;//拖拽
    
    UIImageView * imaV1;
    UIImageView * imaV2;
    UIImageView * imaV3;
    
    UITapGestureRecognizer * tap;//点击图片
    
}
@end

@implementation ScrollerViewLeft

@synthesize scrollview = scrollview;
@synthesize count = count;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
      
        kcellW=frame.size.width;
    
        scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollview.delegate = self;
        scrollview.pagingEnabled = YES;
        scrollview.clipsToBounds = YES;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.bounces=NO;
        [self addSubview:scrollview];
        scrollview.contentSize = CGSizeMake(kcellW*3, 0);
        scrollview.contentOffset=CGPointMake(kcellW, 0);
    
        tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapA:)];
        [scrollview addGestureRecognizer:tap];
        
        offest1=scrollview.contentOffset.x;
  
        [self createImaV];
        
        [self imaVstopScale:0];
        
    }
    return self;
}


-(void)createImaV{
    
    imaV1 = [[UIImageView alloc]init];
    imaV1.userInteractionEnabled = YES;
    imaV1.frame = CGRectMake(0,0,kcellW, scrollview.frame.size.height);
    [scrollview addSubview:imaV1];
    
    imaV2 = [[UIImageView alloc]init];
    imaV2.userInteractionEnabled = YES;
    imaV2.frame = CGRectMake(kcellW,0,kcellW, scrollview.frame.size.height);
    [scrollview addSubview:imaV2];
    
    imaV3 = [[UIImageView alloc]init];
    imaV3.userInteractionEnabled = YES;
    imaV3.frame = CGRectMake(kcellW*2,0,kcellW, scrollview.frame.size.height);
    [scrollview addSubview:imaV3];
    
}

//刷新数据
-(void)reloadData{
    
    if (count==1) {
        UIImageView * imageV2 = [self.delegate cellImageWithIndex:0];
        imaV2.image = imageV2.image;
        imaV2.tag=0;
        [scrollview setScrollEnabled:NO];
        
    }else{
        UIImageView * imageV1 = [self.delegate cellImageWithIndex:count-2];
        imaV1.image = imageV1.image;
        imaV1.tag=count-2;
        
        UIImageView * imageV2 = [self.delegate cellImageWithIndex:count-1];
        imaV2.image = imageV2.image;
        imaV2.tag=count-1;
        
        UIImageView * imageV3 = [self.delegate cellImageWithIndex:0];
        imaV3.image = imageV3.image;
        imaV3.tag=0;
        
    }
    
    [self setNeedsLayout];
}



//刷新UI
-(void)reloadUI{
    
   
    kcellW=self.frame.size.width;
  
    scrollview.frame = self.bounds;
    
    scrollview.contentSize = CGSizeMake(kcellW*3, 0);
    scrollview.contentOffset=CGPointMake(kcellW, 0);
    
    offest1=scrollview.contentOffset.x;
    
    imaV1.layer.transform=CATransform3DMakeScale(1,1, 1);
    imaV2.layer.transform=CATransform3DMakeScale(1,1, 1);
    imaV3.layer.transform=CATransform3DMakeScale(1,1, 1);
    imaV1.frame = CGRectMake(0,0,kcellW, scrollview.frame.size.height);
    imaV2.frame = CGRectMake(kcellW,0,kcellW, scrollview.frame.size.height);
    imaV3.frame = CGRectMake(kcellW*2,0,kcellW, scrollview.frame.size.height);
    
    [self imaVstopScale:0];
    
    [self setNeedsLayout];
}

//点击图片
-(void)tapA:(UITapGestureRecognizer *)tapsender{
    offest=scrollview.contentOffset.x;
    isdrag = YES;
    [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - scrollViewdelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   
    
    offest=scrollView.contentOffset.x;
    isdrag = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 // NSLog(@"scrollview1 - %f",scrollView.contentOffset.x );
    if (isdrag) {
        
    CGFloat x = scrollView.contentOffset.x;
    CGFloat cut = x-offest;
    [self.delegate LeftscrollViewing:cut :NO];
    offest = scrollView.contentOffset.x;
        
        CGFloat scale = (fabs(offest1-x)/kcellW);
        [self imaVstartScale:scale];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (isdrag) {
        
        isdrag=NO;
        
      //  NSLog(@"left%f",scrollView.contentOffset.x );
        
        CGFloat x = scrollView.contentOffset.x;
        CGFloat cut = x-offest;
        
        
        if (offest1>x) {
            [self.delegate LeftscrollViewing:cut :YES :NO];
            [self imaVwithImage:NO];
        }else if (offest1<x){
            [self.delegate LeftscrollViewing:cut :YES :YES];
            [self imaVwithImage:YES];
        }else{
          [self.delegate LeftscrollViewing:cut :YES];
             [scrollview setContentOffset:CGPointMake(kcellW, 0)];
        }
        [self imaVstopScale:0];
    }
    
    offest = scrollView.contentOffset.x;
    
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (isdrag) {
        
        isdrag=NO;
        
        //  NSLog(@"left%f",scrollView.contentOffset.x );
        
        CGFloat x = scrollView.contentOffset.x;
        CGFloat cut = x-offest;
        
        
        if (offest1>x) {
            [self.delegate LeftscrollViewing:cut :YES :NO];
            [self imaVwithImage:NO];
        }else if (offest1<x){
            [self.delegate LeftscrollViewing:cut :YES :YES];
            [self imaVwithImage:YES];
        }else{
            [self.delegate LeftscrollViewing:cut :YES];
            [scrollview setContentOffset:CGPointMake(kcellW, 0)];
        }
        [self imaVstopScale:0];
    }
    
    offest = scrollView.contentOffset.x;
    
}
//滚动结束时图片处理
-(void)imaVwithImage:(BOOL)isleft{
    
    if (isleft==NO) {
        if (imaV1.tag-1<count-1 && imaV1.tag-1 >= 0) {
            UIImageView * imageV3 = [self.delegate cellImageWithIndex:imaV1.tag-1];
            imaV1.image = imageV3.image;
            imaV1.tag=imaV1.tag-1;
        }else if(imaV1.tag-1<0){
            UIImageView * imageV3 = [self.delegate cellImageWithIndex:count-1];
            imaV1.image = imageV3.image;
            imaV1.tag=count-1;
            
        }
        
        if (imaV2.tag-1<count-1 && imaV2.tag-1 >= 0) {
            UIImageView * imageVw = [self.delegate cellImageWithIndex:imaV2.tag-1];
            imaV2.image = imageVw.image;
            imaV2.tag=imaV2.tag-1;
        }else if(imaV2.tag-1<0){
            UIImageView * imageV2 = [self.delegate cellImageWithIndex:count-1];
            imaV2.image = imageV2.image;
            imaV2.tag=count-1;
            
        }
        
        if (imaV3.tag-1<count-1 && imaV3.tag-1 >= 0) {
            UIImageView * imageV3 = [self.delegate cellImageWithIndex:imaV3.tag-1];
            imaV3.image = imageV3.image;
            imaV3.tag=imaV3.tag-1;
        }else if(imaV3.tag-1<0){
            UIImageView * imageV3 = [self.delegate cellImageWithIndex:count-1];
            imaV3.image = imageV3.image;
            imaV3.tag=count-1;
            
        }
        
        
    }else if (isleft==YES){
        
        if (imaV1.tag+1<count && imaV1.tag+1>0) {
            UIImageView * imageV1 = [self.delegate cellImageWithIndex:imaV1.tag+1];
            imaV1.image = imageV1.image;
            imaV1.tag=imaV1.tag+1;
        }else if(imaV1.tag+1>=count){
            UIImageView * imageV1 = [self.delegate cellImageWithIndex:0];
            imaV1.image = imageV1.image;
            imaV1.tag=0;
        }
        
        if (imaV2.tag+1<count && imaV2.tag+1>0) {
            UIImageView * imageV2 = [self.delegate cellImageWithIndex:imaV2.tag+1];
            imaV2.image = imageV2.image;
            imaV2.tag=imaV2.tag+1;
        }else if(imaV2.tag+1>=count){
            UIImageView * imageV1 = [self.delegate cellImageWithIndex:0];
            imaV2.image = imageV1.image;
            imaV2.tag=0;
        }
        
        if (imaV3.tag+1<count && imaV3.tag+1>0) {
            UIImageView * imageV1 = [self.delegate cellImageWithIndex:imaV3.tag+1];
            imaV3.image = imageV1.image;
            imaV3.tag=imaV3.tag+1;
        }else if(imaV3.tag+1>=count){
            UIImageView * imageV1 = [self.delegate cellImageWithIndex:0];
            imaV3.image = imageV1.image;
            imaV3.tag=0;
        }
    }
    [scrollview setContentOffset:CGPointMake(kcellW, 0)];
}

//滚动时的缩放
-(void)imaVstartScale:(CGFloat)scale{
    
    imaV1.alpha= (1-scale)*minxAlp+(1-minxAlp);
    imaV2.alpha= (scale)*minxAlp+(1-minxAlp);
    imaV3.alpha= (1-scale)*minxAlp+(1-minxAlp);
    
    imaV1.layer.transform=CATransform3DMakeScale((1-scale)*XmaxScale+(1-XmaxScale), (1-scale)*YmaxScale+(1-YmaxScale), 1);
    imaV2.layer.transform=CATransform3DMakeScale(scale*XmaxScale+(1-XmaxScale), scale*YmaxScale+(1-YmaxScale), 1);
    imaV3.layer.transform=CATransform3DMakeScale((1-scale)*XmaxScale+(1-XmaxScale), (1-scale)*YmaxScale+(1-YmaxScale), 1);
}

//滚动结束时的缩放
-(void)imaVstopScale:(CGFloat)scale{
    
    imaV1.alpha= 1;
    imaV2.alpha= (scale)*minxAlp+(1-minxAlp);
    imaV3.alpha= 1;
    
    imaV1.layer.transform=CATransform3DMakeScale(1,1, 1);
    imaV2.layer.transform=CATransform3DMakeScale(scale*XmaxScale+(1-XmaxScale), scale*YmaxScale+(1-YmaxScale), 1);
    imaV3.layer.transform=CATransform3DMakeScale(1,1, 1);
}

#pragma mark - mainVCscroll 
//滚动时
-(void)scrollViewing:(CGFloat)f :(BOOL)havedelegate{
    if (havedelegate) {
        scrollview.userInteractionEnabled=YES;
        scrollview.delegate=self;
    }else{
        scrollview.userInteractionEnabled=NO;
        scrollview.delegate=nil;
    }
    [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+f, 0)];
    
    CGFloat x = scrollview.contentOffset.x;
    CGFloat scale = (fabs(offest1-x)/kcellW);
    [self imaVstartScale:scale];
}

//结束滚动时
-(void)scrollViewing:(CGFloat)f :(BOOL)havedelegate :(BOOL)isleft{
    
    if (havedelegate) {
        scrollview.userInteractionEnabled=YES;
        scrollview.delegate=self;
    }else{
        scrollview.userInteractionEnabled=NO;
        scrollview.delegate=nil;
    }
    [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+f, 0)];
    [self imaVwithImage:isleft];
    
    [self imaVstopScale:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
