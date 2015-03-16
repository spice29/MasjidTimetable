//
//  ramadhanTimeTableCell.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/20/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "ramadhanTimeTableCell.h"

@implementation ramadhanTimeTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    UIColor *setingColor = [UIColor whiteColor];
    self.date.textColor = setingColor;
    self.fajar.textColor = setingColor;
    self.sunrise.textColor = setingColor;
    self.zohar.textColor = setingColor;
    self.iftar.textColor = setingColor;
    self.asar.textColor = setingColor;
    self.zoharB.textColor = setingColor;
    self.eshaBegin.textColor = setingColor;
    self.asarJammat.textColor = setingColor;
    self.b.textColor = setingColor;
    self.j.textColor = setingColor;
    self.maghrib.textColor = setingColor;
    self.sehriEnd.textColor = setingColor;
    self.esha.textColor = setingColor;
    self.subah.textColor = setingColor;

}

@end
