//
//  ProjectTask.m
//  Test2
//
//  Created by Michael Anteboth on 09.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProjectTask.h"
#import "TimeWorkUnit.h"
#import "TaskTrackerAppDelegate.h"

@implementation ProjectTask

@synthesize name;
@synthesize workUnits;
@synthesize description;
@synthesize markedForExport;
@synthesize userChangeable;
@synthesize dataEntries;

/*
// writes ourselves out to an NSCoder
- (void) encodeWithCoder: (NSCoder *)coder {
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:workUnits forKey:@"workUnits"];
	[coder encodeObject:description forKey:@"description"];
	[coder encodeObject:[NSNumber numberWithInt:userChangeable] forKey:@"changeable"];
	[coder encodeObject:dataEntries forKey:@"dataEntries"];
}

// reads ourself back in from an NSCoder.
- (id) initWithCoder: (NSCoder *) coder {
	[super init];
	name = [[coder decodeObjectForKey:@"name"] retain];
	
	if ([coder containsValueForKey:@"workUnits"]) {
		workUnits = [[coder decodeObjectForKey:@"workUnits"] retain];
	}
	
	//sort workunits by date
	[self sortWorkUnitsByDate:NO];
	
	description = [[coder decodeObjectForKey:@"description"] retain];
	
	NSNumber* changeable = [[coder decodeObjectForKey:@"changeable"] retain];
	if (changeable != nil) {
		userChangeable = [changeable boolValue];
	} else {
		userChangeable = TRUE; //user default value
	}
	
	dataEntries = [[coder decodeObjectForKey:@"dataEntries"] retain];
	if (dataEntries == nil) {
		dataEntries = [[NSMutableDictionary alloc] init];
	}

	return self;
}
 */

// writes ourselves out to an NSCoder
- (void) encodeWithCoder: (NSCoder *)coder {
	[coder encodeObject:name];
	[coder encodeObject:workUnits];
	[coder encodeObject:description];
	[coder encodeObject:[NSNumber numberWithInt:userChangeable]];
	[coder encodeObject:dataEntries];
}

// reads ourself back in from an NSCoder.
- initWithCoder: (NSCoder *) coder {
	[super init];
	name = [[coder decodeObject] retain];
	workUnits = [[coder decodeObject] retain];
	
	//sort workunits by date
	[self sortWorkUnitsByDate:NO];
	
	description = [[coder decodeObject] retain];
	
	NSNumber* changeable = [[coder decodeObject] retain];
	if (changeable != nil) {
		userChangeable = [changeable boolValue];
	} else {
		userChangeable = TRUE; //user default value
	}
	
	dataEntries = [[coder decodeObject] retain];
	if (dataEntries == nil) {
		dataEntries = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}


-(void) sortWorkUnitsByDate: (BOOL)ascending {
	NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:ascending];
	[workUnits sortUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
	[dateSorter release];
}

- (ProjectTask*) init {
	if (self = [super init]) {
		self.name = @"Name";
		self.workUnits = [[NSMutableArray alloc] init];
		self.description = @"";
		self.userChangeable = TRUE;
		self.dataEntries = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(NSString*) formatSeconds:(float)timeInSecs {	
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

//return the total ammount of all WorkUnit of this task
- (NSNumber*) totalAmmount {
	float sum = 0;
	for ( TimeWorkUnit* w in self.workUnits) {
		sum = sum + [w.duration floatValue];
	}
	return [NSNumber numberWithFloat:sum];
}

//return the total ammount of all WorkUnit of this task marked for the export
- (NSNumber*) totalAmmountMarkedForExport {
	float sum = 0;
	for ( TimeWorkUnit* w in self.workUnits) {
		if (w.markedForExport) {
			sum = sum + [w.duration floatValue];
		}
	}
	return [NSNumber numberWithFloat:sum];
}

-(NSString*) summary {
	NSString* duration = [self formatSeconds:[[self totalAmmount] floatValue]];
	NSString* s = [NSString stringWithFormat:@"%@", duration];
	return s;
}

//returns true if there is a workUnit which is running, false else
-(BOOL) hasRunningWorkUnits {
	for (TimeWorkUnit* wu in self.workUnits) {
		if(wu.running) return TRUE;
	}
	return FALSE;
}

//returns a sorted array of this tasks work units. sorted by start date-time descending (from new to old)
-(NSArray*) getWorkUnitsSorted {
	NSArray* sorted = [self.workUnits sortedArrayUsingSelector:@selector(compareByStartDate:)];
	return sorted;
}


- (void) dealloc {
	[name release];
	[workUnits release];
	[description release];
	[dataEntries release];
	[super dealloc]; 
} 

@end
