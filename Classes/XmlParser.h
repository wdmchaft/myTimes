//
//  XmlParser.h
//  TaskTracker
//
//  Created by Michael Anteboth on 26.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "ProjectTask.h"
#import "TimeWorkUnit.h"

@interface XmlParser : NSObject {
	NSMutableString *textInProgress;
	Project* projectInProgress;
	ProjectTask* taskInProgress;
	TimeWorkUnit* wuInProgress;
	NSMutableArray* items;
	NSDateFormatter* dateFormatter;
}

-(NSMutableArray*) parseFromURL:(NSString*) urlString;
-(NSMutableArray*) parseFromXmlData:(NSData*) xmlData;

@end
