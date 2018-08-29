//
//  AppDelegate.h
//  IndoorMap
//
//  Created by 罗吕根 on 2018/8/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController () <UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)setupButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(self.view.bounds.size.width / 2 - 100, self.view.bounds.size.height / 2 - 25, 200, 50);
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 15;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 2;
    [button setTintColor:[UIColor blackColor]];
    [button setTitle:@"前往室内图" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPrint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)buttonPrint
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.edgesForExtendedLayout = UIRectEdgeBottom;
    [self.navigationController pushViewController:webViewController animated:NO];
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    [self setupButton];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isshow = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isshow animated:YES];
}


@end
