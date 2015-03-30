//
//  Card+EasyMapping.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/30/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "Card+EasyMapping.h"
#import <EasyMapping/EasyMapping.h>

@implementation Card (EasyMapping)

+(EKManagedObjectMapping *) mbMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        [mapping setPrimaryKey:@"id"];

        // direct mappings for properties. has to be a string property (??)
        [mapping mapPropertiesFromArray:[self directProperties]];
    }];
}

+(Card *)parseMembrightInfo:(NSDictionary *)info managedObjectContext:(NSManagedObjectContext *)moc{
    /* Format:
    {
        access = pu;
        content = "{\"question\":\"First Milestone\",\"answer\":\"At <b>First Quarter</b>, the Moon 1/4 of the way around its orbit. It can be confusing, but the moon looks <b>half lit</b>&#160;because we are looking straight down the terminator.\",\"links\":[{\"label\":\"4:35\",\"url\":\"http://youtu.be/AQ5vty8f9Xc?t=4m35s\"}]}";
        createdAt = "2015-02-17T23:17:36.289587";
        id = 5191;
        obj =             {
            answer = "At <b>First Quarter</b>, the Moon 1/4 of the way around its orbit. It can be confusing, but the moon looks <b>half lit</b>&#160;because we are looking straight down the terminator.";
            links =                 (
                                     {
                                         label = "4:35";
                                         url = "http://youtu.be/AQ5vty8f9Xc?t=4m35s";
                                     }
                                     );
            question = "First Milestone";
        };
        ownerId = 42;
        resourceUri = "/api/v2/card/5191";
        type = frontAndBack;
        updatedAt = "2015-02-17T23:17:36.289640";
    }
     */

    // initial fill: handles id, which is at top level
    Card *card = (Card *)[Card createOrUpdateFromDictionary:info managedObjectContext:moc];

    // fill question and answer from "obj" key
    [EKManagedObjectMapper fillObject:card fromExternalRepresentation:info[@"obj"] withMapping:[Card mbMapping] inManagedObjectContext:moc];

    return card;
}
@end
