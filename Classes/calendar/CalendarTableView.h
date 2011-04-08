//
//  CalendarTableView.h
//  Calendar
//
//  Created by Michael Anteboth on 20.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalEvent.h"
#import "CalItemView.h"
#import "CalEventDescriptor.h"

@protocol CalendarTableViewDelegate

-(NSDate*) getDisplayedDay;
-(void) setDisplayedDay:(NSDate*)day;

-(NSArray*) getAllItemsForCurrentDay;
-(void) release;
-(void) clearCachedData;
-(long) getDurationOfAllEntriesForCurrentDay;

@end



@interface CalendarTableView : UITableView {
	id <CalendarTableViewDelegate> calendarDelegate;
	NSDate* displayedDay;
	NSArray* colors;
	CalItemView* calItemView;
	CGPoint mystartTouchPosition;
	BOOL isProcessingListMove;
}

@property (retain) NSArray* colors;
@property (retain) CalItemView* calItemView;
@property (retain) NSDate* displayedDay;
@property (retain) id <CalendarTableViewDelegate> calendarDelegate;

-(BOOL) overlaps:(CalEvent*)calEvent otherEvent:(CalEvent*) otherEvent;
-(int) getIndentLevel:(CalEvent*)calItem allCalItems:(NSArray*) allCalItems;
-(void) reloadCalData;

-(void) moveToNextItem;
-(void) moveToPreviousItem;
-(void) loadEntryAndShowDefaultCalItemViewState:(BOOL)nextEntry;

-(CalEventDescriptor*) createCalItemDesc:(int)hour 
								minutes:(int)min 
						   durationHour:(int)durHour 
							durationMin:(int)durMin 
								  color:(UIColor*)color 
							indentLevel:(int)indentLevel 
								   text:(NSString*)txt 
							description:(NSString*) description;

@end
