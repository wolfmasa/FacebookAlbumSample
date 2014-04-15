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
    if(fb!=nil) [fb setReloadTableTarget:self.albumListView];
    
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
    

    [self getAlbumList];
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

- (void)getAlbumList
{
    FASFacebookConnection *fb =[FASFacebookConnection sharedConnection];
    if(fb!=nil) [fb startFacebookConnection];
}


#pragma mark UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FASAlbumThumbnailView *thumbView = [sb instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
    if(fb!=nil) [fb setReloadCollectionTarget:thumbView];
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    [dataManager setActiveAlbumIndex:indexPath.row];
    if(fb!=nil) [fb getNextPhotoList:YES];
    
    [self.navigationController pushViewController:thumbView animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    NSLog(@"%lu <=> %lu", (long)indexPath.row, (unsigned long)[dataManager.albums count]);
    if(indexPath.row+2 >= [dataManager.albums count])
    {
        FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
        if(fb!=nil && [fb getNextAlbumPage]) [self.albumListView reloadData];
    }
}

- (IBAction)changeConnection:(id)sender {
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    if(fb!=nil) fb.connectStatus = [self.isConnection isOn];
}
@end
