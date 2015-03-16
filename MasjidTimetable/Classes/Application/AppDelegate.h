//
//  AppDelegate.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//


int masjidTurn;
int val,val1,val2,val3,val4,val5,val6,alert,mSound;
int counterValue;
int a,xts,l,localDataFetched;
int sound;
BOOL changeFormat;
BOOL isDataFetched;
BOOL isEventsFetched;
BOOL isSearching,fetchFirstTime;
BOOL isColored;
BOOL localDataForSecond;
BOOL localDataForThird;
BOOL localDataForFourth;
NSArray *jsonCalled;
NSArray *globalMasjidNotes,*globalTimeTable,*globalTimeTableFormat,*globalTimeTableValues;
NSMutableArray *globalMasjidBasicValues;
NSMutableArray *arrayList,*newArrayList,*get,*addids,*addpri,*fetchResults;
NSDictionary *checking;
NSMutableDictionary *dictData,*thirdMasjidDictionary;
NSMutableDictionary *globalMasjidNames;
NSString *globalMasjidID;
NSString *fPrayer,*zPrayer,*aPrayer,*mPrayer,*ePrayer,*timetableFormat;
NSString *fajarFormat,*zoharFormat,*asarFormat,*maghribFormat,*eshaFormat,*fajarJFormat,*zoharJFormat,*asarJFormat,*maghribJFormat,*eshaJFormat,*sunsetFormat;
NSString *fajarPrayer,*zoharPrayer,*asarPrayer,*maghribPrayer,*eshaPrayer;
NSString *previousFajar,*previousZohar,*previousAsar,*previousMaghrib,*previousEsha;
NSString *getID,*address,*city,*state,*pin,*country,*telephoneNo;
NSString *fajarJammat,*zoharJammat,*asarJammat,*maghribJammat,*eshaJammat,*fajarBegin,*zoharBegin,*asarBegin,*maghribBegin,*eshaBegin;
NSString *myMonthString,*dVal,*prayerID,*JsonDate,*interval;
NSString *currentEventTime;
UILocalNotification *localNotification;
UIImage *themeImage;
Masjid *primaryMasjid;
MasjidTimetable *primaryTimeTable;
JammatSoundSettings *jammatSoundSettings;

@class PBViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) PBViewController *viewController;

- (void)cancelJammatLocalNotifications;
- (void)creatLocalNotificationsForJammat;
- (void)changeNotificationSound:(BOOL)unMute withNotificationId:(NSString *)Id;



@end

