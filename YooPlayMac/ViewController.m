//
//  ViewController.m
//  YooPlayMac
//
//  Created by bejoy on 14/11/20.
//  Copyright (c) 2014年 zeng. All rights reserved.
//

#import "ViewController.h"
#import "IPDetector.h"

@implementation ViewController



- (void)getIP {
    [IPDetector getLANIPAddressWithCompletion:^(NSString *IPAddress) {
        
        NSLog(@"%@", IPAddress);
        self.ipTextLabel.stringValue = IPAddress;
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];


    



}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
