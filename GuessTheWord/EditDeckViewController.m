//
//  EditDeckViewController.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "EditDeckViewController.h"
#import "Deck.h"
#import "Card.h"

#define PLACEHOLDER_TITLE @"Name for this deck"
#define FORMAT_CARD_COUNT @"Cards in deck: %lu"
@interface EditDeckViewController ()

@end

@implementation EditDeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.constraintHeightInputWord.constant = 40;

#if TESTING
    NSArray *decks = [[Deck where:@{}] allObjectsInMOC:_appDelegate.managedObjectContext];
    if ([decks count]) {
        self.deck = [decks firstObject];
    }
#endif
    
    if (!self.deck) {
        self.deck = (Deck *)[Deck createEntityInContext:_appDelegate.managedObjectContext];
    }

    [self updateTitle];
    [self updateCardCount];
}

-(void)createNewDeck {
    Deck *newDeck = (Deck *)[Deck createEntityInContext:_appDelegate.managedObjectContext];
    newDeck.title = @"New deck";
    [self editDeck:newDeck];
}

-(void)editDeck:(Deck *)deck {
    self.deck = deck;
    [self updateTitle];
    [self updateCardCount];
    [self saveDeck];
}

-(void)updateTitle {
    self.labelTitle.text = self.deck.title;
    if (!self.deck.title) {
        self.labelTitle.text = PLACEHOLDER_TITLE;
    }
}
-(void)updateCardCount {
    NSInteger count = self.deck.cards.count;
    self.labelCount.text = [NSString stringWithFormat:FORMAT_CARD_COUNT, count];
    self.labelCount.hidden = self.deck.cards.count > 0?NO:YES;
}

-(void)saveDeck {
    [_appDelegate.managedObjectContext save:nil];
    [self notify:@"decks:updated"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Segue: %@", segue.identifier);
}

#pragma mark TextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.inputTitle) {
        if (self.deck.title) {
            self.inputTitle.text = self.deck.title;
        }
        self.labelTitle.alpha = 0;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.inputTitle) {
        if (self.inputTitle.text.length && ![self.inputTitle.text isEqualToString:PLACEHOLDER_TITLE]) {
            self.deck.title = self.inputTitle.text;
            [self updateTitle];

            [self saveDeck];
        }
        self.inputTitle.text = nil;
        self.labelTitle.alpha = 1;
    }
    else if (textField == self.inputWord) {
        if (self.inputWord.text.length) {
            Card *card = (Card *)[Card createEntityInContext:_appDelegate.managedObjectContext];
            card.text = self.inputWord.text;
            card.deck = self.deck;
            [self updateCardCount];
            [self saveDeck];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
