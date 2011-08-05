//
//  FerretAnalyzer.h
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretTokenStream;

@interface FerretAnalyzer : NSObject

+ (FerretAnalyzer*)defaultAnalyzer;

- (FerretTokenStream*)getTokenStreamForText:(NSString*)text;

@end
