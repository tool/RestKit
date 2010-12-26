//
//  RKManagedObjectTTListDataSource.h
//  RestKit
//
//  Created by Jeff Arena on 12/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "Three20UI/TTTableViewDataSource.h"
#import "RKRequestManagedObjectTTModel.h"

@interface RKManagedObjectTTListDataSource : TTTableViewDataSource <TTModelDelegate> {
	NSMutableArray* _items;
}

- (id)initWithModel:(RKRequestManagedObjectTTModel*)model;

- (NSIndexPath*)indexPathOfItemWithUserInfo:(id)userInfo;

@end
