//
//  RKManagedObjectTTListDataSource.m
//  RestKit
//
//  Created by Jeff Arena on 12/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "RKManagedObjectTTListDataSource.h"
#import "RKManagedObjectTableItem.h"

@interface RKManagedObjectTTListDataSource (Protected)

- (RKManagedObjectTableItem*)tableItemForObject:(id)object;

@end

@implementation RKManagedObjectTTListDataSource

- (id)initWithModel:(RKRequestManagedObjectTTModel*)model {
	if (self = [self init]) {
		self.model = model;
		[model.delegates addObject:self];
		_items = [[NSMutableArray alloc] initWithCapacity:[model count]];
	}
	return self;
}

- (void)dealloc {
	[self.model.delegates removeObject:self];
	[_items release];
	_items = nil;
	[super dealloc];
}

- (RKManagedObjectTableItem*)tableItemForObject:(id)object {
	if ([object isKindOfClass:[RKManagedObject class]]) {
		return [RKManagedObjectTableItem itemWithObject:object];
	}
	return nil;
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object isKindOfClass:[RKManagedObjectTableItem class]]) {
		RKManagedObjectTableItem* item = (RKManagedObjectTableItem*)object;
		NSString* className = [NSString stringWithFormat:@"%@TableItemCell", [item.entity managedObjectClassName]];
		return NSClassFromString(className);
	}
	return [super tableView:tableView cellClassForObject:object];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	RKRequestManagedObjectTTModel* model = (RKRequestManagedObjectTTModel*)self.model;
	return [model count];
}


#pragma mark -
#pragma mark TTTableViewDataSource

- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath {
	RKRequestManagedObjectTTModel* model = (RKRequestManagedObjectTTModel*)self.model;
	if (indexPath.row < [model count]) {
		RKManagedObjectTableItem* item = nil;
		if (indexPath.row < [_items count]) {
			item = [_items objectAtIndex:indexPath.row];
		}
		if (item == nil) {
			item = [self tableItemForObject:[model.objects objectAtIndex:indexPath.row]];
			[_items insertObject:item atIndex:indexPath.row];
		}
		return item;
	} else {
		return nil;
	}
}

- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object {
	NSUInteger objectIndex = [_items indexOfObject:object];
	if (objectIndex != NSNotFound) {
		return [NSIndexPath indexPathForRow:objectIndex inSection:0];
	}
	return nil;
}

- (NSIndexPath*)indexPathOfItemWithUserInfo:(id)userInfo {
	for (NSInteger i = 0; i < _items.count; ++i) {
		RKManagedObjectTableItem* item = [_items objectAtIndex:i];
		if (item.userInfo == userInfo) {
			return [NSIndexPath indexPathForRow:i inSection:0];
		}
	}
	return nil;
}


#pragma mark -
#pragma mark TTTableViewDataSource

- (void)modelDidFinishLoad:(id<TTModel>)model {
	[_items removeAllObjects];
}


@end
