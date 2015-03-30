//
//  Deck+Info.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//
#import "Deck.h"

typedef enum DeckTypeEnum {
    DeckTypeSingleWord,
    DeckTypeTaboo,
    DeckTypeQuestionAndAnswer
    
} DeckType;

typedef enum DeckSource {
    DeckSourceParse,
    DeckSourceMembright
} DeckSource;

@interface Deck (Info)

-(BOOL)isMBDeck;

@end
