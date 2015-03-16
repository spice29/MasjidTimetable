//
//  AsmaulHusanaView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "AsmaulHusanaView.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
@interface AsmaulHusanaView ()

@end

@implementation AsmaulHusanaView
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
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.title=@"Asmaul Husana";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"allahName" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_webView loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)//(cim == nil && cgref == NULL)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    }
    else
    {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
    
    [super viewWillAppear:animated];
}

-(void)popview
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark webView Delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry Unable to load names" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    
    [alert show];
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
