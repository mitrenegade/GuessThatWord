//
//  MembrightHelper.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/30/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card+Info.h"
#import "Deck+EasyMapping.h"
#import "Card+EasyMapping.h"

@interface MembrightHelper : NSObject
{
    NSTimer *timer;
}

-(void)loadMBDecks;

@end
