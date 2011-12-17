//
//  DataEntry.m
//  TaskTracker
//
//  Created by Michael Anteboth on 29.12.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DataEntry.h"


@implementation DataEntry

@synthesize name;
@synthesize displayText;
@synthesize value;
@synthesize sortIndex;
@synthesize type;


//default constructor
- (DataEntry*) init {
	if ((self = [super self])) {
		self.name = @"";
		self.displayText = @"";
		self.sortIndex = 0;
	}
	return self;
}


// writes ourselves out to an NSCoder
- (void) encodeWithCoder: (NSCoder *)coder {
	[coder encodeObject:name];
	[coder encodeObject:displayText];
	[coder encodeObject:value];
	[coder encodeInt:sortIndex forKey:@"kSortIndex"];
	[coder encodeInt:type forKey:@"kType"];	
}

// reads ourself back in from an NSCoder.
- (id) initWithCoder: (NSCoder *) coder {
	[super init];
	name = [[coder decodeObject] retain];
	displayText = [[coder decodeObject] retain];
	value = [[coder decodeObject] retain];
	sortIndex = [coder decodeIntForKey:@"kSortIndex"];
	type = [coder decodeIntForKey:@"kType"];
	
	return self;
}

- (void) dealloc { 
	[name retain];
	[displayText release];
	[value release];
	[super dealloc]; 
} 


@end
