//
//  XMLHelper.m
//  TaskTracker
//
//  Created by Michael Anteboth on 12.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "XMLHelper.h"
#import "Project.h"
#import "ProjectTask.h"
#import "TimeWorkUnit.h"
#import "GTMNSString+HTML.h"

@implementation XMLHelper

// encode the data string to XML conform (use CDATA Section)
+(NSString*) encodeString:(NSString*)s {
	NSString* encoded;
	if (s != nil) {
		encoded = [s gtm_stringByEscapingForHTML];
	}
	return encoded;
}


+(NSString*) getXmlData:(NSArray*)projects {
	//the Root Node with namespace ...
	NSMutableString* xml = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
	[xml appendString:@"<Data xmlns=\"mytimes\"	xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"mytimes http://iphone.anteboth.com/mytimes/xml/mytimes-model.xsd\">\n"];

	//dateformatter for date output like "2001-12-31T12:45:30"
	NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
	[df setTimeStyle:NSDateFormatterMediumStyle];
	[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
	
	
	//Add Element for each project to the root node
	for (Project* p in projects) {
		if (p.markedForExport) {
			NSString* pName = [self encodeString:p.name];
			NSString* pDesc = [self encodeString:p.description];
			NSString* pEditable = p.userChangeable ? @"true" : @"false";
			[xml appendString:[NSString stringWithFormat:@"<Project name=\"%@\" description=\"%@\" editable=\"%@\">\n", pName, pDesc, pEditable]];
			//add element for each task to the project element
			for (ProjectTask* pt in p.tasks) {
				if (pt.markedForExport) {
					NSString* ptName = [self encodeString:pt.name];
					NSString* ptDesc = [self encodeString:pt.description];
					NSString* ptEditable = pt.userChangeable ? @"true" : @"false";
					[xml appendString:[NSString stringWithFormat:@"<Task name=\"%@\" description=\"%@\" editable=\"%@\">\n", ptName, ptDesc, ptEditable]];
					
					//add element for each workunit to the task element
					for (TimeWorkUnit* wu in pt.workUnits) {
						if (wu.markedForExport) {
							//the attribute values
							NSString* startTime = [df stringFromDate:wu.date];
							NSString* pause = [wu.pause stringValue];
							NSString* duration = [wu.duration stringValue];
							NSString* running = wu.running ? @"true" : @"false";
							NSString* chargeable = wu.chargeable ? @"true" : @"false";
							NSString* desc = [self encodeString:wu.description];
							//create the workunit element and add the attributes
							[xml appendString:[NSString stringWithFormat:@"<WorkUnit startTime=\"%@\" pause=\"%@\" duration=\"%@\" running=\"%@\" chargeable=\"%@\" description=\"%@\"/>\n", 
											   startTime, pause, duration, running, chargeable, desc]];						
						}
					} //end for workunits
					
					[xml appendString:@"</Task>\n"];
				}
			} //end for tasks
			
			[xml appendString:@"</Project>\n"];
		}
	} //end for project
	
	[xml appendString:@"</Data>"];
	return xml;	
}

@end
