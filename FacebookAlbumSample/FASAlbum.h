//
//  FASAlbum.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FASPhoto.h"


typedef NS_ENUM(NSUInteger, FASAlbumCacheStatus) {
    FASAlbumCacheStatusNotCached,
    FASAlbumCacheStatusCached,
    FASAlbumCacheStatusLoading
};

@interface FASAlbum : NSObject
@property(nonatomic, retain) FBGraphObject *fbObject;
@property(nonatomic) NSString* name;
@property(nonatomic) NSString* albumId;

@property FASAlbumCacheStatus cacheStatus;

@property(nonatomic)NSMutableArray *photos;

- (id)initWithFBObject:(FBGraphObject*)fb;
-(BOOL)updateCacheStatus;

@end
