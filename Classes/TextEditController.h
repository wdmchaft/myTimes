//
//  TaskNameEditController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 14.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextEditingControllerDelegate <NSObject>
@required
- (void)takeNewString:(NSString *)newValue;
@end


@interface TextEditController : UIViewController {
	NSString    *string;
	IBOutlet UITextView* textView;
	id<TextEditingControllerDelegate>  delegate;
}

@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign)  id <TextEditingControllerDelegate> delegate;
-(void) save:(id)sender;
-(void) cancel:(id)sender;

@end

