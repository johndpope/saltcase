//
//  SCNote.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/21/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCNote.h"

@implementation SCNote
- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.startsAt = [dictionary[@"startsAt"] floatValue];
        self.length = [dictionary[@"length"] floatValue];
        self.pitch = [dictionary[@"pitch"] intValue];
        self.text = dictionary[@"text"];
    }
    return self;
}

- (NSDictionary*)dictionaryRepresentation {
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.startsAt], @"startsAt", 
            [NSNumber numberWithFloat:self.length], @"length", 
            [NSNumber numberWithInt:self.pitch], @"pitch", 
            self.text ? self.text : @"", @"text", nil];
}
- (NSString*)description { return [[self dictionaryRepresentation] description]; }

- (NSTimeInterval)startsAtSecondsInTempo:(float)tempo {
    return self.startsAt * 60.0f / tempo;
}
- (NSTimeInterval)endsAtSecondsInTempo:(float)tempo {
    return (self.startsAt + self.length) * 60.0f / tempo;
}
@end
