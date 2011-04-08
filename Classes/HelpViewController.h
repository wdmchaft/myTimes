//
//  HelpViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 24.02.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController {
	IBOutlet UIWebView* webView;
}

@property (nonatomic,retain) IBOutlet UIWebView* webView;

-(void) closeView:(id)sender;

@end
