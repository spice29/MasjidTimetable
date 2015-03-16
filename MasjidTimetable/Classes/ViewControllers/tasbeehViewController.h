//
//  tasbeehViewController.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "STKSpinnerView.h"

@interface tasbeehViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *counterBtn;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UIImageView *ringerImage;
@property (strong, nonatomic) IBOutlet UIButton *dashboardBtn;
@property (strong, nonatomic) IBOutlet UIButton *resetBtn;

- (IBAction)popView;
- (IBAction)resetCounter;

@end
