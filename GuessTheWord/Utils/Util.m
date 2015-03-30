#import "Util.h"

@implementation Util

+(NSString *)timeStringForDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)timeAgo:(NSDate *)date
{
    return [self timeAgo:date compact:NO];
}

+(NSString *)timeAgo:(NSDate *)date compact:(BOOL)compact {
    double deltaSeconds = fabs([date timeIntervalSinceNow]);
    double deltaMinutes = deltaSeconds / 60.0f;
    double deltaHours = deltaMinutes / 60.0f;
    double deltaDays = deltaHours / 24;
    double deltaWeeks = deltaDays / 7;
    double deltaMonths = deltaDays / 30; // rough estimate

    if(deltaSeconds < 5)
    {
        if (compact)
            return @"Now";
        return @"Just now";
    }
    else if(deltaSeconds < 60)
    {
        if (compact)
            return [NSString stringWithFormat:@"%ds", (int)deltaSeconds];
        return [NSString stringWithFormat:@"%d sec ago", (int)deltaSeconds];
    }
    else if (deltaMinutes < 60)
    {
        if (compact)
            return [NSString stringWithFormat:@"%dm", (int)deltaMinutes];
        return [NSString stringWithFormat:@"%d min ago", (int)deltaMinutes];
    }
    else if (deltaHours < 24)
    {
        if (compact)
            return [NSString stringWithFormat:@"%dh", (int)deltaHours];
        return [NSString stringWithFormat:@"%d hr ago", (int)deltaHours];
    }
    else if (deltaDays < 7)
    {
        if (deltaDays < 2) {
            if (compact)
                return @"1d";
            return @"1 day ago";
        }
        if (compact)
            return [NSString stringWithFormat:@"%dd", (int)deltaDays];
        return [NSString stringWithFormat:@"%d days ago", (int)deltaDays];
    }
    else if (deltaWeeks < 8)
    {
        if (compact)
            return [NSString stringWithFormat:@"%dwk", (int)deltaWeeks];
        return [NSString stringWithFormat:@"%d wk ago", (int)deltaWeeks];
    }
    else if (deltaMonths < 13)
    {
        if (compact)
            return [NSString stringWithFormat:@"%dmon", (int)deltaMonths];
        return [NSString stringWithFormat:@"%d mon ago", (int)deltaMonths];
    }
    else if (deltaMonths < 24)
    {
        if (compact)
            return @"1yr";
        return @"Last year";
    }
    else
    {
        if (compact)
            return @"past";
        return @"In the past";
    }
}

+ (NSString *)simpleTimeAgo:(NSDate *)date {
    double deltaSeconds = fabs([date timeIntervalSinceNow]);
    if (deltaSeconds < 24*3600)
    {
        return @"Today";
    }
    return [self timeAgo:date];
}

#pragma mark Requests
+(void)easyRequest:(NSString *)endpoint method:(NSString *)method params:(id)params completion:(void(^)(NSDictionary *results, NSError *error))completion {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    NSData *getData;
    if ([params isKindOfClass:[NSDictionary class]])
        getData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    else
        getData = [params dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *getLength = [NSString stringWithFormat:@"%lu", [getData length]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:method];
    [request setHTTPBody:getData];

    // if we need headers like GPRequest
    [request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"iPhone" forHTTPHeaderField:@"Device-Type"];
    [request setValue:VERSION forHTTPHeaderField:@"Version-Number"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"application/vnd.pact.v%d", 4] forHTTPHeaderField:@"Accept"];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            if (completion)
                completion(nil, error);
        }
        else {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
            int status = (int)[httpResponse statusCode];
            // todo: handle error status. Info is still contained in the JSON but return an error object constructed from the JSON?

            // for debug: see if data is valid
            NSString* json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Received status %d json: %@", status, json);

            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            if (completion) {
                completion(results, nil);
            }
        }
    }];
}

@end
