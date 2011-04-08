//
//  TaskNameEditController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 14.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BooleanEditingControllerDelegate <NSObject>

@required
- (void)takeNewBool:(BOOL)newValue;
@end


@interface BooleanEditController : UIViewController {
	BOOL value;
	NSString* labelTxt;
	id<BooleanEditingControllerDelegate>  delegate;
	IBOutlet UISwitch* valueSwitch;
	IBOutlet UILabel* valueLabel;
}

@property BOOL value;
@property (retain) NSString* labelTxt;
@property (nonatomic, assign)  id <BooleanEditingControllerDelegate> delegate;

-(void) save:(id)sender;
-(void) cancel:(id)sender;

@end

