//
//  SCNote.h
//  SaltCase
//
//  Created by Sota Yokoe on 7/21/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNote : NSObject
@property (assign) float startsAt;
@property (assign) float length;
@property (assign) int pitch;
@property (strong) NSString* text;
- (NSDictionary*)dictionaryRepresentation;
- (id)initWithDictionary:(NSDictionary*)dictionary;

- (NSTimeInterval)startsAtSecondsInTempo:(float)tempo;
- (NSTimeInterval)endsAtSecondsInTempo:(float)tempo;
@end
