//
//  CalendarTableViewController.h
//  Calendar
//
//  Created by Michael Anteboth on 20.01.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewController : UITableViewController {
	UILabel* titleLabel;
	NSDateFormatter* dateFormatter;
	NSString* titleTxt;
	UILabel* titleLbl;
}

@property (retain) NSString* titleTxt;
-(NSString*) getTitleText;
-(void) refreshData;
-(void) switchToDaysFromNow:(int) days;

-(void) loadNext:(id)sender;
-(void) loadPrev:(id)sender;


@end
