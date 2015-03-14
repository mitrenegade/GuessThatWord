//
//  EditDeckViewController.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

@class Deck;
#import <UIKit/UIKit.h>

@interface EditDeckViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UITextField *inputWord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightInputWord;

@property (nonatomic, strong) Deck *deck;
@end
