//
//  TimeWorkUnit.m
//  Test2
//
//  Created by Michael Anteboth on 07.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeWorkUnit.h"
#import "TaskTrackerAppDelegate.h"
#import "TextEditViewController.h"

@implementation TimeWorkUnit

@dynamic duration;
@dynamic date;
@dynamic pause;

@synthesize description;
@synthesize chargeable;
@synthesize running;
@synthesize markedForExport;
@synthesize paused;


// writes ourselves out to an NSCoder
- (void) encodeWithCoder:(NSCoder*)coder {
	[coder encodeObject:description];
	[coder encodeObject:duration];
	[coder encodeObject:date];
	[coder encodeObject:pause];
	[coder encodeObject:chargeable];
	[coder encodeObject:[NSNumber numberWithInt:running]];
	[coder encodeObject:[NSNumber numberWithInt:paused]];	
}


// reads ourself back in from an NSCoder.
- (id) initWithCoder: (NSCoder *) coder {	
	[super init];
	description = [[coder decodeObject] retain];
	duration = [[coder decodeObject] retain];
	date = [[coder decodeObject] retain];
	pause = [[coder decodeObject] retain];
	chargeable = [[coder decodeObject] retain];
	NSNumber* run = [[coder decodeObject] retain];
	if (run != nil) {
		running = [run boolValue];
	}
	NSNumber* nrPaused = [[coder decodeObject] retain];
	if (nrPaused != nil) {
		paused = [nrPaused boolValue];
	} 
	
	
	return self;
}

//default constructor
- (id) init {
	if (self = [super self]) {
		self.description = @"";
		duration = [NSNumber numberWithInt:7200]; //7200 soc = 2h
		date = [NSDate date]; //today
		self.pause = [NSNumber numberWithInt:0]; //Default pause = 0
		self.chargeable = [NSNumber numberWithBool:TRUE]; //as default the work unit is chargeable
		self.running = FALSE;
		self.paused = FALSE;
	}
	return self;
}

-(NSDate*) date {
	return date;
}

-(void) setDate:(NSDate*)newDate {
	//Sekundenanteil auf 0 setzen, uns interessieren nur die Minuten und Stunden der Zeitanghabe
	long secs = [newDate timeIntervalSince1970];
	long rest = secs % 60;
	secs = secs-rest;
	
	date = [[NSDate dateWithTimeIntervalSince1970:secs] retain];
}

-(NSNumber*) duration {
	return duration;
}

-(void) setDuration:(NSNumber*)newDuration {
	//Nur ganze Minuten zulassen (modulo 60) also nur volle minuten zulässig	
	long dur = [newDuration longValue];
	int rest = dur % 60;
	dur = dur - rest;
	duration = [[NSNumber numberWithLong:dur] retain];
}

-(NSNumber*) pause {
	return pause;
}

-(void) setPause:(NSNumber*)newPause {
	//Nur ganze Minuten zulassen (modulo 60) also nur volle minuten zulässig
	long p = [newPause longValue];
	int rest = p % 60;
	p = p - rest;
	pause = [[NSNumber numberWithLong:p] retain];
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


- (NSString*) summary {
	//return [NSString stringWithFormat:@"%@, %@h", self.description, self.duration];
	int dur = [self.duration intValue] - [self.pause intValue];
	return [self formatSeconds:dur];
}

//computes the end date of this work unit
//end date := <start datetime> + pause + duration
-(NSDate*) getEndDate {
	int dur = [duration intValue];
	int p = [pause intValue];
	
	//end = start + duration + pause
	NSTimeInterval diffSecs = dur + p;
	NSDate* end = [[NSDate alloc] initWithTimeInterval:diffSecs sinceDate:date];
	
	return end;
}

//start the time tracking, set running to true
-(void) startTimeTracking {
	self.running = TRUE;
	//set pause to old pause + new delay since end time till now
	NSDate* now = [[NSDate date] retain];

	//Jetzt-Zeit auf volle minute abrunden,
	NSTimeInterval nowTi = [now timeIntervalSince1970];
	[now release];
	int secsToRemove = fmod(nowTi, 60);
	nowTi = nowTi - secsToRemove;
	now  = [[NSDate dateWithTimeIntervalSince1970:nowTi] retain];
	
	//if start or end time is later then now, set them to now
	if ( [self.date compare:now] == NSOrderedDescending) {
		self.date = now;
	}
	if ( [[self getEndDate] compare:now] == NSOrderedDescending) {
		NSTimeInterval diff = [now timeIntervalSinceDate:[self date]];
		int dur = abs(diff);
		self.duration = [[NSNumber numberWithInt: dur] retain];		
	} else {
		//duration from prev. end time till now
		NSTimeInterval diff = [now timeIntervalSinceDate:[self getEndDate]];
		int p = [self.pause intValue] + abs(diff);
		if (p < 60) p = 0; //keine pausenzeiten kleiner als eine minute
		self.pause = [[NSNumber numberWithInt:p] retain];
	}
}

//Stop the time tracking
//set running to false, task ends now so update the duration
-(void) stopTimeTracking {
	self.running = FALSE;
	NSDate* now = [[NSDate date] retain];
	
	//if start or end time is later then now, set them to now
	if ( [self.date compare:now] == NSOrderedDescending) {
		self.date = now;
	}
	
	if ( [[self getEndDate] compare:now] == NSOrderedDescending) {
		NSTimeInterval diff = [now timeIntervalSinceDate:[self date]];
		int dur = abs(diff);
		self.duration = [[NSNumber numberWithInt: dur] retain];		
	} else {
		//duration from prev. end time(new start time) till now
		NSTimeInterval diff = [now timeIntervalSinceDate:[self getEndDate]];
		//new duration is the diff + the old duration
		int dur = abs(diff) + [self.duration intValue];
		self.duration = [[NSNumber numberWithInt: dur] retain];		
	}
	
	//ask the user to enter the description
	TaskTrackerAppDelegate* appDelegate = (TaskTrackerAppDelegate *)[[UIApplication sharedApplication] delegate];
	BOOL shouldEnterDesc = appDelegate.promptForCommentWhenStoppingTime;
	if (shouldEnterDesc) {
		TextEditViewController* ctl = [[TextEditViewController alloc] initWithNibName:@"TextEditView" bundle:nil];
		ctl.navigationItem.title = @"Beschreibung";
		ctl.title = @"Beschreibung";
		ctl.workUnit = self;
		[appDelegate.rootViewController presentModalViewController:ctl animated:TRUE];
				ctl.title = @"Beschreibung";
		[ctl release];
		
	}
}



- (NSComparisonResult)compareByStartDate:(TimeWorkUnit*) aWorkUnit {
	if (aWorkUnit != nil) {
//		return [self.date compare:aWorkUnit.date];
		return [aWorkUnit.date compare:self.date];
	}
	return NSOrderedSame;
}

-(TimeWorkUnit*) copy {
	TimeWorkUnit* copy = [[TimeWorkUnit alloc] init];
	copy.duration =  [duration copy];
	copy.date = [date copy];
	copy.pause = [pause copy];
	copy.description = [description copy];
	copy.running = self.running;
	copy.chargeable = [self.chargeable copy];
	return copy;
}

- (void) dealloc { 
	[pause retain];
	[description release];
	[duration release];
	[date release];
	[chargeable release];
	[super dealloc]; 
} 

@end
