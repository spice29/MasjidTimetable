//
//  InstructionDetailView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "InstructionDetailView.h"
#import "AppDelegate.h"

@interface InstructionDetailView ()

@end

@implementation InstructionDetailView

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
   
    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"      Masjid List" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/2, buttonImage.size.height/2-3);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    UIImage *buttonImage1 = [UIImage imageNamed:@"reload.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button1 setTitle:@"Dashboard" forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button1.frame = CGRectMake(0, 0, buttonImage1.size.width/2, buttonImage1.size.height/2);
    [button1 addTarget:self action:@selector(showDashBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = customBarItem1;
    self.heading.textColor=[UIColor colorWithRed:121.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.detailtext.textColor=[UIColor colorWithRed:92.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    self.heading.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"title"];
    self.detailtext.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"detail"];
    self.detailtext.editable=NO;
    self.detailView.layer.cornerRadius=7.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    }
    else
    {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showDashBoard
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end