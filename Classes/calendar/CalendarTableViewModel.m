//
// Provides a sample implementation of CalendarTableViewDelegate
//  CalendarTableViewModel.m
//  Calendar
//
//  Created by Michael Anteboth on 21.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CalendarTableViewModel.h"
#import "CalEvent.h"

@implementation CalendarTableViewModel

NSInteger timeSort(id obj0, id obj1, void *reverse)
{
    CalEvent* c0 = (CalEvent*) obj0;
    CalEvent* c1 = (CalEvent*) obj1;
	
    NSComparisonResult comparison = [c0.date compare:c1.date];
	
    if ((BOOL *)reverse == NO) {
        return 0 - comparison;
    }
    return comparison;
}

-(void) clearCachedData {
}

-(long) getDurationOfAllEntriesForCurrentDay {
	return 0;
}

-(NSArray*) getAllItemsForCurrentDay {
	NSMutableArray* data = [[NSMutableArray alloc] initWithCapacity:4];
	
	NSCalendar* cal = [NSCalendar currentCalendar];
	NSDateComponents *dc;
	unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	
	if ([[self getDisplayedDay] isEqualToDate:today]) {

	CalEvent* e0 = [[CalEvent alloc] init];
	dc = [cal components:unitFlags fromDate:e0.date];
	[dc setHour:8];
	e0.date = [cal dateFromComponents:dc];
	e0.duration = [NSNumber numberWithInt:9600];
	[data addObject:e0];
	e0.description = @"CalEvent 0";
	[e0 release];

	CalEvent* e1 = [[CalEvent alloc] init];
	dc = [cal components:unitFlags fromDate:e1.date];
	[dc setHour:9];
	e1.date = [cal dateFromComponents:dc];
	[data addObject:e1];
	e1.duration = [NSNumber numberWithInt:28800];
	e1.description = @"CalEvent 1";
	[e1 release];
	
	CalEvent* e2 = [[CalEvent alloc] init];
	[data addObject:e2];
	e2.duration = [NSNumber numberWithInt:7200];
	dc = [cal components:unitFlags fromDate:e2.date];
	[dc setHour:10];
	e2.date = [cal dateFromComponents:dc];
	e2.description = @"CalEvent 2";
	[e2 release];
	
	CalEvent* e3 = [[CalEvent alloc] init];
	[data addObject:e3];
	e3.duration = [NSNumber numberWithInt:3600];
	dc = [cal components:unitFlags fromDate:e3.date];
	[dc setHour:11];
	e3.date = [cal dateFromComponents:dc];
	e3.description = @"CalEvent 3";
	[e3 release];	
	
	CalEvent* e4 = [[CalEvent alloc] init];
	[data addObject:e4];
	e4.duration = [NSNumber numberWithInt:3600];
	dc = [cal components:unitFlags fromDate:e4.date];
	[dc setHour:13];
	e4.date = [cal dateFromComponents:dc];
	e4.description = @"CalEvent 4";
	[e4 release];	
	
	}
	
	//sort data
	BOOL reverseSort = NO;
	NSArray* sortedArray = [data sortedArrayUsingFunction:timeSort context:&reverseSort];
	
	return sortedArray;
	//[data release];
}


-(NSDate*) getDisplayedDay {
	if (displayedDay == nil) {
		today = [[NSDate date] retain];
		displayedDay = [today retain];
	}
	return displayedDay;
}

-(void) setDisplayedDay:(NSDate*)day {
	displayedDay = day;
}

- (void)dealloc {
    [super dealloc];
}

-(void) release {
	[super release];
}


@end
