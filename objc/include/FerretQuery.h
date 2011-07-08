//
//  FerretQuery.h
//  ferret
//
//  Created by Sergey Martynov on 07.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretMatchVector;
@class FerretDocument;

@interface FerretQuery : NSObject

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (FerretMatchVector*)matchVectorForDocument:(FerretDocument*)doc field:(NSString*)field;

@end
