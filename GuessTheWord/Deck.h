//
//  Deck.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/26/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseObject.h"

@class Card;

@interface Deck : BaseObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *cards;
@end

@interface Deck (CoreDataGeneratedAccessors)

- (void)addCardsObject:(Card *)value;
- (void)removeCardsObject:(Card *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
