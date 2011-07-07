//
//  FerretSearcher.h
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretIndexReader;
@class FerretDocument;
@class FerretQuery;
@class FerretSearchResults;

@interface FerretSearcher : NSObject

+ (FerretSearcher*)searcherWithIndexReader:(FerretIndexReader*)reader;

- (FerretDocument*)documentWithId:(NSInteger)docId;

- (FerretSearchResults*)search:(FerretQuery*)query;

@end
