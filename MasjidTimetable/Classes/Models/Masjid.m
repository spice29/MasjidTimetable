//
//  Masjid.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "Masjid.h"


@implementation Masjid

@dynamic name;
@dynamic localArea;
@dynamic largerArea;
@dynamic country;
@dynamic masjidId;
@dynamic add_1;
@dynamic postCode;
@dynamic telephone;
@dynamic status;
@dynamic favorite;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.masjidId = [[attributes valueForKeyPath:@"masjid_id"] intValue];
    NSString *name = [[attributes valueForKeyPath:@"masjid_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.name = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]];
    self.localArea = [attributes valueForKeyPath:@"masjid_local_area"];
    self.largerArea = [attributes valueForKeyPath:@"masjid_larger_area"];
    self.country = NULL_TO_NIL([attributes valueForKeyPath:@"masjid_country"]);
    self.add_1 = [attributes valueForKeyPath:@"masjid_add_1"];
    self.postCode = [attributes valueForKeyPath:@"masjid_post_code"];
    self.telephone = [attributes valueForKeyPath:@"masjid_telephone"];
    self.status = [attributes valueForKeyPath:@"status"];
    self.favorite = @"0";
    
    return self;
}

- (void)setAttributes:(NSDictionary *)attributes
{
    self.masjidId = [[attributes valueForKeyPath:@"masjid_id"] intValue];
    NSString *name = [[attributes valueForKeyPath:@"masjid_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.name = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]];
    self.localArea = [attributes valueForKeyPath:@"masjid_local_area"];
    self.largerArea = [attributes valueForKeyPath:@"masjid_larger_area"];
    self.country = NULL_TO_NIL([attributes valueForKeyPath:@"masjid_country"]);
    self.add_1 = [attributes valueForKeyPath:@"masjid_add_1"];
    self.postCode = [attributes valueForKeyPath:@"masjid_post_code"];
    self.telephone = [attributes valueForKeyPath:@"masjid_telephone"];
    self.status = [attributes valueForKeyPath:@"status"];
    self.favorite = NULL_TO_NIL([attributes valueForKeyPath:@"favorite"]) ? @"0" : [attributes valueForKeyPath:@"favorite"];
}

- (NSDictionary *)getAttributes
{
    return [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%i", self.masjidId], self.name, self.localArea, self.largerArea, self.country, self.add_1, self.postCode, self.telephone, self.status, self.favorite] forKeys:@[@"masjid_id", @"masjid_name", @"masjid_local_area", @"masjid_larger_area", @"masjid_country", @"masjid_add_1", @"masjid_post_code", @"masjid_telephone", @"status", @"favorite"]];
}

@end
