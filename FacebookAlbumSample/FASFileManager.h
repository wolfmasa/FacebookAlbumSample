//
//  FASFileManager.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/04/06.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FASFileManager : NSObject

//シングルトン
+(FASFileManager*)sharedConnection;

@property(nonatomic, strong)NSString* userId;

-(BOOL)initWithUserId:(NSString*)userId;
-(BOOL)createAlbumDir:(NSString*)albumId;

@end
