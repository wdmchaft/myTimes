//
//  TimeUtils.h
//  TaskTracker
//
//  Created by Michael Anteboth on 27.03.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeUtils : NSObject {

}

#define LONG_FORMAT 1
#define MEDIUM_FORMAT 2
#define SHORT_FORMAT 3
#define TINY_FORMAT 4
#define FULL_FORMAT 5


//Returns the current date round off to a full minute
+ (NSDate*) getCurrentDateRoundToMinute;

+ (NSString*) formatDate:(NSDate*)date withFormatType:(int)formatType;
+ (NSString*) formatTime:(NSDate*)date withFormatType:(int)formatType;

+ (NSString*) formatDateAndTime:(NSDate*) date withFormatType:(int)formatType;

+(NSString*) getDurationString:(int)hr min:(int)min;
+(NSString*) getTimeString:(int)hr min:(int)min;
+(NSString*) formatSeconds:(float)timeInSecs;

+(NSDate*) getStartTimeForDay:(NSDate*)date;
+(NSDate*) getEndTimeForDay:(NSDate*)date;

@end
