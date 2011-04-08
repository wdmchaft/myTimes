//
//  Project.m
//  Test2
//
//  Created by Michael Anteboth on 08.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Project.h"
#import "ProjectTask.h"


@implementation Project

@synthesize name;
@synthesize tasks;
@synthesize description;
@synthesize markedForExport;
@synthesize userChangeable;

// writes ourselves out to an NSCoder
- (void) encodeWithCoder: (NSCoder *)coder {
	[coder encodeObject:name];
	[coder encodeObject:tasks];
	[coder encodeObject:description];
	[coder encodeObject:[NSNumber numberWithInt:userChangeable]];
}

// reads ourself back in from an NSCoder.
-(id) initWithCoder: (NSCoder *) coder {
	[super init];
	name = [[coder decodeObject] retain];
	tasks = [[coder decodeObject] retain];
	description = [[coder decodeObject] retain];
	
	NSNumber* changeable = [[coder decodeObject] retain];
	if (changeable != nil) {
		userChangeable = [changeable boolValue];
	} else {
		userChangeable = TRUE; //set default value
	}
	
	
	return self;
}

//default constructor
- (Project*) init {
	if (self = [super init]) {
		self.name = @"Name";
		self.tasks = [[NSMutableArray alloc] init];
		self.description = @"";
		self.userChangeable = TRUE;
	}
	return self;
}

//total ammount in seconds of all sub items
- (NSNumber*) totalAmmount {
	float sum = 0;
	for ( ProjectTask* t in self.tasks) {
		sum = sum + [[t totalAmmount] floatValue];
	}
	return [NSNumber numberWithFloat:sum];
}

//total ammount in seconds of all sub items marked for the export
- (NSNumber*) totalAmmountMarkedForExport {
	float sum = 0;
	for ( ProjectTask* t in self.tasks) {
		if (t.markedForExport) {
			sum = sum + [[t totalAmmount] floatValue];
		}
	}
	return [NSNumber numberWithFloat:sum];
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

-(NSString*) summary {
	NSString* duration = [self formatSeconds:[[self totalAmmount] floatValue]];
	NSString* s = [NSString stringWithFormat:@"%@", duration];
	return s;
}

//returns true if there is at least one running work unit in the project tasks
-(BOOL) hasRunningWorkUnits {
	if (self.tasks != nil && [self.tasks count] > 0) {
		for (ProjectTask* pt in self.tasks) {
			if ([pt hasRunningWorkUnits]) return TRUE;
		}
	}
	return FALSE;
}


- (void) dealloc {
	[name release];
	[tasks release];
	[description release];
	[super dealloc]; 
} 

@end
