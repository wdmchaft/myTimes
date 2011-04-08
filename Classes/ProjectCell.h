//
//  TaskCell.h
//  TaskTracker
//
//  Created by Michael Anteboth on 12.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "AbstractTableCell.h"

@interface ProjectCell : AbstractTableCell {
	Project* project;
}

@property (retain) Project* project;

@end
