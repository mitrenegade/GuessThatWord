//
//  Deck+EasyMapping.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/26/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "Deck+EasyMapping.h"
#import "Deck+Info.h"

@implementation Deck (EasyMapping)

+(EKManagedObjectMapping *) mbMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping setPrimaryKey:@"id"];

        [mapping mapPropertiesFromArray:[self directProperties]];

        // membright deck title
        [mapping mapPropertiesFromDictionary:@{@"name":@"title"}];

    }];
}

+(Deck *)parseMembrightInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)moc {
    // base properties like id
    Deck *deck = (Deck *)[Deck createOrUpdateFromDictionary:info managedObjectContext:moc];

    // membright specific properties like "name"
    [EKManagedObjectMapper fillObject:deck fromExternalRepresentation:info withMapping:[Deck mbMapping] inManagedObjectContext:moc];

    deck.type = @(DeckTypeQuestionAndAnswer);
    deck.source = @(DeckSourceMembright);

    return deck;
}
@end
