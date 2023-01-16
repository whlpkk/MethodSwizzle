//
//  ViewController.m
//  SwizzleDemo
//
//  Created by YZK on 2023/1/16.
//

#import "ViewController.h"
#import "UIView+Edge.h"
#import "UIButton+Edge.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 200, 50)];
    view1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 200, 50)];
    view2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view2];
    
    UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeSystem];
    bt1.frame = CGRectMake(50, 10, 100, 30);
    bt1.backgroundColor = [UIColor purpleColor];
    bt1.yzk_responseEdge1 = UIEdgeInsetsMake(-10, -50, -10, -50);
    [bt1 setTitle:@"button" forState:UIControlStateNormal];
    [bt1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:bt1];
    
    UIButton *bt2 = [UIButton buttonWithType:UIButtonTypeSystem];
    bt2.frame = CGRectMake(50, 10, 100, 30);
    bt2.backgroundColor = [UIColor purpleColor];
    bt2.yzk_responseEdge2 = UIEdgeInsetsMake(-10, -50, -10, -50);
    [bt2 setTitle:@"button" forState:UIControlStateNormal];
    [bt2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:bt2];
}

- (void)btn1Click {
    NSLog(@"button 1");
}

- (void)btn2Click {
    NSLog(@"button 2");
}

@end
