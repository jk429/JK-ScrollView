//
//  PageView.m
//  Smart
//
//  Created by Macx on 17/3/6.
//  Copyright © 2017年 www.weidixm.com炜迪电子科技. All rights reserved.
//

#import "PageView.h"

CGFloat XmaxScale; //X最大缩小
CGFloat YmaxScale; //Y最大缩小
CGFloat minxAlp; //最小清晰度

@interface PageView ()
{
    
    CGFloat kcellX;
    CGFloat kcellW;
    
    UIScrollView * scrollview;
    
    CGFloat offest;//初始偏移，随滚动改变
    CGFloat offest1;//初始偏移，滚动结束时改变
   
    
    ScrollerViewLeft * leftscro;
    ScrollViewRight * rightscro;
    
    BOOL isdrag;//拖拽
    
    UIImageView * imaV1;
    UIImageView * imaV2;
    UIImageView * imaV3;
    
    UITapGestureRecognizer * tap;//
    UILongPressGestureRecognizer * press;//
    
}



@end


@implementation PageView

@synthesize count=count;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        leftscro = [[ScrollerViewLeft alloc]initWithFrame:CGRectMake(-(kcellW-kcellX), 0, kcellW, frame.size.height)];
        leftscro.delegate = self;
        [self addSubview:leftscro];
        
        rightscro = [[ScrollViewRight alloc]initWithFrame:CGRectMake(-(kcellW-kcellX)+kcellW*2, 0, kcellW, frame.size.height)];
        rightscro.delegate = self;
        [self addSubview:rightscro];
        
        scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(-(kcellW-kcellX)+kcellW, 0, kcellW, frame.size.height)];
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
        
        press=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressA:)];
        [self addGestureRecognizer:press];
        
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

-(void)tapA:(UITapGestureRecognizer *)tapsender{
    
    [self.delegate tapAction:imaV2.tag];
    
}
-(void)pressA:(UILongPressGestureRecognizer *)presssender{
    
    [self.delegate longPress:imaV2.tag];
}

//刷新数据
-(void)reloadData{
    
    if (count==1) {
        UIImageView * imageV2 = [self.delegate cellImageWithIndex:0];
        imaV2.image = imageV2.image;
        imaV2.tag=0;
        
        [scrollview setScrollEnabled:NO];
        [leftscro reloadData];
        [rightscro reloadData];
       
    }else{
        UIImageView * imageV1 = [self.delegate cellImageWithIndex:count-1];
        imaV1.image = imageV1.image;
        imaV1.tag=count-1;
       
        
        UIImageView * imageV2 = [self.delegate cellImageWithIndex:0];
        imaV2.image = imageV2.image;
        imaV2.tag=0;
        
        UIImageView * imageV3 = [self.delegate cellImageWithIndex:1];
        imaV3.image = imageV3.image;
        imaV3.tag=1;
        if (count==2) {
            
        }
        
        [leftscro reloadData];
        [rightscro reloadData];
    }

    [self setNeedsLayout];
}

//left and right cell
-(UIImageView *)cellImageWithIndex:(NSInteger)index{
   return [self.delegate cellImageWithIndex:index];
}

//刷新UI
-(void)reloadUI{
    
    count = [self.delegate number];
    leftscro.count=count;
    rightscro.count=count;
    
    XmaxScale=0.1;
    YmaxScale=0.1;
    minxAlp=0.5;
    
    kcellW=(int)self.frame.size.width/7*5;
    kcellX=(self.frame.size.width-kcellW)/2;

    leftscro.frame = CGRectMake(-(kcellW-kcellX), 0, kcellW, self.frame.size.height);
    
    scrollview.frame = CGRectMake(-(kcellW-kcellX)+kcellW, 0, kcellW, self.frame.size.height);
    
    rightscro.frame = CGRectMake(-(kcellW-kcellX)+kcellW*2, 0, kcellW, self.frame.size.height);
  
    
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
    
    
    [leftscro reloadUI];
    [rightscro reloadUI];
    
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - scrollViewdelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    offest=scrollView.contentOffset.x;
    isdrag = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scrollview2-%f",scrollView.contentOffset.x );
    if (isdrag) {
        
        CGFloat x = scrollView.contentOffset.x;
        CGFloat cut = x-offest;
        [leftscro scrollViewing:cut :NO];
        [rightscro scrollViewing:cut :NO];
        
        offest = scrollView.contentOffset.x;
        
        CGFloat scale = (fabs(offest1-x)/kcellW);
        [self imaVstartScale:scale];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // NSLog(@"scrollview2%f",scrollView.contentOffset.x );
    
    if (isdrag) {
        
        isdrag=NO;
        
        CGFloat x = scrollView.contentOffset.x;
        CGFloat cut = x-offest;
        
        
        if (offest1>x) {
            [leftscro scrollViewing:cut :YES :NO];
            [rightscro scrollViewing:cut :YES :NO];
            [self imaVwithImage:NO];
        }else if (offest1<x){
            [leftscro scrollViewing:cut :YES :YES];
            [rightscro scrollViewing:cut :YES :YES];
            [self imaVwithImage:YES];
        }else{
            [leftscro scrollViewing:cut :YES];
            [rightscro scrollViewing:cut :YES];
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
    
    imaV2.alpha= (1-scale)*minxAlp+(1-minxAlp);
    imaV1.alpha= (scale)*minxAlp+(1-minxAlp);
    imaV3.alpha= (scale)*minxAlp+(1-minxAlp);
    
    imaV2.layer.transform=CATransform3DMakeScale((1-scale)*XmaxScale+(1-XmaxScale), (1-scale)*YmaxScale+(1-YmaxScale), 1);
    imaV1.layer.transform=CATransform3DMakeScale(scale*XmaxScale+(1-XmaxScale), scale*YmaxScale+(1-YmaxScale), 1);
    imaV3.layer.transform=CATransform3DMakeScale(scale*XmaxScale+(1-XmaxScale), scale*YmaxScale+(1-YmaxScale), 1);
    
}

//滚动结束时的缩放
-(void)imaVstopScale:(CGFloat)scale{
    
    imaV1.alpha= 1;
    imaV2.alpha= 1;
    imaV3.alpha= 1;
    
    imaV1.layer.transform=CATransform3DMakeScale(1,1, 1);
    imaV2.layer.transform=CATransform3DMakeScale(1,1 ,1);
    imaV3.layer.transform=CATransform3DMakeScale(1,1, 1);
    
    [self.delegate DidScrooll:imaV2.tag];
}

#pragma mark - delegate leftAndright
//滚动时
-(void)LeftscrollViewing:(CGFloat)f :(BOOL)havedelegate{
    
    if (havedelegate) {
        scrollview.userInteractionEnabled=YES;
        scrollview.delegate=self;
        rightscro.userInteractionEnabled=YES;
        // rightscro.scrollview.delegate=rightscro;
    }else{
        scrollview.userInteractionEnabled=NO;
        scrollview.delegate=nil;
        rightscro.userInteractionEnabled=NO;
        //rightscro.scrollview.delegate=rightscro;
    }
    
    
    [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+f, 0)];
    
    [rightscro.scrollview setContentOffset:CGPointMake(rightscro.scrollview.contentOffset.x+f, 0)];
    
    CGFloat x = scrollview.contentOffset.x;
    CGFloat scale = (fabs(offest1-x)/kcellW);
    
    [self imaVstartScale:scale];
    [rightscro imaVstartScale:scale];
    
}

//结束滚动时
-(void)LeftscrollViewing:(CGFloat)f :(BOOL)havedelegate :(BOOL)isleft{
    
    if (havedelegate) {
        scrollview.userInteractionEnabled=YES;
        scrollview.delegate=self;
        rightscro.userInteractionEnabled=YES;
        //rightscro.scrollview.delegate=rightscro;
    }else{
        scrollview.userInteractionEnabled=NO;
        scrollview.delegate=nil;
        rightscro.userInteractionEnabled=NO;
        //rightscro.scrollview.delegate=rightscro;
    }
    
    [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+f, 0)];
    
    
    [rightscro.scrollview setContentOffset:CGPointMake(rightscro.scrollview.contentOffset.x+f, 0)];
    
    [self imaVwithImage:isleft];
    [rightscro imaVwithImage:isleft];
    
    [self imaVstopScale:0];
    [rightscro imaVstopScale:0];
    
}

//滚动时
-(void)RightscrollViewing:(CGFloat)f :(BOOL)havedelegate{
    
    if (havedelegate) {
        scrollview.userInteractionEnabled=YES;
        scrollview.delegate=self;
        leftscro.userInteractionEnabled=YES;
        //  leftscro.scrollview.delegate=leftscro;
        
    }else{
        scrollview.userInteractionEnabled=NO;
        scrollview.delegate=nil;
        leftscro.userInteractionEnabled=NO;
        //leftscro.scrollview.delegate=nil;
    }
    
    [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+f, 0)];
    
    [leftscro.scrollview setContentOffset:CGPointMake(leftscro.scrollview.contentOffset.x+f, 0)];
    
    CGFloat x = scrollview.contentOffset.x;
    CGFloat scale = (fabs(offest1-x)/kcellW);
    
    [self imaVstartScale:scale];
    [leftscro imaVstartScale:scale];
    
}

//结束滚动时
-(void)RightscrollViewing:(CGFloat)f :(BOOL)havedelegate :(BOOL)isleft{
    
    if (havedelegate) {
        scrollview.delegate=self;
        scrollview.userInteractionEnabled=YES;
        //leftscro.scrollview.delegate=leftscro;
        leftscro.userInteractionEnabled=YES;
    }else{
        scrollview.delegate=nil;
        scrollview.userInteractionEnabled=NO;
        //leftscro.scrollview.delegate=nil;
        leftscro.userInteractionEnabled=NO;
    }
    
    [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+f, 0)];
    
    [leftscro.scrollview setContentOffset:CGPointMake(leftscro.scrollview.contentOffset.x+f, 0)];
    
    [self imaVwithImage:isleft];
    [leftscro imaVwithImage:isleft];
    
    [self imaVstopScale:0];
    [leftscro imaVstopScale:0];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
