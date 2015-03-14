//
//  PlayViewController.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayViewDelegate <NSObject>

-(void)stopPlaying;

@end

typedef enum GameStateEnum {
    NoRound,
    GameStarting,
    RoundActive,
    RoundRest,
    GameStateMax
} GameState;

@interface PlayViewController : UIViewController
{
    NSTimer *timer;
    float timeLeft;
    GameState state;

    NSMutableArray *allCards;
    Card *currentCard;
}
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelWord;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuit;

// debug only
@property (weak, nonatomic) IBOutlet UIButton *buttonCorrect;
@property (weak, nonatomic) IBOutlet UIButton *buttonSkip;

@property (nonatomic) Deck *deck;
@property (weak, nonatomic) id delegate;

-(void)setupWithDeck:(Deck *)newDeck;
- (IBAction)didClickButton:(id)sender;

@end
