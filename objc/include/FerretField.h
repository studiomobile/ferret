//
//  FerretField.h
//  ferret
//
//  Created by Sergey Martynov on 05.07.11.
//  Copyright 2011 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FerretFieldDescriptor;

@interface FerretField : NSObject

- (id)initWithFieldDescriptor:(FerretFieldDescriptor*)desc;

@end
