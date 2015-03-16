//
//  MuteView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "MuteView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "JammatNotificationsView.h"
#import "otherSettings.h"
#import "NumberPadDoneBtn.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface MuteView ()
{
    int val,val1,val2,val3,val4;
    int prayerTime, alertHours,alertMinutes,unmuteHours,unmuteMinutes;
    int minutes,hours,ii,intervalsAfter;
    float alertTime;
    NSString *time,*getString;
    NSString *fajar,*zohar,*asar,*maghrib,*esha;
    NSString *from,*JsonDate,*soundFile;
    NSString *prayerAlert;
    NSString *unmuteTime;
    NSMutableArray *currentMonthData;
    UILocalNotification *localNotification;
}

@end

@implementation MuteView

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
    
    prayerTime=0;
    intervalsAfter=30;
    NumberPadDoneBtn *done=[[NumberPadDoneBtn alloc]initWithFrame:CGRectMake(0, 0,1,1)];
    currentMonthData=[[NSMutableArray alloc]init];
    val=1,val1=1,val2=1,val3=1,val4=1;
    _fajarMB.keyboardType=UIKeyboardTypeNumberPad;
    _fajarMA.keyboardType=UIKeyboardTypeNumberPad;
    _eshaMB.keyboardType=UIKeyboardTypeNumberPad;
    _eshaMA.keyboardType=UIKeyboardTypeNumberPad;
    _magribMB.keyboardType=UIKeyboardTypeNumberPad;
    _magribMA.keyboardType=UIKeyboardTypeNumberPad;
    _zoharMB.keyboardType=UIKeyboardTypeNumberPad;
    _zoharMA.keyboardType=UIKeyboardTypeNumberPad;
    _asarMB.keyboardType=UIKeyboardTypeNumberPad;
    _asarMA.keyboardType=UIKeyboardTypeNumberPad;
    _fajarMB.inputAccessoryView=done;
    _fajarMA.inputAccessoryView=done;
    _eshaMB.inputAccessoryView=done;
    _eshaMA.inputAccessoryView=done;
    _magribMB.inputAccessoryView=done;
    _magribMA.inputAccessoryView=done;
    _zoharMB.inputAccessoryView=done;
    _zoharMA.inputAccessoryView=done;
    _asarMB.inputAccessoryView=done;
    _asarMA.inputAccessoryView=done;
    _fajarMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _fajarMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _zoharMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _zoharMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _magribMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _magribMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _eshaMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _eshaMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _asarMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _asarMB.keyboardAppearance = UIKeyboardAppearanceDark;
    
    if (globalMasjidID.length !=0 ) {
        [self getDetails];
        [self alertValues];
    }
    [self registerNotifications];
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

-(void)alertValues
{
    NSString *mute=[[NSUserDefaults standardUserDefaults]valueForKey:@"mute"];
    NSString *muteZ=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteZ"];
    NSString *muteA=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteA"];
    NSString *muteE=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteE"];
    NSString *muteM=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteM"];
    if (mute.length==0 || [mute isEqualToString:@"0"])
    {
        [_fImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    else
    {
        [_fImage setImage:[UIImage imageNamed:@"on2.png"]];
    }
    if (muteZ.length==0 || [muteZ isEqualToString:@"0"])
    {
        [_zImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    else
    {
        [_zImage setImage:[UIImage imageNamed:@"on2.png"]];
    }
    if (muteA.length==0 || [muteA isEqualToString:@"0"])
    {
        [_asarImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    else
    {
        [_asarImage setImage:[UIImage imageNamed:@"on2.png"]];
    }
    if (muteM.length==0 || [muteM isEqualToString:@"0"])
    {
        [_mImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    else
    {
        [_mImage setImage:[UIImage imageNamed:@"on2.png"]];
    }
    if (muteE.length==0 || [muteE isEqualToString:@"0"])
    {
        [_eImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    else
    {
        [_eImage setImage:[UIImage imageNamed:@"on2.png"]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    if (IS_IPAD) {
        self.frstText.font=[UIFont systemFontOfSize:29];
        self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,75, self.frstText.frame.size.width, self.frstText.frame.size.height);
        self.scnd.font=[UIFont systemFontOfSize:29];
        self.scnd.frame=CGRectMake(self.scnd.frame.origin.x,190, self.scnd.frame.size.width, self.scnd.frame.size.height);
        self.prayername.font=[UIFont systemFontOfSize:20];
        self.fnctn.font=[UIFont systemFontOfSize:22];
        self.muteBf.font=[UIFont systemFontOfSize:22];
        self.unmuteAf.font=[UIFont systemFontOfSize:22];
        self.magh.font=[UIFont systemFontOfSize:20];
        self.a.font=[UIFont systemFontOfSize:20];
        self.es.font=[UIFont systemFontOfSize:20];
        self.z.font=[UIFont systemFontOfSize:20];
        self.f.font=[UIFont systemFontOfSize:20];
        self.fajarMA.font=[UIFont systemFontOfSize:20];
        self.fajarMB.font=[UIFont systemFontOfSize:20];
        self.magribMA.font=[UIFont systemFontOfSize:20];
        self.magribMB.font=[UIFont systemFontOfSize:20];
        self.zoharMA.font=[UIFont systemFontOfSize:20];
        self.zoharMB.font=[UIFont systemFontOfSize:20];
        self.asarMA.font=[UIFont systemFontOfSize:20];
        self.asarMB.font=[UIFont systemFontOfSize:20];
        self.eshaMA.font=[UIFont systemFontOfSize:20];
        self.eshaMB.font=[UIFont systemFontOfSize:20];
    } else {
        if(IS_IPHONE_6) {
            self.frstText.font=[UIFont systemFontOfSize:15];
            self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,75, self.frstText.frame.size.width, self.frstText.frame.size.height);
            self.scnd.font=[UIFont systemFontOfSize:15];
            self.scnd.frame=CGRectMake(self.scnd.frame.origin.x,162, self.scnd.frame.size.width, self.scnd.frame.size.height);
        } else if(IS_IPHONE_5) {
            self.frstText.font=[UIFont systemFontOfSize:13];
            self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,75, self.frstText.frame.size.width, self.frstText.frame.size.height);
        }
        NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
        if ([defaults intValue]==0 || defaults.length==0) {
            [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
        } else {
            [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
        }
    }
}

-(void)registerNotifications
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIMutableUserNotificationAction *notificationAction = [[UIMutableUserNotificationAction alloc] init];
        notificationAction.identifier = @"Accept";
        notificationAction.title = @"OK";
        notificationAction.activationMode = UIUserNotificationActivationModeBackground;
        notificationAction.destructive = NO;
        notificationAction.authenticationRequired = NO;
        
        UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
        notificationCategory.identifier = @"Alert";
        [notificationCategory setActions:@[notificationAction] forContext:UIUserNotificationActionContextDefault];
        [notificationCategory setActions:@[notificationAction] forContext:UIUserNotificationActionContextMinimal];
        
        UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
        notificationAction1.identifier = @"Reject";
        notificationAction1.title = @"OK";
        notificationAction1.activationMode = UIUserNotificationActivationModeBackground;
        notificationAction1.destructive = NO;
        notificationAction1.authenticationRequired = NO;
        
        UIMutableUserNotificationCategory *notificationCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        notificationCategory1.identifier = @"AlertOff";
        [notificationCategory1 setActions:@[notificationAction1] forContext:UIUserNotificationActionContextDefault];
        [notificationCategory1 setActions:@[notificationAction1] forContext:UIUserNotificationActionContextMinimal];
        
        
        NSSet *categories = [NSSet setWithObjects:notificationCategory,notificationCategory1,nil];
        UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
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
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = next9am;
    notification.category=@"Alert";
    notification.alertBody=@"click OK to mute your device";
    notification.soundName=UILocalNotificationDefaultSoundName;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:prayerID forKey:@"buttonTag"];
    notification.userInfo = userInfo;
    notification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)fireAlarmToUnmute
{
    prayerID=@"99";
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:unmuteHours];
    [components setMinute:unmuteMinutes];
    NSDate *next9am = [calendar dateFromComponents:components];
    if ([next9am timeIntervalSinceNow] < 0) {
        next9am = [next9am dateByAddingTimeInterval:60*60*24];
    }
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = next9am;
    notification.category=@"AlertOff";
    notification.alertBody=@"click OK to unmute your device";
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:prayerID forKey:@"buttonTag"];
    notification.userInfo = userInfo;
    notification.soundName=UILocalNotificationDefaultSoundName;
    notification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (IBAction)fajarAlert:(UIButton *)sender
{
    prayerID = @"45";
    if ([self.fajarMB.text isEqualToString:@"120"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please set minutes less than 120" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if (self.fajarMA.text.length != 0 || self.fajarMB.text.length != 0 ) {
            if (self.fajarMB.text.length !=0  ) {
                NSString *mute=[[NSUserDefaults standardUserDefaults]valueForKey:@"mute"];
                if ([mute isEqualToString:@"1"]) {
                    [_fImage setImage:[UIImage imageNamed:@"off2.png"]];
                    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
                        NSDictionary *userInfo = notification.userInfo;
                        if ([[userInfo objectForKey:@"buttonTag"]isEqualToString:@"45"]){
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        }
                    }
                    [self setSystemVolumeLevelTo:1.0f];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"0" forKey:@"mute"];
                } else {
                    unmuteTime=_fajarMA.text;
                    [_fImage setImage:[UIImage imageNamed:@"on2.png"]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSDate *ab=[formatter dateFromString:fajar];
                    NSDate *newDate = [ab dateByAddingTimeInterval:-60*[_fajarMB.text intValue]];
                    fajar=[formatter stringFromDate:newDate];
                    alertHours=[[fajar substringToIndex:2]intValue];
                    alertMinutes=[[fajar substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarm];
                    NSDate *newDate1 = [ab dateByAddingTimeInterval:60*[_fajarMA.text intValue]];
                    NSString *unmute=[formatter stringFromDate:newDate1];
                    unmuteHours=[[unmute substringToIndex:2]intValue];
                    unmuteMinutes=[[unmute substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarmToUnmute];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"1" forKey:@"mute"];
                }
            }
        }
    }
}

- (IBAction)zoharAlert:(UIButton *)sender
{
    prayerID=@"46";
    if ([self.zoharMB.text isEqualToString:@"120"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please set minutes less than 120" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (self.zoharMA.text.length != 0 || self.zoharMB.text.length != 0)  {
            if (self.zoharMB.text.length != 0) {
                NSString *mute=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteZ"];
                if ([mute isEqualToString:@"1"]) {
                    
                    [_zImage setImage:[UIImage imageNamed:@"off2.png"]];
                    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
                        NSDictionary *userInfo = notification.userInfo;
                        if ([[userInfo objectForKey:@"buttonTag"]isEqualToString:@"46"]){
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        }
                    }
                    [self setSystemVolumeLevelTo:1.0];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"0" forKey:@"muteZ"];
                } else {
                    unmuteTime=_zoharMA.text;
                    [_zImage setImage:[UIImage imageNamed:@"on2.png"]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSDate *ab=[formatter dateFromString:zohar];
                    NSDate *newDate = [ab dateByAddingTimeInterval:-60*[_zoharMB.text intValue]];
                    zohar=[formatter stringFromDate:newDate];
                    alertHours=[[zohar substringToIndex:2]intValue];
                    alertMinutes=[[zohar substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarm];
                    NSDate *newDate1 = [ab dateByAddingTimeInterval:60*[_zoharMA.text intValue]];
                    NSString *unmute=[formatter stringFromDate:newDate1];
                    unmuteHours=[[unmute substringToIndex:2]intValue];
                    unmuteMinutes=[[unmute substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarmToUnmute];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"1" forKey:@"muteZ"];
                }
            }
        }
    }
}

- (IBAction)asarAlert:(UIButton *)sender
{
    prayerID = @"47";
    if ([self.asarMB.text isEqualToString:@"120"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please set minutes less than 120" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if (self.asarMB.text.length != 0 || self.asarMA.text.length != 0) {
            if (self.asarMB.text.length != 0) {
                NSString *mute=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteA"];
                if ([mute isEqualToString:@"1"]) {
                    
                    [_asarImage setImage:[UIImage imageNamed:@"off2.png"]];
                    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
                        NSDictionary *userInfo = notification.userInfo;
                        if ([[userInfo objectForKey:@"buttonTag"]isEqualToString:@"47"]){
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        }
                    }
                    [self setSystemVolumeLevelTo:1.0];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"0" forKey:@"muteA"];
                } else {
                    unmuteTime=_asarMA.text;
                    [_asarImage setImage:[UIImage imageNamed:@"on2.png"]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSDate *ab=[formatter dateFromString:asar];
                    NSDate *newDate = [ab dateByAddingTimeInterval:-60*[_asarMB.text intValue]];
                    asar=[formatter stringFromDate:newDate];
                    alertHours=[[asar substringToIndex:2]intValue];
                    alertMinutes=[[asar substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarm];
                    NSDate *newDate1 = [ab dateByAddingTimeInterval:60*[_asarMA.text intValue]];
                    NSString *unmute=[formatter stringFromDate:newDate1];
                    unmuteHours=[[unmute substringToIndex:2]intValue];
                    unmuteMinutes=[[unmute substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarmToUnmute];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"1" forKey:@"muteA"];
                }
            }
        }
    }
}

- (IBAction)magribAlert:(UIButton *)sender
{
    prayerID=@"48";
    if ([self.magribMB.text isEqualToString:@"120"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please set minutes less than 120" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if (self.magribMA.text.length != 0 || self.magribMB.text.length != 0) {
            if (self.magribMB.text.length != 0) {
                NSString *mute=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteM"];
                if ([mute isEqualToString:@"1"]) {
                    [_mImage setImage:[UIImage imageNamed:@"off2.png"]];
                    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
                        NSDictionary *userInfo = notification.userInfo;
                        if ([[userInfo objectForKey:@"buttonTag"]isEqualToString:@"48"]){
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        }
                    }
                    [self setSystemVolumeLevelTo:1.0];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"0" forKey:@"muteM"];
                } else {
                    unmuteTime=_magribMA.text;
                    [_mImage setImage:[UIImage imageNamed:@"on2.png"]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSDate *ab=[formatter dateFromString:maghrib];
                    NSDate *newDate = [ab dateByAddingTimeInterval:-60*[_magribMB.text intValue]];
                    maghrib=[formatter stringFromDate:newDate];
                    alertHours=[[maghrib substringToIndex:2]intValue];
                    alertMinutes=[[maghrib substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarm];
                    NSDate *newDate1 = [ab dateByAddingTimeInterval:60*[_magribMA.text intValue]];
                    NSString *unmute=[formatter stringFromDate:newDate1];
                    unmuteHours=[[unmute substringToIndex:2]intValue];
                    unmuteMinutes=[[unmute substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarmToUnmute];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"1" forKey:@"muteM"];
                }
            }
        }
    }
}

- (IBAction)eshaAlert:(UIButton *)sender
{
    prayerID=@"49";
    if ([self.eshaMB.text isEqualToString:@"120"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please set minutes less than 120" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if (self.eshaMA.text.length != 0 || self.eshaMB.text.length != 0 ) {
            if (self.eshaMB.text.length != 0) {
                unmuteTime=_eshaMA.text;
                NSString *mute=[[NSUserDefaults standardUserDefaults]valueForKey:@"muteE"];
                if ([mute isEqualToString:@"1"]) {
                    
                    [_eImage setImage:[UIImage imageNamed:@"off2.png"]];
                    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
                        NSDictionary *userInfo = notification.userInfo;
                        if ([[userInfo objectForKey:@"buttonTag"]isEqualToString:@"49"]){
                            [[UIApplication sharedApplication] cancelLocalNotification:notification];
                        }
                    }
                    [self setSystemVolumeLevelTo:1.0];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"0" forKey:@"muteE"];
                } else {
                    [_eImage setImage:[UIImage imageNamed:@"on2.png"]];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSDate *ab=[formatter dateFromString:esha];
                    NSDate *newDate = [ab dateByAddingTimeInterval:-60*[_eshaMB.text intValue]];
                    esha=[formatter stringFromDate:newDate];
                    alertHours=[[esha substringToIndex:2]intValue];
                    alertMinutes=[[esha substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarm];
                    NSDate *newDate1 = [ab dateByAddingTimeInterval:60*[_eshaMA.text intValue]];
                    NSString *unmute=[formatter stringFromDate:newDate1];
                    unmuteHours=[[unmute substringToIndex:2]intValue];
                    unmuteMinutes=[[unmute substringWithRange:NSMakeRange(3,2)]intValue];
                    [self fireAlarmToUnmute];
                    [[NSUserDefaults standardUserDefaults ]setValue:@"1" forKey:@"muteE"];
                }
            }
        }
    }
}

-(void)offButton
{
    if (prayerTime==5)
    {
        [_fImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    if (prayerTime==6)
    {
        [_zImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    if (prayerTime==7)
    {
        [_asarImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    if (prayerTime==8)
    {
        [_mImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    if (prayerTime==9)
    {
        [_eImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
}

-(void)getTimeIntervals
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *serDate;
    
    NSDate *endDate;
    
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *ab=[formatter stringFromDate:[NSDate date]];
    serDate = [formatter dateFromString:ab];
    endDate = [formatter dateFromString:from];
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    minutes = timeDifference / 60;
    hours = minutes / 60;
    double seconds = timeDifference;
    if (hours<0 || minutes<0) {
    }
    else
    {
        [self performSelector:@selector(offButton) withObject:self afterDelay:(seconds+60*intervalsAfter)];
    }
}

-(void)getNotifications
{
    UILocalNotification *local =  [[UILocalNotification alloc] init];
    if (!local)
        return;
    
    int hrs=hours *3600;
    int mins=minutes*60;
    NSDate *date = [NSDate date];
    NSDate *dateToFire = [date dateByAddingTimeInterval:(hrs+mins)];
    [local setFireDate:dateToFire];
    [local setTimeZone:[NSTimeZone defaultTimeZone]];
    [local setSoundName:@"azan1.wav"];
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    [volumeViewSlider setValue:0.0f animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([_fajarMA isFirstResponder]) {
        [_fajarMA resignFirstResponder];
    }
    else if ([_zoharMA isFirstResponder]) {
        [_zoharMA resignFirstResponder];
    }
    else  if ([_asarMA isFirstResponder]) {
        [_asarMA resignFirstResponder];
    }
    else  if ([_magribMA isFirstResponder]) {
        [_magribMA resignFirstResponder];
    }
    else if ([_eshaMA isFirstResponder]) {
        [_eshaMA resignFirstResponder];
    }
    else  if ([_fajarMB isFirstResponder]) {
        [_fajarMB resignFirstResponder];
    }
    else if ([_zoharMB isFirstResponder]) {
        [_zoharMB resignFirstResponder];
    }
    else  if ([_asarMB isFirstResponder]) {
        [_asarMB resignFirstResponder];
    }
    else  if ([_magribMB isFirstResponder]) {
        [_magribMB resignFirstResponder];
    }
    else if ([_eshaMB isFirstResponder]) {
        [_eshaMB resignFirstResponder];
    }
}

-(void)getDetails
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d-MM-yyyy"];
    NSString *ab=[formatter stringFromDate:[NSDate date]];
    NSArray *json;
    
    if (masjidTurn==1) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable"];
    }
    else if (masjidTurn==2) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable1"];
        if ([json count]==0) {
            json=globalTimeTable;
        }
    }
    else if (masjidTurn==3) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable2"];
        if ([json count]==0) {
            json=globalTimeTable;
        }
    }
    else if (masjidTurn==4) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable3"];
        if ([json count]==0) {
            json=globalTimeTable;
        }
    }
    for (int i=0;i<[json count];i++) {
        if ([[json valueForKey:@"DATE"][i]isEqualToString:ab]) {
            [currentMonthData addObject:json[i]];
        }
    }
    if ([currentMonthData count]>0) {
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        
        [df setDateFormat:@"hh:mm a"];
        fajar=[[currentMonthData valueForKey:@"Fajar"]objectAtIndex:0];
        NSDate* wakeTime1 = [df dateFromString:[NSString stringWithFormat:@"%@ AM",fajar]];
        [df setDateFormat:@"HH:mm"];
        fajar=[df stringFromDate:wakeTime1];
        
        [df setDateFormat:@"hh:mm a"];
        zohar=[[currentMonthData valueForKey:@"Zohar-j"]objectAtIndex:0];
        NSDate* wakeTime3 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",zohar]];
        [df setDateFormat:@"HH:mm"];
        zohar=[df stringFromDate:wakeTime3];
        
        [df setDateFormat:@"hh:mm a"];
        asar=[[currentMonthData valueForKey:@"Asar-j"]objectAtIndex:0];
        NSDate* wakeTime5 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",asar]];
        [df setDateFormat:@"HH:mm"];
        asar=[df stringFromDate:wakeTime5];
        
        [df setDateFormat:@"hh:mm a"];
        maghrib=[[currentMonthData valueForKey:@"Maghrib"]objectAtIndex:0];
        NSDate *wakeTime7 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",maghrib]];
        [df setDateFormat:@"HH:mm"];
        maghrib=[df stringFromDate:wakeTime7];
        
        [df setDateFormat:@"hh:mm a"];
        esha=[[currentMonthData valueForKey:@"Esha-j"]objectAtIndex:0];
        NSDate* wakeTime9 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",esha]];
        [df setDateFormat:@"HH:mm"];
        esha=[df stringFromDate:wakeTime9];
        
        JsonDate =[[currentMonthData valueForKey:@"DATE"]objectAtIndex:0];
    }
}

- (IBAction)jammatClickd
{
    JammatNotificationsView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"jammatNotifications"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)muteClickd {
}

- (IBAction)otherClickd
{
    otherSettings *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"otherSettings"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)miscClicked
{
    JammatNotificationsView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"jammatNotifications"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int txtPosition = (textField.frame.origin.y - 180);
    const int movementDistance = (txtPosition < 0 ? 0 : txtPosition);
    const float movementDuration = 0.7f;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 3 && range.length == 0)
    {
        return NO;
    }
    return YES;
}

@end
