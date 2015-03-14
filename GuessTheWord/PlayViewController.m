//
//  PlayViewController.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

#define TIMER_INTERVAL .1
#define ROUND_TIME 3
#define REST_TIME 2
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

#if !TESTING
    [self.buttonCorrect setHidden:YES];
    [self.buttonSkip setHidden:YES];
#endif
    [self resetDeck];

    [self changeStateTo:GameStarting];
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

-(void)setupWithDeck:(Deck *)newDeck {
    self.deck = newDeck;
    allCards = [[newDeck.cards allObjects] mutableCopy];
}

-(void)resetDeck {
    self.labelStatus.text = @"";
    self.labelTime.text = @"";
    self.labelWord.text = @"";
    self.labelMessage.text = @"";

    currentCard = nil;

    if (timer) {
        [timer invalidate];
    }
}

-(void)tick {
    timeLeft -= TIMER_INTERVAL;
    [self updateClock];
    if (timeLeft < .1) {
        [self timeUp];
    }
}

-(void)updateClock {
    self.labelTime.text = [NSString stringWithFormat:@"%d", (int)ceil(timeLeft)];
}

-(void)changeStateTo:(GameState)newState {
    // only updates clock and time display

    state = newState;

    if (newState == GameStarting) {
        timeLeft = REST_TIME;
        self.labelStatus.text = @"Starting in...";
    }
    else if (newState == RoundActive) {
        timeLeft = ROUND_TIME;
        self.labelStatus.text = @"Time left:";
    }
    else if (newState == RoundRest) {
        timeLeft = REST_TIME;
        self.labelStatus.text = @"New round in...";
    }
    else if (newState == NoRound) {
        timeLeft = 0;
        [self resetDeck];
        [self updateClock];
        self.labelStatus.text = @"No game in progress";
    }
}

-(void)timeUp {
    if (state == GameStarting || state == RoundRest) {
        [self roundStart];
    }
    else if (state == RoundActive) {
        [self roundDone];
    }
}

-(void)roundStart {
    // if there isn't currently a card, select a card
    if (!currentCard) {
        [self nextCard];
    }

    // if a card is selected, then continue the timer; otherwise, game is over
    if (currentCard) {
        [self changeStateTo:RoundActive];
        score = 0;
    }
    else {
        [self changeStateTo:NoRound];
    }
}

-(void)roundDone {
    if (currentCard) {
        [self changeStateTo:RoundRest];
        currentCard = nil;
        self.labelWord.text = currentCard.text;
    }
    else {
        [self changeStateTo:NoRound];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didClickButton:(id)sender {
    if (sender == self.buttonQuit) {
        if ([self.delegate respondsToSelector:@selector(stopPlaying)]) {
            [self.delegate stopPlaying];
        }
    }
    else if (sender == self.buttonCorrect) {
        [self advance:YES];
    }
    else if (sender == self.buttonSkip) {
        [self advance:NO];
    }
}

-(void)advance:(BOOL)correct {
    // advances the card, and updates score
    if (!currentCard)
        return;

    if (correct) {
        score++;
    }

    if (![self nextCard]) {
        [self roundDone];
    }
    NSLog(@"Card advanced. Score: %d", score);
}

-(BOOL)nextCard {
    // picks the next card from the deck and displays it
    currentCard = nil;
    if ([allCards count] == 0)
        return NO;

    currentCard = allCards[0];
    [allCards removeObject:currentCard];

    self.labelWord.text = currentCard.text;
    return YES;
}
@end
