//
//  Utils.m
//  GeoLocator_iOS
//
//  Created by Gor Igityan on 2/19/15.
//  Copyright (c) 2015 VTGSoftware LLC. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)saveFirstRunInfo:(BOOL)isFirstRun
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:isFirstRun forKey:@"first_run"];
        [standardUserDefaults synchronize];
    }
}

+ (BOOL)getFirstRunInfo
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults boolForKey:@"first_run"];
    }
    
    return NO;
}

+ (void)setSettingsAlertShown
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:@"1" forKey:@"isSettingsAlertShown"];
    }
}

+ (BOOL)isSettingsfirstRunAlertShown
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
      return [[standardUserDefaults valueForKey:@"isSettingsAlertShown"] boolValue];
    }
    return NO;
}

+ (NSDate*)today
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSString *todayDateStringWithTimeZone = [dateFormatter stringFromDate:[NSDate date]];
    
    return [dateFormatter dateFromString:todayDateStringWithTimeZone];
}

+ (NSString *)getCurrentTime
{
    NSDateFormatter *date = [NSDateFormatter new];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:locale];
    [date setDateFormat:@"HH:mm"];
    
    return [date stringFromDate:[NSDate date]];
}

+ (float)getFromTimeFloatValue:(NSString *)time
{
    return [[time stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue];
}

@end