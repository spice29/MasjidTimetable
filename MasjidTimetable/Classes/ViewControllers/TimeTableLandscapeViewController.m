//
//  TimeTableLandscapeViewController.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/16/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimeTableLandscapeViewController.h"
#import "TimeTableLanscapeContainerView.h"
#import "timeTable.h"

@interface TimeTableLandscapeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    TimeTableLanscapeContainerView *firstView;
    TimeTableLanscapeContainerView *secondView;
    TimeTableLanscapeContainerView *thirdView;
    NSArray *timeTableData;
    NSArray *firstMonthData;
    NSArray *secondMonthData;
    NSArray *thirdsMonthData;
}
@end

@implementation TimeTableLandscapeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timeTableData = [[MTDBHelper sharedDBHelper] getMasjidTimetablesToDate:[self endOfMonth:3] forMasjid:self.masjidId];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setScrollViewItems];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.scrollView = nil;
    firstView = nil;
    secondView = nil;
    
    [super viewWillDisappear:animated];
}

- (void)showScrollItems
{
    NSString *text = @"No masjid has been set as a favourite for this position.";
    NSDate *today = [self today];
    if (self.masjidId) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"d MMM yyyy"];
        NSString *todayDateString = [dateFormatter stringFromDate:today];
        MasjidTimetable *firstTimetable;
        MasjidTimetable *secondTimetable ;
        
        if ([timeTableData count] > 0) {
            firstTimetable = timeTableData[0];
            secondTimetable = timeTableData[[timeTableData count] - 1];
        }
        [dateFormatter setDateFormat:@"MMM yyyy"];
        NSString *interval;
        if (firstTimetable && secondTimetable) {
            interval = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:firstTimetable.date], [dateFormatter stringFromDate:secondTimetable.date]];
        }
        
        [self.masjidNameLabel setText:self.masjidName];
        [self.navigationRightLabel setText:todayDateString];
        [self.navigationLeftLabel setText:interval];
        [self.navigationCenterLabel setText:self.masjidName];
    }
    
    if ([timeTableData count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", today, [self endOfMonth:1]];
        firstMonthData = [timeTableData filteredArrayUsingPredicate:predicate];
        
        predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [self startOfMonth:1], [self endOfMonth:2]];
        secondMonthData = [timeTableData filteredArrayUsingPredicate:predicate];
        
        predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [self startOfMonth:2], [self endOfMonth:3]];
        thirdsMonthData = [timeTableData filteredArrayUsingPredicate:predicate];
    }
    
    if ([firstMonthData count] == 0) {
        [firstView.noDataLabel setHidden:NO];
        [firstView.noDataLabel setText:text];
    } else {
        NSString *month = [[firstMonthData[0] parsedDate] componentsSeparatedByString:@" "][1];
        [self.navigationCenterLabel setText:[NSString stringWithFormat:@"Viewing %@", month]];
    }
    if ([secondMonthData count] == 0) {
        [secondView.noDataLabel setHidden:NO];
        [secondView.noDataLabel setText:text];
    }
    if ([thirdsMonthData count] == 0) {
        [thirdView.noDataLabel setHidden:NO];
        [thirdView.noDataLabel setText:text];
    }
}

- (void)setScrollViewItems
{
    [self.scrollView setContentSize:CGSizeMake(ScreenSizeWidth* 3, ScreenSizeHeight)];
    [self.scrollView setPagingEnabled:YES];
    firstView = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableLanscapeContainerView" owner:nil options:nil] lastObject];
    secondView = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableLanscapeContainerView" owner:nil options:nil] lastObject];
    thirdView = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableLanscapeContainerView" owner:nil options:nil] lastObject];
    [firstView setFrame:CGRectMake(15, 70, self.view.bounds.size.width - 30, self.view.bounds.size.height - 76 )];
    [secondView setFrame:CGRectMake(self.view.bounds.size.width + 15, 70, self.view.bounds.size.width-30, self.view.bounds.size.height - 76)];
    [thirdView setFrame:CGRectMake(self.view.bounds.size.width*2 + 15,70, self.view.bounds.size.width - 30, self.view.bounds.size.height - 76)];
    [firstView.tableView setDelegate:self];
    [firstView.tableView setDataSource:self];
    [secondView.tableView setDelegate:self];
    [secondView.tableView setDataSource:self];
    [thirdView.tableView setDelegate:self];
    [thirdView.tableView setDataSource:self];
    [firstView.tableView setTag:1];
    [secondView.tableView setTag:2];
    [thirdView.tableView setTag:3];
    
    [self.scrollView addSubview:firstView];
    [self.scrollView addSubview:secondView];
    [self.scrollView addSubview:thirdView];
    
    [self showScrollItems];
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

- (NSDate *)startOfMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:[NSDate date]];
    [components setMonth:[components month] + month];
    [components setDay:1];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *months = [[NSDateComponents alloc] init];
    [months setMonth:month];
    NSDate *plusOneMonthDate = [calendar dateByAddingComponents:months toDate:[NSDate date] options:0];
    
    NSDateComponents *plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate:plusOneMonthDate];
    
    return [[calendar dateFromComponents:plusOneMonthDateComponents] dateByAddingTimeInterval:-1];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return [firstMonthData count];
    } else if (tableView.tag == 2) {
        return [secondMonthData count];
    } else {
        return [thirdsMonthData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simple = @"timeTableLandscape";
    timeTable *cell = (timeTable *)[tableView dequeueReusableCellWithIdentifier:simple];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"timeTable" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == 0 && tableView.tag == 1) {
        UIColor *setingColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.date.textColor = setingColor;
        cell.fezarB.textColor = setingColor;
        cell.fazarJ.textColor = setingColor;
        cell.sunrise.textColor = setingColor;
        cell.zoharB.textColor = setingColor;
        cell.zoharJ.textColor = setingColor;
        cell.asarB.textColor = setingColor;
        cell.asarJ.textColor = setingColor;
        cell.magribB.textColor = setingColor;
        cell.magribJ.textColor = setingColor;
        cell.eshaB.textColor = setingColor;
        cell.eshaJ.textColor = setingColor;
        cell.bStart.textColor = setingColor;
        cell.bEnd.textColor = setingColor;
    }
    
    MasjidTimetable *timetable;
    if (tableView.tag == 1) {
        timetable = [firstMonthData objectAtIndex:indexPath.row];
    } else if (tableView.tag == 2) {
        timetable = [secondMonthData objectAtIndex:indexPath.row];
    } else {
        timetable = [thirdsMonthData objectAtIndex:indexPath.row];
    }
    
    cell.date.text = [timetable parsedShortDate];
    cell.fezarB.text = timetable.subahsadiq;
    cell.fazarJ.text = timetable.fajar;
    cell.sunrise.text = timetable.sunrise;
    cell.zoharB.text = timetable.zohar;
    cell.zoharJ.text = timetable.zoharj;
    cell.asarB.text = timetable.asar;
    cell.asarJ.text = timetable.asarj;
    cell.magribB.text = timetable.sunset;
    cell.magribJ.text = timetable.maghrib;
    cell.eshaB.text = timetable.esha;
    cell.eshaJ.text = timetable.eshaj;
    
    return cell;
}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    int pageNumber = lround(fractionalPage);
    [self.pageController setCurrentPage:pageNumber];
    
    MasjidTimetable *firstTimetableItem;
    if (pageNumber == 0) {
        if ([firstMonthData count] != 0) {
            firstTimetableItem = firstMonthData[0];
        }
    } else if (pageNumber == 1) {
        if ([secondMonthData count] != 0) {
            firstTimetableItem = secondMonthData[0];
        }
    } else {
        if ([thirdsMonthData count] != 0) {
            firstTimetableItem = thirdsMonthData[0];
        }
    }
    
    if (firstTimetableItem) {
        NSString *month = [[firstTimetableItem parsedDate] componentsSeparatedByString:@" "][1];
        [self.navigationCenterLabel setText:[NSString stringWithFormat:@"Viewing %@", month]];
    }
}

@end
