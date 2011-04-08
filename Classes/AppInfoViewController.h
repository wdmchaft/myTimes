//
//  AppInfoViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 18.01.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppInfoViewController : UIViewController {
	IBOutlet UITextView* textView;
	IBOutlet UIButton* backButton;
	IBOutlet UIButton* urlButton;
	IBOutlet UIButton* mailButton;
	IBOutlet UILabel* urlLinkLabel;	
}

@property (retain) IBOutlet UITextView* textView;
@property (retain) IBOutlet UIButton* backButton;
@property (retain) IBOutlet UIButton* urlButton;
@property (retain) IBOutlet UIButton* mailButton;
@property (retain) IBOutlet UILabel* urlLinkLabel;

-(void) closeView:(id)sender;
-(void) openUrl:(id)sender;
-(void) openMail:(id)sender;
-(void) setButtonText:(UIButton*)button text:(NSString*)text;

@end
