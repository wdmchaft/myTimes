//
//  ProjectTask.h
//  Test2
//
//  Created by Michael Anteboth on 09.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProjectTask : NSObject <NSCoding> {
	
	//the task name
	NSString* name;
	
	//the list of workunits for this task
	NSMutableArray* workUnits;
	
	//the description 
	NSString* description;
	
	//is the entry marked for export
	BOOL markedForExport;	
	
	//is the value changeable by the user
	BOOL userChangeable;
	
	//holds the data entries for this particular task
	NSMutableDictionary* dataEntries;
}

- (void) dealloc;

-(ProjectTask*) init;
-(NSNumber*) totalAmmount;
-(NSNumber*) totalAmmountMarkedForExport;
-(NSString*) summary;
-(NSString*) formatSeconds:(float)timeInSecs;
-(void) sortWorkUnitsByDate: (BOOL)ascending;

//returns true if there is a workUnit which is running, false else
-(BOOL) hasRunningWorkUnits;

//returns a sorted array of this tasks work units. sorted by start date-time descending (from new to old)
-(NSArray*) getWorkUnitsSorted;

//returns the array of defined dataEntries
//it contains values for all predefined DataEntry values
//-(NSArray*) getDataEntries;


@property (retain) NSString* name;
@property (retain) NSMutableArray* workUnits;
@property (retain) NSString* description;
@property 	BOOL markedForExport;
@property BOOL userChangeable;
@property (retain) NSMutableDictionary* dataEntries;

@end
