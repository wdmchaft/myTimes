//
//  WorkUnitCell.h
//  TaskTracker
//
//  Created by Michael Anteboth on 29.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractTableCell.h"
#import "TimeWorkUnit.h"


@interface WorkUnitCell : AbstractTableCell {
	TimeWorkUnit* workUnit;
}

@property (nonatomic, retain) TimeWorkUnit* workUnit;

@end
