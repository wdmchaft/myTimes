//
//  CalEvent.m
//  Calendar
//
//  Created by Michael Anteboth on 21.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CalEvent.h"


@implementation CalEvent

@synthesize date; //Start date
@synthesize duration; //duration in seconds
@synthesize description; //descriptional text
@synthesize indentLevel; //indention level
@synthesize pause;
@synthesize referenceObject;

- (id)init {
    if (self = [super init]) {
		self.date = [NSDate date]; //now
		self.duration = [NSNumber numberWithInt:7200]; //7200sec = 2h
		self.description = @""; //empty string
		self.indentLevel = 0; //default is 0
		self.pause = [NSNumber numberWithInt:0];
		self.referenceObject = nil;
	}
	return self;
}
		

- (void) dealloc {
	[pause release];
	[date release];
	[duration release];
	[description release];
	[referenceObject release];
	[super dealloc];
}

@end
