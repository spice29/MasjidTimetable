//
//  tasbeehSettings.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface tasbeehSettings : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UIView *soundView;
@property (strong, nonatomic) IBOutlet UIImageView *azan;
@property (strong, nonatomic) IBOutlet UIImageView *phoneAlert;
@property (strong, nonatomic) IBOutlet UIImageView *sound;
@property (strong, nonatomic) IBOutlet UIImageView *vibImage;
@property (strong, nonatomic) IBOutlet UIImageView *bothImage;
@property (strong, nonatomic) IBOutlet UITextField *counterValue;

- (IBAction)both;
- (IBAction)playSound;
- (IBAction)vibration;
- (IBAction)selectSound;

@end
