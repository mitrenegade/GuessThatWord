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

@interface PlayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelWord;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuit;

@property (nonatomic) Deck *deck;
@property (weak, nonatomic) id delegate;

- (IBAction)didClickButton:(id)sender;

@end
