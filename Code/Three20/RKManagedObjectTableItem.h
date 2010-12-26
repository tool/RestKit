//
//  RKManagedObjectTableItem.h
//  GateGuru
//
//  Created by Jeff Arena on 12/14/10.
//  Copyright 2010 GateGuru. All rights reserved.
//

#import <Three20/Three20.h>
#import <Three20UI/Three20UI+Additions.h>
#import <CoreData/CoreData.h>
#import "../CoreData/CoreData.h"

@interface RKManagedObjectTableItem : TTTableLinkedItem {
	RKManagedObject* _object;
}

@property (nonatomic, readonly) NSManagedObjectID* objectId;
@property (nonatomic, readonly) NSEntityDescription* entity;
@property (nonatomic, readonly) RKManagedObject* object;

+ (id)itemWithObject:(RKManagedObject*)object;

@end
