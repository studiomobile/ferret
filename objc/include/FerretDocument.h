//
//  FerretDocument.h
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FerretDocument : NSObject

- (NSString*)stringValueOfField:(NSString*)fieldName;
- (NSData*)dataValueOfField:(NSString*)fieldName;

@end
