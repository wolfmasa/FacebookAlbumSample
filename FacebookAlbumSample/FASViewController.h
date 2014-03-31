//
//  FASViewController.h
//  FacebookAlbumSample
//
//  Created by 上原 将司 on 2014/02/08.
//  Copyright (c) 2014年 Project Wolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FASAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FASDataManager.h"
#import "FASAlbum.h"
#import "FASFacebookConnection.h"

@interface FASViewController : UIViewController<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *albumGetButton;
- (IBAction)getAlbumList:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *albumListView;

@property(retain, nonatomic) FASDataManager *dataManager;
@property(retain, nonatomic) FASFacebookConnection *fb;

//for debug
- (IBAction)pushNext:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pic;

@end
