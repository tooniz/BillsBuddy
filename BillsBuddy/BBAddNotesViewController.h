//
//  BBAddNotesViewController.h
//  BillsBuddy
//
//  Created by Tony Zhou on 12/15/13.
//  Copyright (c) 2013 Equippd Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBAddNotesViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *notesPlaceHolder;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
- (IBAction)didTapSave:(id)sender;

@end
