//
//  FerretIndex.h
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretStore;
@class FerretAnalyzer;
@class FerretQuery;
@class FerretDocument;
@class FerretSearchResults;

@interface FerretIndex : NSObject

@property (nonatomic, readonly, strong) FerretAnalyzer *analyzer;

+ (FerretIndex*)indexWithStore:(FerretStore*)store analyzer:(FerretAnalyzer*)analyzer;

- (FerretDocument*)documentWithId:(NSInteger)docId;

- (FerretQuery*)parseQueryText:(NSString*)text;
- (FerretSearchResults*)search:(FerretQuery*)query;

- (void)appendDocument:(NSDictionary*)fields;
- (void)appendDocument:(NSDictionary*)fields boost:(float)boost;

- (void)commit;

@end
