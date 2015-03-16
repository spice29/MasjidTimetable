//
//  tabBar.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "tabBar.h"
#import "TimeTableView.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface tabBar ()

@end

@implementation tabBar

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Settings";
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"Dashboard.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 67, 32);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    UIImage *buttonImage1 = [UIImage imageNamed:@"reload1.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button1 setTitle:@"Timetable" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button1.frame = CGRectMake(0, 0,52,32);
    [button1 addTarget:self action:@selector(timeTable) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = customBarItem1;
    UIImage* tabBarBackground = [UIImage imageNamed:@"tab.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIViewController *vc1 = self.viewControllers[0];
    UIViewController *vc2 = self.viewControllers[1];
    UIViewController *vc3 = self.viewControllers[2];
    UIViewController *vc4 = self.viewControllers[3];

    if (IS_IPHONE_4 || IS_IPHONE_5) {
        [vc1.tabBarItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:8]} forState:UIControlStateNormal];
        [vc2.tabBarItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:8]} forState:UIControlStateNormal];
        [vc3.tabBarItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:8]} forState:UIControlStateNormal];
        [vc4.tabBarItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:8]} forState:UIControlStateNormal];
    }
}

-(void)timeTable
{
    TimeTableView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"timeTable"];
    [self.navigationController pushViewController:ttView animated:YES];
    xts=0;
}

-(void)popview
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
}

@end
