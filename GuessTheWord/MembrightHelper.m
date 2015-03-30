//
//  MembrightHelper.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/30/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "MembrightHelper.h"
#import "Util.h"
#import "AppDelegate.h"

@implementation MembrightHelper

-(void)loadMBDecks {
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadMBDecksInBackground) userInfo:nil repeats:YES];
}

-(void)loadMBDecksInBackground {
    static int last = 200;
    for (int i=last+1; i<500; i++) {
        NSArray *decks = [[Deck where:@{@"id":@(i)}] all];
        if ([decks count] == 0) {
            NSLog(@"Querying for deck %d", i);
            [self queryForDeck:i];
            last = i;
            break;
        }
    }
    if (last == 500) {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark Membright API
-(void)queryForDeck:(int)deckId {
    NSString *endpoint = [NSString stringWithFormat:@"https://membright.com/api/v2/deck/%d", deckId];
    NSString *method = @"GET";

    [Util easyRequest:endpoint method:method params:nil completion:^(NSDictionary *results, NSError *error) {
        NSLog(@"Results: %d", results.count);

        if (results.count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Deck *deck = (Deck *)[Deck parseMembrightInfo:results managedObjectContext:_appDelegate.managedObjectContext];

                //        [self queryForCardsInDeck:deck];

                [self notify:@"decks:updated"];

                [_appDelegate saveContext];
            });
        }
        else {
            NSLog(@"No results for deck %d", deckId);
        }
    }];
}

-(void)queryForCardsInDeck:(Deck *)deck {
    NSString *endpoint = [NSString stringWithFormat:@"https://membright.com/api/v2/card/?deck__id=%@&format=json", deck.id];
    NSString *method = @"GET";

    [Util easyRequest:endpoint method:method params:nil completion:^(NSDictionary *results, NSError *error) {
        NSArray *cards = results[@"objects"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Results: %d", results.count);
            for (NSDictionary *cardInfo in cards) {
                NSLog(@"Deck: %@\n%@", cardInfo[@"id"], cardInfo);

                Card *card = (Card *)[Card parseMembrightInfo:cardInfo managedObjectContext:_appDelegate.managedObjectContext];
                card.deck = deck;

            }
            [self notify:@"deck:updated" object:deck userInfo:nil];

            [_appDelegate saveContext];
        });
    }];
}

@end
