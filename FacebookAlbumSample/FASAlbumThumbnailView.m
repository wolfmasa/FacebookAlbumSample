//
//  FASAlbumThumbnailView.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/20.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASAlbumThumbnailView.h"
#import "FASPhotoViewController.h"
#import "FASFileManager.h"
#import "FASAlbum.h"
#import "FASDataManager.h"

@implementation FASAlbumThumbnailView

- (void)viewDidLoad
{
    [super viewDidLoad];
    FASDataManager *dataManager = [FASDataManager sharedManager];
    self.thumbnailCollection.delegate = dataManager;
    self.thumbnailCollection.dataSource = dataManager;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.thumbnailCollection reloadData];
    
    [self updateCacheStatus];
    self.progress.progress = 0;
}

-(void)updateCacheStatus
{
    FASDataManager *dataManager = [FASDataManager sharedManager];
    FASAlbum* album = [dataManager getActiveAlbum];
    [album updateCacheStatus];
    NSString *title;
    UIControlState state = UIControlStateDisabled;
    switch (album.cacheStatus) {
        case FASAlbumCacheStatusLoading:
            title =@"Loading...";
            break;
        case FASAlbumCacheStatusNotCached:
            title =@"Download Now";
            state = UIControlStateNormal;
            break;
        case FASAlbumCacheStatusCached:
            title =@"Cached";
            break;
        case FASAlbumCacheStatusDisConnection:
            title =@"Dis-Connection";
            break;
    }
    [self.saveButton setTitle:title forState:UIControlStateNormal];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"showPhoto"])
    {
        NSIndexPath *selectedIndexPath = [[self.thumbnailCollection indexPathsForSelectedItems] objectAtIndex:0];

        FASDataManager *dataManager = [FASDataManager sharedManager];
        [dataManager changeActivePhotoIndex:selectedIndexPath.row];
        
        FASPhotoViewController *photoView = [segue destinationViewController];
        photoView.photo = [dataManager getActivePhoto];
    }
}

- (IBAction)saveAlbum:(id)sender {
    FASDataManager *dataManager = [FASDataManager sharedManager];
    if([dataManager saveAlbum]==YES)
       [self updateCacheStatus];
}
@end
