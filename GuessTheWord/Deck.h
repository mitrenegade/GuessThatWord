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

@property (nonatomic, retain) id words;
@property (nonatomic, retain) NSString * title;

@end
