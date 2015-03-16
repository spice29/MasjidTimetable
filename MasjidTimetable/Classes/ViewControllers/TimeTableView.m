//
//  TimeTableView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "TimeTableLandscapeViewController.h"
#import "TimeTableView.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "MDRadialProgressLabel.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressView.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MasjidDetailTableCell.h"
#import "timeTable.h"
#import "ViewController.h"
#import "ScrollViewWithPaging.h"
#import "ramadhanTable.h"
#import "Chameleon.h"
#import "TimeTableContentView.h"
#import "Masjid.h"
#import "ramadhanTimeTableCell.h"
#import "TimeTableFormat.h"
#import "NotesCell.h"
#import "TimetableMidleInfoTableView.h"

#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface TimeTableView ()
{
    int eventsCount,alertHours,alertMinutes;
    NSString *landscapeDate,*subString11,*subString12;
    MDRadialProgressView *radialView;
    MDRadialProgressView *radialView1;
    NSString *monthStringVal1;
    int meterVal;
    NSMutableAttributedString *attributedString;
    int checkPhn;
    NSString *thirdKey,*thirdValue;
    int getlocalData1;
    int monthValue, swipeCount;
    int keyValue,indexGet;
    int tDay,tMonth,tYear;
    NSInteger month,month1,get,year;
    NSString *paypal;
    int a,pValue,k,seconds;
    float alertTime;
    UIAlertView *alertbox;
    NSInteger anIndex;
    int pageNumber;
    NSUserDefaults *userDefaults;
    NSString *time,*time1,*alertTimeValue,*jamaatHours,*jamaatMinutes;
    UIImageView *image;
    NSString *mas_id;
    NSString *shortWeekDay;
    NSString *frstPrayerText;
    NSString *secondPrayerText,*donationAmnt;
    NSString *dateString1,*alertdate;
    NSString *dateString;
    float frstMeterValue,secondMeterValue;
    NSInteger count,timetableDay,timetableYear,timeTableMonth1;
    NSInteger currentMonthForTimeTable,setMonth;
    int meterGour,meterMin,meterSeconds;
    int minutes,minutes1,hours;
    int mins,mins1;
    int meterValue,totalTime;
    BOOL isTimeFormat24;
    BOOL isBackFromLandScape;
    BOOL isEventNotStart;
    NSString *comingEventTime;
    MPMusicPlayerController *musicPlayer;
    Masjid *currentmMsjid;
    Masjid *masjid1;
    Masjid *masjid2;
    Masjid *masjid3;
    Masjid *masjid4;
    TimeTableContentView *currentView;
    TimeTableContentView *firstView;
    TimeTableContentView *secondView;
    TimeTableContentView *thirdView;
    TimeTableContentView *fourtyView;
    NSArray *page1Events;
    NSArray *page2Events;
    NSArray *page3Events;
    NSArray *page4Events;
    NSArray *page1Donations;
    NSArray *page2Donations;
    NSArray *page3Donations;
    NSArray *page4Donations;
    NSArray *page1Notes;
    NSArray *page2Notes;
    NSArray *page3Notes;
    NSArray *page4Notes;
    NSArray *page1Ramadhans;
    NSArray *page2Ramadhans;
    NSArray *page3Ramadhans;
    NSArray *page4Ramadhans;
    MasjidTimetable *page1TimeTable;
    MasjidTimetable *page2TimeTable;
    MasjidTimetable *page3TimeTable;
    MasjidTimetable *page4TimeTable;
    TimeTableFormat *currentTimeFormat;
    TimeTableFormat *page1TimeTableFormat;
    TimeTableFormat *page2TimeTableFormat;
    TimeTableFormat *page3TimeTableFormat;
    TimeTableFormat *page4TimeTableFormat;
    NSInteger setedPageCount;
}

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation TimeTableView

static NSArray *__pageControlColorList = nil;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isTimeFormat24 = [[[NSUserDefaults standardUserDefaults] valueForKey:@"format12"] boolValue];
    pageNumber = 0;
    [self setScrollViewItems];
    [self setMasjidsInfo];
    [self setCurrenDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPage)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (isBackFromLandScape) {
        [self clearRefreancesForEscapememoryWarningWithBoolValue:NO];
        isBackFromLandScape = NO;
    }
    [self.scrollView setContentOffset:CGPointMake(pageNumber*self.view.frame.size.width, 0)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (isLandscape) {
        [self clearRefreancesForEscapememoryWarningWithBoolValue:YES];
        isBackFromLandScape = YES;
        TimeTableLandscapeViewController *landscapeViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"timeTableLanscapeViewController"];
        Masjid *currentMasjid;
        switch (pageNumber) {
            case 0:
                currentMasjid = masjid1;
                break;
            case 1:
                currentMasjid = masjid2;
                break;
            case 2:
                currentMasjid = masjid3;
                break;
            case 3:
                currentMasjid = masjid4;
                break;
        }
        [landscapeViewController setMasjidId:currentMasjid.masjidId];
        [landscapeViewController setMasjidName:currentMasjid.name];
        [self presentViewController:landscapeViewController animated:NO completion:nil];
    }
}

#pragma mark - Actions

- (void)showEvents:(UIButton*)button
{
    button.selected = !button.selected;
    [self getCurrentView];
    
    [currentView.donationBtn setSelected:NO];
    [currentView.ramadhanBtn setSelected:NO];
    [currentView.donationBtn setBackgroundColor:[UIColor clearColor]];
    [currentView.ramadhanBtn setBackgroundColor:[UIColor clearColor]];
    [currentView.midleTableView setTag:0];
    
    if (button.selected) {
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setAlpha:0.7];
        [currentView.midleContentView setHidden:NO];
        [currentView changeMidleViewToRamadhanView:NO];
        [currentView.midleTableView reloadData];
        
        if ([[self getCurrentPageEventsWithIndex:pageNumber] count] == 0 ) {
            [currentView.midleTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [currentView.noDataLabel setHidden:NO];
        } else {
            [currentView.noDataLabel setHidden:YES];
            [currentView.midleTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [currentView.midleTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
    } else {
        [button setBackgroundColor:[UIColor clearColor]];
        [currentView.noDataLabel setHidden:YES];
        [currentView.midleContentView setHidden:YES];
    }
}

- (void)showDonations:(UIButton*)button
{
    button.selected = !button.selected;
    [self getCurrentView];
    
    [currentView.ramadhanBtn setSelected:NO];
    [currentView.ramadhanBtn setBackgroundColor:[UIColor clearColor]];
    [currentView.eventsBtn setSelected:NO];
    [currentView.eventsBtn setBackgroundColor:[UIColor clearColor]];
    [currentView.midleTableView setTag:1];
    if (button.selected) {
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setAlpha:0.7];
        [currentView.midleContentView setHidden:NO];
        [currentView changeMidleViewToRamadhanView:NO];
        [currentView.midleTableView reloadData];
        
        if ([[self getCurrentPageDonationsWithIndex:pageNumber] count] == 0) {
            [currentView.midleTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [currentView.noDataLabel setHidden:NO];
        } else {
            [currentView.noDataLabel setHidden:YES];
            [currentView.midleTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [currentView.midleTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
    } else {
        [currentView.noDataLabel setHidden:YES];
        [button setBackgroundColor:[UIColor clearColor]];
        [currentView.midleContentView setHidden:YES];
    }
}

- (void)showRamadhan:(UIButton*)button
{
    button.selected = !button.selected;
    [self getCurrentView];
    
    [currentView.donationBtn setSelected:NO];
    [currentView.donationBtn setBackgroundColor:[UIColor clearColor]];
    [currentView.eventsBtn setSelected:NO];
    [currentView.eventsBtn setBackgroundColor:[UIColor clearColor]];
    [currentView.midleTableView setTag:2];
    [currentView.midleTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (button.selected) {
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setAlpha:0.7];
        [currentView.midleContentView setHidden:NO];
        [currentView changeMidleViewToRamadhanView:YES];
        [currentView.midleTableView reloadData];
        
        [currentView.noDataLabel setHidden:YES];
        if ([[self getCurrentPageRamadhansWithIndex:pageNumber] count] == 0 ) {
            [currentView.noDataLabel setHidden:NO];
            [currentView.headerView setHidden:YES];
        } else {
            [currentView.noDataLabel setHidden:YES];
        }
    } else {
        [currentView.noDataLabel setHidden:YES];
        [button setBackgroundColor:[UIColor clearColor]];
        [currentView.midleContentView setHidden:YES];
    }
}

-(void)btnprev:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:paypal]];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popView
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        } else {
            ViewController *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"view"];
            [self.navigationController pushViewController:ttView animated:YES];
            break;
        }
    }
}

- (void)fajarJammatPrayer:(UIButton *)button
{
    button.selected = !button.selected;
    MasjidTimetable *currentTimetable = [self getCurrentTimeTableWithPageNumber:pageNumber];
    if (!button.selected) {
        [Appdelegate changeNotificationSound:YES withNotificationId:@"fajarJ"];
    } else {
        [Appdelegate changeNotificationSound:NO withNotificationId:@"fajarJ"];
    }
    currentTimetable.fajarSoundOff = button.isSelected;
    [[MTDBHelper sharedDBHelper]  saveContext];
}

- (void)zoharJammatPrayer:(UIButton *)button
{
    button.selected = !button.selected;
    MasjidTimetable *currentTimetable = [self getCurrentTimeTableWithPageNumber:pageNumber];
    if (!button.selected) {
        
        [Appdelegate changeNotificationSound:YES withNotificationId:@"zoharJ"];
    } else {
        
        [Appdelegate changeNotificationSound:NO withNotificationId:@"zoharJ"];
    }
    currentTimetable.zoharSoundOff = button.isSelected;
    [[MTDBHelper sharedDBHelper]  saveContext];
}

- (void)asarJammatPrayer:(UIButton *)button
{
    button.selected = !button.selected;
    MasjidTimetable *currentTimetable = [self getCurrentTimeTableWithPageNumber:pageNumber];
    if (!button.selected) {
        [Appdelegate changeNotificationSound:YES withNotificationId:@"asarJ"];
    } else {
        [self getCurrentView];
        k=7;
        [Appdelegate changeNotificationSound:NO withNotificationId:@"asarJ"];
    }
    currentTimetable.asarSoundOff = button.isSelected;
    [[MTDBHelper sharedDBHelper]  saveContext];
}

- (void)maghribjammatprayer:(UIButton *)button
{
    button.selected = !button.selected;
    MasjidTimetable *currentTimetable = [self getCurrentTimeTableWithPageNumber:pageNumber];
    if (!button.selected) {
        [Appdelegate changeNotificationSound:YES withNotificationId:@"maghribJ"];
    } else {
        [Appdelegate changeNotificationSound:NO withNotificationId:@"maghribJ"];
    }
    currentTimetable.maghribSoundOff = button.isSelected;
    [[MTDBHelper sharedDBHelper]  saveContext];
}

- (void)eshajammatprayer:(UIButton *)button
{
    button.selected = !button.selected;
    MasjidTimetable *currentTimetable = [self getCurrentTimeTableWithPageNumber:pageNumber];
    if (!button.selected) {
        [Appdelegate changeNotificationSound:YES withNotificationId:@"eshaJ"];
    } else {
        [Appdelegate changeNotificationSound:NO withNotificationId:@"eshaJ"];
    }
    currentTimetable.eshaSoundOff = button.isSelected;
    [[MTDBHelper sharedDBHelper]  saveContext];
}

- (void)zoharAction:(UIButton *)sender {
    NSLog(@"alert array values %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"zoharB"]);
    NSLog(@"zohar begin %@",zoharBegin);
    zoharBegin=@"13:10";
    zoharBegin = [zoharBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
    if ([[userDefaults valueForKey:@"zoharB"]isEqualToString:@"1"]) {
        [self cancelAlarm];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"zoharB"];
    } else {
        prayerID=@"1";
        k=1;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"zoharB"];
    }
}

- (void)asarAction:(UIButton *)sender {
    NSLog(@"asar begin %@",asarBegin);
    asarBegin=@"13:10";
    asarBegin = [asarBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
    if ([[userDefaults valueForKey:@"asarB"]isEqualToString:@"1"]) {
        [self cancelAlarm];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"asarB"];
    } else {
        prayerID=@"2";
        k=2;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"asarB"];
    }
}

- (void)maghribAction:(UIButton *)sender {
    maghribBegin=@"13:10";
    maghribBegin = [maghribBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
    if ([[userDefaults valueForKey:@"maghribB"]isEqualToString:@"1"]) {
        [self cancelAlarm];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"maghribB"];
    } else {
        prayerID=@"3";
        k=3;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:maghribFormat]; // write zohar begin time here in place of string
        int interval=[maghribPrayer intValue];
        NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*60];
        NSString *chekDate =[formatter stringFromDate:newDate];
        NSLog(@"get new date %@",chekDate);
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"maghribB"];
    }
}

- (void)eshaAction:(UIButton *)sender
{
    NSLog(@"zohar begin %@",eshaBegin);
    eshaBegin=@"13:10";
    eshaBegin = [eshaBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
    if ([[userDefaults valueForKey:@"eshaB"]isEqualToString:@"1"]) {
        [self cancelAlarm];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"eshaB"];
        NSLog(@"alert got off");
    } else {
        prayerID=@"4";
        k=4;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:eshaFormat]; // write zohar begin time here in place of string
        int interval=[eshaPrayer intValue];
        NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*60];
        NSString *chekDate =[formatter stringFromDate:newDate];
        NSLog(@"get new date %@",chekDate);
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"eshaB"];
    }
}

#pragma mark - Custom methods

- (void)setScrollViewItems
{
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 4, self.scrollView.frame.size.height)];
    [self.scrollView setPagingEnabled:YES];
    firstView = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableContainerView" owner:nil options:nil] lastObject];
    secondView = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableContainerView" owner:nil options:nil] lastObject];
    thirdView = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableContainerView" owner:nil options:nil] lastObject];
    fourtyView = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableContainerView" owner:nil options:nil] lastObject];
    
    [firstView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [secondView setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [thirdView setFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [fourtyView setFrame:CGRectMake(self.view.frame.size.width*3, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if (IS_IPAD) {
        firstView.timeMeterImage.frame = CGRectMake(24,46.8,275,200);
        secondView.timeMeterImage.frame = CGRectMake(24,46.8,275,200);
        thirdView.timeMeterImage.frame = CGRectMake(24,46.8,275,200);
        fourtyView.timeMeterImage.frame = CGRectMake(24,46.8,275,200);
    }
    
    [firstView.notesTableView setDelegate:self];
    [firstView.notesTableView setDataSource:self];
    firstView.midleTableView.pageNumber = 0;
    firstView.notesTableView.pageNumber = 0;
    firstView.notesTableView.tag = 4;
    
    [secondView.notesTableView setDelegate:self];
    [secondView.notesTableView setDataSource:self];
    secondView.midleTableView.pageNumber = 1;
    secondView.notesTableView.pageNumber = 1;
    secondView.notesTableView.tag = 4;
    
    
    [thirdView.notesTableView setDataSource:self];
    [thirdView.notesTableView setDelegate:self];
    thirdView.midleTableView.pageNumber = 2;
    thirdView.notesTableView.pageNumber = 2;
    thirdView.notesTableView.tag = 4;
    
    [fourtyView.notesTableView setDelegate:self];
    [fourtyView.notesTableView setDataSource:self];
    fourtyView.midleTableView.pageNumber = 3;
    fourtyView.notesTableView.pageNumber = 3;
    fourtyView.notesTableView.tag = 4;
    
    [firstView.eventsBtn addTarget:self action:@selector(showEvents:) forControlEvents:UIControlEventTouchUpInside];
    [firstView.donationBtn addTarget:self action:@selector(showDonations:) forControlEvents:UIControlEventTouchUpInside];
    [firstView.ramadhanBtn addTarget:self action:@selector(showRamadhan:) forControlEvents:UIControlEventTouchUpInside];
    
    [secondView.eventsBtn addTarget:self action:@selector(showEvents:) forControlEvents:UIControlEventTouchUpInside];
    [secondView.donationBtn addTarget:self action:@selector(showDonations:) forControlEvents:UIControlEventTouchUpInside];
    [secondView.ramadhanBtn addTarget:self action:@selector(showRamadhan:) forControlEvents:UIControlEventTouchUpInside];
    
    [thirdView.eventsBtn addTarget:self action:@selector(showEvents:) forControlEvents:UIControlEventTouchUpInside];
    [thirdView.donationBtn addTarget:self action:@selector(showDonations:) forControlEvents:UIControlEventTouchUpInside];
    [thirdView.ramadhanBtn addTarget:self action:@selector(showRamadhan:) forControlEvents:UIControlEventTouchUpInside];
    
    [fourtyView.eventsBtn addTarget:self action:@selector(showEvents:) forControlEvents:UIControlEventTouchUpInside];
    [fourtyView.donationBtn addTarget:self action:@selector(showDonations:) forControlEvents:UIControlEventTouchUpInside];
    [fourtyView.ramadhanBtn addTarget:self action:@selector(showRamadhan:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:firstView];
    [self.scrollView addSubview:secondView];
    [self.scrollView addSubview:thirdView];
    [self.scrollView addSubview:fourtyView];
}

- (void)setMasjidsInfo
{
    masjid1 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
    masjid2 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"2"];
    masjid3 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"3"];
    masjid4 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"4"];
    setedPageCount = 1;
    if (masjid1) {
        globalMasjidID = [NSString stringWithFormat:@"%i", masjid1.masjidId];
        page1Events = [[MTDBHelper sharedDBHelper] getEvents:masjid1.masjidId];
        page1Donations = [[MTDBHelper sharedDBHelper] getDonations:masjid1.masjidId];
        page1Notes = [[MTDBHelper sharedDBHelper] getNotes:masjid1.masjidId];
        page1Ramadhans = [[MTDBHelper sharedDBHelper] getRamadhansWithMashjidID:masjid1.masjidId];
        page1TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid1.masjidId forDate:[self today]];
        page1TimeTableFormat = [[MTDBHelper sharedDBHelper]  getCurrentMontTimeTableFormat:masjid1.masjidId];
        currentTimeFormat = page1TimeTableFormat;
        [self setMidleViewInfoWithPageNumber:0];
        if (page1TimeTable) {
            [firstView.fajarVolumeBtn addTarget:self action:@selector(fajarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [firstView.zoharVolumeBtn addTarget:self action:@selector(zoharJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [firstView.asarVolumeBtn addTarget:self action:@selector(asarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [firstView.maghribVolumeBtn addTarget:self action:@selector(maghribjammatprayer:) forControlEvents:UIControlEventTouchUpInside];
            [firstView.eshaVolumeBtn addTarget:self action:@selector(eshajammatprayer:) forControlEvents:UIControlEventTouchUpInside];
            [self getTime];
            [self createRadial];
        }
    }
    if (masjid2) {
        page2Events = [[MTDBHelper sharedDBHelper] getEvents:masjid2.masjidId];
        page2Donations = [[MTDBHelper sharedDBHelper] getDonations:masjid2.masjidId];
        page2Notes = [[MTDBHelper sharedDBHelper] getNotes:masjid2.masjidId];
        page2Ramadhans = [[MTDBHelper sharedDBHelper] getRamadhansWithMashjidID:masjid2.masjidId];
        page2TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid2.masjidId forDate:[self today]];
        page2TimeTableFormat = [[MTDBHelper sharedDBHelper]  getCurrentMontTimeTableFormat:masjid2.masjidId];
        if (page2TimeTable) {
            [secondView.fajarVolumeBtn addTarget:self action:@selector(fajarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [secondView.zoharVolumeBtn addTarget:self action:@selector(zoharJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [secondView.asarVolumeBtn addTarget:self action:@selector(asarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [secondView.maghribVolumeBtn addTarget:self action:@selector(maghribjammatprayer:) forControlEvents:UIControlEventTouchUpInside];
            [secondView.eshaVolumeBtn addTarget:self action:@selector(eshajammatprayer:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self setMidleViewInfoWithPageNumber:1];
    }
    
    if (masjid3) {
        page3Events = [[MTDBHelper sharedDBHelper] getEvents:masjid3.masjidId];
        page3Donations = [[MTDBHelper sharedDBHelper] getDonations:masjid3.masjidId];
        page3Notes = [[MTDBHelper sharedDBHelper] getNotes:masjid3.masjidId];
        page3Ramadhans = [[MTDBHelper sharedDBHelper] getRamadhansWithMashjidID:masjid3.masjidId];
        page3TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid3.masjidId forDate:[self today]];
        page3TimeTableFormat = [[MTDBHelper sharedDBHelper]  getCurrentMontTimeTableFormat:masjid3.masjidId];
        if (page3TimeTable) {
            [thirdView.fajarVolumeBtn addTarget:self action:@selector(fajarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [thirdView.zoharVolumeBtn addTarget:self action:@selector(zoharJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [thirdView.asarVolumeBtn addTarget:self action:@selector(asarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [thirdView.maghribVolumeBtn addTarget:self action:@selector(maghribjammatprayer:) forControlEvents:UIControlEventTouchUpInside];
            [thirdView.eshaVolumeBtn addTarget:self action:@selector(eshajammatprayer:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self setMidleViewInfoWithPageNumber:2];
        
    }
    if (masjid4) {
        page4Events = [[MTDBHelper sharedDBHelper] getEvents:masjid4.masjidId];
        page4Donations = [[MTDBHelper sharedDBHelper] getDonations:masjid4.masjidId];
        page4Notes = [[MTDBHelper sharedDBHelper] getNotes:masjid4.masjidId];
        page4Ramadhans = [[MTDBHelper sharedDBHelper] getRamadhansWithMashjidID:masjid4.masjidId];
        page4TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid4.masjidId forDate:[self today]];
        page4TimeTableFormat = [[MTDBHelper sharedDBHelper]  getCurrentMontTimeTableFormat:masjid4.masjidId];
        if (page4TimeTable) {
            [fourtyView.fajarVolumeBtn addTarget:self action:@selector(fajarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [fourtyView.zoharVolumeBtn addTarget:self action:@selector(zoharJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [fourtyView.asarVolumeBtn addTarget:self action:@selector(asarJammatPrayer:) forControlEvents:UIControlEventTouchUpInside];
            [fourtyView.maghribVolumeBtn addTarget:self action:@selector(maghribjammatprayer:) forControlEvents:UIControlEventTouchUpInside];
            [fourtyView.eshaVolumeBtn addTarget:self action:@selector(eshajammatprayer:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self setMidleViewInfoWithPageNumber:3];
    }
    
    firstView.dateLabel.text = page1TimeTable ? [page1TimeTable parsedShortDate] : @"";
    secondView.dateLabel.text = page2TimeTable ? [page1TimeTable parsedShortDate] : @"";
    firstView.dateLabel.text = page3TimeTable ? [page3TimeTable parsedShortDate] : @"";
    firstView.dateLabel.text = page4TimeTable ? [page4TimeTable parsedShortDate] : @"";
    
    firstView.masjidnameLabel.text = masjid1 ? masjid1.name : @"";
    secondView.masjidnameLabel.text = masjid2 ? masjid2.name : @"";
    thirdView.masjidnameLabel.text = masjid3 ? masjid3.name : @"";
    fourtyView.masjidnameLabel.text = masjid4 ? masjid4.name : @"";
    firstView.masjidInfoLabel.text = masjid1 ? [NSString stringWithFormat:@"%@, %@\n%@",masjid1.localArea, masjid1.largerArea, masjid1.country] : @"No masjid has been set as a favourite for this position.";
    secondView.masjidInfoLabel.text = masjid2 ? [NSString stringWithFormat:@"%@, %@\n%@",masjid2.localArea, masjid2.largerArea, masjid2.country] : @"No masjid has been set as a favourite for this position.";
    thirdView.masjidInfoLabel.text = masjid3 ? [NSString stringWithFormat:@"%@, %@\n%@",masjid3.localArea, masjid3.largerArea, masjid3.country] : @"No masjid has been set as a favourite for this position.";
    fourtyView.masjidInfoLabel.text = masjid4 ? [NSString stringWithFormat:@"%@, %@\n%@",masjid4.localArea, masjid4.largerArea, masjid4.country] : @"No masjid has been set as a favourite for this position.";
    
    [self clearRefreancesForEscapememoryWarningWithBoolValue:NO];
}

- (void)getCurrentMasjid
{
    switch (pageNumber) {
        case 0:
            currentmMsjid = masjid1;
            break;
        case 1:
            currentmMsjid = masjid2;
            break;
        case 2:
            currentmMsjid = masjid3;
            break;
        case 3:
            currentmMsjid = masjid4;
            break;
    }
    
}

- (void)getCurrentView
{
    switch (pageNumber) {
        case 0:
            currentView = firstView;
            break;
        case 1:
            currentView = secondView;
            break;
        case 2:
            currentView = thirdView;
            break;
        case 3:
            currentView = fourtyView;
            break;
    }
}

- (void)getCurrentViewWithPageNumber:(int)number
{
    switch (number) {
        case 0:
            currentView = firstView;
            break;
        case 1:
            currentView = secondView;
            break;
        case 2:
            currentView = thirdView;
            break;
        case 3:
            currentView = fourtyView;
            break;
    }
}

- (MasjidTimetable*)getCurrentTimeTableWithPageNumber:(int)number
{
    MasjidTimetable *currenTimeTable;
    
    switch (number) {
        case 0:
            currenTimeTable = page1TimeTable;
            break;
        case 1:
            currenTimeTable = page2TimeTable;
            break;
        case 2:
            currenTimeTable = page3TimeTable;
            break;
        case 3:
            currenTimeTable = page4TimeTable;
            break;
    }
    
    return currenTimeTable;
}

- (NSArray*)getCurrentPageDonationsWithIndex:(int)index
{
    NSArray *returnNotes;
    switch (index) {
        case 0:
            returnNotes = page1Donations;
            break;
        case 1:
            returnNotes = page2Donations;
            break;
        case 2:
            returnNotes = page3Donations;
            break;
        case 3:
            returnNotes = page4Donations;
            break;
    }
    return returnNotes;
}

- (NSArray*)getCurrentPageEventsWithIndex:(int)index
{
    NSArray *events;
    switch (index) {
        case 0:
            events = page1Events;
            break;
        case 1:
            events = page2Events;
            break;
        case 2:
            events = page3Events;
            break;
        case 3:
            events = page4Events;
            break;
    }
    return events;
}

- (NSArray*)getCurrentPageNotesWithIndex:(int)index
{
    NSArray *returnNotes;
    switch (index) {
        case 0:
            returnNotes = page1Notes;
            break;
        case 1:
            returnNotes = page2Notes;
            break;
        case 2:
            returnNotes = page3Notes;
            break;
        case 3:
            returnNotes = page4Notes;
            break;
    }
    return returnNotes;
}

- (NSArray*)getCurrentPageRamadhansWithIndex:(int)index
{
    NSArray *returnNotes;
    switch (index) {
        case 0:
            returnNotes = page1Ramadhans;
            break;
        case 1:
            returnNotes = page2Ramadhans;
            break;
        case 2:
            returnNotes = page3Ramadhans;
            break;
        case 3:
            returnNotes = page4Ramadhans;
            break;
    }
    return returnNotes;
}

- (void)getCurrentPageTimeTableFormatWithIndex:(int)Index
{
    switch (Index) {
        case 0:
            currentTimeFormat = page1TimeTableFormat;
            break;
        case 1:
            currentTimeFormat = page2TimeTableFormat;
            break;
        case 2:
            currentTimeFormat = page3TimeTableFormat;
            break;
        case 3:
            currentTimeFormat = page4TimeTableFormat;
            break;
    }
}

-(void)getTime
{
    count = 0;
    frstPrayerText = @"";
    secondPrayerText = @"";
    MasjidTimetable *timeTable = [self getCurrentTimeTableWithPageNumber:pageNumber];
    [self getCurrentPageTimeTableFormatWithIndex:pageNumber];
    
    [self getCurrentView];
    if (timeTable) {
        [self clearcolors];
        
        NSString *redLabelTime, *greenLabelTime;
        
        [self compairCurrentTimeWithTime:timeTable.subahsadiq isAMformat:YES withTimeFormat:currentTimeFormat.format] ;
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Fajar begins in";
                redLabelTime = comingEventTime;
                currentView.fajarLabel.textColor = [UIColor greenColor];
                currentView.fajarTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Fajar begins in";
                currentView.fajarLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.fajar isAMformat:YES withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Fajar Jammat in";
                redLabelTime = comingEventTime;
                currentView.fajarJLabel.textColor = [UIColor greenColor];;
                currentView.fajarTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Fajar Jammat in";
                currentView.fajarJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.sunrise isAMformat:YES withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Sunrise in";
                redLabelTime = comingEventTime;
                currentView.sunriselabel.textColor = [UIColor greenColor];;
                currentView.fajarTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Sunrise in";
                currentView.sunriselabel.textColor = [UIColor yellowColor];
            }
        }
        
        
        BOOL isAM = [timeTable.zohar integerValue] < 12;
        
        [self compairCurrentTimeWithTime:timeTable.zohar isAMformat:isAM withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Zohar begins in";
                redLabelTime = comingEventTime;
                currentView.zoharLabel.textColor = [UIColor greenColor];
                currentView.zoharTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Zohar begins in";
                currentView.zoharLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.zoharj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Zohar Jamaat in";
                redLabelTime = comingEventTime;
                currentView.zoharJlabel.textColor = [UIColor greenColor];
                currentView.zoharTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Zohar Jamaat in";
                currentView.zoharJlabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.asar isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Asar Begins in";
                redLabelTime = comingEventTime;
                currentView.asarlabel.textColor = [UIColor greenColor];
                currentView.asarTitlelabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Asar Begins in";
                currentView.asarlabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.asarj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Asar Jamaat in";
                redLabelTime = comingEventTime;
                currentView.asarJLabel.textColor = [UIColor greenColor];
                currentView.asarTitlelabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Asar Jamaat in";
                currentView.asarJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.sunset isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Maghrib begins in";
                redLabelTime = comingEventTime;
                currentView.maghribLabel.textColor = [UIColor greenColor];
                currentView.maghribTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Maghrib begins in";
                currentView.maghribLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.maghrib isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart){
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Maghrib Jamaat in";
                redLabelTime = comingEventTime;
                currentView.maghribJLabel.textColor = [UIColor greenColor];
                currentView.maghribTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Maghrib Jamaat in";
                currentView.maghribJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.esha isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText =  @"Esha begins in";
                redLabelTime = comingEventTime;
                currentView.eshaLabel.textColor = [UIColor greenColor];
                currentView.eshaTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Esha begins in";
                currentView.eshaLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.eshaj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText =  @"Esha Jammat in";
                redLabelTime = comingEventTime;
                currentView.eshaTitleLabel.textColor = [UIColor greenColor];
                currentView.eshaJLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Esha Jammat in";
                currentView.eshaJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        if ([frstPrayerText length] != 0 && [secondPrayerText length] == 0) {
            secondPrayerText = @"Fajar begins in";
            
            MasjidTimetable *updatedTimeTable = [self getUpdatedTimeTable];
            [self compairCurrentTimeWithTime:updatedTimeTable.subahsadiq isAMformat:YES withTimeFormat:currentTimeFormat.format] ;
            
            greenLabelTime = comingEventTime;
        }
        
        if ([frstPrayerText length] == 0 && [secondPrayerText length] == 0) {
            [self updateCurrentTimeTable];
            frstPrayerText =  @"Fajar begins in";
            secondPrayerText = @"Fajar Jammat in";
            [self compairCurrentTimeWithTime:timeTable.subahsadiq isAMformat:YES withTimeFormat:currentTimeFormat.format] ;
            redLabelTime = comingEventTime;
            [self compairCurrentTimeWithTime:timeTable.fajar isAMformat:YES withTimeFormat:currentTimeFormat.format];
            greenLabelTime = comingEventTime;
        }
        
        [self compairCurrentTimeWithTime:timeTable.eshaj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        [self setTimerValuesWithEndTime:redLabelTime lastEventTime:comingEventTime];
        
        count = 1;
        
        [self setTimerValuesWithEndTime:greenLabelTime lastEventTime:comingEventTime];
        
        [self performSelector:@selector(getTime) withObject:nil afterDelay:20.0];
    }
}

- (void)compairCurrentTimeWithTime:(NSString*)eventStart isAMformat:(BOOL)formatAM withTimeFormat:(int)format
{
    isEventNotStart = NO;
    comingEventTime = @"";
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:locale];
    
    if (format == 12) {
        [date setAMSymbol:@"AM"];
        [date setPMSymbol:@"PM"];
        [date setDateFormat:@"hh:mm a"];
        
        NSString *timeFormat = formatAM ? @" AM" : @" PM";
        eventStart = [eventStart stringByAppendingString:timeFormat];
        NSDate *evenStartDate = [date dateFromString:eventStart];
        [date setDateFormat:@"HH:mm"];
        
        eventStart = [date stringFromDate:evenStartDate];
        dateString = [date stringFromDate:[NSDate date]];
        
        if ([[eventStart stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue] > [[dateString stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue]) {
            isEventNotStart = YES;
        }
        comingEventTime = eventStart;
    } else {
        [date setDateFormat:@"HH:mm"];
        
        dateString = [date stringFromDate:[NSDate date]];
        if ([[eventStart stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue] > [[dateString stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue]) {
            isEventNotStart = YES;
        }
        comingEventTime = eventStart;
    }
}

- (void)setTimerValuesWithEndTime:(NSString*)endDateString lastEventTime:(NSString*)lastEventTime
{
    NSDateFormatter *date = [NSDateFormatter new];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:locale];
    [date setDateFormat:@"HH:mm"];
    
    NSString *currentTime = [date stringFromDate:[NSDate date]];
    
    NSDate *serDate = [date dateFromString:currentTime];
    NSDate *endDate = [date dateFromString:endDateString];
    
    currentTime = [currentTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    lastEventTime = [lastEventTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    endDateString = [endDateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    if ( ([currentTime floatValue] >  [lastEventTime floatValue] || [currentTime floatValue] > [endDateString  floatValue]) && [currentTime floatValue] < 23.60) {
        endDate = [endDate dateByAddingTimeInterval:60*60*24];
    }
    
    if ([currentTime floatValue] == 0.0 && count == 1) {
        [self updateTimeTables];
        [self setCurrenDate];
        [self updateViewsInfoForNewDay];
    }
    
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    meterMin = timeDifference / 60;
    if (meterMin>=60) {
        meterMin=meterMin%60;
    }
    
    meterGour = timeDifference / 3600;
    meterSeconds = timeDifference;
    
    [self setSpeedometerCurrentValue];
}

-(void)clearcolors
{
    [self getCurrentView];
    currentView.maghribLabel.textColor= [UIColor whiteColor];
    currentView.eshaLabel.textColor = [UIColor whiteColor];
    currentView.zoharLabel.textColor = [UIColor whiteColor];
    currentView.zoharJlabel.textColor = [UIColor whiteColor];
    currentView.zoharTitleLabel.textColor = [UIColor whiteColor];
    currentView.fajarLabel.textColor = [UIColor whiteColor];
    currentView.asarTitlelabel.textColor = [UIColor whiteColor];
    currentView.asarlabel.textColor = [UIColor whiteColor];
    currentView.asarJLabel.textColor = [UIColor whiteColor];
    currentView.maghribJLabel.textColor = [UIColor whiteColor];
    currentView.maghribLabel.textColor = [UIColor whiteColor];
    currentView.maghribTitleLabel.textColor = [UIColor whiteColor];
    currentView.eshaJLabel.textColor = [UIColor whiteColor];
    currentView.eshaTitleLabel.textColor = [UIColor whiteColor];
    currentView.fajarJLabel.textColor = [UIColor whiteColor];
    currentView.fajarTitleLabel.textColor = [UIColor whiteColor];
    currentView.zoharLabel.textColor = [UIColor whiteColor];
    currentView.sunriselabel.textColor = [UIColor whiteColor];
}

-(void)createRadial
{
    [self getCurrentView];
    CGRect frame,frame1;
    if (IS_IPAD) {
        frame = CGRectMake(70,57,159,222);
        frame1 = CGRectMake(40,12,215.6,309.6);
        
        radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
        radialView.progressTotal = 120;
        // radialView.progressCounter = 71.5; //min
        radialView.startingSlice = 82; //max
        radialView.label.hidden=YES;
        radialView.clockwise=NO;
        radialView.theme.incompletedColor = [UIColor clearColor];
        radialView.theme.thickness=69;
        radialView.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                              withFrame:radialView.bounds
                                                              andColors:@[[UIColor colorWithRed:111.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0],[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:97.0/255.0 alpha:1.0]]];
        radialView.theme.sliceDividerHidden = YES;
        [currentView.firstViewbackground addSubview:radialView];
        
        radialView1 = [[MDRadialProgressView alloc] initWithFrame:frame1];
        radialView1.progressTotal = 120;
        //radialView1.progressCounter = 40; //min
        radialView1.startingSlice = 82; //max
        radialView1.label.hidden=YES;
        radialView1.clockwise=NO;
        radialView1.theme.incompletedColor = [UIColor clearColor];
        radialView1.theme.thickness=54;
        radialView1.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                               withFrame:radialView1.bounds
                                                               andColors:@[[UIColor colorWithRed:76.0/255.0 green:95.0/255.0 blue:108.0/255.0 alpha:1.0],
                                                                           [UIColor colorWithRed:50.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0]]];
        radialView1.theme.sliceDividerHidden = YES;
        [currentView.firstViewbackground addSubview:radialView1];
    } else {
        if(IS_IPHONE_6P) {
            frame = CGRectMake(30,63,105,118);
            frame1 =CGRectMake(-10,50,189.6,143.6);
            
            radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
            radialView.progressTotal = 120;
            // radialView.progressCounter = 71.5; //min
            radialView.startingSlice = 82; //max
            radialView.label.hidden=YES;
            radialView.clockwise=NO;
            radialView.theme.incompletedColor = [UIColor clearColor];
            radialView.theme.thickness=45;
            radialView.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                  withFrame:radialView.bounds
                                                                  andColors:@[[UIColor colorWithRed:111.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0],[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:97.0/255.0 alpha:1.0]]];
            radialView.theme.sliceDividerHidden = YES;
            [currentView.firstViewbackground addSubview:radialView];
            
            radialView1 = [[MDRadialProgressView alloc] initWithFrame:frame1];
            radialView1.progressTotal = 120;
            //radialView1.progressCounter = 40; //min
            radialView1.startingSlice = 82; //max
            radialView1.label.hidden=YES;
            radialView1.clockwise=NO;
            radialView1.theme.incompletedColor = [UIColor clearColor];
            radialView1.theme.thickness=40;
            radialView1.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                   withFrame:radialView1.bounds
                                                                   andColors:@[[UIColor colorWithRed:76.0/255.0 green:95.0/255.0 blue:108.0/255.0 alpha:1.0],
                                                                               [UIColor colorWithRed:50.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0]]];
            radialView1.theme.sliceDividerHidden = YES;
            [currentView.firstViewbackground addSubview:radialView1];
        } else if(IS_IPHONE_6) {
            frame = CGRectMake(31,71,89.2,85.2);
            frame1 = CGRectMake(1,53.5,150, 122.4);
            
            radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
            radialView.progressTotal = 120;
            // radialView.progressCounter = 71.5; //min
            radialView.startingSlice = 82; //max
            radialView.label.hidden=YES;
            radialView.clockwise=NO;
            radialView.theme.incompletedColor = [UIColor clearColor];
            radialView.theme.thickness=42;
            radialView.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                  withFrame:radialView.bounds
                                                                  andColors:@[[UIColor colorWithRed:111.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0],[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:97.0/255.0 alpha:1.0]]];
            radialView.theme.sliceDividerHidden = YES;
            [currentView.firstViewbackground addSubview:radialView];
            
            radialView1 = [[MDRadialProgressView alloc] initWithFrame:frame1];
            radialView1.progressTotal = 120;
            radialView1.startingSlice = 82; //max
            radialView1.label.hidden=YES;
            radialView1.clockwise=NO;
            radialView1.theme.incompletedColor = [UIColor clearColor];
            radialView1.theme.thickness=35;
            radialView1.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                   withFrame:radialView1.bounds
                                                                   andColors:@[[UIColor colorWithRed:76.0/255.0 green:95.0/255.0 blue:108.0/255.0 alpha:1.0],
                                                                               [UIColor colorWithRed:50.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0]]];
            radialView1.theme.sliceDividerHidden = YES;
            
            [currentView.firstViewbackground addSubview:radialView1];
        } else if(IS_IPHONE_5) {
            frame = CGRectMake(3,55.4,123.8,74.2);
            frame1 = CGRectMake(7,42.7,112,100.4);
            radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
            radialView.progressTotal = 120;
            // radialView.progressCounter = 71.5; //min
            radialView.startingSlice = 82; //max
            radialView.label.hidden=YES;
            radialView.clockwise=NO;
            radialView.theme.incompletedColor = [UIColor clearColor];
            radialView.theme.thickness=32.9;
            radialView.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                  withFrame:radialView.bounds
                                                                  andColors:@[[UIColor colorWithRed:111.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0],[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:97.0/255.0 alpha:1.0]]];
            radialView.theme.sliceDividerHidden = YES;
            [currentView.firstViewbackground addSubview:radialView];
            radialView1 = [[MDRadialProgressView alloc] initWithFrame:frame1];
            radialView1.progressTotal = 120;
            //radialView1.progressCounter = 40; //min
            radialView1.startingSlice = 82; //max
            radialView1.label.hidden=YES;
            radialView1.clockwise=NO;
            radialView1.theme.incompletedColor = [UIColor clearColor];
            radialView1.theme.thickness=30;
            radialView1.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                   withFrame:radialView1.bounds
                                                                   andColors:@[[UIColor colorWithRed:76.0/255.0 green:95.0/255.0 blue:108.0/255.0 alpha:1.0],
                                                                               [UIColor colorWithRed:50.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0]]];
            radialView1.theme.sliceDividerHidden = YES;
            [currentView.firstViewbackground addSubview:radialView1];
            
        } else if(IS_IPHONE_4) {
            frame = CGRectMake(27,31.2,77,94.5);
            frame1 = CGRectMake(2.4,27.5,126,102.9);
            
            radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
            radialView.progressTotal = 120;
            radialView.startingSlice = 82; //max
            radialView.label.hidden=YES;
            radialView.clockwise=NO;
            radialView.theme.incompletedColor = [UIColor clearColor];
            radialView.theme.thickness=37;
            radialView.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                  withFrame:radialView.bounds
                                                                  andColors:@[[UIColor colorWithRed:111.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0],[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:97.0/255.0 alpha:1.0]]];
            radialView.theme.sliceDividerHidden = YES;
            [currentView.firstViewbackground addSubview:radialView];
            
            
            
            radialView1 = [[MDRadialProgressView alloc] initWithFrame:frame1];
            radialView1.progressTotal = 120;
            radialView1.startingSlice = 82; //max
            radialView1.label.hidden=YES;
            radialView1.clockwise=NO;
            radialView1.theme.incompletedColor = [UIColor clearColor]; //
            radialView1.theme.completedColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                                   withFrame:radialView1.bounds
                                                                   andColors:@[[UIColor colorWithRed:76.0/255.0 green:95.0/255.0 blue:108.0/255.0 alpha:1.0],
                                                                               [UIColor colorWithRed:50.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0]]];
            radialView1.theme.sliceDividerHidden = YES;
            [currentView.firstViewbackground addSubview:radialView1];
            radialView1.theme.thickness=28.5;
        }
    }
    [self getMeterValues];
    [self getSecondMeterValues];
}

- (void) setSystemVolumeLevelTo:(float)newVolumeLevel
{
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFramework/Celestial.framework"];
    [b load];
    Class avSystemControllerClass = NSClassFromString(@"AVSystemController");
    id avSystemControllerInstance = [avSystemControllerClass performSelector:@selector(sharedAVSystemController)];
    
    NSString *soundCategory = @"Ringtone";
    
    NSInvocation *volumeInvocation = [NSInvocation invocationWithMethodSignature:
                                      [avSystemControllerClass instanceMethodSignatureForSelector:
                                       @selector(setVolumeTo:forCategory:)]];
    [volumeInvocation setTarget:avSystemControllerInstance];
    [volumeInvocation setSelector:@selector(setVolumeTo:forCategory:)];
    [volumeInvocation setArgument:&newVolumeLevel atIndex:2];
    [volumeInvocation setArgument:&soundCategory atIndex:3];
    [volumeInvocation invoke];
}

- (void)cancelAlarm
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        NSDictionary *userInfo = notification.userInfo;
        if ([prayerID isEqualToString:[userInfo objectForKey:@"buttonTag"]]){
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
        if ([@"99"isEqualToString:[userInfo objectForKey:@"buttonTag"]]){
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

-(void)fireAlarm
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:alertHours];
    [components setMinute:alertMinutes];
    NSDate *next9am = [calendar dateFromComponents:components];
    if ([next9am timeIntervalSinceNow] < 0) {
        next9am = [next9am dateByAddingTimeInterval:60*60*24];
    }
    localNotification.fireDate = next9am;
    localNotification.alertBody = @"Click OK to mute your device";
    localNotification.soundName  = UILocalNotificationDefaultSoundName;
    localNotification.category = @"Alert";
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:prayerID forKey:@"buttonTag"];
    localNotification.userInfo = userInfo;
    localNotification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)fireAlarmToUnmute
{
    prayerID=@"99";
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:[jamaatHours intValue]];
    [components setMinute:[jamaatMinutes intValue]];
    // Gives us today's date but at specified time
    NSDate *next9am = [calendar dateFromComponents:components];
    if ([next9am timeIntervalSinceNow] < 0) {
        // If today's 9am already occurred, add 24hours to get to tomorrow's
        next9am = [next9am dateByAddingTimeInterval:60*60*24];
    }
    localNotification.fireDate = next9am;
    localNotification.alertBody=@"Click OK to unmute your device";
    localNotification.soundName=UILocalNotificationDefaultSoundName;
    localNotification.category=@"AlertOff";
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:prayerID forKey:@"buttonTag"];
    localNotification.userInfo = userInfo;
    // Set a repeat interval to daily
    localNotification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)loadedViewDeclaration
{
    interval= @"30";
    checkPhn = 0;
    
    self.navTimeTable.hidden = YES;
    getlocalData1=0;
    self.navTimeTable.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    self.navDate.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
    count=0;
}

- (NSDate*)today
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSString *todayDateStringWithTimeZone = [dateFormatter stringFromDate:[NSDate date]];
    
    return [dateFormatter dateFromString:todayDateStringWithTimeZone];
}

- (void)setMidleViewInfoWithPageNumber:(int)Number
{
    MasjidTimetable *timeTable = [self getCurrentTimeTableWithPageNumber:Number];
    if (timeTable) {
        [self getCurrentViewWithPageNumber:Number];
        currentView.fajarVolumeBtn.Selected = timeTable.fajarSoundOff ? YES : NO;
        currentView.zoharVolumeBtn.Selected = timeTable.zoharSoundOff ? YES : NO;
        currentView.asarVolumeBtn.Selected = timeTable.asarSoundOff ? YES : NO;
        currentView.maghribVolumeBtn.Selected = timeTable.maghribSoundOff ? YES : NO;
        currentView.eshaVolumeBtn.Selected = timeTable.eshaSoundOff ? YES : NO;
        
        [self getCurrentPageTimeTableFormatWithIndex:Number];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"format12"]) {
            if (isTimeFormat24) {
                NSDateFormatter* df = [[NSDateFormatter alloc] init];
                [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [df setLocale:locale];
                [df setAMSymbol:@"AM"];
                [df setPMSymbol:@"PM"];
                
                NSString *stringAM, *stringPM;
                if (currentTimeFormat.format == 12) {
                    [df setDateFormat:@"hh:mm a"];
                    stringAM = @" AM";
                    stringPM = @" PM";
                } else {
                    [df setDateFormat:@"HH:mm"];
                    stringAM = @"";
                    stringPM = @"";
                }
                
                NSDate* subahsadiqDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.subahsadiq, stringAM]];
                NSDate* fajarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.fajar, stringAM]];
                NSDate* zoharDate ;
                if ([timeTable.zohar integerValue] < 12) {
                    zoharDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zohar, stringAM]];
                } else {
                    zoharDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zohar, stringPM]];
                }
                NSDate* sunriseDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunrise, stringAM]];
                NSDate* zoharjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zoharj, stringPM]];
                NSDate* asarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asar, stringPM]];
                NSDate* asarjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asarj, stringPM]];
                NSDate* sunsetDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunset, stringPM]];
                NSDate* maghribDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.maghrib, stringPM]];
                NSDate* eshaDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.esha, stringPM]];
                NSDate* eshajDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.eshaj, stringPM]];
                [df setDateFormat:@"HH:mm"];
                
                currentView.fajarLabel.text = [df stringFromDate:subahsadiqDate];
                currentView.fajarJLabel.text = [df stringFromDate:fajarDate];
                currentView.zoharLabel.text = [df stringFromDate:zoharDate];
                currentView.zoharJlabel.text = [df stringFromDate:zoharjDate];
                currentView.asarlabel.text = [df stringFromDate:asarDate];
                currentView.asarJLabel.text = [df stringFromDate:asarjDate];
                currentView.maghribLabel.text = [df stringFromDate:sunsetDate];
                currentView.maghribJLabel.text = [df stringFromDate:maghribDate];
                currentView.eshaLabel.text = [df stringFromDate:eshaDate];
                currentView.eshaJLabel.text = [df stringFromDate:eshajDate];
                currentView.sunriselabel.text = [df stringFromDate:sunriseDate];
            } else {
                NSDateFormatter* df = [[NSDateFormatter alloc] init];
                [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [df setLocale:locale];
                [df setAMSymbol:@"AM"];
                [df setPMSymbol:@"PM"];
                NSString *stringAM, *stringPM;
                if (currentTimeFormat.format == 12) {
                    [df setDateFormat:@"hh:mm a"];
                    stringAM = @" AM";
                    stringPM = @" PM";
                } else {
                    [df setDateFormat:@"HH:mm"];
                    stringAM = @"";
                    stringPM = @"";
                }
                
                NSDate* subahsadiqDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.subahsadiq, stringAM]];
                NSDate* fajarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.fajar, stringAM]];
                NSDate* zoharDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zohar, stringAM]];
                NSDate* sunriseDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunrise, stringAM]];
                NSDate* zoharjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zoharj, stringPM]];
                NSDate* asarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asar, stringPM]];
                NSDate* asarjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asarj, stringPM]];
                NSDate* sunsetDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunset, stringPM]];
                NSDate* maghribDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.maghrib, stringPM]];
                NSDate* eshaDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.esha, stringPM]];
                NSDate* eshajDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.eshaj, stringPM]];
                [df setDateFormat:@"h:mm"];
                
                currentView.fajarLabel.text = [df stringFromDate:subahsadiqDate];
                currentView.fajarJLabel.text = [df stringFromDate:fajarDate];
                currentView.zoharLabel.text = [df stringFromDate:zoharDate];
                currentView.sunriselabel.text = [df stringFromDate:sunriseDate];
                currentView.zoharJlabel.text = [df stringFromDate:zoharjDate];
                currentView.asarlabel.text = [df stringFromDate:asarDate];
                currentView.asarJLabel.text = [df stringFromDate:asarjDate];
                currentView.maghribLabel.text = [df stringFromDate:sunsetDate];
                currentView.maghribJLabel.text = [df stringFromDate:maghribDate];
                currentView.eshaLabel.text = [df stringFromDate:eshaDate];
                currentView.eshaJLabel.text = [df stringFromDate:eshajDate];
            }
        } else {
            currentView.fajarLabel.text = timeTable.subahsadiq;
            currentView.fajarJLabel.text = timeTable.fajar;
            currentView.zoharLabel.text = timeTable.zohar;
            currentView.zoharJlabel.text = timeTable.zoharj;
            currentView.asarlabel.text = timeTable.asar;
            currentView.asarJLabel.text = timeTable.asarj;
            currentView.maghribLabel.text = timeTable.sunset;
            currentView.maghribJLabel.text = timeTable.maghrib;
            currentView.eshaLabel.text = timeTable.esha;
            currentView.eshaJLabel.text = timeTable.eshaj;
            currentView.sunriselabel.text = timeTable.sunrise;
        }
    }
}

- (void)clearRefreancesForEscapememoryWarningWithBoolValue:(BOOL)needClear
{
    id value = needClear ? nil : self;
    [self getCurrentView];
    if (needClear) {
        [firstView.midleTableView setDelegate:value];
        [firstView.midleTableView setDataSource:value];
        [firstView.notesTableView setDelegate:value];
        [firstView.notesTableView setDataSource:value];
        
        [secondView.midleTableView setDelegate:value];
        [secondView.midleTableView setDataSource:value];
        [secondView.notesTableView setDelegate:value];
        [secondView.notesTableView setDataSource:value];
        
        [thirdView.midleTableView setDelegate:value];
        [thirdView.midleTableView setDataSource:value];
        [thirdView.notesTableView setDataSource:value];
        [thirdView.notesTableView setDelegate:value];
        
        [fourtyView.midleTableView setDelegate:value];
        [fourtyView.midleTableView setDataSource:value];
        [fourtyView.notesTableView setDelegate:value];
        [fourtyView.notesTableView setDataSource:value];
    } else {
        [currentView.midleTableView setDelegate:value];
        [currentView.midleTableView setDataSource:value];
        [currentView.notesTableView setDelegate:value];
        [currentView.notesTableView setDataSource:value];
    }
}

- (NSString *)getTimeIn24HoursFormat:(NSString*)timeOfEvent withTimeEndSmbyol:(NSString*)simbol
{
    
    NSDateFormatter *date = [NSDateFormatter new];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:locale];
    if (currentTimeFormat.format == 12) {
        [date setAMSymbol:@"AM"];
        [date setPMSymbol:@"PM"];
        [date setDateFormat:@"hh:mm a"];
        
        timeOfEvent = [timeOfEvent stringByAppendingString:simbol];
        NSDate *timeOfEventDate = [date dateFromString:timeOfEvent];
        [date setDateFormat:@"HH:mm"];
        
        timeOfEvent = [date stringFromDate:timeOfEventDate];
    }
    
    return timeOfEvent;
}

- (void)setCurrenDate
{
    NSDateFormatter *istDateFormatter1 = [[NSDateFormatter alloc] init];
    [istDateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    [istDateFormatter1 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [istDateFormatter1 setDateFormat:@"dd MMMM yyyy"];
    NSDate *date = [istDateFormatter1 dateFromString:[istDateFormatter1 stringFromDate:[NSDate date]]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    timetableDay=[components2 day];
    currentMonthForTimeTable = [components2 month];
    timetableYear = [components2 year];
    setMonth=currentMonthForTimeTable+1;
    timeTableMonth1=currentMonthForTimeTable;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"EEE"];
    shortWeekDay= [dateFormatter stringFromDate:[NSDate date]];
    NSInteger weekday = [components weekday];
    NSString *weekdayName = [istDateFormatter1 weekdaySymbols][weekday - 1];
    
    NSString *todayDateString = [NSString stringWithFormat:@"%@, %@",weekdayName,[istDateFormatter1 stringFromDate:[NSDate date]]];
    attributedString = [[NSMutableAttributedString alloc]  initWithString:todayDateString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:100.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0] range:NSMakeRange(0,[todayDateString rangeOfString:@","].location)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0] range:NSMakeRange([todayDateString rangeOfString:@","].location+1,[istDateFormatter1 stringFromDate:[NSDate date]].length+1)];
    
    firstView.dateLabel.text = todayDateString;
    firstView.dateLabel.attributedText = attributedString;
    secondView.dateLabel.text = todayDateString;
    secondView.dateLabel.attributedText = attributedString;
    thirdView.dateLabel.text = todayDateString;
    thirdView.dateLabel.attributedText = attributedString;
    fourtyView.dateLabel.text = todayDateString;
    fourtyView.dateLabel.attributedText = attributedString;
}

- (void)updateCurrentTimeTable
{
    switch (pageNumber) {
        case 0:
            page1TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid1.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
        case 1:
            page2TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid2.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
        case 2:
            page3TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid3.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
        case 3:
            page4TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid4.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
        default:
            break;
    }
}

- (MasjidTimetable *)getUpdatedTimeTable
{
    switch (pageNumber) {
        case 0:
            return (MasjidTimetable*)[[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid1.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
        case 1:
            return (MasjidTimetable*)[[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid2.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
        case 2:
            return (MasjidTimetable*)[[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid3.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
        case 3:
            return (MasjidTimetable*)[[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid4.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)updateTimeTables
{
    page1TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid1.masjidId forDate:[Utils today]];
    page2TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid2.masjidId forDate:[Utils today]];
    page3TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid3.masjidId forDate:[Utils today]];
    page4TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid4.masjidId forDate:[Utils today]];
}

- (void)updateViewsInfoForNewDay
{
    for (int i = 0; i < 4; i++) {
        [self setMidleViewInfoWithPageNumber:i];
    }
}

- (void)reloadPage
{
    [self setScrollViewItems];
    [self setMasjidsInfo];
    [self setCurrenDate];
}

#pragma mark - setSpeedometerCurrentValue

- (void)setSpeedometerCurrentValue
{
    [self getCurrentView];
    if (count==0) {
        NSString *timeText;
        NSString *minutesString = meterMin > 1 ? @"minutes" : @"minute";
        if (meterGour==00) {
            timeText=[NSString stringWithFormat:@"%d %@",meterMin , minutesString];
            currentView.digitalTimeLabel.text=[NSString stringWithFormat:@"%dm",meterMin];
        } else {
            NSString *hoursString = meterGour > 1 ? @"hours" : @"hour";
            timeText = meterMin > 0 ?[NSString stringWithFormat:@"%d %@ %d %@" ,meterGour ,hoursString, meterMin, minutesString] : [NSString stringWithFormat:@"%d %@",meterGour ,hoursString];
            currentView.digitalTimeLabel.text=[NSString stringWithFormat:@"%dh:%dm",meterGour,meterMin];
        }
        meterValue = (meterGour*60) + meterMin;

        currentView.redLabel.text=[NSString stringWithFormat:@"%@ %@",frstPrayerText,timeText];
        currentView.captionLabel.text = @"Remaining";
        [self getMeterValues];
    } else if(count==1) {
        NSString *timeText;
        NSString *minutesString = meterMin > 1 ? @"minutes" : @"minute";
        if (meterGour==00) {
            timeText=[NSString stringWithFormat:@"%d %@",meterMin ,minutesString];
        } else {
            NSString *hoursString =  meterGour > 1 ? @"hours" : @"hour";
            timeText = meterMin > 0 ? [NSString stringWithFormat:@"%d %@ %d %@",meterGour , hoursString, meterMin, minutesString] : [NSString stringWithFormat:@"%d %@",meterGour ,hoursString];
        }
        totalTime = (meterGour*60)+meterMin;
        currentView.greenLabel.text=[NSString stringWithFormat:@"%@ %@",secondPrayerText,timeText];
        [self getSecondMeterValues];
    }
}

-(void)getMeterValues
{
//    if (meterValue<=1) {
//        frstMeterValue=78;
//    } else  if (meterValue>1 && meterValue<=19) {
//        int value=meterValue-1;
//        frstMeterValue=78-0.65*value;
//    } else  if (meterValue>20 && meterValue<=39) {
//        int value=meterValue-20;
//        frstMeterValue=66-0.65*value;
//    } else  if (meterValue>40 && meterValue<=59) {
//        int value=meterValue-40;
//        frstMeterValue=53-0.65*value;
//    } else  if (meterValue>60 && meterValue<=79) {
//        int value=meterValue-60;
//        frstMeterValue=40-0.65*value;
//    } else  if (meterValue>80 && meterValue<=99) {
//        int value=meterValue-80;
//        frstMeterValue=27-0.65*value;
//    } else  if (meterValue>100 && meterValue<=119) {
//        int value=meterValue-100;
//        frstMeterValue=14-0.65*value;
//    } else if (meterValue>=120) {
//        frstMeterValue = 3;
//    } else if (meterValue==20) {
//        frstMeterValue=65;
//    } else if (meterValue==40) {
//        frstMeterValue=52;
//    } else if (meterValue==60) {
//        frstMeterValue=39;
//    } else if (meterValue==80) {
//        frstMeterValue=26.0;
//    } else if (meterValue==100) {
//        frstMeterValue=13;
//    }

    radialView.progressCounter = 78 - meterValue * 120/185.0;
    [radialView setNeedsDisplay];
    [radialView setNeedsLayout];
}


-(void)getSecondMeterValues
{
    if (totalTime<=120) {
        secondMeterValue=78;
    } else if (totalTime>120 && totalTime<=139) {
        int value=totalTime-120;
        secondMeterValue=79-0.65*value;
    } else  if (totalTime>140 && totalTime<=159) {
        int value=totalTime-140;
        secondMeterValue=66-0.65*value;
    } else  if (totalTime>160 && totalTime<=179) {
        int value=totalTime-160;
        secondMeterValue=53-0.65*value;
    } else  if (totalTime>180 && totalTime<=199) {
        int value=totalTime-180;
        secondMeterValue=40-0.65*value;
    } else  if (totalTime>200 && totalTime<=219) {
        int value=totalTime-200;
        secondMeterValue=27-0.65*value;
    } else  if (totalTime>220 && totalTime<=239) {
        int value=totalTime-220;
        secondMeterValue=14-0.65*value;
    } else if (totalTime==140) {
        secondMeterValue=66;
    } else if (totalTime==160) {
        secondMeterValue=53;
    } else if (totalTime==180) {
        secondMeterValue=40;
    } else if (totalTime==200)  {
        secondMeterValue=27;
    } else if (totalTime==220) {
        secondMeterValue=14;
    } else if (totalTime>=240) {
        secondMeterValue=1;
    }
    
    radialView1.progressCounter = secondMeterValue;
}


#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!isLandscape) {
        pageNumber = lround(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
        [self.pageController setCurrentPage:pageNumber];
        
        [self getCurrentView];
        if (!currentView.midleTableView.delegate) {
            [self clearRefreancesForEscapememoryWarningWithBoolValue:NO];
            [currentView.notesTableView reloadData];
            [currentView.midleTableView reloadData];
        }
        
        MasjidTimetable *currentTimeTable = [self getCurrentTimeTableWithPageNumber:pageNumber];
        if (currentTimeTable) {
            [self createRadial];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getTime) object:nil];
        [self getTime];
    }
}

#pragma mark - TableView Delegate's

- (NSInteger)tableView:(TimetableMidleInfoTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self getCurrentViewWithPageNumber:tableView.pageNumber];
    
    if (tableView.tag == 0) {
        return [[self getCurrentPageEventsWithIndex:tableView.pageNumber] count];
    } else if (tableView.tag == 1) {
        return [[self getCurrentPageDonationsWithIndex:tableView.pageNumber] count];
    } else if (tableView.tag == 2 ) {
        return [[self getCurrentPageRamadhansWithIndex:tableView.pageNumber] count];
    } else {
        return [[self getCurrentPageNotesWithIndex:tableView.pageNumber] count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(TimetableMidleInfoTableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getCurrentViewWithPageNumber:tableViews.pageNumber];
    
    if (tableViews.tag  == 0) {
        static NSString *simple = @"MasjidDetailTableCell";
        Event *currentEvent = [[self getCurrentPageEventsWithIndex:tableViews.pageNumber] objectAtIndex:indexPath.row];
        MasjidDetailTableCell *cell = (MasjidDetailTableCell *)[tableViews dequeueReusableCellWithIdentifier:simple];
        [tableViews setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MasjidDetailTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.backImage.hidden=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.donationText setLineBreakMode:NSLineBreakByWordWrapping];
            [cell.donationText setMinimumScaleFactor:FONT_SIZE];
            [cell.donationText setNumberOfLines:0];
            [cell.donationText setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [cell.donationText setTag:1];
            cell.donationText.textColor=[UIColor whiteColor];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.timeLabel.frame=CGRectMake(cell.timeLabel.frame.origin.x,cell.dateTimeLabel.frame.origin.y,100, cell.timeLabel.frame.size.height);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.donationButton.hidden=YES;
        cell.donationImage.hidden=YES;
        cell.bankDetails.hidden=YES;
        cell.dateTimeLabel.text =  [NSDateFormatter localizedStringFromDate:currentEvent.date
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterFullStyle];
        cell.dateTimeLabel.text = currentEvent.date;
        cell.timeLabel.text = currentEvent.time;
        cell.donationLabel.text= currentEvent.title;
        cell.donationLabel.textColor=[UIColor colorWithRed:168/255.0 green:217/255.0 blue:231/255.0 alpha:1.0];
        NSString *text= currentEvent.details;
        cell.donationText.font=[UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE];
        UIFont *cellFont = cell.donationText.font;
        CGSize constraintSize;
        if (IS_IPAD) {
            constraintSize = CGSizeMake(700, MAXFLOAT);
            cell.dateTimeLabel.frame=CGRectMake(cell.dateTimeLabel.frame.origin.x,cell.dateTimeLabel.frame.origin.y, 700, cell.dateTimeLabel.frame.size.height);
            cell.timeLabel.frame=CGRectMake(550,cell.timeLabel.frame.origin.y,100, cell.timeLabel.frame.size.height);
            cell.timeLabel.textColor=[UIColor whiteColor];
            cell.timeLabel.text = currentEvent.time;
        }  else {
            if(IS_IPHONE_6P) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else if(IS_IPHONE_6) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else {
                constraintSize = CGSizeMake(280, MAXFLOAT);
            }
        }
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentEvent.details attributes:@{NSFontAttributeName: cellFont}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        
        CGRect frame = cell.donationText.frame;
        frame.size = rect.size;
        frame.origin.y=cell.donationText.frame.origin.y + 45;
        frame.size.height =rect.size.height + 5;
        cell.donationText.frame = frame;
        [cell.donationText setText:text];
        cell.donationText.textColor=[UIColor colorWithRed:244/255.0 green:233/255.0 blue:212/255.0 alpha:1.0];
        cell.donationText.textAlignment = NSTextAlignmentJustified;
        
        return cell;
    } else if  (tableViews.tag == 1) {
        static NSString *simple = @"MasjidDetailTableCell";
        [tableViews setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        Donation *currentDonation= [[self getCurrentPageDonationsWithIndex:tableViews.pageNumber] objectAtIndex:indexPath.row];
        
        MasjidDetailTableCell *cell = (MasjidDetailTableCell *)[tableViews dequeueReusableCellWithIdentifier:simple];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MasjidDetailTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.backImage.hidden=YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.donationText setLineBreakMode:NSLineBreakByWordWrapping];
            [cell.donationText setMinimumScaleFactor:FONT_SIZE];
            
            [cell.donationText setNumberOfLines:0];
            [cell.donationText setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [cell.donationText setTag:1];
            cell.donationText.textColor=[UIColor whiteColor];
        }
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dateTimeLabel.hidden=YES;
        cell.donationLabel.hidden=YES;
        cell.timeLabel.hidden=YES;
        
        if (currentDonation.live == 0) {
            cell.bankDetails.hidden=YES;
            cell.donationButton.hidden=YES;
            cell.donationImage.hidden=YES;
            cell.donationText.text=@"Sorry, Due to privacy settings you can't see the donation details";
        } else if(currentDonation.live == 1) {
            cell.bankDetails.hidden=NO;
            cell.donationButton.hidden=NO;
            cell.donationImage.hidden=NO;
            cell.donationText.hidden=NO;
            
            cell.bankDetails.text= currentDonation.bankDetails;
            NSString *text = currentDonation.encouragementText;
            if (text.length==0 || cell.bankDetails.text==0) {
                cell.donationImage.hidden=YES;
                cell.donationButton.hidden=YES;
            }
            cell.bankDetails.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
            cell.donationText.font=[UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE];
            UIFont *cellFont = cell.donationText.font;
            CGSize constraintSize;
            if(IS_IPHONE_6P) {
                constraintSize = CGSizeMake(390, MAXFLOAT);
            } else if(IS_IPHONE_6) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else {
                constraintSize = CGSizeMake(280, MAXFLOAT);
            }
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentDonation.encouragementText attributes:@{NSFontAttributeName: cellFont}];
            CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            CGRect frame = cell.donationText.frame;
            frame.size = rect.size;
            frame.origin.y=cell.donationText.frame.origin.y;
            frame.size.height =rect.size.height+5;
            cell.donationText.frame = frame;
            [cell.donationText setText:text];
            cell.bankDetails.frame=CGRectMake(frame.origin.x, frame.size.height+8, 260,100);
            cell.bankDetails.textColor=[UIColor colorWithRed:168/255.0 green:217/255.0 blue:231/255.0 alpha:1.0];
            cell.donationText.textColor=[UIColor colorWithRed:244/255.0 green:233/255.0 blue:212/255.0 alpha:1.0];
            cell.donationText.textAlignment=NSTextAlignmentJustified;
            cell.donationButton.tag=indexPath.row;
            paypal= currentDonation.paypalCode;
            
            NSRange range = [paypal rangeOfString:@"<input" options:NSBackwardsSearch];
            NSRange range1 = [paypal rangeOfString:@"value=" options:NSBackwardsSearch];
            NSRange range2 = [paypal rangeOfString:@"border="];
            
            int firstCharacterPosition1 = range1.location+7;
            int firstCharacterPosition2 = range2.location-14;
            int firstCharacterPosition = range.location-3;
            if (firstCharacterPosition2 < 0 || firstCharacterPosition1 < 0 || firstCharacterPosition < 0  ) {
                if (IS_IPAD) {
                    cell.donationButton.frame=CGRectMake((cell.contentView.frame.size.width - 100)/2,cell.contentView.frame.size.height - 50,100,40);
                    cell.donationImage.frame=CGRectMake((cell.contentView.frame.size.width - 100)/2,cell.contentView.frame.size.height - 50,100,40);
                } else {
                    cell.donationButton.frame=CGRectMake((cell.contentView.frame.size.width - 150)/2,cell.contentView.frame.size.height - 50, 150, 40);
                    cell.donationImage.frame=CGRectMake((cell.contentView.frame.size.width - 143)/2,cell.contentView.frame.size.height - 50,143,40);
                }
                [cell.donationImage setImage:[UIImage imageNamed:@"new-paypal.png"]];
                [cell.donationButton addTarget:self action:@selector(btnprev:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                cell.donationButton.frame=CGRectMake(75,frame.size.height+99,150,50);
                cell.donationImage.frame=CGRectMake(73,frame.size.height+99,150,55);
                cell.donationButton.frame=CGRectMake((cell.contentView.frame.size.width - 150)/2,cell.contentView.frame.size.height - 60, 150, 50);
                cell.donationImage.frame=CGRectMake((cell.contentView.frame.size.width - 146)/2,cell.contentView.frame.size.height - 60,143,55);                        cell.donationButton.frame=CGRectMake((cell.contentView.frame.size.width - 150)/2,cell.contentView.frame.size.height - 50, 150, 40);
                NSString *subString = [currentDonation.paypalCode substringWithRange: NSMakeRange([currentDonation.paypalCode rangeOfString: @"value="options:NSBackwardsSearch].location+7,firstCharacterPosition-firstCharacterPosition1)];
                NSString *subString1 = [currentDonation.paypalCode substringWithRange: NSMakeRange([currentDonation.paypalCode rangeOfString: @"src="].location+5,firstCharacterPosition2-[paypal rangeOfString: @"src="].location+7)];
                NSURL *imageUrl=[NSURL URLWithString:subString1];
                [cell.donationImage setImageWithURL:imageUrl];
                NSString *url=[NSString stringWithFormat:@"%@%@",@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=",subString];
                paypal=url;
                [cell.donationButton addTarget:self action:@selector(btnprev:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        return cell;
    } else if (tableViews.tag == 2) {
        static NSString *simple = @"ramadhanTimeTableCell";
        ramadhanTimeTableCell *cell = (ramadhanTimeTableCell *)[tableViews dequeueReusableCellWithIdentifier:simple];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ramadhanTimeTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        Ramadhan *currentRamadhan = [[self getCurrentPageRamadhansWithIndex:tableViews.pageNumber] objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            UIColor *setingColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
            cell.date.textColor = setingColor;
            cell.fajar.textColor = setingColor;
            cell.sunrise.textColor = setingColor;
            cell.zohar.textColor = setingColor;
            cell.iftar.textColor = setingColor;
            cell.asar.textColor = setingColor;
            cell.zoharB.textColor = setingColor;
            cell.eshaBegin.textColor = setingColor;
            cell.asarJammat.textColor = setingColor;
            cell.b.textColor = setingColor;
            cell.j.textColor = setingColor;
            cell.maghrib.textColor = setingColor;
            cell.sehriEnd.textColor = setingColor;
            cell.esha.textColor = setingColor;
            cell.subah.textColor = setingColor;
        }
        
        cell.b.text = @"B";
        cell.j.text = @"J";
        cell.date.text = [currentRamadhan parsedShortDate];
        cell.asar.text = currentRamadhan.asar;
        cell.zoharB.text = currentRamadhan.zohar;
        cell.eshaBegin.text = currentRamadhan.esha;
        cell.fajar.text = currentRamadhan.fajar;
        cell.esha.text = currentRamadhan.eshaj;
        cell.asarJammat.text = currentRamadhan.asar;
        cell.iftar.text = currentRamadhan.iftar;
        cell.maghrib.text = currentRamadhan.maghrib;
        cell.sehriEnd.text = currentRamadhan.sehriends;
        cell.subah.text = currentRamadhan.subahsadiq;
        cell.sunrise.text = currentRamadhan.sunrise;
        cell.zohar.text = currentRamadhan.zohar;
        
        return cell;
    } else {
        Note *currentNote = [[self getCurrentPageNotesWithIndex:tableViews.pageNumber] objectAtIndex:indexPath.row];
        
        static NSString *simple = @"NotesCell";
        NotesCell *cell = (NotesCell *)[tableViews dequeueReusableCellWithIdentifier:simple];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotesCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.noteText.editable=NO;
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        UIFont *cellFont = [UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE];
        cell.noteText.textAlignment = NSTextAlignmentJustified;
        CGSize constraintSize;
        constraintSize = CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT);
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentNote.text attributes:@{NSFontAttributeName: cellFont}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGRect frame = cell.noteText.frame;
        frame.size = rect.size;
        int width = self.view.frame.size.width-30;
        if (IS_IPHONE_4) {
            frame.size.width = 285;
        } else if (IS_IPHONE_6) {
            frame.size.width = width - 50;
        } else if (IS_IPHONE_6P) {
            frame.size.width = width - 85;
        } else {
            frame.size.width = width ;
        }
        frame.size.height = rect.size.height+25;
        cell.noteText.frame = frame;
        [cell.noteText setText:currentNote.text];
        [cell.noteText setEditable:NO];
        [cell.noteText setScrollEnabled:NO];
        
        return cell;
    }
}

-(CGFloat)tableView:(TimetableMidleInfoTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self getCurrentViewWithPageNumber:tableView.pageNumber];
    
    int row;
    if(tableView.tag == 0) {
        Event *currentEvent = [[self getCurrentPageEventsWithIndex:tableView.pageNumber] objectAtIndex:indexPath.row];
        if (IS_IPAD) {
            CGSize constraintSize = CGSizeMake(700, MAXFLOAT);
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentEvent.details attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE]}];
            CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            row = rect.size.height + 60;
        } else {
            CGSize constraintSize;
            if(IS_IPHONE_6P) {
                constraintSize = CGSizeMake(390, MAXFLOAT);
            } else if(IS_IPHONE_6) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else {
                constraintSize = CGSizeMake(280, MAXFLOAT);
            }
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentEvent.details attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE]}];
            CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            row = rect.size.height + 65;
        }
    } else if (tableView.tag == 1) {
        Donation *currentDonation = [[self getCurrentPageDonationsWithIndex:tableView.pageNumber] objectAtIndex:indexPath.row];
        
        if (IS_IPAD) {
            CGSize constraintSize = CGSizeMake(700, MAXFLOAT);
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentDonation.encouragementText attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE]}];
            CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            row = rect.size.height + 180;
        } else {
            CGSize constraintSize;
            if(IS_IPHONE_6P) {
                constraintSize = CGSizeMake(390, MAXFLOAT);
            } else if(IS_IPHONE_6) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else {
                constraintSize = CGSizeMake(290, MAXFLOAT);
            }
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentDonation.encouragementText attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE]}];
            CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            row= rect.size.height + 180;
        }
    } else if (tableView.tag == 2){
        row = 40;
    } else {
        Note *currentNote = [[self getCurrentPageNotesWithIndex:tableView.pageNumber] objectAtIndex:indexPath.row];
        CGSize constraintSize = CGSizeMake(self.view.frame.size.width, MAXFLOAT);
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:currentNote.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:FONT_SIZE]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        row= rect.size.height + 15;
    }
    
    return row;
}

@end

