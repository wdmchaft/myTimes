//
//  TextEditViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 18.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkUnitDetailsTableViewController.h"
#import "TimeWorkUnit.h"

@interface TextEditViewController : UIViewController {
	IBOutlet UITextView* textView;
	TimeWorkUnit* workUnit;
	WorkUnitDetailsTableViewController* parent;	
}

@property (retain) TimeWorkUnit* workUnit;
@property (retain) WorkUnitDetailsTableViewController* parent;	
@property (retain) IBOutlet UITextView* textView;

-(void) save:(id)sender;
-(void) cancel:(id)sender;

@end
