//
//  RKManagedObjectTableItem.m
//  GateGuru
//
//  Created by Jeff Arena on 12/14/10.
//  Copyright 2010 GateGuru. All rights reserved.
//

#import "RKManagedObjectTableItem.h"

@implementation RKManagedObjectTableItem

+ (id)itemWithObject:(RKManagedObject*)object {
	return [[[self alloc] initWithObject:object] autorelease];
}

- (id)initWithObject:(RKManagedObject*)object {
	if (self = [super init]) {
		_object = [object retain];
		self.URL = [_object URLValueWithName:@"show"];
	}
	return self;
}

- (void)dealloc {
	[_object release];
	_object = nil;
	[super dealloc];
}

- (RKManagedObject*)object {
	return _object;
}

- (NSManagedObjectID*)objectId {
	return [self.object objectID];
}

- (NSEntityDescription*)entity {
	return [self.object entity];
}

- (NSString*)text {
	if ([_object respondsToSelector:@selector(name)]) {
		return [_object performSelector:@selector(name)];
	}
	return nil;
}

- (NSString*)caption {
	if ([_object respondsToSelector:@selector(code)]) {
		return [_object performSelector:@selector(code)];
	}
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSCoding

- (id)initWithCoder:(NSCoder*)decoder {
    if (self = [super initWithCoder:decoder]) {
        _object = [[decoder decodeObjectForKey:@"object"] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder {
    [super encodeWithCoder:encoder];
    if (_object) {
		[encoder encodeObject:_object forKey:@"object"];
    }
}

@end
