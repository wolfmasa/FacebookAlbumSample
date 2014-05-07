//
//  FASPhoto.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

/// １枚の画像に関するクラス。
@interface FASPhoto : NSObject<NSCoding>

/// サムネイル画像。
@property UIImage *thumbnail;
/// サムネイル画像のURL。URLが入っている場合は未取得。取得したらnil。
@property NSString *thumbnailUrl;
/// 本画像。
@property UIImage *image;
/// 本画像のURL。URLが入っている場合には未取得。取得したらnil。
@property NSString *imageUrl;
/// １枚の画像オブジェクトに対するFBObjectのID
@property NSString *graphId;

/// 本画像がキャッシュされているか？
-(BOOL)isCached;

@end
