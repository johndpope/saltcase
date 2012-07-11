//
//  SCKeyboardView.m
//  SaltCase
//
//  Created by Sota Yokoe on 7/11/12.
//  Copyright (c) 2012 Pankaku Inc. All rights reserved.
//

#import "SCKeyboardView.h"

@interface SCKeyboardView() {
    int selectedKey;
}
@property (nonatomic, strong) NSArray* keyNames;
- (void)deselectKey;
- (void)selectKey:(int)keyNumber;
@end

@implementation SCKeyboardView
@synthesize keyNames;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // TODO: Move to appropriate class.
    NSDictionary* noteMappings = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NoteMap" ofType:@"plist"]];
    NSMutableArray* names = [NSMutableArray array];
    for (NSDictionary* note in [noteMappings objectForKey:@"Notes"]) {
        [names addObject:[note objectForKey:@"Name"]];
    }
    self.keyNames = names;
    
    [self deselectKey];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    float y = 0.0f;
    int i = 0;
    while (y <= dirtyRect.size.height) {
        if (i == selectedKey) {
            [[NSColor whiteColor] set];
        } else if (i % 2 == 0) {
            [[NSColor lightGrayColor] set];
        } else {
            [[NSColor grayColor] set];
        }
        NSRect rect = NSMakeRect(0.0f, y, dirtyRect.size.width, kSCNoteLineHeight);
        NSRectFill(rect);
        
        NSString* keyName = [self.keyNames objectAtIndex:i % self.keyNames.count];
        [keyName drawInRect:rect withAttributes:nil];
        NSLog(@"%@", keyName);
        
        i++, y += kSCNoteLineHeight;
    }
}

- (void)deselectKey {
    [self selectKey:-1];
}
- (void)selectKey:(int)keyNumber {
    if (selectedKey != keyNumber) {
        selectedKey = keyNumber;
        NSLog(@"selectKey %d", keyNumber);
        [self setNeedsDisplay:YES];
    }
}

- (int)noteNumberAtPoint:(NSPoint)point {
    return (int)floor(point.y / kSCNoteLineHeight);
}
- (void)mouseDown:(NSEvent *)theEvent {
    [self selectKey:[self noteNumberAtPoint:theEvent.locationInWindow]];
}
- (void)mouseDragged:(NSEvent *)theEvent {
    [self selectKey:[self noteNumberAtPoint:theEvent.locationInWindow]];
}
- (void)mouseUp:(NSEvent *)theEvent {
    [self deselectKey];
}
@end
