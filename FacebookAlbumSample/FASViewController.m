//
//  FASViewController.m
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/08.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASViewController.h"
#import "FASDataManager.h"
#import "FASAlbum.h"
#import "FASFacebookConnection.h"

@interface FASViewController ()

@end

@implementation FASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    [fb setReloadTableTarget:self.albumListView];
    
    [self.albumListView setDelegate:self];
    [self.albumListView setDataSource:dataManager];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    
    self.loginView.delegate =self;
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"%@", error);
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@", user);
}

- (IBAction)getAlbumList:(id)sender {
    [[FASFacebookConnection sharedConnection] startFacebookConnection];
}


#pragma mark UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FASAlbumThumbnailView *thumbView = [sb instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
    [fb setReloadCollectionTarget:thumbView];
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    [dataManager setActiveAlbumIndex:indexPath.row];
    [fb getNextPhotoList:YES];
    
    [self.navigationController pushViewController:thumbView animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%lu <=> %lu", (long)indexPath.row, (unsigned long)[self.dataManager.albums count]);
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    if(indexPath.row+1 >= [dataManager.albums count])
    {
        if([[FASFacebookConnection sharedConnection] getNextAlbumPage])
            [self.albumListView reloadData];
    }
}

@end
