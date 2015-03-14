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


@end
