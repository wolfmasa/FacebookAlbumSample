//
//  FASViewController.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/08.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASViewController.h"

@interface FASViewController ()

@end

@implementation FASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dataManager = [FASDataManager new];
    
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    fb = [fb initWithDataManager:self.dataManager];
    [fb setReloadTableTarget:self.albumListView];
    
    [self.albumListView setDelegate:self];
    [self.albumListView setDataSource:self.dataManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    return YES;
}

- (IBAction)getAlbumList:(id)sender {
    [[FASFacebookConnection sharedConnection] startFacebookConnection];
}


#pragma mark UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FASAlbumThumbnailView *thumbView = [sb instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
    [fb setReloadCollectionTarget:thumbView];
    
    [self.dataManager setActiveAlbumIndex:indexPath.row];
    [fb getNextPhotoList:YES];
    
    thumbView.dataManager = self.dataManager;
    
    [self.navigationController pushViewController:thumbView animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d <=> %d", indexPath.row, [self.dataManager.albums count]);
    if(indexPath.row+1 >= [self.dataManager.albums count])
    {
        if([[FASFacebookConnection sharedConnection] getNextAlbumPage])
            [self.albumListView reloadData];
    }
}

#pragma mark Button

- (IBAction)pushNext:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FASAlbumThumbnailView *thumbView = [sb instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
    thumbView.dataManager = self.dataManager;
    
    [self.navigationController pushViewController:thumbView animated:YES];
}
@end
