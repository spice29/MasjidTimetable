//
//  MTDBHelper.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Masjid.h"
#import "MasjidTimetable.h"
#import "Event.h"
#import "Donation.h"
#import "Note.h"
#import "Ramadhan.h"
#import "TimeTableFormat.h"
#import "JammatSoundSettings.h"

@interface MTDBHelper : NSObject

+ (instancetype)sharedDBHelper;
- (void)saveContext;
- (NSManagedObjectContext *)managedObjectContext;

- (Masjid*)createMasjidWithAttributes:(NSDictionary*)attributes;
- (Masjid*)updateMasjidWithAttributes:(NSDictionary*)attributes;
- (Masjid*)getMasjidWithID:(NSString*)ID;
- (Masjid*)getFavoritMasjidByPriority:(NSString*)priority;
- (void)addMasjids:(NSArray*)response;
- (void)updateMasjids:(NSArray*)response;
- (NSArray*)getMasjids;
- (NSArray*)searchMasjids:(NSString *) keyword;

- (MasjidTimetable*)createTimetableWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId;
- (MasjidTimetable*)updateTimetableWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId;
- (MasjidTimetable*)getTimetableWithMashjidID:(int)ID forDate:(NSDate*)date;
- (MasjidTimetable*)getLastestTimetableWithMashjidID:(int)ID;
- (void)addTimetables:(NSArray*)response forMasjid:(int)masjidId;
- (void)updateTimetables:(NSArray*)response forMasjid:(int)masjidId;
- (NSArray*)getMasjidTimetablesToDate:(NSDate*)date forMasjid:(int)masjidId;

- (Ramadhan*)createRamadhanWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId;
- (Ramadhan*)updateRamadhanWithAttributes:(NSDictionary *)attributes forMasjid:(int)masjidId;
- (Ramadhan*)getRamadhanWithMashjidID:(int)ID forDate:(NSDate*)date;
- (void)updateRamadhans:(NSArray*)response forMasjid:(int)masjidId;
- (NSArray*)getRamadhansWithMashjidID:(int)ID;

- (Event*)createEventWithAttributes:(NSDictionary*)attributes;
- (Event*)updateEventWithAttributes:(NSDictionary*)attributes;
- (Event*)getEventWithID:(NSString*)ID;
- (void)updateEvents:(NSArray*)response;
- (NSArray*)getEvents:(int)masjidId;

- (Donation*)createDonationWithAttributes:(NSDictionary*)attributes;
- (Donation*)updateDonationWithAttributes:(NSDictionary*)attributes;
- (Donation*)getDonationWithID:(NSString*)ID;
- (void)updateDonations:(NSArray*)response;
- (NSArray*)getDonations:(int)masjidId;

- (Note*)createNoteWithAttributes:(NSDictionary*)attributes;
- (Note*)updateNoteWithAttributes:(NSDictionary*)attributes;
- (Note*)getNoteWithID:(NSString*)ID;
- (void)updateNotes:(NSArray*)response;
- (NSArray*)getNotes:(int)masjidId;

- (TimeTableFormat*)createTimeTableFormatWithAttributes:(NSDictionary *)attributes;
- (TimeTableFormat*)updateTimeTableFormatWithAttributes:(NSDictionary *)attributes;
- (void)updateTimeTableFormats:(NSArray*)response;
- (TimeTableFormat*)getTimeTableFormatWithID:(NSString*)ID;
- (TimeTableFormat*)getCurrentMontTimeTableFormat:(int)masjidId;
- (NSArray*)getTimeTableFormats:(int)masjidId;

- (JammatSoundSettings *)createJammatSoundSettings;
- (JammatSoundSettings *)getJammatSoundSettings;

@end
