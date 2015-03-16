//
//  AppDelegate.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPalMobile.h"
#import "TimeTableView.h"
#import "ViewController.h"
#import "MTDBHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    changeFormat = NO;
    isDataFetched = NO;
    isEventsFetched = NO;
    isSearching = NO;
    isColored = NO;
    fetchFirstTime = NO;
    counterValue = 0;
    sound = 0;
    a = 0;
    masjidTurn=1;
    localDataFetched=0;
    interval = @"30";
    localDataForFourth=NO;
    localDataForThird=NO;
    localDataForSecond=NO;
    //    dictData=[[NSMutableDictionary alloc]init];
    thirdMasjidDictionary=[[NSMutableDictionary alloc]init];
    arrayList=[[NSMutableArray alloc]init];
    checking=[[NSDictionary alloc]init];
    fetchResults=[[NSMutableArray alloc]init];
    globalMasjidBasicValues=[[NSMutableArray alloc]init];
    globalMasjidNames=[[NSMutableDictionary alloc]init];
    localNotification = [[UILocalNotification alloc] init];
    newArrayList =[[NSMutableArray alloc]init];
    val=1,val1=1,val2=1,val3=1,val4=1,val5=1,val6=1,alert=0;
    get=[[NSMutableArray alloc]init];
    addids =[[NSMutableArray alloc]init];
    addpri=[[NSMutableArray alloc]init];
    
    //    dictData=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"idWithPriorities"]];
    //
    //    if ([[dictData allKeys]containsObject:@"1"]) {
    //        TimeTableView *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"timeTable"];             UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
    //        self.window.rootViewController=navController;
    //        xts=1;
    //        l=0;
    //    } else {
    ViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"view"];
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginController];
    self.window.rootViewController=navController;
    xts=0;
    //    }
    
    if (!(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem" message:@"This app is designed for work better with iOS 8" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"3-3.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabNav.png"] forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setTranslucent:YES];
    [NSTimer scheduledTimerWithTimeInterval:31.0 target:self selector:@selector(updateDateForNextDay) userInfo:nil repeats:YES];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    
    if(state ==UIApplicationStateInactive ){
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"99"]) {
            [self setSystemVolumeLevelTo:1.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"45"]) {
            interval=[notification.userInfo objectForKey:@"5"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"46"]) {
            interval=[notification.userInfo objectForKey:@"6"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"47"]) {
            interval=[notification.userInfo objectForKey:@"7"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"48"]) {
            interval=[notification.userInfo objectForKey:@"8"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"49"]) {
            interval=[notification.userInfo objectForKey:@"9"];
            [self setSystemVolumeLevelTo:0.0f];
        }
    } else {
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"99"]) {
            [self setSystemVolumeLevelTo:1.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"45"]) {
            interval=[notification.userInfo objectForKey:@"45"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"46"]) {
            interval=[notification.userInfo objectForKey:@"46"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"47"]) {
            interval=[notification.userInfo objectForKey:@"47"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"48"]) {
            interval=[notification.userInfo objectForKey:@"48"];
            [self setSystemVolumeLevelTo:0.0f];
        }
        if ([[notification.userInfo objectForKey:@"buttonTag"]isEqualToString:@"49"]) {
            interval=[notification.userInfo objectForKey:@"49"];
            [self setSystemVolumeLevelTo:0.0f];
        }
    }
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"Accept"]) {
        [self setSystemVolumeLevelTo:0.0];
    } else if ([identifier isEqualToString:@"Reject"]) {
        [self setSystemVolumeLevelTo:1.0];
    }
    if (completionHandler) {
        completionHandler();
    }
}

-(void)unmuteThePhone
{
    [self setSystemVolumeLevelTo:1.0];
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

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self cancelJammatLocalNotifications];
    [self creatLocalNotificationsForJammat];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[MTDBHelper sharedDBHelper] saveContext];
}

- (void)creatLocalNotificationsForJammat
{
    jammatSoundSettings = [[MTDBHelper sharedDBHelper] getJammatSoundSettings];
    primaryMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
    primaryTimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:primaryMasjid.masjidId forDate:[Utils today]];

    if (primaryMasjid && primaryTimeTable && jammatSoundSettings) {
        if (![jammatSoundSettings.fajarJammatTime isEqualToString:@""] && jammatSoundSettings.fajarOn) {
            [self generateLocalNotificationWithIdebntifier:@"fajarJ"];
        }
        if (![jammatSoundSettings.zoharJammatTime isEqualToString:@""] && jammatSoundSettings.zoharOn) {
            [self generateLocalNotificationWithIdebntifier:@"zoharJ"];
        }
        if (![jammatSoundSettings.asarJammatTime isEqualToString:@""] && jammatSoundSettings.asarOn) {
            [self generateLocalNotificationWithIdebntifier:@"asarJ"];
        }
        if (![jammatSoundSettings.maghribJammatTime isEqualToString:@""] && jammatSoundSettings.maghribOn) {
            [self generateLocalNotificationWithIdebntifier:@"maghribJ"];
        }
        if (![jammatSoundSettings.eshaJammatTime isEqualToString:@""] && jammatSoundSettings.eshaOn) {
            [self generateLocalNotificationWithIdebntifier:@"eshaJ"];
        }
    }
}

- (void)generateLocalNotificationWithIdebntifier:(NSString *)identifier
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.category = @"Alert";
    notification.alertBody = @"Jamaat Notification";
    notification.fireDate = [self getFireDateWithIdentifier:identifier];
    notification.soundName = [self isTimetableSoundOffWithIdentifier:identifier]? nil : jammatSoundSettings.soundName;
    notification.alertAction = @"Ok";
    notification.repeatInterval = NSCalendarUnitDay;
    notification.userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"identifier"];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSDate *)getFireDateWithIdentifier:(NSString *)identifier
{
    TimeTableFormat *tableTimeFormat = [[MTDBHelper sharedDBHelper] getCurrentMontTimeTableFormat:primaryMasjid.masjidId];
    
    NSString *fajarTime;
    NSString *userSettedTimeCount;
    BOOL isTimeFromatAM = NO;
    if ([identifier isEqualToString:@"fajarJ"]) {
        fajarTime = primaryTimeTable.fajar;
        isTimeFromatAM = YES;
        userSettedTimeCount = jammatSoundSettings.fajarJammatTime;
    } else if ([identifier isEqualToString:@"zoharJ"]) {
        fajarTime = primaryTimeTable.zoharj;
        userSettedTimeCount = jammatSoundSettings.zoharJammatTime;
    } else if ([identifier isEqualToString:@"asarJ"]) {
        fajarTime = primaryTimeTable.asarj;
        userSettedTimeCount = jammatSoundSettings.asarJammatTime;
    } else if ([identifier isEqualToString:@"maghribJ"]) {
        fajarTime = primaryTimeTable.maghrib;
        userSettedTimeCount = jammatSoundSettings.maghribJammatTime;
    } else if ([identifier isEqualToString:@"eshaJ"]) {
        fajarTime = primaryTimeTable.eshaj;
        userSettedTimeCount = jammatSoundSettings.eshaJammatTime;
    }
    fajarTime =  [self reformatTimeTo24timeFormat:fajarTime isAMformat:isTimeFromatAM withTimeFormat:tableTimeFormat.format];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    
    NSString *monthYear = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fireTimeString = [NSString stringWithFormat:@"%@ %@", monthYear, fajarTime];
    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
    NSDate *jamatDate = [dateFormatter dateFromString:fireTimeString];
    
    return [jamatDate dateByAddingTimeInterval:-60*[userSettedTimeCount integerValue]];
}

- (NSString *)reformatTimeTo24timeFormat:(NSString*)eventStart
                              isAMformat:(BOOL)formatAM
                          withTimeFormat:(int)format
{
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
    }
    return eventStart;
}

- (BOOL)isTimetableSoundOffWithIdentifier:(NSString *)identifier
{
    MasjidTimetable *currentTimeTable= [[MTDBHelper sharedDBHelper]
                                        getTimetableWithMashjidID:primaryMasjid.masjidId
                                        forDate:[Utils today]];
    
    if ([identifier isEqualToString:@"fajarJ"]) {
        return currentTimeTable.zoharSoundOff;
    } else if ([identifier isEqualToString:@"zoharJ"]) {
        return currentTimeTable.fajarSoundOff;
    } else if ([identifier isEqualToString:@"asarJ"]) {
        return currentTimeTable.asarSoundOff;
    } else if ([identifier isEqualToString:@"maghribJ"]) {
        return currentTimeTable.maghribSoundOff;
    } else if ([identifier isEqualToString:@"eshaJ"]) {
        return currentTimeTable.eshaSoundOff;
    }
    
    return NO;
}

- (void)changeNotificationSound:(BOOL)unMute withNotificationId:(NSString *)Id
{
    BOOL notificationExist = NO;
    NSDate *fireDate;
    for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([[localNotification.userInfo valueForKey:@"identifier"] isEqualToString:Id]) {
            notificationExist = YES;
            fireDate = localNotification.fireDate;
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            break;
        }
    }
    if (notificationExist) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.category = @"Alert";
        notification.alertBody = @"Jamaat Notification";
        notification.fireDate = fireDate;
        notification.soundName = unMute? jammatSoundSettings.soundName : nil;
        notification.alertAction = @"Ok";
        notification.repeatInterval = NSCalendarUnitDay;
        notification.userInfo = [NSDictionary dictionaryWithObject:Id forKey:@"identifier"];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)cancelJammatLocalNotifications
{
    for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString * identifier = [localNotification.userInfo valueForKey:@"identifier"];
        if ([[identifier substringFromIndex:identifier.length - 1] isEqualToString:@"J"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

- (void)updateDateForNextDay
{
    if ([Utils getFromTimeFloatValue:[Utils getCurrentTime]] == 0.0) {
        [self cancelJammatLocalNotifications];
        [self creatLocalNotificationsForJammat];
    }
}

@end
