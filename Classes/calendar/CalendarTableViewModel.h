//
//  CalendarTableViewModel.h
//  Calendar
//
//  Created by Michael Anteboth on 21.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarTableView.h"

@interface CalendarTableViewModel : NSObject <CalendarTableViewDelegate> {
	NSDate* displayedDay;
	NSDate* today;
}

@end
