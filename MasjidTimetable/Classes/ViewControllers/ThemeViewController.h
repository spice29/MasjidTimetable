//
//  ThemeViewController.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface ThemeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *theme1;
@property (strong, nonatomic) IBOutlet UIButton *theme2;
@property (strong, nonatomic) IBOutlet UIView *themeView;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *dasboardBtn;

- (IBAction)Theme1Action;
- (IBAction)theme2Action;
- (IBAction)back;

@end
