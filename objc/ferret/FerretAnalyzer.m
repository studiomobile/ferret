//
//  FerretAnalyzer.m
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretAnalyzer.h"
#import "FerretInternals.h"

@implementation FerretAnalyzer

@synthesize analyzer;

+ (void)initialize
{
    [FerretStore class]; // force class loading - ferret initialization
}

- (id)initWithAnalyzer:(FrtAnalyzer*)_analyzer
{
    if (!_analyzer) return nil;
    self = [super init];
    if (self) {
        analyzer = _analyzer;
    }
    return self;
}

- (void)dealloc
{
    if (analyzer) frt_a_deref(analyzer);
    analyzer = NULL;
}

+ (FerretAnalyzer*)defaultAnalyzer
{
//    FrtAnalyzer *a = frt_utf8_standard_analyzer_new(false);
    FrtAnalyzer *a = frt_analyzer_new(frt_hyphen_filter_new(frt_utf8_standard_tokenizer_new()), NULL, NULL);
    return [[self alloc] initWithAnalyzer:a];
}

- (FerretTokenStream*)getTokenStreamForText:(NSString*)text
{
    FrtTokenStream *ts = frt_a_get_ts(analyzer, frt_intern("text"), (char*)[text UTF8String]);
    return [[FerretTokenStream alloc] initWithTokenStream:ts];
}

@end
