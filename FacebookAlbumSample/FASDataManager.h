//
//  FASDataManager.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FASAlbum.h"
#import "FASPhoto.h"
#import "FASPhotoCell.h"

@interface FASDataManager : NSObject<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource>

+(FASDataManager*)sharedManager;

@property NSMutableArray* albums;
@property NSString* nextPageGraphPath;

// Album
@property NSInteger activeAlbumIndex;
-(BOOL)changeActiveAlbumIndex:(NSInteger)index;
-(FASAlbum*)getActiveAlbum;

// Photo
@property NSInteger activePhotoIndex;
-(BOOL)changeActivePhotoIndex:(NSInteger)index;
-(FASPhoto*)getActivePhoto;

-(BOOL)saveAlbum;
-(void)clearAllAlbum;

@end
