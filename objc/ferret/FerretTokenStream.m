//
//  FerretTokenStream.m
//  ferret
//
//  Created by Sergey Martynov on 18.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretTokenStream.h"
#import "FerretInternals.h"

@interface FerretToken ()
- (id)initWithTok:(FrtToken*)tok;
@end

@interface FerretTokenStream ()
@property (nonatomic, readonly) FrtTokenStream *stream;
@end

@implementation FerretTokenStream

@synthesize text;
@synthesize stream;

- (id)initWithText:(NSString*)_text analyzer:(FerretAnalyzer*)analyzer
{
    if (!_text || !analyzer) return NULL;
    self = [super init];
    if (self) {
        text = _text;
        stream = frt_a_get_ts(analyzer.analyzer, frt_intern("text"), (char*)[text UTF8String]);
        if (!stream) return nil;
    }
    return self;
}

+ (FerretTokenStream*)tokenStreamForText:(NSString*)text analyzer:(FerretAnalyzer*)analyzer
{
    return [[self alloc] initWithText:text analyzer:analyzer];
}

- (void)dealloc
{
    if (stream) frt_ts_deref(stream);
    stream = NULL;
}

- (FerretToken*)next
{
    return [[FerretToken alloc] initWithTok:frt_ts_next(stream)];
}

- (void)reset
{
    stream->reset(stream, (char*)[text UTF8String]);
}

- (NSArray*)collectAll
{
    FerretToken *tok = nil;
    NSMutableArray *tokens = [NSMutableArray array];
    while ((tok = [self next])) {
        [tokens addObject:tok];
    }
    return tokens;
}

@end


@implementation FerretToken

@synthesize text;
@synthesize byteRange;

- (id)initWithTok:(FrtToken *)tok
{
    if (!tok) return nil;
    self = [super init];
    if (self) {
        text = [[NSString alloc] initWithBytes:tok->text length:tok->len encoding:NSUTF8StringEncoding];
        byteRange = NSMakeRange(tok->start, tok->end - tok->start);
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<FerretToken: '%@', bytes:%@>", text, NSStringFromRange(byteRange)];
}

@end