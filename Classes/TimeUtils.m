//
//  TimeUtils.m
//  TaskTracker
//
//  Created by Michael Anteboth on 27.03.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeUtils.h"


@implementation TimeUtils

+ (NSDate*) getCurrentDateRoundToMinute {
	NSDate* now = [NSDate date];
	NSTimeInterval nowInSecs = [now timeIntervalSince1970];
	int secsToSubtract = fmod(nowInSecs, 60);
	nowInSecs = nowInSecs - secsToSubtract;
	NSDate* date = [NSDate dateWithTimeIntervalSince1970:nowInSecs];
	return date;
}

+ (NSString*) formatDate:(NSDate*)date withFormatType:(int)formatType {
	NSString* dateString;
	if (formatType == LONG_FORMAT) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateStyle:NSDateFormatterLongStyle];
		[dateFormat setTimeStyle:NSDateFormatterNoStyle];
		dateString = [dateFormat stringFromDate:date];  
		[dateFormat release];
	} else if (formatType == FULL_FORMAT) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateStyle:NSDateFormatterFullStyle];
		[dateFormat setTimeStyle:NSDateFormatterNoStyle];
		dateString = [dateFormat stringFromDate:date];  
		[dateFormat release];
	} else if (formatType == MEDIUM_FORMAT) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//		[dateFormat setDateFormat:@"EEE d.MM.YYYY"];
		[dateFormat setDateStyle:NSDateFormatterMediumStyle];
		[dateFormat setTimeStyle:NSDateFormatterNoStyle];
		dateString = [dateFormat stringFromDate:date];  
		[dateFormat release];
	} else if (formatType == SHORT_FORMAT) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateStyle:NSDateFormatterShortStyle];
		[dateFormat setTimeStyle:NSDateFormatterNoStyle];
//		[dateFormat setDateFormat:@"d.MM.YY"];
		dateString = [dateFormat stringFromDate:date];  
		[dateFormat release];
	} else if (formatType == TINY_FORMAT) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		NSString* format = NSLocalizedString(@"tinyDateFormat", @"");
		[dateFormat setDateFormat:format];
		dateString = [dateFormat stringFromDate:date];  
		[dateFormat release];
	}
	
	return dateString;
}

+ (NSString*) formatTime:(NSDate*) date withFormatType:(int)formatType {
	if (formatType == MEDIUM_FORMAT) {
		NSDateFormatter *tf = [[NSDateFormatter alloc] init];
		[tf setDateStyle:NSDateFormatterNoStyle];
		[tf setTimeStyle:NSDateFormatterShortStyle];
		NSString *s = [tf stringFromDate:date];
		[tf release];
		return s;
	} else if (formatType == LONG_FORMAT) {
		NSDateFormatter *tf = [[NSDateFormatter alloc] init];
		[tf setDateStyle:NSDateFormatterNoStyle];
		[tf setTimeStyle:NSDateFormatterMediumStyle];
		NSString *s = [tf stringFromDate:date];
		[tf release];
		return s;		
	}
	return @"";
}


+ (NSString*) formatDateAndTime:(NSDate*) date withFormatType:(int)formatType {
	NSString* dateString = [TimeUtils formatDate:date withFormatType:formatType];
	NSString* timeString = [TimeUtils formatTime:date withFormatType:formatType];		
	NSString* dateTimeFormat = NSLocalizedString(@"workUnitDetails.dateTimeFormat", @"");
	NSString* s = [NSString stringWithFormat:dateTimeFormat, dateString, timeString];
	return s;
}

//creates a formatted time string for the given hr and minute
+(NSString*) getTimeString:(int)hr min:(int)min {
	NSString *dateStr = [NSString stringWithFormat:@"%i:%i", hr, min];
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"HH:mm"];
	NSDate *date = [dateFormat dateFromString:dateStr];  
	
	NSString* s = [TimeUtils formatTime:date withFormatType:2];
	if (s == nil) s = @"";
	return s;
}

//creates a formatted duration string for the given hr and minute
+(NSString*) getDurationString:(int)hr min:(int)min {
	NSString* sh;
	NSString* sm;
	if (hr<10) {
		sh = [NSString stringWithFormat:@"0%i", hr];
	} else {
		sh = [NSString stringWithFormat:@"%i", hr];
	}
	
	if (min<10) {
		sm = [NSString stringWithFormat:@"0%i", min];
	} else {
		sm = [NSString stringWithFormat:@"%i", min];
	}
	
	return [NSString stringWithFormat:@"%@:%@", sh, sm];
}

/* format seconds to  e.g. 2:19 h for 2 hours and 19 minutes */
+(NSString*) formatSeconds:(float)timeInSecs {	
	const int secsPerMin = 60;
	const int secsPerHour = secsPerMin * 60;
	const char *timeSep = ":"; //@TODO localise...
	const char *hrsName = "h";
	
	float time = timeInSecs;
	int hrs = time/secsPerHour;
	
	time -= hrs*secsPerHour;
	int mins = time/secsPerMin;
	//time -= mins*secsPerMin;
	
	return [NSString stringWithFormat:@"%d%s%02d %s", hrs, timeSep, mins, hrsName];
}

//Setzt die Zeit des Datum auf 00:00 Uhr, Tag, Monat und Jahr bleiben unveräbdert. Liedert das geänderte Datum zurück.
+(NSDate*) getStartTimeForDay:(NSDate*)date {

	NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = 
		[cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	
	NSInteger year = [comp year];
	NSInteger months = [comp month];
	NSInteger days = [comp day];
	
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setYear:year];
	[components setMonth:months];
	[components setDay:days];
	NSDate *newDate = [cal dateFromComponents:components];
	return newDate;	
}

//Setzt die Zeit des Datum auf 23:59 Uhr, Tag, Monat und Jahr bleiben unveräbdert. Liedert das geänderte Datum zurück.
+(NSDate*) getEndTimeForDay:(NSDate*)date {
	NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = 
	[cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	
	NSInteger year = [comp year];
	NSInteger months = [comp month];
	NSInteger days = [comp day];
	
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setYear:year];
	[components setMonth:months];
	[components setDay:days];
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
	
	NSDate *newDate = [cal dateFromComponents:components];
	return newDate;	
}



@end
