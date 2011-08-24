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
- (id)initWithTok:(FrtToken*)tok pos:(NSInteger)pos;
@end

@interface FerretTokenStream ()
@property (nonatomic, readonly) FrtTokenStream *stream;
@property (nonatomic, readonly) NSInteger token_pos;
@end

@implementation FerretTokenStream

@synthesize text;
@synthesize stream;
@synthesize token_pos;

- (id)initWithText:(NSString*)_text analyzer:(FerretAnalyzer*)analyzer
{
    if (!_text || !analyzer) return NULL;
    self = [super init];
    if (self) {
        text = _text;
        stream = frt_a_get_ts(analyzer.analyzer, frt_intern("text"), (char*)[text UTF8String]);
        if (!stream) return nil;
        token_pos = 0;
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
    FrtToken *tok = frt_ts_next(stream);
    FerretToken *token = [[FerretToken alloc] initWithTok:tok pos:token_pos];
    if (tok) token_pos += tok->pos_inc;
    return token;
}

- (void)reset
{
    stream->reset(stream, (char*)[text UTF8String]);
    token_pos = 0;
}

- (NSArray*)collectAll
{
    NSMutableArray *tokens = [NSMutableArray array];
    FerretToken *tok = nil;
    while ((tok = [self next])) {
        [tokens addObject:tok];
    }
    return tokens;
}

@end


@implementation FerretToken

@synthesize text;
@synthesize range;
@synthesize pos;
@synthesize posInc;

- (id)initWithTok:(FrtToken *)tok pos:(NSInteger)_pos
{
    if (!tok) return nil;
    self = [super init];
    if (self) {
        text = [[NSString alloc] initWithBytes:tok->text length:tok->len encoding:NSUTF8StringEncoding];
        range = NSMakeRange(tok->start, tok->len);
        pos = _pos;
        posInc = tok->pos_inc;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<FerretToken: '%@', bytes:%@>", text, NSStringFromRange(range)];
}

@end