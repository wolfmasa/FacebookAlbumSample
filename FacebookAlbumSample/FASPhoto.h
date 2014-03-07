//
//  FASPhoto.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FASPhoto : NSObject

@property(nonatomic,retain)UIImage *thumbnail;
@property(nonatomic, retain)NSString *url;
@property(nonatomic, retain)NSString *facebookId;

@end
