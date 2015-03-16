//
//  tasbeehViewController.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "tasbeehViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "tasbeehSettings.h"
#import "tabBar.h"
#import "AppDelegate.h"

@interface tasbeehViewController ()

@end

@implementation tasbeehViewController
{
    MDRadialProgressView *radialView;
    int counter;
    AVAudioPlayer *audioPlayer;
}
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

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
    MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    view.center = CGPointMake(self.view.center.x + 80, view.center.y);
    return view;
}

- (UILabel *)labelAtY:(CGFloat)y andText:(NSString *)text
{
    CGRect frame = CGRectMake(5, y, 180, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:14];
    return label;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
         [self.ringerImage setImage:[UIImage imageNamed:@"Yellow_Circle.png"]];
         radialView.theme.completedColor=[UIColor redColor];
    }
    else
    {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
        [self.ringerImage setImage:[UIImage imageNamed:@"whiteCircle.png"]];
         radialView.theme.completedColor=[UIColor redColor];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    counter=0;
    self.title=@"Tasbeeh";
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    UIImage *buttonImage1 = [UIImage imageNamed:@"reload.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button1 setTitle:@"Reset" forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button1.frame = CGRectMake(0, 0, buttonImage1.size.width/2, buttonImage1.size.height/2);
    [button1 addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = customBarItem1;
    UISwipeGestureRecognizer *settingSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToSettings)];
    [settingSwipe setNumberOfTouchesRequired:2];
    [settingSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:settingSwipe];
    UISwipeGestureRecognizer *settingSwipe2=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToSettings)];
    [settingSwipe2 setNumberOfTouchesRequired:2];
    [settingSwipe2 setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:settingSwipe2];
    
    CGRect frame = CGRectMake(63, 145, 189.6, 189.6);
    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    radialView.progressTotal = counterValue;
    radialView.label.hidden=YES;
    radialView.theme.incompletedColor =[UIColor clearColor];
    radialView.theme.thickness=45;
    radialView.theme.completedColor=[UIColor redColor];
    radialView.theme.sliceDividerHidden = YES;
    [self.view addSubview:radialView];
    [self.view bringSubviewToFront:self.counterBtn];
}

-(void)popview
{
}

-(void)reset
{
}

-(void)moveToSettings
{
    tasbeehSettings *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"tasbeehSettings"];
    [self.navigationController pushViewController:jView animated:YES];
}

- (IBAction)btnTapped:(id)sender
{
    radialView.progressTotal = counterValue;
    
    if (radialView.progressTotal==0) {
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select the counter value first in Tasbeeh Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else
    {
       if (counter<radialView.progressTotal) {
           counter++;
           [self.counterBtn setTitle:[NSString stringWithFormat:@"%d",counter]forState:UIControlStateNormal];
       
           radialView.progressCounter = counter;
        
           if (counter==radialView.progressTotal && a==1 && sound==3) {
               AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
               NSString *path = [[NSBundle mainBundle]
                              pathForResource:@"azan1" ofType:@"mp3"];
               audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                           [NSURL fileURLWithPath:path] error:NULL];
               [audioPlayer play];
           }
        else if (counter==radialView.progressTotal && a==1 && sound==1) {
            NSString *path = [[NSBundle mainBundle]
                              pathForResource:@"azan1" ofType:@"mp3"];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                           [NSURL fileURLWithPath:path] error:NULL];
            [audioPlayer play];
        }
        else if (counter==radialView.progressTotal && a==0 && sound==3) {
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            NSString *path = [[NSBundle mainBundle]
                              pathForResource:@"ringtone1" ofType:@"mp3"];
            audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                           [NSURL fileURLWithPath:path] error:NULL];
            [audioPlayer play];
        }
        else if (counter==radialView.progressTotal && a==2 && sound==2) {
            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        }
       }
   }
}

- (IBAction)popView
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetCounter
{
    [self.counterBtn setTitle:[NSString stringWithFormat:@"%d",0]forState:UIControlStateNormal];
    radialView.progressCounter = 0.5;
    counter=0;
}

@end
