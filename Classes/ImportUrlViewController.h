//
//  ImportUrlViewController.h
//  TaskTracker
//
//  Created by Michael Anteboth on 24.06.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImportUrlViewController : UIViewController {
	IBOutlet UITextField* urlTextField;
	IBOutlet UIButton* btnImportAddProjects;
	IBOutlet UIButton* btnImportRemoveProjects;
	IBOutlet UILabel* urlLabel;
}

- (IBAction)cancel:(id)sender;
- (IBAction)importAndRemoveProjects:(id)sender;
- (IBAction)importAndAddProjects:(id)sender;

@end
