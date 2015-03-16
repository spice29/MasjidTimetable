//
//  alarmView.m
//  Masjid Timetable
//
//  Created by Lentrica Software -  © 2015
//  Copyright Lentrica Software -  © 2015. All rights reserved.
//

#import "alarmView.h"
#import "AppDelegate.h"

@interface alarmView ()
{
    MPMoviePlayerViewController *moviePlayer;
    NSTimer *timer;
    NSInteger time;
    int i,j,m;
    NSString *from,*setVal;
    NSString *minsValue;
    NSString *outDateStr1, *outDateStr;
    NSDate *datePlusOneMinut;
    NSArray *pickerDetail,*selectTime;
    NSString *currentTime,*currentMonth;
    int minutes,minutes1,hours;
}
@end

@implementation alarmView

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

    self.title=@"Wake Up";
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    i=0; j=0;
    minsValue=@"10";
    NSDateFormatter *istDateFormatter1 = [[NSDateFormatter alloc] init];
    [istDateFormatter1 setDateFormat:@"dd-MM-yyyy"];
    currentMonth=[istDateFormatter1 stringFromDate:[NSDate date]];
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"HH:mm"];
    currentTime = [date stringFromDate:[NSDate date]];
    self.pickerView.hidden=YES;
    pickerDetail=[[NSArray alloc]initWithObjects:@"5 minutes",@"10 minutes",@"15 minutes",@"20 minutes",@"25 minutes",@"30 minutes",@"35 minutes",@"40 minutes",@"45 minutes",@"50 minutes",@"55 minutes",@"1 hour", nil];
    selectTime=[[NSArray alloc]initWithObjects:@"After",@"Before",nil];
    [self setTime];
    datePlusOneMinut = [[NSDate date] dateByAddingTimeInterval:60];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
       [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    }
    else
    {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    }
}

-(void)setTime
{
    time=11;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}
-(void)countDown
{
    time = time - 1;
    if (time==6) {
        [timer invalidate];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake && time==6) {
        [self showAlert];
    }
}

-(void)showAlert
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"ShakeGesture Demo"
                              message:@"Shake Detected"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (pickerView==self.picker1)
        return [pickerDetail count];
    else
        return [selectTime count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==self.picker1)
        return [pickerDetail objectAtIndex:row];
    else
        return  [selectTime objectAtIndex:row];
    
}

-(UIView *)pickerView:(UIPickerView *)pickerViews viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerViews.frame.size.width, 44)];
    if (pickerViews==self.picker1) {
      
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        label.text = [pickerDetail objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    else
    {
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        label.text = [selectTime objectAtIndex:row];
        [label setTextAlignment:NSTextAlignmentCenter];
   
    }
    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerViews didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (pickerViews==self.picker1) {
        switch (row) {
            case 0:
                self.label1.text=[pickerDetail objectAtIndex:0];
                minutes1=05;
                break;
            case 1:
                self.label1.text=[pickerDetail objectAtIndex:1];
                minutes1=10;
                break;
            case 2:
                 self.label1.text=[pickerDetail objectAtIndex:2];
                minutes1=15;
                break;
            case 3:
                 self.label1.text=[pickerDetail objectAtIndex:3];
                minutes1=20;
                break;
            case 4:
                 self.label1.text=[pickerDetail objectAtIndex:4];
                minutes1=25;
                break;
            case 5:
                 self.label1.text=[pickerDetail objectAtIndex:5];
                minutes1=30;
                break;
            case 6:
                 self.label1.text=[pickerDetail objectAtIndex:6];
                minutes1=35;
                break;
            case 7:
                 self.label1.text=[pickerDetail objectAtIndex:7];
                minutes1=40;
                break;
            case 8:
                 self.label1.text=[pickerDetail objectAtIndex:8];
                minutes1=45;
                break;
            case 9:
                 self.label1.text=[pickerDetail objectAtIndex:9];
                minutes1=50;
                break;
            case 10:
                 self.label1.text=[pickerDetail objectAtIndex:10];
                minutes1=55;
                break;
            case 11:
                 self.label1.text=[pickerDetail objectAtIndex:11];
                minutes1=60;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (row) {
            case 0:
                self.label2.text=[selectTime objectAtIndex:0];
                m=0;
                break;
            case 1:
                self.label2.text=[selectTime objectAtIndex:1];
                m=1;
                break;
        }
    }
}

- (IBAction)minutesClickd {
    if (i==0) {
        self.pickerView.hidden=NO;
        self.picker1.hidden=NO;
        self.picker2.hidden=YES;
        i=1;
    }
    else
    {
         self.pickerView.hidden=YES;
         i=0;
    }
}

- (IBAction)afterClickd {
    if (j==0) {
        self.pickerView.hidden=NO;
        self.picker1.hidden=YES;
        self.picker2.hidden=NO;
        j=1;
    }
    else
    {
        self.pickerView.hidden=YES;
        j=0;
    }
}

- (IBAction)setAlarm {
    [self cancelAlarm];
    fajarFormat=@"13:10";
    if (m==0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:fajarFormat];
        NSDate *newDate = [endDate dateByAddingTimeInterval:minutes1*60];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",currentMonth,chekDate];
        setVal=@"1";
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"fajar"];
        [self getTimeIntervals];
    } else if (m==1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *endDate=[formatter dateFromString:fajarFormat];
        NSDate *newDate = [endDate dateByAddingTimeInterval:-minutes1*60];
        NSString *chekDate =[formatter stringFromDate:newDate];
        from=[NSString stringWithFormat:@"%@ %@",currentMonth,chekDate];
        setVal=@"2";
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"fajar"];
        [self getTimeIntervals];
    }
}

- (IBAction)cancel:(id)sender {
    self.pickerView.hidden=YES;
    i=0;
    j=0;
}

- (IBAction)done {
    self.pickerView.hidden=YES;
    i=0;
    j=0;
}

-(void)getTimeIntervals
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *serDate;
    NSDate *endDate;
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    serDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",currentMonth,currentTime]];
    endDate = [formatter dateFromString:from];
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    minutes = timeDifference / 60;
    hours = minutes / 60;
    if (hours<0 || minutes<0) {
    }
    else
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
    NSDate *date = [NSDate date];
    NSDate *dateToFire = [date dateByAddingTimeInterval:(hrs+mins)];
    [localNotification setFireDate:dateToFire];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [localNotification setSoundName:@"azan1.wav"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:setVal forKey:@"setAlarm"];
    localNotification.userInfo = userInfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Alarm has been set successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(void)cancelAlarm
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        NSDictionary *userInfo = notification.userInfo;
        if ([setVal isEqualToString:[userInfo objectForKey:@"setAlarm"]]){
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
