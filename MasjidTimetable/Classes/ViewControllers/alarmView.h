//
//  alarmView.h
//  Masjid Timetable
//
//  Created by Lentrica Software -  © 2015
//  Copyright Lentrica Software -  © 2015. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface alarmView : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIButton *drop1;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;
@property (strong, nonatomic) IBOutlet UIButton *drop2;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *picker1;
@property (strong, nonatomic) IBOutlet UIPickerView *picker2;

- (IBAction)setAlarm;
- (IBAction)cancel:(id)sender;
- (IBAction)done;
- (IBAction)popview;
- (IBAction)minutesClickd;
- (IBAction)afterClickd;
- (IBAction)popView;

@end
