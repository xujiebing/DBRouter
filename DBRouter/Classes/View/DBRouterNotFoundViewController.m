//
//  DBRouterNotFoundViewController.m
//  DBRouter
//
//  Created by 徐结兵 on 2019/8/29.
//

#import "DBRouterNotFoundViewController.h"

@interface DBRouterNotFoundViewController ()

@end

@implementation DBRouterNotFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"页面丢失了";
    self.view.backgroundColor = [UIColor whiteColor];
    [self p_initView];
}

- (void)p_initView {
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] pathForResource:@"DBRouter" ofType:@"bundle"], @"router_404"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"页面丢失了～";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, [UIScreen mainScreen].bounds.size.width, 40);
    [self.view addSubview:label];
}

@end
