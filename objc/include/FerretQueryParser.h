//
//  FerretQueryParser.h
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretAnalyzer;
@class FerretQuery;

@interface FerretQueryParser : NSObject

+ (FerretQueryParser*)queryParserWithAnalyzer:(FerretAnalyzer*)analyzer;

- (FerretQuery*)parseQueryText:(NSString*)text;

@end
