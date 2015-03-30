//
//  BaseObject+EasyMapping.h
//  GuessTheWord
//
//  Created by Bobby Ren on 3/26/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "BaseObject.h"
#import <EasyMapping.h>

#define MAPPING_ENTITY_DESCRIPTION [NSEntityDescription entityForName:NSStringFromClass(self.class) inManagedObjectContext:_appDelegate.managedObjectContext]

@interface BaseObject (EasyMapping)


+(EKManagedObjectMapping *) objectMapping;

+(BaseObject *)createOrUpdateFromDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(NSArray *)createOrUpdateFromResults:(NSArray *)dictArray managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark for each sub class
+(NSMutableArray *)directProperties;
+(NSMutableDictionary *)mappedProperties;
+(NSMutableArray *)numericalProperties;
+(NSMutableArray *)transformableProperties;

+(void)dateMappings:(EKManagedObjectMapping *)mapping;
+(void)relationshipMapping:(EKManagedObjectMapping *)mapping;


@end
