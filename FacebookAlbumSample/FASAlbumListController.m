//
//  FASAlbumListController.m
//  FacebookAlbumSample
//
//  Created by ICP223G on 2014/04/17.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import "FASAlbumListController.h"
#import "FASFacebookConnection.h"
#import "FASDataManager.h"

@interface FASAlbumListController ()

@end

@implementation FASAlbumListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    
    FASFacebookConnection *fb = [FASFacebookConnection sharedConnection];
    if(fb!=nil)
    {
        [fb setReloadTableTarget:self.tableView];
        [fb initConnection];
        [fb getFirstAlbumList];
    }
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:dataManager];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if(fb!=nil && [fb getNextAlbumPage]) [self.tableView reloadData];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
