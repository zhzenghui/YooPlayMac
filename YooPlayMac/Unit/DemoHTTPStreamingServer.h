//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServer.h"


@interface DemoHTTPStreamingServer : NSObject

@property (nonatomic, strong) HTTPServer *httpServer;

+ (instancetype)sharedInstance;

- (void)setDocumentRoot:(NSString *)webPath;

- (void)start;
- (void)stop;

@end
