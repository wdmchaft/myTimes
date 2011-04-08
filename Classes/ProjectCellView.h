//
//  TaskCellView.h
//  TaskTracker
//
//  Created by Michael Anteboth on 12.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "TableRowSelectionDelegate.h"
#import "AbstractTableCellView.h"

@interface ProjectCellView : AbstractTableCellView {
	Project* project;
	NSString* summaryFormatString;
	UIActivityIndicatorView* actIndicator;
}

@property (retain) Project* project;
@property (retain) 	UIActivityIndicatorView* actIndicator;

@end
