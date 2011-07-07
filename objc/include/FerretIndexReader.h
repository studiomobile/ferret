//
//  FerretIndexReader.h
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretStore;

@interface FerretIndexReader : NSObject

+ (FerretIndexReader*)readIndexWithStore:(FerretStore*)store;

- (void)deleteDocumentWithId:(NSInteger)docId;
- (void)commit;
- (void)undeleteAll;

@end
