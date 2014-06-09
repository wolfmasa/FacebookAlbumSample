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
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Loading", nil)];
    [self.saveButton setTitle:title forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.thumbnailCollection reloadData];
    
    [self updateCacheStatus];
    self.progress.progress = 0;
}

-(FASAlbumCacheStatus)getCacheStatus
{
    FASDataManager *dataManager = [FASDataManager sharedManager];
    FASAlbum* album = [dataManager getActiveAlbum];
    [album updateCacheStatus];
    return album.cacheStatus;
}

-(void)updateCacheStatus
{
    FASAlbumCacheStatus status = [self getCacheStatus];
    NSString *title;
    UIControlState state = UIControlStateDisabled;
    switch (status) {
        case FASAlbumCacheStatusLoading:
            title =[NSString stringWithFormat:NSLocalizedString(@"Loading", nil)];
            break;
        case FASAlbumCacheStatusNotCached:
//            title =@"Download Now";
            title = [NSString stringWithFormat:NSLocalizedString(@"Download", nil)];
            state = UIControlStateNormal;
            break;
        case FASAlbumCacheStatusCached:
            title =[NSString stringWithFormat:NSLocalizedString(@"Cached", nil)];
            break;
        case FASAlbumCacheStatusDisConnection:
            title =[NSString stringWithFormat:NSLocalizedString(@"DisConnect", nil)];
            break;
    }
    [self.saveButton setTitle:title forState:UIControlStateNormal];

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"showPhoto"])
    {
        NSIndexPath *selectedIndexPath = [[self.thumbnailCollection indexPathsForSelectedItems] objectAtIndex:0];
        
        FASDataManager *dataManager = [FASDataManager sharedManager];
        [dataManager changeActivePhotoIndex:selectedIndexPath.row];
        
        if([dataManager getActivePhoto].image != nil) return YES;
    }
    return NO;
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
    if([self getCacheStatus] != FASAlbumCacheStatusNotCached) return ;
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    if([dataManager saveAlbum]==YES)
       [self updateCacheStatus];
}
@end
