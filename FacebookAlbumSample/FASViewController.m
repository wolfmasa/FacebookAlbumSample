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
    
    [self.getAlbumButton setImage:[UIImage imageNamed:@"stack-of-photos-blue.png"] forState:UIControlStateNormal];
    [self.getAlbumButton setImage:[UIImage imageNamed:@"stack-of-photos-gray.png"] forState:UIControlStateDisabled];
    
    self.loginView.delegate =self;
    
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    _userName.text = user[@"name"];
//    NSLog(@"%@", user[@"name"]);
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    [self.getAlbumButton setEnabled:YES];
    NSLog(@"%@", @"login");

}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self.getAlbumButton setEnabled:NO];
    NSLog(@"%@", @"logout!");
    _userName.text = @"ログインしてください";

}


- (IBAction)changeConnection:(id)sender {
    [FASFacebookConnection changeConnectStatus:[self.isConnection isOn]];
}
- (IBAction)clearCache:(id)sender {
    
    FASDataManager *dataManager = [FASDataManager sharedManager];
    [dataManager clearAllAlbum];
}
@end
