//
//  RKRequestManagedObjectTTModel.m
//  RestKit
//
//  Created by Jeff Arena on 12/17/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "RKRequestManagedObjectTTModel.h"
#import "../CoreData/CoreData.h"


@implementation RKRequestManagedObjectTTModel

- (id)initWithResourcePath:(NSString*)resourcePath {
	if (self = [super initWithResourcePath:resourcePath]) {
		RKManagedObjectStore* store = [RKObjectManager sharedManager].objectStore;
		if (store.managedObjectCache) {
			_fetchRequest = [[[store.managedObjectCache fetchRequestsForResourcePath:resourcePath] objectAtIndex:0] retain];
		}
		_count = 0;
	}
	return self;
}

- (void)dealloc {
	[_fetchRequest release];
	_fetchRequest = nil;
	[super dealloc];
}

- (void)reset {
	[_fetchRequest release];
	_fetchRequest = nil;
	_count = 0;
	self.predicate = nil;
	self.sortDescriptors = nil;
	[_searchText release];
	_searchText = nil;
	[self didChange];
}

- (void)search:(NSString*)text {
	[_objects release];
	_objects = nil;
	_count = 0;

	[super search:text];
}

- (NSUInteger)count {
	NSError* error = nil;
	if (_count == 0) {
		_count = [[RKManagedObject managedObjectContext] countForFetchRequest:_fetchRequest error:&error];
	}
	return _count;
}

- (NSArray*)objects {
	if (nil == _objects) {
		_objects = [[RKManagedObject objectsWithFetchRequest:_fetchRequest] retain];

		if (_searchText || self.sortSelector) {
			[_filteredObjects release];
			_filteredObjects = nil;

			if (_searchText) {
				_filteredObjects = [self search:_searchText inCollection:_objects];
			}
			if (self.sortSelector) {
				_filteredObjects = [_filteredObjects ? _filteredObjects : _objects sortedArrayUsingSelector:self.sortSelector];
			}

			[_filteredObjects retain];
			return _filteredObjects;
		}
	}
	return _objects;
}

- (void)modelsDidLoad:(NSArray*)models {
	[_objects release];
	_objects = nil;
	_count = 0;

	_isLoaded = YES;

	[self didFinishLoad];
}

- (void)setPredicate:(NSPredicate*)predicate {
	if (predicate != self.predicate) {
		[super setPredicate:predicate];

		[_fetchRequest setPredicate:predicate];
		_count = 0;

		[_objects release];
		_objects = nil;
	}
}

- (void)setSortDescriptors:(NSArray*)sortDescriptors {
	if (sortDescriptors != self.sortDescriptors) {
		[super setSortDescriptors:sortDescriptors];

		[_fetchRequest setSortDescriptors:sortDescriptors];
		_count = 0;

		[_objects release];
		_objects = nil;
	}
}

- (void)setSortSelector:(SEL)sortSelector {
	if (sortSelector != self.sortSelector) {
		[super setSortSelector:sortSelector];
		[super setSortDescriptors:nil];

		[_fetchRequest setSortDescriptors:nil];
		_count = 0;

		[_objects release];
		_objects = nil;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)load {
	NSError *error = nil;
	NSUInteger cachedObjectCount =  [[RKManagedObject managedObjectContext] countForFetchRequest:_fetchRequest error:&error];

	if (_cacheLoaded || (cachedObjectCount == 0 && [[RKObjectManager sharedManager] isOnline])) {
		RKObjectLoader* objectLoader = [[[RKObjectManager sharedManager] objectLoaderWithResourcePath:_resourcePath delegate:self] retain];
		objectLoader.method = self.method;
		objectLoader.objectClass = _objectClass;
		objectLoader.keyPath = _keyPath;
		objectLoader.params = self.params;

		_isLoading = YES;
		[self didStartLoad];
		[objectLoader send];

	} else if (!_cacheLoaded) {
		_cacheLoaded = YES;
		[self modelsDidLoad:nil];
	}
}

@end
