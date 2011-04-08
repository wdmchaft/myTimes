//
//  TimeUnit.h
//  Test2
//
//  Created by Michael Anteboth on 07.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface TimeWorkUnit : NSObject <NSCoding> {
	
	NSString* description;	//a description
	NSNumber* duration;		//duration in sec (without pause)
	NSDate* date;			//start date
	NSNumber* pause;		//pause in sec
	//End time := Start + duration - pause
	NSNumber* chargeable;  //is the work unit chargeable or not, interpreted as a boolean value
	BOOL running; //is this item started und active
	BOOL markedForExport;	
	BOOL paused;//is this entry running but paused
}


//- (TimeWorkUnit*) init;
- (NSString*) summary;

@property (retain) NSNumber* duration;
@property (retain) NSDate* date; 
@property (retain) NSNumber* pause; 
@property (retain) NSString* description; 
@property (retain) NSNumber* chargeable;
@property BOOL running;
@property BOOL markedForExport;
@property BOOL paused;

-(NSDate*) getEndDate;

-(void) startTimeTracking;
-(void) stopTimeTracking;
-(id) init;

- (NSComparisonResult)compareByStartDate:(TimeWorkUnit*) aWorkUnit;

@end
