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
    self.dataManager.albums = [NSMutableArray new];
    
    self.fb = [[FASFacebookConnection alloc]initWithDataManager:self.dataManager];
    [self.fb setReloadTarget:self.albumListView];
    
    [self.albumListView setDelegate:self];
    [self.albumListView setDataSource:self];
    
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
    [self.fb startFacebookConnection];
}


#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataManager.albums count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [UITableViewCell new];
    FASAlbum *a = (FASAlbum *)[self.dataManager.albums objectAtIndex:indexPath.row];
    [newCell textLabel].text = a.name;
    return newCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FASAlbumThumbnailView *thumbView = [sb instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
    thumbView.delegateTemp = self.dataManager;
    
    [self.navigationController pushViewController:thumbView animated:YES];
}

#pragma mark Button

- (IBAction)pushNext:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    FASAlbumThumbnailView *thumbView = [sb instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
    thumbView.delegateTemp = self.dataManager;
    //[thumbView.thumbnailCollection setDelegate:self.dataManager];
    //[thumbView.thumbnailCollection setDataSource:self.dataManager];
    
    [self.navigationController pushViewController:thumbView animated:YES];
}
@end
