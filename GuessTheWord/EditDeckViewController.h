//
//  EditDeckViewController.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDeckViewController : UIViewController <UITextFieldDelegate>
{
    Deck *deck;
}
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *inputTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UITextField *inputWord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightInputWord;

@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;

-(Deck *)deck;
-(void)createNewDeck;
-(void)editDeck:(Deck *)deck;

-(IBAction)didClickButton:(id)sender;
@end
