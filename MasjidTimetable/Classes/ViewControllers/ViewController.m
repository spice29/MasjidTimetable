//
//  ViewController.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "MasjidListView.h"
#import "AsmaulHusanaView.h"
#import "learningCentreViewViewController.h"
#import "InstructionView.h"
#import "alarmView.h"
#import "TimeTableView.h"
#import "ScrollViewWithPaging.h"
#import "tabBar.h"
#import "tasbeehViewController.h"
#import "JammatNotificationsView.h"
#import "ThemeViewController.h"
#import "NearestMasjidView.h"
#import "tasbeehSettings.h"
#import "TestingView.h"

@interface ViewController ()

@end

@implementation ViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.settingLabel.textColor=[UIColor colorWithRed:171.0/255.0 green:244.0/255.0 blue:43.0/255.0 alpha:1.0];
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    if (IS_IPHONE_5) {
        [self.selectmasjidImage setFrame:CGRectMake(self.selectmasjidImage.frame.origin.x, self.selectmasjidImage.frame.origin.y + 15, self.selectmasjidImage.frame.size.width, self.selectmasjidImage.frame.size.width)];
        [self.nearestMasjidImage setFrame:CGRectMake(self.nearestMasjidImage.frame.origin.x, self.nearestMasjidImage.frame.origin.y + 15, self.nearestMasjidImage.frame.size.width, self.nearestMasjidImage.frame.size.width)];
        [self.tasbeehImage setFrame:CGRectMake(self.tasbeehImage.frame.origin.x, self.tasbeehImage.frame.origin.y + 15, self.tasbeehImage.frame.size.width, self.tasbeehImage.frame.size.width)];
        [self.wakeupImage setFrame:CGRectMake(self.wakeupImage.frame.origin.x, self.wakeupImage.frame.origin.y + 8, self.wakeupImage.frame.size.width, self.wakeupImage.frame.size.width)];
        [self.learningCentreImage setFrame:CGRectMake(self.learningCentreImage.frame.origin.x, self.learningCentreImage.frame.origin.y + 8, self.learningCentreImage.frame.size.width, self.learningCentreImage.frame.size.width)];
        [self.allahNameImage setFrame:CGRectMake(self.allahNameImage.frame.origin.x, self.allahNameImage.frame.origin.y + 8, self.allahNameImage.frame.size.width, self.allahNameImage.frame.size.width)];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _settingLabel.font =[UIFont systemFontOfSize:16.0f];
        if([UIScreen mainScreen].bounds.size.height ==736)
        {
            self.dashboard.font=[UIFont systemFontOfSize:30];
        } else if([UIScreen mainScreen].bounds.size.height>=650) {
            self.dashboard.font=[UIFont systemFontOfSize:25];
        } else if([UIScreen mainScreen].bounds.size.height>480) {
            self.frontView.frame=CGRectMake(self.frontView.frame.origin.x,181,self.frontView.frame.size.width,293);
            self.selectmasjid.frame=CGRectMake(self.selectmasjid.frame.origin.x,192,90,80);
            self.nearest.frame=CGRectMake(self.nearest.frame.origin.x,192,90, 80);
            self.tasbeeh.frame=CGRectMake(self.tasbeeh.frame.origin.x,192,90, 80);
            self.wakeup.frame=CGRectMake(self.wakeup.frame.origin.x,286,90,80);
            self.learning.frame=CGRectMake(self.learning.frame.origin.x,286,90,80);
            self.alah.frame=CGRectMake(self.alah.frame.origin.x,286,90,80);
            self.instructions.frame=CGRectMake(self.instructions.frame.origin.x,381,90,80);
            self.themes.frame=CGRectMake(self.themes.frame.origin.x,381,90,80);
            self.sponsor.frame=CGRectMake(self.sponsor.frame.origin.x,381,90,80);
        }
    } else {
        self.dashboard.font = [UIFont systemFontOfSize:35];
    }
    xts=1;
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfIDs1 = [userDefaults1 objectForKey:@"idValues"];
    NSArray *arrayOfpriorities1 = [userDefaults1 objectForKey:@"priorityValues"];
    addids=[NSMutableArray arrayWithArray:arrayOfIDs1];
    addpri=[NSMutableArray arrayWithArray:arrayOfpriorities1];
    if (addids.count==0) {
    } else {
        globalMasjidID=[addids objectAtIndex:0];
    }
    [super viewWillAppear:animated];
}

- (IBAction)clickToSelectMasjid
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=NO;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move1) withObject:self afterDelay:1.0];
}

-(void)move1
{
    MasjidListView *masjidView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectMasjid"];
    [self.navigationController pushViewController:masjidView animated:YES];
}

- (IBAction)clickToNearestMasjid
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=NO;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(moveToNearest) withObject:self afterDelay:0.0];
}

-(void)moveToNearest
{
    NearestMasjidView *masjidView = [self.storyboard instantiateViewControllerWithIdentifier:@"nearestMasjid"];
    [self.navigationController pushViewController:masjidView animated:YES];
}

- (IBAction)clickToTasbeeh
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=NO;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(movetoTasbeeh) withObject:self afterDelay:0.0];
}

-(void)movetoTasbeeh
{
    tasbeehViewController *View = [self.storyboard instantiateViewControllerWithIdentifier:@"tasbeeh"];
    [self.navigationController pushViewController:View animated:YES];
}

- (IBAction)clickToWakeUp
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=NO;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move4) withObject:self afterDelay:0.0];
}

-(void)move4
{
    alarmView *alarmView = [self.storyboard instantiateViewControllerWithIdentifier:@"alarm"];
    [self.navigationController pushViewController:alarmView animated:YES];
}

- (IBAction)clickTolearningCentre
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=NO;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move5) withObject:self afterDelay:0.0];
}

-(void)move5
{
    learningCentreViewViewController *lcView = [self.storyboard instantiateViewControllerWithIdentifier:@"learningCentre"];
    [self.navigationController pushViewController:lcView animated:YES];
}

- (IBAction)clickToGetInstructions
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=NO;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move7) withObject:self afterDelay:0.0];
}

-(void)move7
{
    InstructionView *instView = [self.storyboard instantiateViewControllerWithIdentifier:@"instructions"];
    [self.navigationController pushViewController:instView animated:YES];
}

- (IBAction)clickToGetAllahNames
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=NO;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move6) withObject:self afterDelay:0.0];
}

-(void)move6
{
    AsmaulHusanaView *AHView = [self.storyboard instantiateViewControllerWithIdentifier:@"AllahName"];
    [self.navigationController pushViewController:AHView animated:YES];
}

- (IBAction)clickToGoToSettings
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=NO;
    [self performSelector:@selector(move10) withObject:self afterDelay:0.0];
}

-(void)move10
{
    tabBar *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    [self.navigationController pushViewController:jView animated:YES];
}

- (IBAction)timeTableAction
{
    self.timetableImage.hidden=NO;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move) withObject:self afterDelay:1.2];
}

-(void)move
{
    TimeTableView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"timeTable"];
    [self.navigationController pushViewController:ttView animated:YES];
}

- (IBAction)themeBtnClickd
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=NO;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move8) withObject:self afterDelay:0.6];
}

-(void)move8
{
    ThemeViewController *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"themeView"];
    [self.navigationController pushViewController:ttView animated:YES];
}

- (IBAction)sponsorClickd
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=NO;
    self.settingsImage.hidden=YES;
}

@end
