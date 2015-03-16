//
//  tasbeehSettings.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "tasbeehSettings.h"
#import "AppDelegate.h"

@interface tasbeehSettings ()

@end

@implementation tasbeehSettings
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
    self.soundView.hidden=YES;
    self.soundView.layer.cornerRadius=4;
    self.soundView.clipsToBounds=YES;
    a=0;
    self.counterValue.keyboardType=UIKeyboardTypeNumberPad;
    UIImage *buttonImage = [UIImage imageNamed:@"Dashboard.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 67, 32);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *counter=_counterValue.text;
    counterValue=[counter intValue];
    if ([_counterValue isFirstResponder]) {
        [_counterValue resignFirstResponder];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

- (IBAction)playSound
{
    [self.sound setImage:[UIImage imageNamed:@"on.png"]];
    [self.vibImage setImage:[UIImage imageNamed:@"off.png"]];
    [self.bothImage setImage:[UIImage imageNamed:@"off.png"]];
    CATransition *transition1 = [CATransition animation];
    transition1.duration = 1.5;
    transition1.type=kCATransitionPush;
    transition1.subtype=kCATransitionFromTop;
    [self.soundView.layer addAnimation:transition1 forKey:nil];
    self.soundView.hidden=NO;
    [UIView commitAnimations];
    sound=1;
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES ];
}

- (IBAction)vibration
{
    [self.sound setImage:[UIImage imageNamed:@"off.png"]];
    [self.vibImage setImage:[UIImage imageNamed:@"on.png"]];
    [self.bothImage setImage:[UIImage imageNamed:@"off.png"]];
    CATransition *transition1 = [CATransition animation];
    transition1.duration = 1.5;
    transition1.type=kCATransitionPush;
    transition1.subtype=kCATransitionFromBottom;
    [self.soundView.layer addAnimation:transition1 forKey:nil];
    self.soundView.hidden=YES;
    [UIView commitAnimations];
    sound=2;
    a=2;
}

- (IBAction)both
{
    [self.sound setImage:[UIImage imageNamed:@"off.png"]];
    [self.vibImage setImage:[UIImage imageNamed:@"off.png"]];
    [self.bothImage setImage:[UIImage imageNamed:@"on.png"]];
    CATransition *transition1 = [CATransition animation];
    transition1.duration = 1.5;
    transition1.type=kCATransitionPush;
    transition1.subtype=kCATransitionFromTop;
    [self.soundView.layer addAnimation:transition1 forKey:nil];
    self.soundView.hidden=NO;
    [UIView commitAnimations];
    sound=3;
}

- (IBAction)selectSound
{
    if (a==0) {
        [self.azan setImage:[UIImage imageNamed:@"on.png"]];
        [self.phoneAlert setImage:[UIImage imageNamed:@"off.png"]];
        a=1;
    }
    else if (a==1)
    {
        [self.azan setImage:[UIImage imageNamed:@"off.png"]];
        [self.phoneAlert setImage:[UIImage imageNamed:@"on.png"]];
        a=0;
    }
    [self performSelector:@selector(move) withObject:self afterDelay:0.9];
}

-(void)move
{
    CATransition *transition1 = [CATransition animation];
    transition1.duration = 0.0;
    transition1.type=kCATransitionPush;
    transition1.subtype=kCATransitionFromBottom;
    [self.soundView.layer addAnimation:transition1 forKey:nil];
    self.soundView.hidden=YES;
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *counter=textField.text;
    counterValue=[counter intValue];
    [self.counterValue resignFirstResponder];
    return YES;
}

@end
