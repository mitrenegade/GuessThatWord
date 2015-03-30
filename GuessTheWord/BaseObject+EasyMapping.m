//
//  BaseObject+EasyMapping.m
//  GuessTheWord
//
//  Created by Bobby Ren on 3/26/15.
//  Copyright (c) 2015 Bobby Ren Tech. All rights reserved.
//

#import "BaseObject+EasyMapping.h"

@implementation BaseObject (EasyMapping)


+(BaseObject *)createOrUpdateFromDictionary:(NSDictionary *)dictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    // this method creates or updates?
    return [EKManagedObjectMapper objectFromExternalRepresentation:dictionary withMapping:[self objectMapping] inManagedObjectContext:managedObjectContext];
}

+(NSArray *)createOrUpdateFromResults:(NSArray *)dictArray managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSArray *results = [EKManagedObjectMapper arrayOfObjectsFromExternalRepresentation:dictArray withMapping:[self objectMapping] inManagedObjectContext:managedObjectContext];

    return results;
}

+(NSManagedObject *)createEntityInContext:(NSManagedObjectContext *)managedObjectContext {
    NSString *name = [[self class] description];
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:managedObjectContext];

    return object;
}

+(EKManagedObjectMapping *) objectMapping {
    return [EKManagedObjectMapping mappingForEntityName:NSStringFromClass(self.class) withBlock:^(EKManagedObjectMapping *mapping) {
        // direct mappings for properties. has to be a string property (??)
        [mapping mapPropertiesFromArray:[self directProperties]];

        // mappings for properties that might have different names: ie user_id to userId
        [mapping mapPropertiesFromDictionary:[self mappedProperties]];

        [mapping setPrimaryKey:@"id"];

        // numerical mappings
        for (NSString *propertyName in [self numericalProperties]) {
            [mapping mapKeyPath:propertyName toProperty:propertyName withValueBlock:^id(NSString *key, id value, NSManagedObjectContext *context) {
                return [self convertValue:value forKey:propertyName context:context];
            } reverseBlock:^id(id value, NSManagedObjectContext *context) {
                return [NSString stringWithFormat:@"%@", value];
            }];
        }

        // dates
        [self dateMappings:mapping];

        // transformables
        [self transformableMappings:mapping];

        // relationships
        [self relationshipMapping:mapping];
    }];
}

+(void)relationshipMapping:(EKManagedObjectMapping *)mapping {
    return;
}

#pragma mark Direct Properties
// this works for all subclasses and does not need to be overloaded.
// looks for all properties that are not numeric using the attributes
+(NSMutableArray *)directProperties {
    NSMutableArray *inheritedProperties = [NSMutableArray array];
    NSDictionary *attributes = [MAPPING_ENTITY_DESCRIPTION attributesByName];
    for (NSString *attribute in attributes) {
        NSAttributeType type = [[attributes objectForKey:attribute] attributeType];
        if (type == NSStringAttributeType ||
            type == NSBinaryDataAttributeType ||
            type == NSUndefinedAttributeType ||
            type == NSObjectIDAttributeType) {
            [inheritedProperties addObject:attribute];
        }
    }
    NSLog(@"All direct properties: %@", inheritedProperties);
    return inheritedProperties;
}

#pragma mark Numeric properties
// this works for all subclasses and does not need to be overloaded.
// looks for properties that are numeric
+(NSMutableArray *)numericalProperties {
    NSMutableArray *numericalProperties = [NSMutableArray array];
    NSDictionary *attributes = [MAPPING_ENTITY_DESCRIPTION attributesByName];
    for (NSString *attribute in attributes) {
        NSAttributeType type = [[attributes objectForKey:attribute] attributeType];
        NSLog(@"attribute: %@ type: %d", attribute, type);
        /*
         NSInteger16AttributeType = 100,
         NSInteger32AttributeType = 200,
         NSInteger64AttributeType = 300,
         NSDecimalAttributeType = 400,
         NSDoubleAttributeType = 500,
         NSFloatAttributeType = 600,
         NSBooleanAttributeType
         */
        if (type == NSInteger16AttributeType ||
            type == NSInteger32AttributeType ||
            type == NSInteger64AttributeType ||
            type == NSDecimalAttributeType ||
            type == NSDoubleAttributeType ||
            type == NSFloatAttributeType ||
            type == NSBooleanAttributeType) {
            [numericalProperties addObject:attribute];
        }
    }
    NSLog(@"All numeric properties: %@", numericalProperties);
    return numericalProperties;
}

+(NSMutableArray *)transformableProperties {
    NSMutableArray *transformableProperties = [NSMutableArray array];
    NSDictionary *attributes = [MAPPING_ENTITY_DESCRIPTION attributesByName];
    for (NSString *attribute in attributes) {
        NSAttributeType type = [[attributes objectForKey:attribute] attributeType];
        NSLog(@"attribute: %@ type: %d", attribute, type);
        if (type == NSTransformableAttributeType) {
            [transformableProperties addObject:attribute];
        }
    }
    NSLog(@"All transformable properties: %@", transformableProperties);
    return transformableProperties;
}

#pragma mark Other custom properties
// these should be implemented by the subclass if it needs special/custom attention
+(NSMutableDictionary *)mappedProperties {
    return [NSMutableDictionary dictionary];
}

+(void)dateMappings:(EKManagedObjectMapping *)mapping {
/*
    NSDateFormatter *localFormatter = [Util isoFormatter];
    [localFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [mapping mapKeyPath:@"created_at" toProperty:@"created_at" withDateFormatter:localFormatter];
    [mapping mapKeyPath:@"updated_at" toProperty:@"updated_at" withDateFormatter:localFormatter];
 */
}

+(void)transformableMappings:(EKManagedObjectMapping *)mapping {
    // transformables are sent down as an array
    // they can be converted into an NSData blob and stored in the attribute with suffix _data, ie pact_ids_data for pact_ids
    // later, transformables are retrieved through the _data attribute. This is done through the Transformables section in the category for each NSManagedObject type
    for (NSString *attribute in [self transformableProperties]) {
        if ([attribute isEqualToString:@"attributesToBeCleared"]) {
            continue; // this is one transformable that doesnt have data access because it isn't sent from web. todo: remove it from core data once we replace everything with easymapping
        }
        NSString *transformableAttributeName = [self transformableNameForAttribute:attribute];
        [mapping mapKeyPath:attribute toProperty:transformableAttributeName withValueBlock:^id(NSString *key, id value, NSManagedObjectContext *context) {
            NSData *valueForTransformableAttribute = [NSKeyedArchiver archivedDataWithRootObject:value];
            return valueForTransformableAttribute;
        }];
    }
}
// utils
+(NSAttributeType)attributeTypeForAttributeName:(NSString *)name context:(NSManagedObjectContext *)context{
    NSDictionary *attributesByName = [[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context] attributesByName];
    return [[attributesByName objectForKey:name] attributeType];
}

+(id)convertValue:(id)value forKey:(NSString *)key context:(NSManagedObjectContext *)context {
    id newValue = value;

    NSAttributeType attributeType = [self attributeTypeForAttributeName:key context:context];
    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
        newValue = [value stringValue];
    } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
        newValue = [NSNumber numberWithInteger:[value integerValue]];
    } else if ((attributeType == NSDoubleAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
        newValue = [NSNumber numberWithDouble:[value doubleValue]];
    } else if ((attributeType == NSDecimalAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
        newValue = [NSDecimalNumber decimalNumberWithString:value];
    } else if ((attributeType == NSDecimalAttributeType) &&  ([value isKindOfClass:[NSNumber class]])) {
        newValue = [NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]];
    } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
        newValue = [NSNumber numberWithFloat:[value floatValue]];
    } else if ((attributeType == NSBooleanAttributeType) && ([value isKindOfClass:[NSNumber class]])){
        newValue = [NSNumber numberWithBool:[value boolValue]];
    }
    return newValue;
}

+(NSString *)transformableNameForAttribute:(NSString *)attribute {
    return [NSString stringWithFormat:@"%@_data", attribute];
}

@end
