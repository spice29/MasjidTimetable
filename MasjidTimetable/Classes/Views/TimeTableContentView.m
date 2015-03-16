//
//  timeTableContentView.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/14/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimeTableContentView.h"

@implementation TimeTableContentView

- (void)awakeFromNib
{
    [self.midleContentView setHidden:YES];
    [self.noDataLabel setText:@"No data are available at this time. Pleasecheck with masjid administartor."];
    [self.noDataLabel setHidden:YES];
    if (IS_IPAD) {
        self.digitalTimeLabel.font=[UIFont systemFontOfSize:12];
        self.captionLabel.font=[UIFont systemFontOfSize:10];
        self.digitalTimeLabel.frame=CGRectMake(47.5,90,60,15);
        self.captionLabel.frame=CGRectMake(43,100,80,23);
    } else if (IS_IPHONE_6P) {
        self.timeMeterImage.frame = CGRectMake(3.5,45,175,130);
        self.digitalTimeLabel.frame=CGRectMake(60.5,210,60,15);
        self.captionLabel.frame=CGRectMake(43,115,80,23);
    } else if (IS_IPHONE_6) {
        self.timeMeterImage.frame=CGRectMake(7,42,146,108);
        self.digitalTimeLabel.frame=CGRectMake(55,95,30,15);
        self.captionLabel.frame=CGRectMake(34,101,80,23);
    } else if (IS_IPHONE_5) {
        self.timeMeterImage.frame=CGRectMake(6,38,124.7,95);
        self.digitalTimeLabel.font=[UIFont systemFontOfSize:8];
        self.captionLabel.font=[UIFont systemFontOfSize:6];
        self.digitalTimeLabel.frame=CGRectMake(54.5,90,30,15);
        self.captionLabel.frame=CGRectMake(29,95,80,23);
    } else if (IS_IPHONE_4) {
        self.timeMeterImage.frame=CGRectMake(8,27,127,95);
        self.digitalTimeLabel.frame=CGRectMake(48,82,48,23);
        self.captionLabel.frame=CGRectMake(32,90,80,30);
        self.captionLabel.font=[UIFont systemFontOfSize:6];
    }
}

- (void)changeMidleViewToRamadhanView:(BOOL)isRamadhanTable
{
    if (isRamadhanTable) {
        [self.headerView setHidden:NO];
        [self.midleTableView setFrame:CGRectMake(0, self.headerView.frame.size.height, self.midleTableView.frame.size.width, self.midleContentView.frame.size.height - self.headerView.frame.size.height)];
    } else {
        [self.headerView setHidden:YES];
        [self.midleTableView setFrame:CGRectMake(0, 0, self.midleTableView.frame.size.width, self.midleContentView.frame.size.height)];
    }
}

@end
