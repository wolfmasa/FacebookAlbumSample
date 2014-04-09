//
//  FASPhoto.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FASPhoto : NSObject<NSCoding>

@property UIImage *thumbnail;
@property NSString *thumbnailUrl;
@property UIImage *image;
@property NSString *imageUrl;
@property NSString *graphId;

-(BOOL)isCached;

@end
