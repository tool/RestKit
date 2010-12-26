//
//  RKRequestManagedObjectTTModel.h
//  RestKit
//
//  Created by Jeff Arena on 12/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "RKRequestFilterableTTModel.h"

@interface RKRequestManagedObjectTTModel : RKRequestFilterableTTModel {
	NSFetchRequest* _fetchRequest;
	NSUInteger _count;
}

- (NSUInteger)count;

@end
