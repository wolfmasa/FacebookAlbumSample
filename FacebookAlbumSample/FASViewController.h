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

@interface FASViewController : UIViewController<UITableViewDelegate, FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

- (void)getAlbumList;

@property (weak, nonatomic) IBOutlet UISwitch *isConnection;
- (IBAction)changeConnection:(id)sender;

@end
