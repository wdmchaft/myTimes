//
//  DataEntry.h
//  TaskTracker
//
//  Created by Michael Anteboth on 29.12.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ValueType  {
	kString,
	kInteger,
	kBool,
	kDouble
} ValueType;

@interface DataEntry : NSObject  <NSCoding> {
	NSString* name;
	NSString* displayText;
	id value;
	int sortIndex;
	ValueType type;
	//nullable
	//editabled
	//...
}

@property (retain) NSString* name;
@property (retain) NSString* displayText;
@property (retain) id value;
@property int sortIndex;
@property ValueType type;

- (void) encodeWithCoder: (NSCoder *)coder;
- initWithCoder: (NSCoder *)coder;


@end
