//
//  ViewController.h
//  YooPlayMac
//
//  Created by bejoy on 14/11/20.
//  Copyright (c) 2014年 zeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
{
    BOOL isStart;
    NSString *serverPath;
}


@property (weak) IBOutlet NSTextField *ipTextLabel;
@property (weak) IBOutlet NSTextField *serverPathTextLabel;
@property (weak) IBOutlet NSTextField *serverStatusLabel;

@property (weak) IBOutlet NSButton *controlButton;

- (IBAction)serverControl:(id)sender;
- (IBAction)openWebSite:(id)sender;
- (IBAction)openFilesFinder:(id)sender;
- (IBAction)setServerPath:(id)sender;



@end

