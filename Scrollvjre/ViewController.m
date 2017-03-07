//
//  ViewController.m
//  Scrollvjre
//
//  Created by Macx on 17/2/25.
//  Copyright © 2017年 Macx. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<ScrollViewDelegate>
{
    PageView * pv;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    pv=[[PageView alloc]initWithFrame:CGRectMake(0, 200, 1024, 350)];
    [self.view addSubview:pv];
    pv.delegate = self;
   
    [pv reloadUI];
     [pv reloadData];
   
}

#pragma mark - PagedView delegate
-(NSInteger)number{
    
    return 5;
}

-(UIImageView *)cellImageWithIndex:(NSInteger)index{
    
    UIImageView * imaV1 = [[UIImageView alloc]initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"interface_%ld",(long)index+101]]];
  
    return imaV1;

}

-(void)longPress:(NSUInteger)index{
    
    NSLog(@"%ld",(unsigned long)index);
    
}

-(void)tapAction:(NSUInteger)index{
    NSLog(@"%ld",(unsigned long)index);
}

-(void)DidScrooll:(NSUInteger)pageNumber{
     NSLog(@"%ld",(unsigned long)pageNumber);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
