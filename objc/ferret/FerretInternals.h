//
//  FerretInternals.h
//  ferret
//
//  Created by Sergey Martynov on 04.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import "store.h"
#import "index.h"
#import "analysis.h"
#import "search.h"
#import "ind.h"

#import "FerretStore.h"
#import "FerretAnalyzer.h"
#import "FerretConfig.h"
#import "FerretIndex.h"
#import "FerretIndexWriter.h"
#import "FerretIndexReader.h"
#import "FerretSearcher.h"
#import "FerretSearchResults.h"
#import "FerretDocument.h"
#import "FerretField.h"
#import "FerretFieldDescriptor.h"
#import "FerretQuery.h"


@interface FerretStore ()
@property (nonatomic, readonly) FrtStore *store;
@end


@interface FerretAnalyzer ()
@property (nonatomic, readonly) FrtAnalyzer *analyzer;
@end


@interface FerretConfig ()
@property (nonatomic, readonly) FrtConfig config;
@end

@interface FerretIndex ()
@property (nonatomic, readonly) FrtIndex *index;
@end

@interface FerretIndexWriter ()
@property (nonatomic, readonly) FrtIndexWriter *writer;
@end


@interface FerretIndexReader ()
@property (nonatomic, readonly) FrtIndexReader *reader;
@end


@interface FerretSearcher ()
@property (nonatomic, readonly) FrtSearcher *searcher;
@end

@interface FerretSearchResults ()
@property (nonatomic, readonly) FrtTopDocs *topdocs;
@property (nonatomic, strong) FerretSearcher *searcher;
@property (nonatomic, strong) FerretIndex *index;
- (id)initWithTopDocs:(FrtTopDocs*)topdocs;
@end

@interface FerretDocument ()
@property (nonatomic, readonly) FrtLazyDoc *lazyDoc;
@property (nonatomic, readonly) FrtDocument *doc;
@property (nonatomic, strong) FerretSearcher *searcher;
@property (nonatomic, strong) FerretIndex *index;
- (id)initWithLazyDoc:(FrtLazyDoc*)doc;
- (id)initWithDocument:(FrtDocument*)doc;
@end

@interface FerretField ()
@property (nonatomic, readonly) FrtFieldInfo *field;
+ (FrtDocField*)createDocFieldWithName:(NSString*)name value:(NSString*)value;
+ (FrtDocField*)createDocFieldWithName:(NSString*)name data:(NSData*)data;
- (id)initWithField:(FrtFieldInfo*)field;
@end

@interface FerretFieldDescriptor ()
@property (nonatomic, readonly) FrtStoreValue storeValue;
@property (nonatomic, readonly) FrtIndexValue indexValue;
@property (nonatomic, readonly) FrtTermVectorValue termVectorValue;
@end

@interface FerretQuery ()
@property (nonatomic, readonly) FrtQuery *query;
- (id)initWithQuery:(FrtQuery*)query;
@end