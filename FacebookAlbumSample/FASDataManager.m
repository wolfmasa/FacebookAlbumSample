//
//  FASDataManager.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/28.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASDataManager.h"
#import "FASFacebookConnection.h"
#import "FASFileManager.h"

@implementation FASDataManager

static FASDataManager *sharedManager_ = nil;
+ (FASDataManager *)sharedManager{
    if (!sharedManager_) {
        sharedManager_ = [FASDataManager new];
    }
    return sharedManager_;
}

- (id)init
{
    // Init FileManager
    FASFileManager * fileManager = [FASFileManager sharedManager];
    [fileManager initWithUserId:@"me"];
    
    self = [super init];
    if (self) {
        self.activeAlbumIndex = 0;
        
        self.albums = [fileManager unarchivePhotoData];
        if(self.albums == nil) self.albums = [NSMutableArray new];            
    }
    
    return self;
}

-(BOOL)changeActiveAlbumIndex:(NSInteger)index
{
    if (self.activeAlbumIndex != index) {
        self.activeAlbumIndex = index;
        return YES;
    }
    
    return NO;
}

-(FASPhoto*)getActivePhoto
{
    FASAlbum *album = [self getActiveAlbum];
    return album.photos[self.activePhotoIndex];
}

-(BOOL)changeActivePhotoIndex:(NSInteger)index
{
    if (self.activePhotoIndex != index) {
        self.activePhotoIndex = index;
        return YES;
    }
    
    return NO;
}

-(FASAlbum*)getActiveAlbum
{
    FASAlbum *album = [self.albums objectAtIndex:self.activeAlbumIndex];
    FASFileManager *fileManager = [FASFileManager sharedManager];
    [fileManager setAlbum:album.albumId];

    return album;
}

-(BOOL)saveAlbum
{
    FASFileManager *fileManager = [FASFileManager sharedManager];
    FASAlbum* album = [self getActiveAlbum];
    int i = 0;
    for (FASPhoto* photo in album.photos) {
        i++;
        if(photo.image == nil)
        {
            FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
            if(fb!=nil)
            {
                [fb getFullImage:photo];
                [fb updateProgress:[NSNumber numberWithFloat:((float)i*100/[album.photos count])]];
            }
        }
        [fileManager savePhoto:photo.graphId image:photo.image];
    }
    
    [fileManager archivePhotoData:self.albums];
    
    return YES;
}

#pragma mark UICollectionView

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FASAlbum* album = [self getActiveAlbum];
    FASPhoto* photo = [album.photos objectAtIndex:indexPath.row];
    
    if([album.photos count]-1 <= indexPath.row)
    {
        FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
        if(fb!=nil) [fb getNextPhotoList:NO];
    }
    
    
    FASPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];

    cell.thumbnail.image = photo.thumbnail;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    FASAlbum* album = [self getActiveAlbum];
    return [album.photos count];
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.albums count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    FASAlbum *a = (FASAlbum *)[self.albums objectAtIndex:indexPath.row];
    [cell textLabel].text = a.name;
    return cell;
}

@end
