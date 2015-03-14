//
//  Deck.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/14/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Deck : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *cards;
@end

@interface Deck (CoreDataGeneratedAccessors)

- (void)addCardsObject:(NSManagedObject *)value;
- (void)removeCardsObject:(NSManagedObject *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
