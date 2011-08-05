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
@property (nonatomic, readonly) NSInteger token_pos;
@end

@implementation FerretTokenStream

@synthesize stream;
@synthesize token_pos;

- (id)initWithTokenStream:(FrtTokenStream*)_stream
{
    if (!_stream) return nil;
    self = [super init];
    if (self) {
        stream = _stream;
        token_pos = 0;
    }
    return self;
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
    stream->reset(stream, stream->text);
    token_pos = 0;
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
        text = [NSString stringWithCString:tok->text encoding:NSUTF8StringEncoding];
        range = NSMakeRange(tok->start, tok->end - tok->start + 1);
        pos = _pos;
        posInc = tok->pos_inc;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<FerretToken: \"%@\", %@, %d+%d>", text, NSStringFromRange(range), pos, posInc];
}

@end