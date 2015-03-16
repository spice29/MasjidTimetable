//
//  Utils.h
//  GeoLocator_iOS
//
//  Created by Gor Igityan on 2/19/15.
//  Copyright (c) 2015 VTGSoftware LLC. All rights reserved.
//

@interface Utils : NSObject <UIAlertViewDelegate>

+ (void)saveFirstRunInfo:(BOOL)isFirstRun;
+ (BOOL)getFirstRunInfo;
+ (void)setSettingsAlertShown;
+ (BOOL)isSettingsfirstRunAlertShown;
+ (NSDate*)today;
+ (NSString *)getCurrentTime;
+ (float)getFromTimeFloatValue:(NSString *)time;

@end