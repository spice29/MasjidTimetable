//
//  JammatNotificationsView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface JammatNotificationsView : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *fajar;
@property (strong, nonatomic) IBOutlet UITextField *zohar;
@property (strong, nonatomic) IBOutlet UITextField *asar;
@property (strong, nonatomic) IBOutlet UITextField *maghrib;
@property (strong, nonatomic) IBOutlet UITextField *esha;
@property (strong, nonatomic) IBOutlet UIImageView *fajarAlert;
@property (strong, nonatomic) IBOutlet UIImageView *zoharAlert;
@property (strong, nonatomic) IBOutlet UIImageView *asarAlert;
@property (strong, nonatomic) IBOutlet UIImageView *magribAlert;
@property (strong, nonatomic) IBOutlet UIImageView *eshaAlert;
@property (strong, nonatomic) IBOutlet UIImageView *popupAlert;
@property (strong, nonatomic) IBOutlet UIImageView *radio1;
@property (strong, nonatomic) IBOutlet UIImageView *radio2;
@property (strong, nonatomic) IBOutlet UIButton *jammatNotification;
@property (strong, nonatomic) IBOutlet UIButton *mute;
@property (strong, nonatomic) IBOutlet UIButton *other;
@property (strong, nonatomic) IBOutlet UIButton *misc;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UIPickerView *tablePicker;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *pickTable;
@property (strong, nonatomic) IBOutlet UILabel *pickLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelClickd;
@property (strong, nonatomic) IBOutlet UIButton *doneClikd;
@property (strong, nonatomic) IBOutlet UILabel *frstText;
@property (strong, nonatomic) IBOutlet UILabel *f;
@property (strong, nonatomic) IBOutlet UILabel *z;
@property (strong, nonatomic) IBOutlet UILabel *a;
@property (strong, nonatomic) IBOutlet UILabel *mpray;
@property (strong, nonatomic) IBOutlet UILabel *e;
@property (strong, nonatomic) IBOutlet UILabel *prayerName;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;
@property (strong, nonatomic) IBOutlet UILabel *minsBf;
@property (strong, nonatomic) IBOutlet UILabel *notification;
@property (strong, nonatomic) IBOutlet UILabel *pickerlabel;

- (IBAction)alertOnOffClick:(UIButton *)sender;
- (IBAction)btnAction;
- (IBAction)donePicker;
- (IBAction)cancelPicker;
- (IBAction)miscClicked;
- (IBAction)otherClicked;
- (IBAction)muteClicked;
- (IBAction)jammatClicked;
- (IBAction)zoharAlertOnOFF:(UIButton *)sender;
- (IBAction)asarOnOFF:(UIButton *)sender;
- (IBAction)magribONOFF:(UIButton *)sender;
- (IBAction)eshaONOFF:(UIButton *)sender;
- (IBAction)soundAlert:(UIButton *)sender;
- (IBAction)popupAlertONOFF:(UIButton *)sender;

@end
