//
//  FerretQueryParser.m
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "FerretQueryParser.h"
#import "FerretInternals.h"

@interface FerretQueryParser ()
@property (nonatomic, assign) FrtQueryParser *parser;
@property (nonatomic, strong) FerretAnalyzer *analyzer;
@end

@implementation FerretQueryParser

@synthesize parser;
@synthesize analyzer;

- (id)initWithQueryParser:(FrtQueryParser*)_parser
{
    if (!_parser) return nil;
    self = [super init];
    if (self) {
        parser = _parser;
    }
    return self;
}

- (void)dealloc
{
    if (parser) frt_qp_destroy(parser);
    parser = NULL;
}

+ (FerretQueryParser*)queryParserWithAnalyzer:(FerretAnalyzer*)analyzer
{
    FrtQueryParser *qp = frt_qp_new(analyzer.analyzer);
    FerretQueryParser *parser = [[self alloc] initWithQueryParser:qp];
    parser.analyzer = analyzer;
    return parser;
}

- (FerretQuery*)parseQueryText:(NSString*)text
{
    FrtQuery *q = frt_qp_parse(parser, (char*)[text UTF8String]);
    return [[FerretQuery alloc] initWithQuery:q];
}

@end
