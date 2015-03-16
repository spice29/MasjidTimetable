//
//  otherSettings.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "otherSettings.h"
#import "JammatNotificationsView.h"
#import "MuteView.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface otherSettings ()
{
    int m,pickerValue,hourPickerValue;
    int EshaAb;
    NSArray *json;
    int dateIndex;
    int jamaat,days,hours;
    BOOL EshaAlert,FajarAlert,AsarAlert,MaghribAlert,ZoharAlert;
    NSMutableArray *uniqueId;
    NSArray *hoursValue,*daysValues,*arrayListX,*arrayList2,*jammatTime;
    NSArray *eventTitle,*eventDetail,*eventDate;
    NSMutableArray *getMutableData,*getHours,*getMutableTime,*mutableFajar,*mutableAsar,*mutableZohar,*mutableMaghrib,*mutableEsha;
    int alertHours,alertMinutes, eshaCount,fajarCount,zoharCount,maghribCount,asarCount;
    NSString *from,*date,*intervalString,*prayerAlert,*XXAlert,*XXDate;
    NSString *FFAlert,*FFDate,*JJDate,*JJAlert,*aaAlert,*aaDate,*mmAlert,*mmDate;
    int minutes,hour,a,seconds,intervals,hoursInterval,month,i,jammatInterval;
    NSArray *jsonDict,*alertDateArray;
    BOOL isNotified;
    NSMutableArray *fajarArray;
    NSMutableArray *zoharArray;
    NSMutableArray *asarArray;
    NSMutableArray *maghribArray;
    NSMutableArray *eshaArray;
    NSMutableArray *dateArray;
}

@end

@implementation otherSettings

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

- (IBAction)miscClicked {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m=0;
    EshaAlert=NO;
    FajarAlert=NO;ZoharAlert=NO;MaghribAlert=NO;AsarAlert=NO;
    pickerValue=0;
    hourPickerValue=0;
    jamaat=0;
    hours=0;
    days=0;
    eshaCount=0,fajarCount=0,zoharCount=0,maghribCount=0;
    isNotified=NO;
    self.jammatPickerView.hidden=YES;
    pickerValue=0;
    hourPickerValue=0;
    m=0;
    getMutableTime = [[NSMutableArray alloc]init];
    uniqueId = [[NSMutableArray alloc]init];
    dateArray = [[NSMutableArray alloc]init];
    fajarArray = [[NSMutableArray alloc]init];
    zoharArray = [[NSMutableArray alloc]init];
    asarArray = [[NSMutableArray alloc]init];
    maghribArray = [[NSMutableArray alloc]init];
    eshaArray = [[NSMutableArray alloc]init];
    mutableAsar = [[NSMutableArray alloc]init];
    mutableEsha = [[NSMutableArray alloc]init];
    mutableFajar = [[NSMutableArray alloc]init];
    mutableMaghrib = [[NSMutableArray alloc]init];
    mutableZohar = [[NSMutableArray alloc]init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    month = [components month];
    self.cancelButton.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.cancelButton.layer.borderWidth=1.5;
    self.cancelButton.layer.cornerRadius=4;
    self.cancelButton.clipsToBounds=YES;
    self.doneButton.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.doneButton.layer.cornerRadius=4;
    self.doneButton.layer.borderWidth=1.5;
    self.doneButton.clipsToBounds=YES;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"format12"]isEqualToString:@"1"]) {
        [self.hourImage setImage:[UIImage imageNamed:@"hourly_butto2_large.png"]];//24
    } else {
        [self.hourImage setImage:[UIImage imageNamed:@"hourly_button_1_large.png"]];//12
    }
    NSString *label=[[NSUserDefaults standardUserDefaults]valueForKey:@"jamaatLabel"];
    if (label.length==0) {
        self.jammatNotifyTime.text=@"Don't Notify";
    } else {
        self.jammatNotifyTime.text=label;
    }
    getMutableData=[[NSMutableArray alloc]init];
    getHours=[[NSMutableArray alloc]init];
    arrayListX=[[NSArray alloc]initWithObjects:@"0",@"1 day",@"2 days",@"3 days",@"4 days",@"5 days",@"6 days",@"7 days",nil];
    arrayList2=[[NSArray alloc]initWithObjects:@"00",@"01 hour",@"02 hours",@"03 hours",@"04 hours",@"05 hours",@"06 hours",@"07 hours",@"08 hours",@"09 hours",@"10 hours",@"11 hours",@"12 hours",nil];
    jammatTime=[[NSArray alloc]initWithObjects:@"Don’t Notify",@"5 minutes",@"10 minutes",@"15 minutes",@"20 minutes",@"25 minutes",@"30 minutes",@"35 minutes",@"40 minutes",@"45 minutes",@"50 minutes",@"55 minutes",@"1 hour", nil];
    if (globalMasjidID.length!=0) {
        [self callEvents];
        [self getFormat];
        [self getDetails];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];

    if (IS_IPAD) {
        self.frstText.font=[UIFont systemFontOfSize:30];
        self.secondText.font=[UIFont systemFontOfSize:30];
        self.thrs.font=[UIFont systemFontOfSize:27];
        self.four.font=[UIFont systemFontOfSize:27];
        self.hrsMins.font=[UIFont systemFontOfSize:25];
        self.timeFormat.font=[UIFont systemFontOfSize:25];
        self.timeFormat.frame=CGRectMake(78,self.timeFormat.frame.origin.y,self.timeFormat.frame.size.width,self.timeFormat.frame.size.height);
        self.frstText.frame=CGRectMake(12,130,self.frstText.frame.size.width, self.frstText.frame.size.height);
        self.jammatNotifyTime.font=[UIFont systemFontOfSize:18];
        self.daysCount.font=[UIFont systemFontOfSize:19];
        self.hoursCount.font=[UIFont systemFontOfSize:19];
        self.sd.titleLabel.font=[UIFont systemFontOfSize:18];
        self.sh.titleLabel.font=[UIFont systemFontOfSize:18];
    } else {
        if(IS_IPHONE_6) {
            self.frstText.font=[UIFont systemFontOfSize:15];
            self.secondText.font=[UIFont systemFontOfSize:15];
            self.thrs.font=[UIFont systemFontOfSize:15];
            self.four.font=[UIFont systemFontOfSize:15];
            self.hrsMins.font=[UIFont systemFontOfSize:13];
        }
    }
    self.jammatPickerView.hidden=YES;
    pickerValue=0;
    hourPickerValue=0;
    m=0;
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)//(cim == nil && cgref == NULL)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else
    {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
}

- (IBAction)formatChange:(UIButton *)sender
{
    NSString *ab=[[NSUserDefaults standardUserDefaults]valueForKey:@"format12"];
    if ([ab isEqualToString:@"0"]||ab.length==0) {
        [self.hourImage setImage:[UIImage imageNamed:@"hourly_butto2_large.png"]]; //24 hr
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"format12"];
        [self changeTimeFormat];
    } else {
        [self.hourImage setImage:[UIImage imageNamed:@"hourly_button_1_large.png"]]; //12 hr
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"format12"];
        [self changeTimeFormat];
    }
}

-(void)changeTimeFormat
{
    NSString *prayersFormat = timetableFormat;
    if ([prayersFormat intValue] ==12)
    {
        NSString *ab=[[NSUserDefaults standardUserDefaults]valueForKey:@"format12"];
        if ([ab intValue]==1) {
            changeFormat=YES;
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
        }
        else
        {
            changeFormat=NO;
        }
    }
    else if ([prayersFormat intValue]==24)
    {
        NSString *ab=[[NSUserDefaults standardUserDefaults]valueForKey:@"format12"];
        if ([ab intValue]==1) {
            changeFormat=NO;
        }
        else
        {
            changeFormat=YES;
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"HH:mm"];
            NSDate* wakeTime  = [df dateFromString:[NSString stringWithFormat:@"%@",fajarBegin]];
            NSDate* wakeTime1 = [df dateFromString:[NSString stringWithFormat:@"%@",fajarJammat]];
            NSDate* wakeTime10 =[df dateFromString:[NSString stringWithFormat:@"%@",sunsetFormat]];
            NSDate* wakeTime2 = [df dateFromString:[NSString stringWithFormat:@"%@",zoharBegin]];
            NSDate* wakeTime3 = [df dateFromString:[NSString stringWithFormat:@"%@",zoharJammat]];
            NSDate* wakeTime4 = [df dateFromString:[NSString stringWithFormat:@"%@",asarBegin]];
            NSDate* wakeTime5 = [df dateFromString:[NSString stringWithFormat:@"%@",asarJammat]];
            NSDate* wakeTime6 = [df dateFromString:[NSString stringWithFormat:@"%@",maghribBegin]];
            NSDate* wakeTime7 = [df dateFromString:[NSString stringWithFormat:@"%@",maghribJammat]];
            NSDate* wakeTime8 = [df dateFromString:[NSString stringWithFormat:@"%@",eshaBegin]];
            NSDate* wakeTime9 = [df dateFromString:[NSString stringWithFormat:@"%@",eshaJammat]];
            [df setDateFormat:@"hh:mm a"];
            
            fajarFormat=[df stringFromDate:wakeTime];
            fajarFormat=[fajarFormat substringToIndex:5];
            
            fajarJFormat=[df stringFromDate:wakeTime1];
            fajarJFormat=[fajarJFormat substringToIndex:5];
            
            zoharFormat=[df stringFromDate:wakeTime2];
            zoharFormat=[zoharFormat substringToIndex:5];
            
            zoharJFormat=[df stringFromDate:wakeTime3];
            zoharJFormat=[zoharJFormat substringToIndex:5];
            
            asarFormat=[df stringFromDate:wakeTime4];
            asarFormat=[asarFormat substringToIndex:5];
            
            asarJFormat=[df stringFromDate:wakeTime5];
            asarJFormat=[asarJFormat substringToIndex:5];
            
            maghribFormat=[df stringFromDate:wakeTime6];
            maghribFormat=[maghribFormat substringToIndex:5];
            
            maghribJFormat=[df stringFromDate:wakeTime7];
            maghribJFormat=[maghribJFormat substringToIndex:5];
            
            eshaFormat=[df stringFromDate:wakeTime8];
            eshaFormat=[eshaFormat substringToIndex:5];
            
            eshaJFormat=[df stringFromDate:wakeTime9];
            eshaJFormat=[eshaJFormat substringToIndex:5];
            
            sunsetFormat=[df stringFromDate:wakeTime10];
            sunsetFormat=[sunsetFormat substringToIndex:5];            
        }
    }
}

-(void)changeTimeTo24Hours
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"HH:mm"];
    NSDate* wakeTime  = [df dateFromString:[NSString stringWithFormat:@"%@",fajarBegin]];
    NSDate* wakeTime1 = [df dateFromString:[NSString stringWithFormat:@"%@",fajarJammat]];
    NSDate* wakeTime10 =[df dateFromString:[NSString stringWithFormat:@"%@",sunsetFormat]];
    NSDate* wakeTime2 = [df dateFromString:[NSString stringWithFormat:@"%@",zoharBegin]];
    NSDate* wakeTime3 = [df dateFromString:[NSString stringWithFormat:@"%@",zoharJammat]];
    NSDate* wakeTime4 = [df dateFromString:[NSString stringWithFormat:@"%@",asarBegin]];
    NSDate* wakeTime5 = [df dateFromString:[NSString stringWithFormat:@"%@",asarJammat]];
    NSDate* wakeTime6 = [df dateFromString:[NSString stringWithFormat:@"%@",maghribBegin]];
    NSDate* wakeTime7 = [df dateFromString:[NSString stringWithFormat:@"%@",maghribJammat]];
    NSDate* wakeTime8 = [df dateFromString:[NSString stringWithFormat:@"%@",eshaBegin]];
    NSDate* wakeTime9 = [df dateFromString:[NSString stringWithFormat:@"%@",eshaJammat]];
    [df setDateFormat:@"hh:mm a"];
    
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
}

- (IBAction)jammatClickd
{
    [self.jammatBtn setBackgroundImage:[UIImage imageNamed:@"jamat_select.png"] forState:UIControlStateNormal];
    [self.miscbtn setBackgroundImage:[UIImage imageNamed:@"misc_unSelect.png"] forState:UIControlStateNormal];
    [self.muteBtn setBackgroundImage:[UIImage imageNamed:@"mute_unSelect.png"] forState:UIControlStateNormal];
    [self.otherBtn setBackgroundImage:[UIImage imageNamed:@"other_unSelect.png"] forState:UIControlStateNormal];
    JammatNotificationsView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"jammatNotifications"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)muteClickd {
    MuteView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"muteView"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)otherSettings {
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (pickerView==self.daysPicker)
        return [arrayListX count];
    else if (pickerView==self.jammatPicker)
        return [jammatTime count];
    else
        return [arrayList2 count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==self.daysPicker)
        return [arrayListX objectAtIndex:row];
    else if (pickerView==self.jammatPicker)
        return [jammatTime objectAtIndex:row];
    else
        return  [arrayList2 objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerViews viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerViews.frame.size.width, 44)];
    if (pickerViews==self.daysPicker) {
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        label.text = [arrayListX objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];
    } else if (pickerViews==self.jammatPicker) {
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:19];
        label.text = [jammatTime objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];
    } else if (pickerViews==self.hoursPicker) {
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        label.text = [arrayList2 objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    return label;
}

-(void)pickerView:(UIPickerView *)pickerViews didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (pickerViews==self.daysPicker) {
        switch (row) {
            case 0:
                intervals=0;
                self.daysCount.text=@"0";
                break;
            case 1:
                intervals=24*60*60;
                self.daysCount.text=@"1";
                break;
            case 2:
                intervals=2*(24*60*60);
                self.daysCount.text=@"2";
                break;
            case 3:
                intervals=3*(24*60*60);
                self.daysCount.text=@"3";
                break;
            case 4:
                intervals=4*(24*60*60);
                self.daysCount.text=@"4";
                break;
            case 5:
                intervals=5*(24*60*60);
                self.daysCount.text=@"5";
                break;
            case 6:
                intervals=6*(24*60*60);
                self.daysCount.text=@"6";
                break;
            case 7:
                intervals=7*(24*60*60);
                self.daysCount.text=@"7";
                break;
            default:
                break;
        }
        i=1;
    }
    
    else if (pickerViews==self.jammatPicker) {
        switch (row) {
            case 0:
                jammatInterval=0;
                self.jammatNotifyTime.text=@" Don't Notify";
                isNotified=NO;
                break;
            case 1:
                jammatInterval=60*5;
                self.jammatNotifyTime.text=@" 5 minutes";
                isNotified=YES;
                break;
            case 2:
                jammatInterval=60*10;
                self.jammatNotifyTime.text=@" 10 minutes";
                isNotified=YES;
                break;
            case 3:
                jammatInterval=60*15;
                self.jammatNotifyTime.text=@" 15 minutes";
                isNotified=YES;
                break;
            case 4:
                jammatInterval=60*20;
                self.jammatNotifyTime.text=@" 20 minutes";
                isNotified=YES;
                break;
            case 5:
                jammatInterval=60*25;
                self.jammatNotifyTime.text=@" 25 minutes";
                isNotified=YES;
                break;
            case 6:
                jammatInterval=60*30;
                self.jammatNotifyTime.text=@" 30 minutes";
                isNotified=YES;
                break;
            case 7:
                jammatInterval=60*35;
                self.jammatNotifyTime.text=@" 35 minutes";
                isNotified=YES;
                break;
            case 8:
                jammatInterval=60*40;
                self.jammatNotifyTime.text=@" 40 minutes";
                isNotified=YES;
                break;
            case 9:
                jammatInterval=60*45;
                self.jammatNotifyTime.text=@" 45 minutes";
                isNotified=YES;
                break;
            case 10:
                jammatInterval=60*50;
                self.jammatNotifyTime.text=@" 50 minutes";
                isNotified=YES;
                break;
            case 11:
                jammatInterval=60*55;
                self.jammatNotifyTime.text=@" 55 minutes";
                isNotified=YES;
                break;
            case 12:
                jammatInterval=60*60;
                self.jammatNotifyTime.text=@" 1 hour";
                isNotified=YES;
                break;
            default:
                break;
        }
        i=2;
    } else {
        switch (row) {
            case 0:
                hoursInterval=0;
                self.hoursCount.text=@"0";
                break;
            case 1:
                hoursInterval=1*(60*60);
                self.hoursCount.text=@"1";
                break;
            case 2:
                hoursInterval=2*(60*60);
                self.hoursCount.text=@"2";
                break;
            case 3:
                hoursInterval=3*(60*60);
                self.hoursCount.text=@"3";
                break;
            case 4:
                hoursInterval=4*(60*60);
                self.hoursCount.text=@"4";
                break;
            case 5:
                hoursInterval=5*(60*60);
                self.hoursCount.text=@"5";
                break;
            case 6:
                hoursInterval=6*(60*60);
                self.hoursCount.text=@"6";
                break;
            case 7:
                hoursInterval=7*(60*60);
                self.hoursCount.text=@"7";
                break;
            case 8:
                hoursInterval=8*(60*60);
                self.hoursCount.text=@"8";
                break;
            case 9:
                hoursInterval=9*(60*60);
                self.hoursCount.text=@"9";
                break;
            case 10:
                hoursInterval=10*(60*60);
                self.hoursCount.text=@"10";
                break;
            case 11:
                hoursInterval=11*(60*60);
                self.hoursCount.text=@"11";
                break;
            case 12:
                hoursInterval=12*(60*60);
                self.hoursCount.text=@"12";
                break;
            default:
                break;
        }
        i=1;
    }
    
    if (i==1) {
        if (hoursInterval==0 && intervals==0) {
        } else {
            [self getNotifications];
            i=0;
        }
    }
}

-(void)getNotifiedForJammatTime
{
    fajarJammat=[fajarJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
    previousFajar=[previousFajar stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    zoharJammat=[zoharJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
    previousZohar=[previousZohar stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    asarJammat=[asarJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
    previousAsar=[previousAsar stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    maghribJammat=[maghribJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
    previousMaghrib=[previousMaghrib stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    eshaJammat=[eshaJammat stringByReplacingOccurrencesOfString:@":" withString:@"."];
    previousEsha=[previousEsha stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    
    if ([previousFajar floatValue]!=[fajarJammat floatValue]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        fajarJammat=[fajarJammat stringByReplacingOccurrencesOfString:@"." withString:@":"];
        NSDate *endDate=[formatter dateFromString:fajarJammat]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
        prayerAlert=[NSString stringWithFormat:@"New Fajar Jamaat Timing is %@",fajarJammat];
        [self getTimeIntervals2];
    }
    
    if ([previousZohar floatValue]!=[zoharJammat floatValue]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        zoharJammat=[zoharJammat stringByReplacingOccurrencesOfString:@"." withString:@":"];
        NSDate *endDate=[formatter dateFromString:zoharJammat]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
        prayerAlert=[NSString stringWithFormat:@"New Zohar Jamaat Timing is %@",zoharJammat];
        [self getTimeIntervals2];
    }
    
    if ([previousAsar floatValue]!=[asarJammat floatValue]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        asarJammat=[asarJammat stringByReplacingOccurrencesOfString:@"." withString:@":"];
        NSDate *endDate=[formatter dateFromString:asarJammat]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
        prayerAlert=[NSString stringWithFormat:@"New Asar Jamaat Timing is %@",asarJammat];
        [self getTimeIntervals2];
    }
    
    if ([previousMaghrib floatValue]!=[maghribJammat floatValue]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        maghribJammat=[maghribJammat stringByReplacingOccurrencesOfString:@"." withString:@":"];
        NSDate *endDate=[formatter dateFromString:maghribJammat]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
        prayerAlert=[NSString stringWithFormat:@"New Maghrib Jamaat Timing is %@",maghribJammat];
        [self getTimeIntervals2];
    }
    
    if ([previousEsha floatValue]!=[eshaJammat floatValue]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        eshaJammat=[eshaJammat stringByReplacingOccurrencesOfString:@"." withString:@":"];
        NSDate *endDate=[formatter dateFromString:eshaJammat]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",JsonDate,chekDate];
        prayerAlert=[NSString stringWithFormat:@"New Esha Jamaat Timing is %@",eshaJammat];
        [self getTimeIntervals2];
    }
}

-(void)getTimeIntervals2
{
    uniqueId=[[NSMutableArray alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *serDate;
    NSDate *endDate;
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *get = [formatter stringFromDate:[NSDate date]];
    serDate=[formatter dateFromString:get];
    endDate = [formatter dateFromString:from];
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    
    minutes = timeDifference / 60;
    hour = minutes / 60;
    seconds = timeDifference;
    
    if (hour<0 || minutes<0) {
    }
    else
    {
        if (FajarAlert==YES) {
            prayerID=@"25";
            fajarCount++;
            [self getJammatNotifications];
            [uniqueId addObject:prayerID];
        }
        if (EshaAlert==YES) {
            prayerID=@"29";
            eshaCount++;
            [self getJammatNotifications];
            [uniqueId addObject:prayerID];
        }
        if (MaghribAlert==YES) {
            prayerID=@"28";
            maghribCount++;
            [self getJammatNotifications];
            [uniqueId addObject:prayerID];
        }
        if (AsarAlert==YES) {
            prayerID=@"27";
            asarCount++;
            [self getJammatNotifications];
            [uniqueId addObject:prayerID];
        }
        if (ZoharAlert==YES) {
            prayerID=@"26";
            zoharCount++;
            [self getJammatNotifications];
            [uniqueId addObject:prayerID];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:uniqueId forKey:@"uniqueKeys"];
        [[NSUserDefaults standardUserDefaults]setValue:self.jammatNotifyTime.text forKey:@"jamaatLabel"];
    }
}

-(void)getJammatNotifications
{
    if (!localNotification)
        return;
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [localNotification setAlertBody:prayerAlert];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:prayerID forKey:@"Tags"];
    localNotification.userInfo = userInfo;
    [localNotification setHasAction:YES];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)cancelPopup
{    NSDictionary *userInfo;
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        userInfo = notification.userInfo;
        NSArray *ids=[[NSArray alloc]initWithObjects:@"25",@"26",@"27",@"28",@"29",nil];
        for (int c=0;c<[ids count];c++)
        {
            if ([[userInfo objectForKey:@"Tags"]isEqualToString:ids[c]]){
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
    }
}

-(void)getFormat
{
    NSArray *json2;
    if (masjidTurn==1) {
        json2=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat"];
    }
    else if (masjidTurn==2) {
        json2=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat1"];
        if ([json2 count]==0) {
            json2=globalTimeTableFormat;
        }
    }
    else if (masjidTurn==3) {
        json2=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat2"];
        if ([json2 count]==0) {
            json2=globalTimeTableFormat;
        }
    }
    else if (masjidTurn==4) {
        json2=[[NSUserDefaults standardUserDefaults]valueForKey:@"globalTimeTableFormat2"];
        if ([json2 count]==0) {
            json2=globalTimeTableFormat;
        }
    }
    
    if (json2.count==0) {
        timetableFormat=@"12";
    }
    else
    {
        for (int mm=0;mm<[json2 count];mm++) {
            NSString *getMnth=[[json2 valueForKey:@"timetable_month"]objectAtIndex:mm];
            getMnth=[getMnth substringWithRange:NSMakeRange(5,2)];
            if ([getMnth intValue] == month) {
                timetableFormat=[[json2 valueForKey:@"timetable_format"]objectAtIndex:mm];
            }
        }
    }
}

-(void)callEvents
{
    
    if (masjidTurn==1) {
        jsonDict=[[NSUserDefaults standardUserDefaults]valueForKey:@"masjid_events"];
    }
    else if (masjidTurn==2) {
        jsonDict=[[NSUserDefaults standardUserDefaults]valueForKey:@"masjid_events1"];
        if ([jsonDict count]==0) {
            jsonDict=jsonCalled;
        }
    }
    else if (masjidTurn==3) {
        jsonDict=[[NSUserDefaults standardUserDefaults]valueForKey:@"masjid_events2"];
        if ([jsonDict count]==0) {
            jsonDict=jsonCalled;
        }
    }
    else if (masjidTurn==4) {
        jsonDict=[[NSUserDefaults standardUserDefaults]valueForKey:@"masjid_events3"];
        if ([jsonDict count]==0) {
            jsonDict=jsonCalled;
        }
    }
    
    [SVProgressHUD dismiss];
    if (jsonDict.count!=0) {
        eventDate=[jsonDict valueForKey:@"event_date"];
        eventDetail=[jsonDict valueForKey:@"event_details"];
        eventTitle=[jsonDict valueForKey:@"event_title"];
        NSArray *eventTime=[jsonDict valueForKey:@"event_time"];
        
        for (a=0;a<[eventDate count];a++) {
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"hh:mm a"];
            NSDate *wakeTime = [df dateFromString:[NSString stringWithFormat:@"%@",eventTime[a]]];
            [df setDateFormat:@"HH:mm"];
            NSString *get =[df stringFromDate:wakeTime];
            date=[NSString stringWithFormat:@"%@ %@",[eventDate objectAtIndex:a],get];
            [self getTimeIntervals];
        }
        if ([getMutableData count]==0) {
        }
        else
        {}
        isEventsFetched=YES;
    }
}

-(void)getTimeIntervals
{
    NSDateFormatter *istDateFormatter = [[NSDateFormatter alloc] init];
    [istDateFormatter setDateFormat:@"yyyy-MM-dd"];
    intervalString = [istDateFormatter stringFromDate:[NSDate date]];
    [istDateFormatter setDateFormat:@"HH:mm"];
    NSString *time=[istDateFormatter stringFromDate:[NSDate date]];
    NSDate *serDate;
    NSDate *endDate;
    [istDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    serDate=[istDateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",intervalString,time]];
    endDate = [istDateFormatter dateFromString:date];
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    minutes = timeDifference / 60;
    hour = minutes / 60;
    seconds = timeDifference;
    if (hour<0 || minutes<0) {
    }
    else
    {
        [getMutableData addObject:[jsonDict objectAtIndex:a]];
        [getHours addObject:[NSNumber numberWithInt:seconds]];
    }
}

-(void)getNotifications
{
    if ([getHours count]==0) {
    }
    else
    {
        if (!localNotification)
            return;
        NSString *dateTime=[getHours objectAtIndex:0];
        NSDate *dateToFire = [NSDate dateWithTimeIntervalSinceNow:[dateTime intValue]-(intervals+hoursInterval)];
        [localNotification setFireDate:dateToFire];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        [localNotification setAlertBody:[NSString stringWithFormat:@"%@ %@ %@ , %@",[[getMutableData valueForKey:@"event_title"]objectAtIndex:0],@"on",[[getMutableData valueForKey:@"event_date"]objectAtIndex:0],[[getMutableData valueForKey:@"event_time"]objectAtIndex:0]]];
        [localNotification setAlertAction:@"Alert"];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (IBAction)jammatNotifyBtn
{
    jamaat=1;hours=0;days=0;
    self.daysPicker.hidden=YES;
    self.hoursPicker.hidden=YES;
    self.jammatPicker.hidden=NO;
    if (self.jammatPickerView.hidden==NO) {
        pickerValue=0;
        hourPickerValue=0;
        m=0;
    } else {
        if (m==0) {
            self.jammatPickerView.hidden=NO;
            CGRect newFrame = self.containerView.frame;
            CGRect newImage=self.jammatPickerView.frame;
            newImage.origin.y-=120;
            newFrame.origin.y -= 120;
            [UIView animateWithDuration:1.0
                             animations:^{
                                 self.containerView.frame = newFrame;
                                 self.jammatPickerView.frame=newImage;
                             }];
            m=1;
        } else if (m==1) {
            CGRect newFrame = self.containerView.frame;
            CGRect newImage=self.jammatPickerView.frame;
            newImage.origin.y+=120;
            newFrame.origin.y += 120;
            [UIView animateWithDuration:1.0 animations:^{
                self.containerView.frame = newFrame;
                self.jammatPickerView.frame=newImage;
            } completion:^(BOOL finished) {
                self.jammatPickerView.hidden=YES;
            }];
            m=0;
        }
    }
}

- (IBAction)cancelPicker
{
    if (jamaat==1) {
        m=0;
        jammatInterval=0;
        self.jammatNotifyTime.text=@" Don't Notify";
        CGRect newFrame = self.containerView.frame;
        CGRect newImage=self.jammatPickerView.frame;
        newImage.origin.y+=120;
        newFrame.origin.y += 120;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.containerView.frame = newFrame;
            self.jammatPickerView.frame=newImage;
        } completion:^(BOOL finished) {
            self.jammatPickerView.hidden=YES;
        }];
        
        days=1;jamaat=0;hours=1;
    }
    else if (days==1)
    {
        pickerValue=0;
        intervals=0;
        self.daysCount.text=@"0";
        [self.daysPicker selectRow:0 inComponent:0 animated:YES];
        CGRect newFrame = self.containerView.frame;
        CGRect newImage=self.jammatPickerView.frame;
        newImage.origin.y+=120;
        newFrame.origin.y += 120;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.containerView.frame = newFrame;
            self.jammatPickerView.frame=newImage;
        } completion:^(BOOL finished) {
            self.jammatPickerView.hidden=YES;
        }];
        days=0;jamaat=1;hours=1;
    }
    else if (hours==1)
    {
        hourPickerValue=0;
        hoursInterval=0;
        self.hoursCount.text=@"0";
        [self.hoursPicker selectRow:0 inComponent:0 animated:YES];
        CGRect newFrame = self.containerView.frame;
        CGRect newImage=self.jammatPickerView.frame;
        newImage.origin.y+=120;
        newFrame.origin.y += 120;
        
        [UIView animateWithDuration:1.0 animations:^{
            self.containerView.frame = newFrame;
            self.jammatPickerView.frame=newImage;
        } completion:^(BOOL finished) {
            self.jammatPickerView.hidden=YES;
        }];
        
        days=1;jamaat=1;hours=0;
    }
}

- (IBAction)donePicker
{
    if (jamaat==1) {
        m=0;
        [self cancelPopup];
        if (isNotified==YES) {
            [self getAlertsForFajar];
            [self getAlertsForZohar];
            [self getAlertsForAsar];
            [self getAlertsForMaghrib];
            [self getAlertsForEsha];
        } else {
            [[NSUserDefaults standardUserDefaults]setValue:self.jammatNotifyTime.text forKey:@"jamaatLabel"];
        }
        CGRect newFrame = self.containerView.frame;
        CGRect newImage=self.jammatPickerView.frame;
        newImage.origin.y +=120;
        newFrame.origin.y += 120;
        [UIView animateWithDuration:1.0 animations:^{
            self.containerView.frame = newFrame;
            self.jammatPickerView.frame=newImage;
        } completion:^(BOOL finished) {
            self.jammatPickerView.hidden=YES;
        }];
        
        days=1;jamaat=0;hours=1;
    } else if (days==1) {
        pickerValue=0;
        CGRect newFrame = self.containerView.frame;
        CGRect newImage=self.jammatPickerView.frame;
        newImage.origin.y +=120;
        newFrame.origin.y+= 120;
        [UIView animateWithDuration:1.0 animations:^{
            self.containerView.frame = newFrame;
            self.jammatPickerView.frame=newImage;
        } completion:^(BOOL finished) {
            self.jammatPickerView.hidden=YES;
        }];
        
        days=0;jamaat=1;hours=1;
    } else if (hours==1) {
        hourPickerValue=0;
        CGRect newFrame = self.containerView.frame;
        CGRect newImage=self.jammatPickerView.frame;
        newImage.origin.y +=120;
        newFrame.origin.y += 120;
        [UIView animateWithDuration:1.0 animations:^{
            self.containerView.frame = newFrame;
            self.jammatPickerView.frame=newImage;
        } completion:^(BOOL finished) {
            self.jammatPickerView.hidden=YES;
        }];
        
        days=1;jamaat=1;hours=0;
    }
}

- (IBAction)daysClickd
{
    jamaat=0;hours=0;days=1;
    self.hoursPicker.hidden=YES;
    self.jammatPicker.hidden=YES;
    self.daysPicker.hidden=NO;
    if (self.jammatPickerView.hidden == NO) {
        pickerValue = 0;
        hourPickerValue = 0;
        m = 0;
    } else {
        if (pickerValue==0) {
            self.jammatPickerView.hidden=NO;
            CGRect newFrame = self.containerView.frame;
            CGRect newImage=self.jammatPickerView.frame;
            newImage.origin.y -=120;
            newFrame.origin.y -= 120;
            
            [UIView animateWithDuration:1.0
                             animations:^{
                                 self.containerView.frame = newFrame;
                                 self.jammatPickerView.frame=newImage;
                             }];
            pickerValue=1;
        } else if (pickerValue==1) {
            CGRect newFrame = self.containerView.frame;
            CGRect newImage=self.jammatPickerView.frame;
            newImage.origin.y +=120;
            newFrame.origin.y += 120;
            [UIView animateWithDuration:1.0 animations:^{
                self.containerView.frame = newFrame;
                self.jammatPickerView.frame=newImage;
            } completion:^(BOOL finished) {
                self.jammatPickerView.hidden=YES;
            }];
            
            pickerValue=0;
        }
    }
}

- (IBAction)hoursClickd
{
    jamaat=0;hours=1;days=0;
    self.daysPicker.hidden=YES;
    self.jammatPicker.hidden=YES;
    self.hoursPicker.hidden=NO;
    if (self.jammatPickerView.hidden==NO)
    {
        pickerValue=0;
        hourPickerValue=0;
        m=0;
    }
    else
    {
        if (hourPickerValue==0) {
            self.jammatPickerView.hidden=NO;
            CGRect newFrame = self.containerView.frame;
            CGRect newImage=self.jammatPickerView.frame;
            newImage.origin.y -=120;
            newFrame.origin.y -= 120;
            
            [UIView animateWithDuration:1.0
             
                             animations:^{
                                 self.containerView.frame = newFrame;
                                 self.jammatPickerView.frame=newImage;
                             }];
            hourPickerValue=1;
        }  else if (hourPickerValue==1) {
            CGRect newFrame = self.containerView.frame;
            CGRect newImage=self.jammatPickerView.frame;
            newImage.origin.y +=120;
            newFrame.origin.y += 120;
            
            [UIView animateWithDuration:1.0 animations:^{
                self.containerView.frame = newFrame;
                self.jammatPickerView.frame=newImage;
            } completion:^(BOOL finished) {
                self.jammatPickerView.hidden=YES;
            }];
            
            hourPickerValue=0;
        }
    }
}

-(void)getDetails
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    NSDateFormatter *istDateFormatter12 = [[NSDateFormatter alloc] init];
    [istDateFormatter12 setDateFormat:@"d-MM-yyyy"];
    NSString *today=[istDateFormatter12 stringFromDate:[NSDate date]];
    NSDate *previous=[istDateFormatter12 dateFromString:today];
    [offsetComponents setDay:-1];
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents toDate:previous options:0];
    NSString *get=[istDateFormatter12 stringFromDate:endOfWorldWar3];
    
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
    
    NSArray *Array=[json valueForKey:@"Fajar"];
    NSArray *Array1=[json valueForKey:@"Zohar-j"];
    NSArray *Array2=[json valueForKey:@"Asar-j"];
    NSArray *Array3=[json valueForKey:@"Maghrib"];
    NSArray *Array4=[json valueForKey:@"Esha-j"];
    alertDateArray=[json valueForKey:@"DATE"];
    if ([[json valueForKey:@"DATE"]containsObject:get]) {
        dateIndex=[[json valueForKey:@"DATE"]indexOfObject:get];
    }
    if ([Array count]>0 && [Array1 count]>0 && [Array2 count]>0 && [Array3 count]>0 &&[Array4 count]>0) {
        for (int abd=dateIndex;abd<30;abd++) {
            [fajarArray addObject:[Array objectAtIndex:abd]];
            [zoharArray addObject:[Array1 objectAtIndex:abd]];
            [asarArray addObject:[Array2 objectAtIndex:abd]];
            [maghribArray addObject:[Array3 objectAtIndex:abd]];
            [eshaArray addObject:[Array4 objectAtIndex:abd]];
            [dateArray addObject:[alertDateArray objectAtIndex:abd]];
        }
    }
    
    for (int b=0;b<[zoharArray count];b++) {
        NSString *ab=[zoharArray[b]stringByReplacingOccurrencesOfString:@":" withString:@"."];
        NSString *fajar24=[fajarArray[b]stringByReplacingOccurrencesOfString:@":" withString:@"."];
        NSString *esha24=[eshaArray[b]stringByReplacingOccurrencesOfString:@":" withString:@"."];
        NSString *asar24=[asarArray[b]stringByReplacingOccurrencesOfString:@":" withString:@"."];
        NSString *maghrib24=[maghribArray[b]stringByReplacingOccurrencesOfString:@":" withString:@"."];
        if ([ab floatValue]<12.0) {
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"hh:mm a"];
            NSDate* wakeTime = [df dateFromString:[NSString stringWithFormat:@"%@ PM",zoharArray[b]]];
            NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
            [df2 setTimeZone:[NSTimeZone systemTimeZone]];
            [df2 setDateFormat:@"HH:mm"];
            NSString *g=[df2 stringFromDate:wakeTime];
            [mutableZohar addObject:g];
        }
        else
        {
            [mutableZohar addObject:zoharArray[b]];
        }
        if ([fajar24 floatValue]<12.0) {
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"hh:mm a"];
            NSDate* wakeTime = [df dateFromString:[NSString stringWithFormat:@"%@ AM",fajarArray[b]]];
            NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
            [df2 setTimeZone:[NSTimeZone systemTimeZone]];
            [df2 setDateFormat:@"HH:mm"];
            NSString *g=[df2 stringFromDate:wakeTime];
            [mutableFajar addObject:g];
        }
        else
        {
            [mutableFajar addObject:zoharArray[b]];
        }
        if ([asar24 floatValue]<12.0) {
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"hh:mm a"];
            NSDate* wakeTime = [df dateFromString:[NSString stringWithFormat:@"%@ PM",asarArray[b]]];
            NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
            [df2 setTimeZone:[NSTimeZone systemTimeZone]];
            [df2 setDateFormat:@"HH:mm"];
            NSString *g=[df2 stringFromDate:wakeTime];
            [mutableAsar addObject:g];
        }
        else
        {
            [mutableAsar addObject:zoharArray[b]];
        }
        if ([maghrib24 floatValue]<12.0) {
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"hh:mm a"];
            NSDate* wakeTime = [df dateFromString:[NSString stringWithFormat:@"%@ PM",maghribArray[b]]];
            NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
            [df2 setTimeZone:[NSTimeZone systemTimeZone]];
            [df2 setDateFormat:@"HH:mm"];
            NSString *g=[df2 stringFromDate:wakeTime];
            [mutableMaghrib addObject:g];
        }
        else
        {
            [mutableMaghrib addObject:zoharArray[b]];
        }
        if ([esha24 floatValue]<12.0) {
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setDateFormat:@"hh:mm a"];
            NSDate* wakeTime = [df dateFromString:[NSString stringWithFormat:@"%@ PM",eshaArray[b]]];
            NSDateFormatter* df2 = [[NSDateFormatter alloc]init];
            [df2 setTimeZone:[NSTimeZone systemTimeZone]];
            [df2 setDateFormat:@"HH:mm"];
            NSString *g=[df2 stringFromDate:wakeTime];
            [mutableEsha addObject:g];
        }
        else
        {
            [mutableEsha addObject:zoharArray[b]];
        }
    }
    
}

-(void)getAlertsForZohar
{
    for (int ab=0;ab<[mutableZohar count];ab++) {
        if (zoharCount>=5) {
            if ([[json valueForKey:@"DATE"]containsObject:[dateArray objectAtIndex:ab]]) {
            }
            ZoharAlert=NO;
            return;
        }
        if (ab==[mutableZohar count]-1) {
            if ([mutableZohar[ab-1]isEqualToString:mutableZohar[ab]]) {
                ZoharAlert=NO;
            }
            else
            {
                ZoharAlert=YES;
                JJAlert=mutableZohar[ab];
                JJDate=dateArray[ab];
                prayerAlert=[NSString stringWithFormat:@"New Zohar Jamaat Timing is %@",mutableZohar[ab]];
                [self setPopupForZohar];
            }
        }
        else
        {
            if ([mutableZohar[ab+1]isEqualToString:mutableZohar[ab]]) {
                ZoharAlert=NO;
            }
            else
            {
                ZoharAlert=YES;
                JJAlert=mutableZohar[ab+1];
                JJDate=dateArray[ab+1];
                prayerAlert=[NSString stringWithFormat:@"New Zohar Jamaat Timing is %@",mutableZohar[ab+1]];
                [self setPopupForZohar];
            }
        }
    }
}

-(void)setPopupForZohar
{
    if (zoharCount>=5) {
        return;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:JJAlert]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",JJDate,chekDate];
        [self getTimeIntervals2];
    }
}


-(void)getAlertsForAsar
{
    for (int ab=0;ab<[mutableAsar count];ab++) {
        if (asarCount>=5) {
            if ([[json valueForKey:@"DATE"]containsObject:[dateArray objectAtIndex:ab]]) {
            }
            AsarAlert=NO;
            return;
        }
        if (ab==[mutableAsar count]-1) {
            if ([mutableAsar[ab-1]isEqualToString:mutableAsar[ab]]) {
                AsarAlert=NO;
            }
            else
            {
                AsarAlert=YES;
                aaAlert=mutableAsar[ab];
                aaDate=dateArray[ab];
                prayerAlert=[NSString stringWithFormat:@"New Asar Jamaat Timing is %@",mutableAsar[ab]];
                [self setPopupForAsar];
            }
        }
        else
        {
            if ([mutableAsar[ab+1]isEqualToString:mutableAsar[ab]]) {
                AsarAlert=NO;
            }
            else
            {
                AsarAlert=YES;
                aaAlert=mutableAsar[ab+1];
                aaDate=dateArray[ab+1];
                prayerAlert=[NSString stringWithFormat:@"New Asar Jamaat Timing is %@",mutableAsar[ab+1]];
                [self setPopupForAsar];
            }
        }
    }
}

-(void)setPopupForAsar
{
    if (asarCount>=5) {
        return;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:aaAlert];
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",aaDate,chekDate];
        [self getTimeIntervals2];
    }
}

-(void)getAlertsForMaghrib
{
    for (int ab=0;ab<[mutableMaghrib count];ab++) {
        if (maghribCount>=5) {
            if ([[json valueForKey:@"DATE"]containsObject:[dateArray objectAtIndex:ab]]) {
            }
            MaghribAlert=NO;
            return;
        }
        if (ab==[mutableMaghrib count]-1) {
            if ([mutableMaghrib[ab-1]isEqualToString:mutableMaghrib[ab]]) {
                MaghribAlert=NO;
            }
            else
            {
                MaghribAlert=YES;
                mmAlert=mutableMaghrib[ab];
                mmDate=dateArray[ab];
                prayerAlert=[NSString stringWithFormat:@"New Maghrib Jamaat Timing is %@",mutableMaghrib[ab]];
                [self setPopupForMaghrib];
            }
        }
        else
        {
            if ([mutableMaghrib[ab+1]isEqualToString:mutableMaghrib[ab]]) {
                MaghribAlert=NO;
            }
            else
            {
                MaghribAlert=YES;
                mmAlert=mutableMaghrib[ab+1];
                mmDate=dateArray[ab+1];
                prayerAlert=[NSString stringWithFormat:@"New Maghrib Jamaat Timing is %@",mutableMaghrib[ab+1]];
                [self setPopupForMaghrib];
            }
        }
    }
}

-(void)setPopupForMaghrib
{
    if (maghribCount>=5) {
        return;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:mmAlert];
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",mmDate,chekDate];
        [self getTimeIntervals2];
    }
}

-(void)getAlertsForEsha
{
    for (EshaAb=0;EshaAb<[mutableEsha count];EshaAb++) {
        if (eshaCount>=5) {
            if ([[json valueForKey:@"DATE"]containsObject:[dateArray objectAtIndex:EshaAb]]) {
            }
            EshaAlert=NO;
            return;
        }
        if (EshaAb==[mutableEsha count]-1) {
            if ([mutableEsha[EshaAb-1]isEqualToString:mutableEsha[EshaAb]]) {
                EshaAlert=NO;
            }
            else
            {
                EshaAlert=YES;
                XXAlert=mutableEsha[EshaAb];
                XXDate=dateArray[EshaAb];
                prayerAlert=[NSString stringWithFormat:@"New Esha Jamaat Timing is %@",mutableEsha[EshaAb]];
                [self setPopupForEsha];
            }
        }
        else
        {
            if ([mutableEsha[EshaAb+1]isEqualToString:mutableEsha[EshaAb]]) {
                EshaAlert=NO;
            }
            else
            {
                EshaAlert=YES;
                XXAlert=mutableEsha[EshaAb+1];
                XXDate=dateArray[EshaAb+1];
                prayerAlert=[NSString stringWithFormat:@"New Esha Jamaat Timing is %@",mutableEsha[EshaAb+1]];
                [self setPopupForEsha];
            }
        }
    }
}

-(void)setPopupForEsha
{
    if (eshaCount>=5) {
        return;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:XXAlert]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",XXDate,chekDate];
        [self getTimeIntervals2];
    }
}

-(void)getAlertsForFajar
{
    for (int ab=0;ab<[mutableFajar count];ab++) {
        if (fajarCount>=5) {
            if ([[json valueForKey:@"DATE"]containsObject:[dateArray objectAtIndex:ab]]) {
            }
            FajarAlert=NO;
            return;
        }
        if (ab==[mutableFajar count]-1) {
            if ([mutableFajar[ab-1]isEqualToString:mutableFajar[ab]]) {
                FajarAlert=NO;
            }
            else
            {
                FajarAlert=YES;
                FFAlert=mutableFajar[ab];
                FFDate=dateArray[ab];
                prayerAlert=[NSString stringWithFormat:@"New Fajar Jamaat Timing is %@",mutableFajar[ab]];
                [self setPopupForFajar];
            }
        }
        else
        {
            if ([mutableFajar[ab+1]isEqualToString:mutableFajar[ab]]) {
                FajarAlert=NO;
            }
            else
            {
                FajarAlert=YES;
                FFAlert=mutableFajar[ab+1];
                FFDate=dateArray[ab+1];
                prayerAlert=[NSString stringWithFormat:@"New Fajar Jamaat Timing is %@",mutableFajar[ab+1]];
                [self setPopupForFajar];
            }
        }
    }
}

-(void)setPopupForFajar
{
    if (fajarCount>=5) {
        return;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:FFAlert]; // write prayer time here in place of string
        NSDate *newDate = [endDate dateByAddingTimeInterval:-jammatInterval];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",FFDate,chekDate];
        [self getTimeIntervals2];
    }
}

@end
