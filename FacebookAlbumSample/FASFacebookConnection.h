//
//  FASFacebookConnection.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/03/04.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FASDataManager.h"

@interface FASFacebookConnection : NSObject

@property(weak, nonatomic)FASDataManager* dataManager;
@property(nonatomic)UITableView* reloadTableTarget;
@property(nonatomic)UICollectionView* reloadCollectionTarget;
-(FASFacebookConnection*)initWithDataManager:(FASDataManager*)manager;
-(void)startFacebookConnection;
-(BOOL)getNextAlbumPage;
-(void)getAlbumData:(NSString*)albumId;

@end
