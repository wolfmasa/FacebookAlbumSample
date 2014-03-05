//
//  FASDataManager.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FASAlbum.h"

@interface FASDataManager : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource>

@property(retain,nonatomic)NSMutableArray* albums;
@property NSString* nextPageGraphPath;

@end
