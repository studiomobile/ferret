//
//  FerretIndexWriter.h
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretStore;
@class FerretAnalyzer;
@class FerretConfig;
@class FerretIndexReader;

@interface FerretIndexWriter : NSObject

@property (nonatomic, readonly) NSInteger count;

+ (FerretIndexWriter*)writeIndexWithStore:(FerretStore*)store analyzer:(FerretAnalyzer*)analyzer config:(FerretConfig*)config;

- (FerretIndexReader*)readIndex;

- (void)appendDocument:(NSDictionary*)fields;
- (void)appendDocument:(NSDictionary*)fields boost:(float)boost;

- (void)commit;
- (void)optimize;

@end
