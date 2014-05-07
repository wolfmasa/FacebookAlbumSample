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

/// アルバム管理クラス
@interface FASAlbum : NSObject<NSCoding>
/// タイトル。
@property(nonatomic)NSString* name;
/// アルバムのGraph ID
@property(nonatomic)NSString* albumId;
/// Cacheの状態。適時updateCacheStatusで更新する
@property(assign, nonatomic)FASAlbumCacheStatus cacheStatus;
/// 保持する写真
@property NSMutableArray *photos;

/// 初期化
- (id)init;
/// キャッシュの状態を更新する。
-(BOOL)updateCacheStatus;

@end
