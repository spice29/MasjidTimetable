//
//  ramadhanTimeTableCell.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/20/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

@interface ramadhanTimeTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *b;
@property (weak, nonatomic) IBOutlet UILabel *j;
@property (weak, nonatomic) IBOutlet UILabel *sehriEnd;
@property (weak, nonatomic) IBOutlet UILabel *subah;
@property (weak, nonatomic) IBOutlet UILabel *fajar;
@property (weak, nonatomic) IBOutlet UILabel *sunrise;
@property (weak, nonatomic) IBOutlet UILabel *zoharB;
@property (weak, nonatomic) IBOutlet UILabel *zohar;
@property (weak, nonatomic) IBOutlet UILabel *asar;
@property (weak, nonatomic) IBOutlet UILabel *asarJammat;
@property (weak, nonatomic) IBOutlet UILabel *iftar;
@property (weak, nonatomic) IBOutlet UILabel *maghrib;
@property (weak, nonatomic) IBOutlet UILabel *eshaBegin;
@property (weak, nonatomic) IBOutlet UILabel *esha;

@end
