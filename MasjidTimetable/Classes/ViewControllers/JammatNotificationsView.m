//
//  JammatNotificationsView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "JammatNotificationsView.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import <math.h>
#import "NumberPadDoneBtn.h"
#import "otherSettings.h"
#import "MuteView.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface JammatNotificationsView ()
{
    NSMutableArray *currentMonthData,*alertOnOFF,*previousDayData;
    float alertTime;
    NSArray *json;
    NSInteger tag;
    NSMutableArray *alertsPopup;
    int alertHours,alertMinutes;
    NSArray *ArrayObjects;
    NSString *from,*soundFile;
    int minutes,hours,ii,m,k,l,seconds,xx;
    NSString *prayerAlert,*time,*prayerTime,*prayerTime1,*prayerTime2,*prayerTime3,*prayerTime4;
    NSString *finalAlert,*AlertTag;
    NSTimer *timer;
    NSUserDefaults *userDefaults;
    UIButton *doneButton;
    UIAlertView *timeLimitAlert;
    JammatSoundSettings *soundSettings;
}

@end

@implementation JammatNotificationsView

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
    
    alertsPopup=[[NSMutableArray alloc]init];
    ii=1;
    xx=1;
    self.pickerView.hidden=YES;
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.hidden=YES;
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    ArrayObjects=[NSArray arrayWithObjects:@"Azan",@"Phone Alert",@"None",nil];
    previousDayData=[[NSMutableArray alloc]init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    currentMonthData=[[NSMutableArray alloc]init];
    alertOnOFF=[[NSMutableArray alloc]init];
    
    NSDateFormatter *istDateFormatter1 = [[NSDateFormatter alloc] init];
    [istDateFormatter1 setDateFormat:@"dd-MM-yyyy"];
    myMonthString=[istDateFormatter1 stringFromDate:[NSDate date]];
    NSString *dated=[myMonthString substringToIndex:2];
    if (([dated isEqualToString:@"09"])||([dated isEqualToString:@"07"])||([dated isEqualToString:@"06"])||([dated isEqualToString:@"05"])||([dated isEqualToString:@"04"])||([dated isEqualToString:@"03"])||([dated isEqualToString:@"02"])||([dated isEqualToString:@"01"])) {
        [istDateFormatter1 setDateFormat:@"d-MM-yyyy"];
        myMonthString = [istDateFormatter1 stringFromDate:[NSDate date]];
    }
    self.cancelClickd.layer.cornerRadius=5;
    self.doneClikd.layer.cornerRadius=5;
    self.cancelClickd.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    self.doneClikd.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    self.cancelClickd.layer.borderWidth=2.0f;
    self.doneClikd.layer.borderWidth=2.0f;
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"HH:mm"];
    time = [date stringFromDate:[NSDate date]];
    self.pickerView.layer.cornerRadius=3.6f;
    self.pickerView.clipsToBounds=YES;
    NSString *phone=[userDefaults valueForKey:@"sound"];
    if (phone.length==0 || [phone isEqualToString:@"2"]) {
        self.pickLabel.text=@"Select Alert Type";
    } else if ([phone isEqualToString:@"0"]) {
        self.pickLabel.text=@"Azan";
    } else if ([phone isEqualToString:@"1"]) {
        self.pickLabel.text = @"Phone Alert";
    }
    
    NumberPadDoneBtn *done=[[NumberPadDoneBtn alloc]initWithFrame:CGRectMake(0, 0,1,1)];
    _fajar.inputAccessoryView=done;
    _asar.inputAccessoryView=done;;
    _maghrib.inputAccessoryView=done;
    _esha.inputAccessoryView=done;
    _zohar.inputAccessoryView=done;
    _fajar.inputAccessoryView=done;
    self.asar.inputAccessoryView=done;
    _zohar.inputAccessoryView=done;
    _maghrib.inputAccessoryView=done;
    _esha.inputAccessoryView=done;
    
    _fajar.keyboardType=UIKeyboardTypeNumberPad;
    _asar.keyboardType=UIKeyboardTypeNumberPad;
    _maghrib.keyboardType=UIKeyboardTypeNumberPad;
    _esha.keyboardType=UIKeyboardTypeNumberPad;
    _zohar.keyboardType=UIKeyboardTypeNumberPad;
    _fajar.keyboardAppearance = UIKeyboardAppearanceDark;
    self.asar.keyboardAppearance = UIKeyboardAppearanceDark;
    _zohar.keyboardAppearance = UIKeyboardAppearanceDark;
    _maghrib.keyboardAppearance = UIKeyboardAppearanceDark;
    _esha.keyboardAppearance = UIKeyboardAppearanceDark;
    
    timeLimitAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please set minutes less than 180" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    
    if (![Utils isSettingsfirstRunAlertShown]) {
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Many of these settings may not work until a masjid is selected as a favourite in the Primary position. You can select and set a particular masjid to be your primary favourite by visiting the Select Masjid page from the Dashboard." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        [Utils setSettingsAlertShown];
        [[MTDBHelper sharedDBHelper] createJammatSoundSettings];
    } else {
        [self getFormat];
        [self getDetails];
    }
    soundSettings = [[MTDBHelper sharedDBHelper] getJammatSoundSettings];
    [self alertsValues];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    if (IS_IPAD) {
        self.frstText.font=[UIFont systemFontOfSize:30];
        self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,110, self.frstText.frame.size.width, self.frstText.frame.size.height);
        self.f.font=[UIFont systemFontOfSize:20];
        self.z.font=[UIFont systemFontOfSize:20];
        self.a.font=[UIFont systemFontOfSize:20];
        self.mpray.font=[UIFont systemFontOfSize:20];
        self.e.font=[UIFont systemFontOfSize:20];
        self.fajar.font=[UIFont systemFontOfSize:20];
        self.asar.font=[UIFont systemFontOfSize:20];
        self.maghrib.font=[UIFont systemFontOfSize:20];
        self.zohar.font=[UIFont systemFontOfSize:20];
        self.esha.font=[UIFont systemFontOfSize:20];
        self.prayerName.font=[UIFont systemFontOfSize:22];
        self.alertLabel.font=[UIFont systemFontOfSize:22];
        self.minsBf.font=[UIFont systemFontOfSize:22];
        self.minsBf.frame=CGRectMake(305, self.minsBf.frame.origin.y,self.minsBf.frame.size.width,self.minsBf.frame.size.height);
        self.alertLabel.frame=CGRectMake(560, self.alertLabel.frame.origin.y,self.alertLabel.frame.size.width,self.alertLabel.frame.size.height);
        self.pickLabel.font=[UIFont systemFontOfSize:18];
        self.notification.font=[UIFont systemFontOfSize:22];
        self.pickerView.frame=CGRectMake(16,720,728,243);
        self.doneClikd.frame=CGRectMake(574,1,150,55);
        self.doneClikd.titleLabel.font=[UIFont systemFontOfSize:19];
        self.tablePicker.frame=CGRectMake(self.tablePicker.frame.origin.x,self.tablePicker.frame.origin.y,700,self.tablePicker.frame.size.height);
    } else {
        if(IS_IPHONE_6P) {
            self.frstText.font=[UIFont systemFontOfSize:15];
            self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,80, self.frstText.frame.size.width, self.frstText.frame.size.height);
        } else if(IS_IPHONE_6) {
            self.frstText.font=[UIFont systemFontOfSize:15];
            self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,80, self.frstText.frame.size.width, self.frstText.frame.size.height);
            self.pickerView.frame=CGRectMake(12,474,352,135);
            self.doneClikd.frame=CGRectMake(278,0,73,30);
        } else if(IS_IPHONE_5) {
            self.frstText.font=[UIFont systemFontOfSize:13];
            self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,77, self.frstText.frame.size.width, self.frstText.frame.size.height);
            self.pickerView.frame=CGRectMake(12,500,297,110);
            self.doneClikd.frame=CGRectMake(222,0,73,30);
        }
    }
    
    xx=1;
    doneButton.hidden=YES;
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)//(cim == nil && cgref == NULL)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocalNotifications)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];

    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self updateLocalNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [super viewWillDisappear:animated];
}

-(void)alertsValues
{
    NSString *popup=[userDefaults valueForKey:@"popup"];
    NSString *phone=[userDefaults valueForKey:@"sound"];
    if (!soundSettings.fajarOn) {
        [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
    } else {
        [_fajarAlert setImage:[UIImage imageNamed:@"on2.png"]];
        _fajar.text = [soundSettings.fajarJammatTime intValue] == 0 ? @"" : soundSettings.fajarJammatTime;
    }
    if (!soundSettings.zoharOn) {
        [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
    } else {
        [_zoharAlert setImage:[UIImage imageNamed:@"on2.png"]];
        _zohar.text = [soundSettings.zoharJammatTime intValue] == 0 ? @"" : soundSettings.zoharJammatTime;
    }
    if (!soundSettings.asarOn) {
        [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
    } else {
        [_asarAlert setImage:[UIImage imageNamed:@"on2.png"]];
        _asar.text = [soundSettings.asarJammatTime intValue] == 0 ? @"" : soundSettings.asarJammatTime;
    }
    if (!soundSettings.maghribOn) {
        [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
    } else {
        [_magribAlert setImage:[UIImage imageNamed:@"on2.png"]];
        _maghrib.text = [soundSettings.maghribJammatTime intValue] == 0 ? @"" : soundSettings.maghribJammatTime;
    }
    if (!soundSettings.eshaOn) {
        [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
    } else {
        [_eshaAlert setImage:[UIImage imageNamed:@"on2.png"]];
        _esha.text = [soundSettings.eshaJammatTime intValue] == 0 ? @"" : soundSettings.eshaJammatTime;

    }
    if (popup.length==0 || [popup isEqualToString:@"0"]) {
        [_popupAlert setImage:[UIImage imageNamed:@"off2.png"]];
    } else {
        [_popupAlert setImage:[UIImage imageNamed:@"on2.png"]];
    }
    if (phone.length==0 || [phone isEqualToString:@"0"]) {
        
        [_radio1 setImage:[UIImage imageNamed:@"off.png"]];
        [_radio2 setImage:[UIImage imageNamed:@"on.png"]];
        m=0;
    } else {
        [_radio1 setImage:[UIImage imageNamed:@"on.png"]];
        [_radio2 setImage:[UIImage imageNamed:@"off.png"]];
        m=1;
    }
    if ([soundSettings.soundName isEqualToString:UILocalNotificationDefaultSoundName]) {
    } else if ([soundSettings.soundName containsString:@"azan"]) {
        [self.pickLabel setText:@"Azan"];
    } else {
        [self.pickLabel setText:@"Phone Alert"];
        [self.pickLabel setText:@"Select Alert type"];
    }
}

-(void)getFormat
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSInteger monthVal = [components month];
    NSArray *jsonGet;
    if (masjidTurn==1) {
        jsonGet=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat"];
    } else if (masjidTurn==2) {
        jsonGet=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat1"];
        if ([jsonGet count]==0) {
            jsonGet=globalTimeTableFormat;
        }
    } else if (masjidTurn==3) {
        jsonGet=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat2"];
        if ([jsonGet count]==0) {
            jsonGet=globalTimeTableFormat;
        }
    } else if (masjidTurn==4) {
        jsonGet=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat2"];
        if ([jsonGet count]==0) {
            jsonGet=globalTimeTableFormat;
        }
    }
    for (int val=0;val<[jsonGet count];val++) {
        NSString *getMnth=[[jsonGet valueForKey:@"timetable_month"]objectAtIndex:val];
        getMnth=[getMnth substringWithRange:NSMakeRange(5,2)];
        if ([getMnth intValue] == monthVal) {
            timetableFormat=[[jsonGet valueForKey:@"timetable_format"]objectAtIndex:val];
        }
    }
}

-(void)changePrayerValues
{
    if ([timetableFormat intValue] == 12) {
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setDateFormat:@"hh:mm a"];
        NSDate* wakeTime = [df dateFromString:[NSString stringWithFormat:@"%@ AM",fajarBegin]];
        NSDate* wakeTime1 = [df dateFromString:[NSString stringWithFormat:@"%@ AM",fajarJammat]];
        NSDate* wakeTime10 = [df dateFromString:[NSString stringWithFormat:@"%@ AM",sunsetFormat]];
        NSDate* wakeTime2 = [df dateFromString:[NSString stringWithFormat:@"%@ AM",zoharBegin]];
        NSDate* wakeTime3 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",zoharJammat]];
        NSDate* wakeTime4 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",asarBegin]];
        NSDate* wakeTime5 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",asarJammat]];
        NSDate* wakeTime6 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",maghribBegin]];
        NSDate* wakeTime7 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",maghribJammat]];
        NSDate* wakeTime8 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",eshaBegin]];
        NSDate* wakeTime9 = [df dateFromString:[NSString stringWithFormat:@"%@ PM",eshaJammat]];
        [df setDateFormat:@"HH:mm"];
        
        fajarFormat=[df stringFromDate:wakeTime];
        fajarJFormat=[df stringFromDate:wakeTime1];
        zoharFormat=[df stringFromDate:wakeTime2];
        zoharJFormat=[df stringFromDate:wakeTime3];
        asarFormat=[df stringFromDate:wakeTime4];
        asarJFormat=[df stringFromDate:wakeTime5];
        maghribFormat=[df stringFromDate:wakeTime6];
        maghribJFormat=[df stringFromDate:wakeTime7];
        eshaFormat=[df stringFromDate:wakeTime8];
        eshaJFormat=[df stringFromDate:wakeTime9];
        sunsetFormat=[df stringFromDate:wakeTime10];
    } else {
        fajarFormat=fajarBegin;
        fajarJFormat=fajarJammat;
        zoharFormat=zoharBegin;
        zoharJFormat=zoharJammat;
        asarFormat=asarBegin;
        asarJFormat=asarJammat;
        maghribFormat=maghribBegin;
        maghribJFormat=maghribJammat;
        eshaFormat=eshaBegin;
        eshaJFormat=eshaJammat;
    }
}

-(void)getDetails
{
    if (masjidTurn==1) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable"];
    } else if (masjidTurn==2) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable1"];
        if ([json count]==0) {
            json=globalTimeTable;
        }
    } else if (masjidTurn==3) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable2"];
        if ([json count]==0) {
            json=globalTimeTable;
        }
    } else if (masjidTurn==4) {
        json=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTable3"];
        if ([json count]==0) {
            json=globalTimeTable;
        }
    }
    for (int i=0;i<[json count];i++) {
        if ([[json valueForKey:@"DATE"][i]isEqualToString:myMonthString])
        {
            [currentMonthData addObject:json[i]];
        }
    }
    if (currentMonthData.count!=0) {
        fajarBegin=[[currentMonthData valueForKey:@"Subah Sadiq"]objectAtIndex:0];
        dVal = [fajarBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        fajarJammat=[[currentMonthData valueForKey:@"Fajar"]objectAtIndex:0];
        dVal = [fajarJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        zoharJammat=[[currentMonthData valueForKey:@"Zohar-j"]objectAtIndex:0];
        dVal = [zoharJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        zoharBegin=[[currentMonthData valueForKey:@"Zohar"]objectAtIndex:0];
        dVal = [zoharBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        asarJammat=[[currentMonthData valueForKey:@"Asar-j"]objectAtIndex:0];
        dVal = [asarJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        asarBegin=[[currentMonthData valueForKey:@"Asar"]objectAtIndex:0];
        dVal = [asarBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        maghribJammat=[[currentMonthData valueForKey:@"Maghrib"]objectAtIndex:0];
        dVal = [maghribJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        maghribBegin=[[currentMonthData valueForKey:@"Sunset"]objectAtIndex:0];
        dVal = [maghribBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        eshaJammat=[[currentMonthData valueForKey:@"Esha-j"]objectAtIndex:0];
        dVal = [eshaJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        eshaBegin=[[currentMonthData valueForKey:@"Esha"]objectAtIndex:0];
        dVal = [eshaBegin stringByReplacingOccurrencesOfString:@":" withString:@"."];
        
        sunsetFormat=[[currentMonthData valueForKey:@"Sunrise"]objectAtIndex:0];
        JsonDate =[[currentMonthData valueForKey:@"DATE"]objectAtIndex:0];
    }
    [self previousDayValues];
    [self changePrayerValues];
}

-(void)previousDayValues
{
    NSDate* date = [NSDate date];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.day = -1;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* yesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"d-MM-yyyy";
    NSString* dateString = [formatter stringFromDate:yesterday];
    for (int i=0;i<[json count];i++) {
        if ([[json valueForKey:@"DATE"][i]isEqualToString:dateString])
        {
            [previousDayData addObject:json[i]];
        }
    }
    if ([previousDayData count] > 0) {
        previousFajar=[[previousDayData valueForKey:@"Fajar"]objectAtIndex:0];
        previousZohar=[[previousDayData valueForKey:@"Zohar-j"]objectAtIndex:0];
        previousAsar=[[previousDayData valueForKey:@"Asar-j"]objectAtIndex:0];
        previousMaghrib=[[previousDayData valueForKey:@"Sunset"]objectAtIndex:0];
        previousEsha=[[previousDayData valueForKey:@"Esha-j"]objectAtIndex:0];
    }
}

-(void)callActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select anyone to be notified XX minutes before prayer time"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Notify before Beginning time", @"Notify before Jammat time",
                                  nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if (tag==0) {
                prayerTime=fajarFormat;
                prayerID=@"0";
                [self fajarAction];
            }
            else if (tag==1) {
                prayerTime1=zoharFormat;
                prayerID=@"1";
                [self callZohar];
            }
            else if (tag==2) {
                prayerTime2=asarFormat;
                prayerID=@"2";
                [self callASAR];
            }
            else if (tag==3) {
                prayerTime3=maghribFormat;
                prayerID=@"3";
                [self callMaghrib];
            }
            else if (tag==4) {
                prayerTime4=eshaFormat;
                prayerID=@"4";
                [self callEsha];
            }
            
            break;
        }
        case 1:
        {
            if (tag==0) {
                prayerTime=fajarJFormat;
                prayerID=@"5";
                [self fajarAction];
            }
            else if (tag==1) {
                prayerTime1=zoharJFormat;
                prayerID=@"6";
                [self callZohar];
            }
            else if (tag==2) {
                prayerTime2=asarJFormat;
                prayerID=@"7";
                [self callASAR];
            }
            else if (tag==3) {
                prayerTime3=maghribJFormat;
                prayerID=@"8";
                [self callMaghrib];
            }
            else if (tag==4) {
                prayerTime4=eshaJFormat;
                prayerID=@"9";
                [self callEsha];
            }
            
            break;
        }
            
    }
}

-(void)fajarAction
{
    [_fajarAlert setImage:[UIImage imageNamed:@"on2.png"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *endDate=[formatter dateFromString:fajarJFormat];
    int interval=[_fajar.text intValue];
    NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*120];
    NSString *chekDate =[formatter stringFromDate:newDate];
    fajarPrayer=_fajar.text;
    from=[NSString stringWithFormat:@"%@ %@",myMonthString,chekDate];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"fajar"];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Fajar Jammat in",_fajar.text,@"minutes"];
    k=1;
    [self getTimeIntervals];
}

-(void)alertValues
{
    NSString *alrt=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange: NSMakeRange(0, [[NSString stringWithFormat:@"%f",alertTime] rangeOfString:@"."].location)];
    if ([alrt isEqualToString:@"7"]) {
        alrt=@"07";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else if ([alrt isEqualToString:@"6"]) {
        alrt=@"06";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else  if ([alrt isEqualToString:@"5"]) {
        alrt=@"05";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else  if ([alrt isEqualToString:@"4"]) {
        alrt=@"04";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else  if ([alrt isEqualToString:@"3"]) {
        alrt=@"03";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else if ([alrt isEqualToString:@"2"]) {
        alrt=@"02";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else  if ([alrt isEqualToString:@"1"]) {
        alrt=@"01";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else if ([alrt isEqualToString:@"9"]) {
        alrt=@"09";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else if ([alrt isEqualToString:@"8"]) {
        alrt=@"08";
        NSString *minutesTime=[[NSString stringWithFormat:@"%f",alertTime]substringWithRange:NSMakeRange(2,2)];
        finalAlert=[NSString stringWithFormat:@"%@:%@",alrt,minutesTime];
    }
    else
    {
        NSString *alert = [NSString stringWithFormat:@"%f",alertTime];
        alert=[alert stringByReplacingOccurrencesOfString:@"." withString:@":"];
        alert= [alert substringToIndex:5];
        finalAlert=alert;
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
    if (mSound==0) {
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    } else {
        [localNotification setSoundName:@"makkahAzan.wav"];
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:prayerID forKey:@"buttonTag"];
    localNotification.userInfo = userInfo;
    localNotification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)cancelAlarm
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        NSDictionary *userInfo = notification.userInfo;
        if ([prayerID isEqualToString:[userInfo objectForKey:@"buttonTag"]]){
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

-(void)getTimeIntervals
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *serDate;
    NSDate *endDate;
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    serDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",myMonthString,time]];
    endDate = [formatter dateFromString:from];
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    minutes = timeDifference / 60;
    hours = minutes / 60;
    seconds = timeDifference;
    if (hours<0 || minutes<0) {
        if (k==1) {
            [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"fajar"];
        } else if (k==2) {
            [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zohar"];
        } else  if (k==3) {
            [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"asar"];
        } else  if (k==4) {
            [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"maghrib"];
        } else  if (k==5) {
            [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"esha"];
        }
    } else
    {
        [self getNotifications];
    }
}

-(void)getNotifications
{
    if (!localNotification)
        return;
    int hrs=hours *3600;
    int mins=minutes*60;
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    
    if (mSound==0) {
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    } else {
        [localNotification setSoundName:@"makkahAzan.wav"];
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:prayerID forKey:@"buttonTag"];
    localNotification.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [self performSelector:@selector(sendNotificationSound) withObject:self afterDelay:(hrs+mins)];
}

-(void)sendNotificationSound
{
    if (tag==0) {
        [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"fajar"];
    }
    else if (tag==1) {
        [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"zohar"];
    }
    else  if (tag==2) {
        [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"asar"];
    }
    else  if (tag==3) {
        [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"maghrib"];
    }
    else  if (tag==4) {
        [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"esha"];
    }
    else if (tag==5) {
        [_popupAlert setImage:[UIImage imageNamed:@"off2.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"popup"];
    }
    else if (tag==7) {
        [_radio2 setImage:[UIImage imageNamed:@"on.png"]];
        [_radio1 setImage:[UIImage imageNamed:@"off.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"sound"];
    }
    else if (tag==8) {
        [_radio2 setImage:[UIImage imageNamed:@"off.png"]];
        [_radio1 setImage:[UIImage imageNamed:@"on.png"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"sound"];
    }
    [self alertsValues];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_fajar isFirstResponder]) {
        doneButton.hidden=YES;
        [_fajar resignFirstResponder];
    }
    if ([_zohar isFirstResponder]) {
        doneButton.hidden=YES;
        [_zohar resignFirstResponder];
    }
    if ([_asar isFirstResponder]) {
        doneButton.hidden=YES;
        [_asar resignFirstResponder];
    }
    if ([_maghrib isFirstResponder]) {
        doneButton.hidden=YES;
        [_maghrib resignFirstResponder];
    }
    if ([_esha isFirstResponder]) {
        doneButton.hidden=YES;
        [_esha resignFirstResponder];
    }
}



-(void)callZohar
{
    [_zoharAlert setImage:[UIImage imageNamed:@"on2.png"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *endDate=[formatter dateFromString:zoharJFormat];
    int interval=[_zohar.text intValue];
    NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*120];
    NSString *chekDate =[formatter stringFromDate:newDate];
    zoharPrayer=_zohar.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"zohar"];
    k=2;
    [self getTimeIntervals];
}

-(void)callASAR
{
    [_asarAlert setImage:[UIImage imageNamed:@"on2.png"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *endDate=[formatter dateFromString:asarJFormat];
    int interval=[_asar.text intValue];
    NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*120];
    NSString *chekDate =[formatter stringFromDate:newDate];
    asarPrayer=_asar.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"asar"];
    k=3;
    [self getTimeIntervals];
}

-(void)callMaghrib
{
    [_magribAlert setImage:[UIImage imageNamed:@"on2.png"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *endDate=[formatter dateFromString:maghribJFormat];
    int interval=[_maghrib.text intValue];
    NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*120];
    NSString *chekDate =[formatter stringFromDate:newDate];
    maghribPrayer=_maghrib.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"maghrib"];
    k=4;
    [self getTimeIntervals];
}


-(void)callEsha
{
    [_eshaAlert setImage:[UIImage imageNamed:@"on2.png"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *endDate=[formatter dateFromString:eshaJFormat];
    int interval=[_esha.text intValue];
    NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*120];
    NSString *chekDate =[formatter stringFromDate:newDate];
    eshaPrayer=_esha.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"esha"];
    k=5;
    [self getTimeIntervals];
}

-(void)popupAlerts
{
    AlertTag=@"16";
    alertHours=[[zoharJFormat substringToIndex:2]intValue];
    alertMinutes=[[zoharJFormat substringWithRange:NSMakeRange(3,2)]intValue];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Zohar Jamaat in",_zohar.text,@"minutes"];
    [alertsPopup addObject:AlertTag];
    [self fireAlarmForPopup];
    AlertTag=@"15";
    alertHours=[[fajarJFormat substringToIndex:2]intValue];
    alertMinutes=[[fajarJFormat substringWithRange:NSMakeRange(3,2)]intValue];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Fajar Jamaat in",_fajar.text,@"minutes"];
    [alertsPopup addObject:AlertTag];
    [self fireAlarmForPopup];
    
    AlertTag=@"17";
    alertHours=[[asarJFormat substringToIndex:2]intValue];
    alertMinutes=[[asarJFormat substringWithRange:NSMakeRange(3,2)]intValue];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Asar Jamaat in",_asar.text,@"minutes"];
    [alertsPopup addObject:AlertTag];
    [self fireAlarmForPopup];
    
    AlertTag=@"18";
    alertHours=[[maghribJFormat substringToIndex:2]intValue];
    alertMinutes=[[maghribJFormat substringWithRange:NSMakeRange(3,2)]intValue];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Maghrib Jamaat in",_maghrib.text,@"minutes"];
    [alertsPopup addObject:AlertTag];
    [self fireAlarmForPopup];
    
    AlertTag=@"19";
    alertHours=[[eshaJFormat substringToIndex:2]intValue];
    alertMinutes=[[eshaJFormat substringWithRange:NSMakeRange(3,2)]intValue];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Esha Jamaat in",_esha.text,@"minutes"];
    [alertsPopup addObject:AlertTag];
    [self fireAlarmForPopup];
    [[NSUserDefaults standardUserDefaults]setObject:alertsPopup forKey:@"alertsForPopup"];
}

-(void)fireAlarmForPopup
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
    
    localNotification.fireDate =next9am;
    localNotification.alertBody=prayerAlert;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:AlertTag forKey:@"Tags"];
    localNotification.userInfo = userInfo;
    localNotification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)cancelPopup
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        NSDictionary *userInfo = notification.userInfo;
        NSArray *ids=[[NSArray alloc]initWithObjects:@"15",@"16",@"17",@"18",@"19",nil];
        for (int c=0;c<[ids count];c++)
        {
            if ([[userInfo objectForKey:@"popupTag"]isEqualToString:ids[c]]){
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

-(void)getPopupAlert
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *endDate=[formatter dateFromString:fajarJFormat];
    int interval=[_fajar.text intValue];
    NSDate *newDate = [endDate dateByAddingTimeInterval:-interval*120];
    NSString *chekDate =[formatter stringFromDate:newDate];
    fajarPrayer=_fajar.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Fajar Jamaat in",_fajar.text,@"minutes"];
    [self getTimeIntervals2];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    NSDate *endDate1=[formatter1 dateFromString:zoharJFormat];
    int interval1=[_zohar.text intValue];
    NSDate *newDate1 = [endDate1 dateByAddingTimeInterval:-interval1*120];
    NSString *chekDate1 =[formatter1 stringFromDate:newDate1];
    zoharPrayer=_zohar.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate1];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Zohar Jamaat in",_zohar.text,@"minutes"];
    [self getTimeIntervals2];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH:mm"];
    NSDate *endDate2=[formatter2 dateFromString:asarJFormat];
    int interval2=[_asar.text intValue];
    NSDate *newDate2 = [endDate2 dateByAddingTimeInterval:-interval2*120];
    NSString *chekDate2 =[formatter2 stringFromDate:newDate2];
    asarPrayer=_asar.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate2];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Asar Jamaat in",_asar.text,@"minutes"];
    [self getTimeIntervals2];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"HH:mm"];
    NSDate *endDate3=[formatter3 dateFromString:maghribJFormat];
    int interval3=[_maghrib.text intValue];
    NSDate *newDate3 = [endDate3 dateByAddingTimeInterval:-interval3*120];
    NSString *chekDate3 =[formatter3 stringFromDate:newDate3];
    maghribPrayer=_maghrib.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate3];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Maghrib Jamaat in",_maghrib.text,@"minutes"];
    [self getTimeIntervals2];
    NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
    [formatter4 setDateFormat:@"HH:mm"];
    NSDate *endDate4=[formatter4 dateFromString:eshaJFormat];
    int interval4=[_esha.text intValue];
    NSDate *newDate4= [endDate4 dateByAddingTimeInterval:-interval4*120];
    NSString *chekDate4 =[formatter4 stringFromDate:newDate4];
    eshaPrayer=_esha.text;
    from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate4];
    prayerAlert=[NSString stringWithFormat:@"%@ %@ %@",@"Esha Jamaat in",_esha.text,@"minutes"];
    [self getTimeIntervals2];
    prayerID=@"10";
}

-(void)getTimeIntervals2
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *serDate;
    NSDate *endDate;
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    serDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",myMonthString,time]];
    endDate = [formatter dateFromString:from];
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    
    minutes = timeDifference / 60;
    hours = minutes / 60;
    seconds = timeDifference;
    
    if (hours<0 || minutes<0) {
        [_popupAlert setImage:[UIImage imageNamed:@"off2.png"]];
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"popup"];
    }
    else
    {
        [_popupAlert setImage:[UIImage imageNamed:@"on2.png"]];
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"popup"];
        if (!localNotification)
            return;
        [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        [localNotification setAlertBody:prayerAlert];
        [localNotification setAlertAction:@"Alert"];
        [localNotification setHasAction:YES];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        timer=[NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(soundNotifications) userInfo:nil repeats:NO];
    }
}

-(void)soundNotifications
{
    [_popupAlert setImage:[UIImage imageNamed:@"off2.png"]];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"popup"];
    [timer invalidate];
    timer=nil;
}

- (IBAction)miscClicked {
    JammatNotificationsView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"jammatNotifications"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)otherClicked {
    otherSettings *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"otherSettings"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)muteClicked {
    MuteView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"muteView"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)jammatClicked {}

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

- (void)updateLocalNotifications
{
    [[MTDBHelper sharedDBHelper] saveContext];
    [Appdelegate cancelJammatLocalNotifications];
    [Appdelegate creatLocalNotificationsForJammat];
}

#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
    return [ArrayObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    UILabel *myLabel;
    UIView *gradientBack;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        myLabel=[[UILabel alloc]init];
        gradientBack=[[UIView alloc]init];
        myLabel.frame=CGRectMake(0,2,160,28);
        gradientBack.frame=CGRectMake(0,2,160,28);
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = gradientBack.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1.0]CGColor], (id)[[UIColor colorWithRed:214.0f/255.0f green:214.0f/255.0f blue:214.0f/255.0f alpha:1.0]CGColor], nil];
        [gradientBack.layer insertSublayer:gradientLayer atIndex:0];
        
        [cell.contentView addSubview:gradientBack];
        [cell.contentView addSubview:myLabel];
        [cell.contentView bringSubviewToFront:myLabel];
    }
    [self.tablePicker bringSubviewToFront:myLabel];
    myLabel.textColor=[UIColor blackColor];
    myLabel.textAlignment=NSTextAlignmentLeft;
    myLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold"size:12];
    myLabel.text=[ArrayObjects objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Textfield's delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 3 && range.length == 0) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text integerValue]> 180) {
        [timeLimitAlert show];
        textField.text = @"";
    } else {
        if ([textField isEqual:self.fajar]) {
            soundSettings.fajarJammatTime = textField.text;
        } else if ([textField isEqual:self.zohar]) {
            soundSettings.zoharJammatTime = textField.text;
        } else if ([textField isEqual:self.asar]) {
            soundSettings.asarJammatTime = textField.text;
        } else if ([textField isEqual:self.maghrib]) {
            soundSettings.maghribJammatTime = textField.text;
        } else {
            soundSettings.eshaJammatTime = textField.text;
        }
        [[MTDBHelper sharedDBHelper] saveContext];
    }
    [self animateTextField: textField up: NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

#pragma mark - Picker actions

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [ArrayObjects count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [ArrayObjects objectAtIndex:row];
}


-(UIView *)pickerView:(UIPickerView *)pickerViews viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerViews.frame.size.width, 44)];
    if (pickerViews==self.tablePicker) {
        float fontSize = IS_IPAD ? 30.0 : 18.0;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
        label.text = [ArrayObjects objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    return label;
}

-(void)pickerView:(UIPickerView *)pickerViews didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
    if (row==0) {
        self.pickLabel.text = @"Azan";
        soundSettings.soundName = @"azan.wav";
        xx=1;
        mSound=1;
    } else if (row==1) {
        self.pickLabel.text = @"Phone Alert";
        soundSettings.soundName = UILocalNotificationDefaultSoundName;
        xx=1;
        mSound=0;
    } else if (row==2) {
        self.pickLabel.text=@"Select Alert Type";
        soundSettings.soundName = @"None";
        xx=1;
        mSound=0;
    }
    [[MTDBHelper sharedDBHelper] saveContext];
}

#pragma mark - Switch actions

- (IBAction)popupAlertONOFF:(UIButton *)sender
{
    alert = 1;
    tag = sender.tag;
    switch (tag) {
        case 5:
            if ([[userDefaults valueForKey:@"popup"]isEqualToString:@"1"]) {
                [_popupAlert setImage:[UIImage imageNamed:@"off2.png"]];
                [self cancelPopup];
                [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"popup"];
            } else {
                [_popupAlert setImage:[UIImage imageNamed:@"on2.png"]];
                [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"popup"];
                [self popupAlerts];
            }
            break;
    }
}

- (IBAction)alertOnOffClick:(UIButton *)sender
{
    if ([self.fajar.text intValue] <= 180) {
            alert=1;
            tag=sender.tag;
            if (soundSettings.fajarOn) {
                prayerID=@"5";
                [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
                [self cancelAlarm];
                soundSettings.fajarOn = NO;
            } else {
                [_fajarAlert setImage:[UIImage imageNamed:@"on2.png"]];
                prayerID=@"5";
                [self fireAlarm];
                soundSettings.fajarOn = YES;
            }
        [[MTDBHelper sharedDBHelper] saveContext];
    } else {
        [timeLimitAlert show];
        self.fajar.text = @"";
    }
}

- (IBAction)zoharAlertOnOFF:(UIButton *)sender
{
    if ([self.zohar.text intValue] <= 180) {
            alert=1;
            tag = sender.tag;
            if (tag == 1) {
                prayerID=@"6";
                if (soundSettings.zoharOn){
                    [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
                    [self cancelAlarm];
                    soundSettings.zoharOn = NO;
                } else {
                    [_zoharAlert setImage:[UIImage imageNamed:@"on2.png"]];
                    [self fireAlarm];
                    soundSettings.zoharOn = YES;
                }
                [[MTDBHelper sharedDBHelper] saveContext];
            }
    } else {
        [timeLimitAlert show];
        self.zohar.text = @"";
    }
}

- (IBAction)magribONOFF:(UIButton *)sender
{
    if ([self.maghrib.text intValue] <= 180) {
            alert=1;
            tag=sender.tag;
            if (tag == 3) {
                prayerID=@"8";
                if (soundSettings.maghribOn) {
                    [self cancelAlarm];
                    [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
                    soundSettings.maghribOn = NO;
                } else {
                    [_magribAlert setImage:[UIImage imageNamed:@"on2.png"]];
                    [self fireAlarm];
                    soundSettings.maghribOn = YES;
                }
                [[MTDBHelper sharedDBHelper] saveContext];
            }
    } else {
        [timeLimitAlert show];
        self.maghrib.text = @"";
    }
}

- (IBAction)asarOnOFF:(UIButton *)sender
{
    if ([self.asar.text intValue] <= 180) {
            alert=1;
            tag=sender.tag;
            if (tag == 2) {
                if (soundSettings.asarOn) {
                    [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
                    [self cancelAlarm];
                    soundSettings.asarOn = NO;
                } else {
                    prayerID=@"7";
                    [_asarAlert setImage:[UIImage imageNamed:@"on2.png"]];
                    [self fireAlarm];
                    soundSettings.asarOn = YES;
                }
                [[MTDBHelper sharedDBHelper] saveContext];
            }
    } else {
        [timeLimitAlert show];
        self.asar.text = @"";
    }
}

- (IBAction)eshaONOFF:(UIButton *)sender
{
    if ([self.esha.text intValue] <= 180) {
            alert=1;
            tag=sender.tag;
                    prayerID=@"9";
                    if (soundSettings.eshaOn) {
                        [self cancelAlarm];
                        [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
                        soundSettings.eshaOn = NO;
                    } else {
                        [_eshaAlert setImage:[UIImage imageNamed:@"on2.png"]];
                        [self fireAlarm];
                        soundSettings.eshaOn = YES;
                    }
        [[MTDBHelper sharedDBHelper] saveContext];
    } else {
        [timeLimitAlert show];
        self.esha.text = @"";
    }
}

#pragma mark - Actions

- (IBAction)btnAction
{
    if (xx==0) {
        [UIView animateWithDuration:0.7
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.pickerView.frame=CGRectMake(self.pickerView.frame.origin.x,self.pickerView.frame.origin.y, self.pickerView.frame.size.width,0);
                             self.tablePicker.hidden=YES;
                         }
                         completion:^(BOOL finished){
                             [self.doneClikd setTitle:@"" forState:UIControlStateNormal];
                             [self.cancelClickd setTitle:@"" forState:UIControlStateNormal];
                             self.tablePicker.hidden=YES;
                         }];
        xx=1;
    } else if (xx==1) {
        CGRect pickerFrame;
        CGRect doneClickedFrame;
        CGRect tablePickerFram;
        if (IS_IPAD) {
            pickerFrame = CGRectMake(16,720,728,243);
            doneClickedFrame = CGRectMake(576,1,150,55);
            tablePickerFram = CGRectMake(-8,-35,750,267);
        } else {
            tablePickerFram = CGRectMake(-8,-35,316,86);
            if(IS_IPHONE_6) {
                pickerFrame = CGRectMake(12,474,352,136);
                doneClickedFrame = CGRectMake(278,0.5,73,30);
            } else if(IS_IPHONE_5) {
                pickerFrame = CGRectMake(12,400,297,110);;
                doneClickedFrame = CGRectMake(222,0,73,30);
            } else {
                pickerFrame = CGRectMake(self.pickerView.frame.origin.x,self.pickerView.frame.origin.y, self.pickerView.frame.size.width,83);
                doneClickedFrame = CGRectMake(230,0,73,30);
            }
        }
        [UIView animateWithDuration:0.7 delay: 0.0  options: UIViewAnimationOptionCurveEaseIn animations:^{
            self.pickerView.alpha=1.0;
            self.pickerView.frame = pickerFrame;
            [self.doneClikd setTitle:@"Done" forState:UIControlStateNormal];
            [self.cancelClickd setTitle:@"Cancel" forState:UIControlStateNormal];
            self.doneClikd.hidden=NO;
            self.cancelClickd.hidden=NO;
            self.cancelClickd.frame=CGRectMake(-1,0,73,30);
            self.doneClikd.frame = doneClickedFrame;
            self.tablePicker.frame=tablePickerFram;
            self.pickerView.hidden=NO;
        } completion:^(BOOL finished){
            self.tablePicker.hidden = NO;
        }];
        xx=0;
    }
}

- (IBAction)donePicker
{
    CGFloat originY = IS_IPHONE_5 ? 400 : self.pickerView.frame.origin.y;
    
    [UIView animateWithDuration:0.7
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.pickerView.frame=CGRectMake(self.pickerView.frame.origin.x, originY, self.pickerView.frame.size.width,0);
                         self.tablePicker.hidden=YES;
                     }
                     completion:^(BOOL finished){
                         [self.doneClikd setTitle:@"" forState:UIControlStateNormal];
                         [self.cancelClickd setTitle:@"" forState:UIControlStateNormal];
                         self.tablePicker.hidden=YES;
                     }];
    
    xx=1;
}

- (IBAction)cancelPicker
{
    self.pickLabel.text=@"Select alert type";
    [UIView animateWithDuration:0.7
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.pickerView.frame=CGRectMake(self.pickerView.frame.origin.x,self.pickerView.frame.origin.y, self.pickerView.frame.size.width,0);
                         self.tablePicker.hidden=YES;
                     }
                     completion:^(BOOL finished){
                         [self.doneClikd setTitle:@"" forState:UIControlStateNormal];
                         [self.cancelClickd setTitle:@"" forState:UIControlStateNormal];
                         self.tablePicker.hidden=YES;
                     }];
    xx=1;
    
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"sound"];
    mSound=0;
    xx=1;
}

- (IBAction)soundAlert:(UIButton *)sender
{
    alert=1;
    tag=sender.tag;
    switch (tag) {
        case 6:
            if ([[userDefaults valueForKey:@"sound"]isEqualToString:@"0"]) {
                [_radio2 setImage:[UIImage imageNamed:@"on.png"]];
                [_radio1 setImage:[UIImage imageNamed:@"off.png"]];
                mSound=0;
                [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"sound"];
            } else {
                [_radio1 setImage:[UIImage imageNamed:@"on.png"]];
                [_radio2 setImage:[UIImage imageNamed:@"off.png"]];
                mSound=1;
                [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"sound"];
            }
            break;
    }
}

@end
