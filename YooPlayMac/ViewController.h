//
//  ViewController.h
//  YooPlayMac
//
//  Created by bejoy on 14/11/20.
//  Copyright (c) 2014年 zeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DirectoryWatcher.h"



@interface ViewController : NSViewController <DirectoryWatcherDelegate>
{
    BOOL isStart;
    NSString *serverPath;
    
    BOOL isChangeIndex;
}



@property (nonatomic, strong) DirectoryWatcher *docWatcher;



@property (weak) IBOutlet NSTextField *ipSubTextLabel;

@property (weak) IBOutlet NSTextField *ipTextLabel;
@property (weak) IBOutlet NSTextField *serverPathTextLabel;
@property (weak) IBOutlet NSTextField *serverStatusLabel;

@property (weak) IBOutlet NSButton *controlButton;

//handoff

- (IBAction)serverControl:(id)sender;
- (IBAction)openWebSite:(id)sender;
- (IBAction)openFilesFinder:(id)sender;



@end

