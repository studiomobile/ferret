//
//  FerretAnalyzer.m
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretAnalyzer.h"
#import "FerretInternals.h"
#import "UnicodeWhitespaceTokenizer.h"

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
//    FrtAnalyzer *a = frt_analyzer_new(frt_hyphen_filter_new(frt_utf8_standard_tokenizer_new()), NULL, NULL);
//    FrtAnalyzer *a = frt_analyzer_new(frt_stem_filter_new(unicode_ws_tokenizer_new(), "ru", "UTF_8"), NULL, NULL);
    FrtAnalyzer *a = frt_analyzer_new(unicode_ws_tokenizer_new(), NULL, NULL);
    return [[self alloc] initWithAnalyzer:a];
}

@end
