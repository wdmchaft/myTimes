//
//  CalendarTableView.m
//  Calendar
//
//  Created by Michael Anteboth on 20.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CalendarTableView.h"
#import "CalItemView.h"
#import "CalEvent.h"
#import "CalEventDescriptor.h"
#import "CalendarTableViewController.h"
#import "TimeUtils.h"

@implementation CalendarTableView

@synthesize calendarDelegate;
@synthesize displayedDay;
@synthesize calItemView;
@synthesize colors;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) 
    {
        // Initialization code
		self.bounces = false;		
		
	}
    return self;
}


#pragma mark Horizontal Scrolling support 


#define HORIZ_SWIPE_DRAG_MIN 100

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {	
	UITouch *touch = [touches anyObject];
	CGPoint newTouchPosition = [touch locationInView:self];
	if(mystartTouchPosition.x != newTouchPosition.x || mystartTouchPosition.y != newTouchPosition.y) {
		isProcessingListMove = NO;
	}
	mystartTouchPosition = [touch locationInView:self];
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *touch = touches.anyObject;
	CGPoint currentTouchPosition = [touch locationInView:self];
	
	// If the swipe tracks correctly.
	double diffx = mystartTouchPosition.x - currentTouchPosition.x + 0.1; // adding 0.1 to avoid division by zero
	double diffy = mystartTouchPosition.y - currentTouchPosition.y + 0.1; // adding 0.1 to avoid division by zero
	
	if(abs(diffx / diffy) > 1 && abs(diffx) > HORIZ_SWIPE_DRAG_MIN)
	{
		// It appears to be a swipe.
		if(isProcessingListMove) {
			// ignore move, we're currently processing the swipe
			return;
		}
		
		if (mystartTouchPosition.x < currentTouchPosition.x) {
			isProcessingListMove = YES;
			[self moveToNextItem];
			return;
		}
		else {
			isProcessingListMove = YES;
			[self moveToPreviousItem];
			return;
		}
	}
	else if(abs(diffy / diffx) > 1)
	{
		isProcessingListMove = YES;
		[super touchesMoved:touches withEvent:event];
	}
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
	isProcessingListMove = NO;
	[super touchesEnded:touches withEvent:event];
} 

#define DEFAULT_ALPHA 0.85
#define ANI_DELAY 0.4

//switch back to normal view state and load the next day in calendar
-(void) animationToRightDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*) context {
	[self loadEntryAndShowDefaultCalItemViewState:TRUE];
}

//switch back to normal view state and load the previous day in calendar
-(void) animationToLeftDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*) context {
	[self loadEntryAndShowDefaultCalItemViewState:FALSE];
}

//switch back to normal view state and load the next or the previous day in calendar 
-(void) loadEntryAndShowDefaultCalItemViewState:(BOOL)prevEntry {
	//load next entry
	CalendarTableViewController* ctl = (CalendarTableViewController*) self.delegate;
	if (prevEntry) {
		//load the next day
		[ctl loadPrev:self];
	} else {
		//load previous day
		[ctl loadNext:self];
	}

	//move to default location
	calItemView.frame = CGRectMake(0, calItemView.frame.origin.y, calItemView.frame.size.width, calItemView.frame.size.height);
	
	[UIView beginAnimations:@"animateBack" context:nil];
	[UIView setAnimationDuration: ANI_DELAY];	
	//fade in
	calItemView.alpha = DEFAULT_ALPHA;
	[UIView commitAnimations];
}

//scroll to right and fade out the cal item view
-(void) moveToNextItem {
	[UIView beginAnimations:@"moveRight" context:nil];
	[ UIView setAnimationDelegate: self ]; // Set the delegate (Only needed if you need to use the animationDid... selectors)
	[UIView  setAnimationDidStopSelector:@selector(animationToRightDidStop:finished:context:)]; 
	[UIView setAnimationDuration: ANI_DELAY]; //time (0.5 secs)
	
	//scroll to right
	calItemView.frame = CGRectMake(calItemView.frame.origin.x + 150,
							calItemView.frame.origin.y,	calItemView.frame.size.width , calItemView.frame.size.height);
	//and fade out
	calItemView.alpha = 0.0;
	[UIView commitAnimations]; //animate
}

//scroll to left and fade out cal item view
-(void) moveToPreviousItem {
	[UIView beginAnimations:@"moveLeft" context:nil];
	[ UIView setAnimationDelegate: self ]; // Set the delegate (Only needed if you need to use the animationDid... selectors)
	[UIView  setAnimationDidStopSelector:@selector(animationToLeftDidStop:finished:context:)]; 
	[UIView setAnimationDuration: ANI_DELAY]; //time (0.5 secs)
	
	//scroll to right
	calItemView.frame = CGRectMake(calItemView.frame.origin.x - 150,
								   calItemView.frame.origin.y,	calItemView.frame.size.width , calItemView.frame.size.height);
	//and fade out
	calItemView.alpha = 0.0;
	[UIView commitAnimations]; //animate
}


#pragma mark display calendar items

#define LEFT_OFFSET 60;
#define ROW_HEIGHT 60;
#define DEFAULT_WIDTH 160;
#define MIN_HEIGHT 30;

//calculates the rect for the cal event to display, creates the descripto object which contains all
//nessecary data to display the event item
-(CalEventDescriptor*) createCalItemDesc:(int)hour minutes:(int)min durationHour:(int)durHour durationMin:(int)durMin color:(UIColor*)color indentLevel:(int)indentLevel text:(NSString*)txt description:(NSString*) description {
	
	int x = LEFT_OFFSET;
	int y = hour * ROW_HEIGHT;
	y = y + min;
	y = y + 30;
	int h = durHour*ROW_HEIGHT;
	h = h + durMin;
	int w = DEFAULT_WIDTH;
	
	//consider indent level
	x = x + (10 * indentLevel);
	
	//consider minimum height
	int mh = MIN_HEIGHT;
	if (h < mh) h = mh;
	
	//create calitemview
	CGRect calFrame = CGRectMake(x, y, w, h);
	CalEventDescriptor* d = [[CalEventDescriptor alloc] init];
	d.rect = calFrame;
	d.text = txt;
	d.description = description;
	d.color = color;
	
	return d;
}


//reload all table data
-(void) reloadData {
	self.rowHeight = ROW_HEIGHT;
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	//relead table cells
	[super reloadData];
	
	//if calendar items view doesn't exit create it and show it
	if (self.calItemView == nil) {
		CGSize s = self.contentSize;
		CGRect r = CGRectMake(0, 0, s.width, s.height);
		self.calItemView = [[CalItemView alloc] initWithFrame:r];
		[self addSubview:calItemView];
	}
	
	//create some colors for the event items
	if (self.colors == nil) {
		UIColor* c1 = [UIColor colorWithRed:0.708 green:0.901 blue:0.98 alpha:1]; //pastel blue
		UIColor* c2 = [UIColor colorWithRed:0.639 green:0.901 blue:0.741 alpha:1]; //pastel green
		UIColor* c3 = [UIColor colorWithRed:0.976 green:0.894 blue:0.592 alpha:1]; //pastel yellow
		UIColor* c4 = [UIColor colorWithRed:0.992 green:0.258 blue:0.223 alpha:1]; //red		
		UIColor* c5 = [UIColor colorWithRed:0.97 green:0.81 blue:0.84 alpha:1]; //pastel pink		
		UIColor* c6 = [UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1]; //gray
		self.colors = [NSArray arrayWithObjects:c1, c2, c3, c4, c5, c6, nil];
	}
	
	//Reload calendar view data
	[self reloadCalData];
	
	//repaint of cal item view is nessecary
	[self.calItemView setNeedsDisplay];
}

//reload the event items
-(void) reloadCalData {
	NSCalendar* cal = [NSCalendar currentCalendar];
	unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	
	//get the data to display
	NSArray* data = [calendarDelegate getAllItemsForCurrentDay];
	
	//contains the cal descriptors with display information
	NSMutableArray* calDescs = [NSMutableArray arrayWithCapacity:[data count]];
	
	//create the single event descriptors
	int i=0;
	for (CalEvent* calEvent in data) {
		NSDateComponents *dc = [cal components:unitFlags fromDate:calEvent.date];
		int hour = [dc hour]; //hour of day
		int min = [dc minute];
		int dur = [calEvent.duration intValue]; //duration in secs
		
		NSDate* end = [[NSDate alloc] initWithTimeInterval:dur sinceDate:calEvent.date];
		NSDateComponents *dc1 = [cal components:unitFlags fromDate:end];
		int endHr = [dc1 hour];
		int endMin = [dc1 minute];	
		
		//duration in min. and hours (contains pause)
		int durMin = dur % 3600;
		if (durMin > 0) {
			durMin = durMin / 60;
		}
		dur = dur / 3600; // in hours
		
		//real duration (without pause)
		int rdur = [calEvent.duration intValue] - [calEvent.pause intValue]; //in secs
		//real duration mins
		int rdurMin = rdur % 3600;
		if (rdurMin > 0) {
			rdurMin = rdurMin / 60;
		}
		//real duration hours
		rdur = rdur / 3600;
		
		NSString* durStr = [TimeUtils getDurationString:rdur min:rdurMin];
		//the display text (1st row)
		//e.g. 10:00 - 16:00 Uhr (06:00h) 
		NSString* txt = [NSString stringWithFormat:@"%@ - %@ (%@h)", [TimeUtils getTimeString:hour min:min], [TimeUtils getTimeString:endHr min:endMin], durStr];
		
		
		//compute indent level (not for the first entry)
		if (i>0) {
			calEvent.indentLevel = [self getIndentLevel:calEvent allCalItems:data];
		}
		
		int colIdx = i % [colors count];
		
		CalEventDescriptor* desc = [self createCalItemDesc:hour 
												   minutes:min 
											  durationHour:dur 
											   durationMin:durMin 
													 color:[colors objectAtIndex:colIdx]  
											   indentLevel:calEvent.indentLevel 
													  text:txt 
											   description:calEvent.description];
		desc.indentLevel = calEvent.indentLevel;
		desc.referenceObject = calEvent.referenceObject;
		[calDescs addObject:desc];
		
		i++;
		[end release];
	}
	
	//set the descriptors in cal item view to be displayed
	[self.calItemView setCalItemDescriptors:calDescs];
	
	//scroll to first item
	if ([data count] > 0) {
		CalEvent* first = [data objectAtIndex:0];
		NSDateComponents *dc = [cal components:unitFlags fromDate:first.date];
		int hour = [dc hour]; //hour of day
		//scroll to the hours row
		[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:hour inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
	}

}


//returns the indent level for the event
-(int) getIndentLevel:(CalEvent*)calItem allCalItems:(NSArray*) allCalItems {
	int level = 0;
	
	for (CalEvent* ci in allCalItems) {
		if (ci != calItem) { //don't compare with itself
			if ([self overlaps:calItem otherEvent:ci]) {
				//if the entries overlaps, increase the indent level
				if (calItem.indentLevel <= ci.indentLevel) {
					//don't decrease while loop
					if (level <= ci.indentLevel) {
						level = ci.indentLevel + 1;
					}
				}
			}
		}
	}
	return level;
}

//returns true if the both events overlaps, false else
-(BOOL) overlaps:(CalEvent*)calEvent otherEvent:(CalEvent*) otherEvent {
	BOOL overlaps = FALSE;
	//start and end date of first event, in ms
	NSDate* ds0 = calEvent.date;
	NSDate* de0 = [[NSDate alloc] initWithTimeInterval:[calEvent.duration intValue] sinceDate:ds0];
	NSTimeInterval s0 = [ds0 timeIntervalSince1970];
	NSTimeInterval e0 = [de0 timeIntervalSince1970];
	
	//and second event in ms
	NSDate* ds1 = otherEvent.date;
	NSDate* de1 = [[NSDate alloc] initWithTimeInterval:[otherEvent.duration intValue] sinceDate:ds1];
	NSTimeInterval s1 = [ds1 timeIntervalSince1970];
	NSTimeInterval e1 = [de1 timeIntervalSince1970];
	
	//events overlaps in case of these 4 conditions are true
	if (s0 > s1 && s0 < (e1-60)) {
		overlaps = TRUE;
	} else if (e0 > s1 && e0 < e1) {
		overlaps = TRUE;	
	} else if (s0 < s1 && e0 > e1) {
		overlaps = TRUE;		
	} else if (s0 > s1 && e0 < e1) {
		overlaps = TRUE;		
	}
	
	return overlaps;
}


- (void)dealloc {
	[colors release];
	[calItemView release];
	[displayedDay release];
	[calendarDelegate release];
    [super dealloc];
}


@end
