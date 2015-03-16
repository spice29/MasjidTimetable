//
//  timeTableContentView.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/14/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimetableMidleInfoTableView.h"

@interface TimeTableContentView : UIView

@property (weak, nonatomic) IBOutlet UILabel *masjidInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *masjidnameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstViewbackground;
@property (weak, nonatomic) IBOutlet UIImageView *secondViewbackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *timeMeterImage;
@property (weak, nonatomic) IBOutlet UIButton *eventsBtn;
@property (weak, nonatomic) IBOutlet UIButton *donationBtn;
@property (weak, nonatomic) IBOutlet UIButton *ramadhanBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redButtonImageView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *greenButtonImageView;
@property (weak, nonatomic) IBOutlet UIButton *fajarMuteBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoharMuteBtn;
@property (weak, nonatomic) IBOutlet UIButton *asarMuteBtn;
@property (weak, nonatomic) IBOutlet UIButton *maghribMuteBtn;
@property (weak, nonatomic) IBOutlet UIButton *eshaMuteBtn;
@property (weak, nonatomic) IBOutlet TimetableMidleInfoTableView *notesTableView;
@property (weak, nonatomic) IBOutlet UIView *midleContentView;
@property (weak, nonatomic) IBOutlet UIButton *fajarVolumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *eshaVolumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *maghribVolumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *asarVolumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoharVolumeBtn;
@property (weak, nonatomic) IBOutlet UITextField *fajarLabel;
@property (weak, nonatomic) IBOutlet UITextField *zoharLabel;
@property (weak, nonatomic) IBOutlet UITextField *asarlabel;
@property (weak, nonatomic) IBOutlet UITextField *maghribLabel;
@property (weak, nonatomic) IBOutlet UITextField *eshaLabel;
@property (weak, nonatomic) IBOutlet UITextField *fajarJLabel;
@property (weak, nonatomic) IBOutlet UITextField *zoharJlabel;
@property (weak, nonatomic) IBOutlet UITextField *asarJLabel;
@property (weak, nonatomic) IBOutlet UITextField *maghribJLabel;
@property (weak, nonatomic) IBOutlet UITextField *eshaJLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenLabel;
@property (weak, nonatomic) IBOutlet UITextField *sunriselabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *fajarTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoharTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *asarTitlelabel;
@property (weak, nonatomic) IBOutlet UILabel *maghribTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eshaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *digitalTimeLabel;
@property (weak, nonatomic) IBOutlet TimetableMidleInfoTableView *midleTableView;

- (void)changeMidleViewToRamadhanView:(BOOL)isRamadhanTable;

@end
