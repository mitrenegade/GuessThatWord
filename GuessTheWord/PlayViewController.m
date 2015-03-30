//
//  PlayViewController.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "PlayViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "Deck+Info.h"
#import "Card+Info.h"

static CMMotionManager *sharedManager;

@interface PlayViewController ()

@end

@implementation PlayViewController

#define TIMER_INTERVAL .1
#define ROUND_TIME 200
#define REST_TIME 5
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

-(void)dealloc {
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

    self.buttonAnswerOrHint.hidden = YES;
    if ([self.deck isMBDeck]) {
        self.buttonAnswerOrHint.hidden = NO;
    }
    if (TESTING) {
        self.buttonAnswerOrHint.hidden = NO;
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

    gameState = newState;

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
    if (gameState == GameStarting || gameState == RoundRest) {
        [self roundStart];
    }
    else if (gameState == RoundActive) {
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

        [self enableCardNavigation:YES];
        [self startOrientationUpdates];
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

    [self enableCardNavigation:NO];
    [self stopOrientationUpdates];
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
    else if (sender == self.buttonAnswerOrHint) {
        if ([currentCard.type isEqualToString:CARD_TYPE_FRONTANDBACK]) {
            self.labelMessage.text = currentCard.answer;
        }
    }
}

#pragma mark Card control
-(void)advance:(BOOL)correct {
    if (gameState != RoundActive)
        return;

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

    [self updateCurrentCard];
    return YES;
}

-(void)enableCardNavigation:(BOOL)enabled {
    // todo: when using ipad motion, set some variable
    [self.buttonCorrect setEnabled:enabled];
    [self.buttonSkip setEnabled:enabled];
}

-(void) updateCurrentCard {
    if ([currentCard.type isEqualToString:CARD_TYPE_SINGLETEXT]) {
        self.labelWord.text = currentCard.text;
    }
    else if ([currentCard.type isEqualToString:CARD_TYPE_FRONTANDBACK]) {
        self.labelWord.text = currentCard.question;
    }
}
#pragma mark orientation
-(CMMotionManager *)sharedManager {
    if (!sharedManager) {
        sharedManager = [[CMMotionManager alloc] init];
    }
    return sharedManager;
}
-(void)startOrientationUpdates {
    // use device orientation to know absolute position - when the ipad has returned to regular position
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [self listenFor:UIDeviceOrientationDidChangeNotification action:@selector(orientationChanged:)];

    UIDeviceOrientation or = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(or)) {
        orientationState = Regular;
    }
    else {
        orientationState = NeedsLandscape;
    }

    // use gyroscope to trigger changes - less stringent than orientation facedown/up
    NSTimeInterval updateInterval = .1;
    CMMotionManager *motionManager = [self sharedManager];
    if ([motionManager isGyroAvailable] == YES) {
        // Assign the update interval to the motion manager
        [motionManager setGyroUpdateInterval:updateInterval];
        [motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
            float y = gyroData.rotationRate.y;
            if (orientationState == Regular && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
                NSLog(@"Rotation change: %f", y);
                [self updateScreenPositionWithRotation:y];
            }
        }];
    }
}

- (void)stopOrientationUpdates{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self stopListeningFor:UIDeviceOrientationDidChangeNotification];

    if ([[self sharedManager] isGyroActive] == YES) {
        [[self sharedManager] stopGyroUpdates];
    }
}

-(void)updateScreenPositionWithRotation:(float)change {
    orientationSum += change;
    if (orientationSum >= 5) {
        NSLog(@"Face down!");
        orientationState = FaceDownTriggered;
        [self advance:YES];
        // todo: display status until orientation is reset
    }
    else if (orientationSum <= -5) {
        NSLog(@"Face up!");
        orientationState = FaceUpTriggered;
        [self advance:YES];
        // todo: display status until orientation is reset
    }
}

-(void)orientationChanged:(NSNotification *)n {
    UIDeviceOrientation or = [UIDevice currentDevice].orientation;
    NSLog(@"Device orientation now: %d", or);
    // 4 is normal
    // 5 is facing up
    // 6 is facing down
    if (gameState == RoundActive && UIDeviceOrientationIsLandscape(or)) {
        if (orientationState == NeedsLandscape) {
            // now round can start
            NSLog(@"Start");
        }
        else if (orientationState == FaceDownTriggered) {
            NSLog(@"already advanced:YES");
        }
        else if (orientationState == FaceUpTriggered) {
            NSLog(@"already advanced:NO");
        }
        orientationSum = 0;
        orientationState = Regular;
    }
    else {
        NSLog(@"Whats up");
    }

    // todo: display message before advancing; only advance when the device has been returned to the upright position
}
@end
