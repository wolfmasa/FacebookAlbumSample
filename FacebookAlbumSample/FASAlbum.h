//
//  FASAlbum.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef NS_ENUM(NSUInteger, FASAlbumCacheStatus) {
    FASAlbumCacheStatusNotCached,
    FASAlbumCacheStatusCached,
    FASAlbumCacheStatusLoading,
    FASAlbumCacheStatusDisConnection
};

@interface FASAlbum : NSObject<NSCoding>
@property NSString* name;
@property NSString* albumId;

@property FASAlbumCacheStatus cacheStatus;

@property NSMutableArray *photos;

- (id)init;
-(BOOL)updateCacheStatus;

@end
