//
//  FASPhoto.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FASPhoto : NSObject

@property(nonatomic,strong)UIImage *thumbnail;
@property(nonatomic, strong)NSString *thumbnailUrl;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic, strong)NSString *graphId;

-(BOOL)isCached;

@end
