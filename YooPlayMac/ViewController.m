//
//  ViewController.m
//  YooPlayMac
//
//  Created by bejoy on 14/11/20.
//  Copyright (c) 2014年 zeng. All rights reserved.
//

#import "ViewController.h"
#import "IPDetector.h"
#import "DemoHTTPStreamingServer.h"


@implementation ViewController



- (void)getIP {
    [IPDetector getLANIPAddressWithCompletion:^(NSString *IPAddress) {
        NSLog(@"%@", IPAddress);
        self.ipTextLabel.stringValue = IPAddress;

        
        //    生产索引目录
        //    index.html
        //    allfile.json
        //    allfile.html
        [self buildPath];
    }];
    
}

- (void)setSerVerPath {
    self.serverPathTextLabel.stringValue = @"/Users/zenghui/百度云同步盘";
    serverPath = self.serverPathTextLabel.stringValue;
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
    
    webPath = serverPath;
    [[DemoHTTPStreamingServer sharedInstance] setDocumentRoot:webPath];
}

- (void)startServer {
    isStart = YES;
    self.serverStatusLabel.stringValue = @"正在运行...";
    self.serverStatusLabel.textColor = [NSColor greenColor];
    
    [[DemoHTTPStreamingServer sharedInstance] start];
    
    [self.controlButton setTitle: @"停止服务"];

}

- (void)stopServer {
    
    isStart = NO;
    self.serverStatusLabel.stringValue = @"已停止";
    self.serverStatusLabel.textColor = [NSColor redColor];
    [[DemoHTTPStreamingServer sharedInstance] stop];

    
    [self.controlButton setTitle: @"开始服务"];
}




- (void)buildPath {
    
    NSFileManager *filemgr;
    NSString *pathString;
    
    filemgr = [NSFileManager defaultManager];
    
    pathString = serverPath;
    
    NSDirectoryEnumerator *direnum = [filemgr enumeratorAtPath:pathString];

    
    
    NSMutableArray *files = [NSMutableArray arrayWithCapacity:42];
//    数据字典
    NSMutableDictionary *htmlDicts = [NSMutableDictionary dictionary];
    
    NSString *filename ;
    while (filename = [direnum nextObject]) {
        if ( ![[filename substringToIndex:1] isEqualToString:@"."] && ![[filename pathExtension] isEqualTo:@""]
            && ![[filename pathExtension] isEqualTo:@"jpg"]) { //[[filename pathExtension] isEqualTo:@"jpg"]
            
            [files addObject: filename];
//            文件名
            NSString* theFileName = [filename lastPathComponent];
//            网络地址
            [htmlDicts setValue:filename forKey:theFileName];
            
        }
    }
    
//    NSEnumerator *fileenum;
//    fileenum = [files objectEnumerator];
//    
//    while (filename = [fileenum nextObject]) {
//        NSLog(@"%@", filename);
//    }
    
//    保存html
    NSString *allFileHtml = [NSString stringWithFormat:@"%@/allFile.html", serverPath];
    NSString *allFilePlist = [NSString stringWithFormat:@"%@/allFile.plist", serverPath];

    NSMutableString *htmlString = [NSMutableString string];
    
    [htmlString appendFormat:@"<html>"];
    [htmlString appendFormat:@"<head>"];
    [htmlString appendFormat:@"<meta charset=\"utf-8\">"];
    [htmlString appendFormat:@"<title>所有文件</title>"];
    [htmlString appendFormat:@"</head>"];
    [htmlString appendFormat:@"<body>"];
    [htmlDicts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [htmlString appendFormat:@"<a href=\"/%@\"> %@</a><br />", obj, key];
    }];
    [htmlString appendFormat:@"</body>"];
    [htmlString appendFormat:@"</html>"];
    
    
    [htmlString writeToFile:allFileHtml atomically:YES encoding:NSUTF8StringEncoding error:nil];
    

//    保存 plist
    
    [files writeToFile:allFilePlist atomically:YES];
    
}



- (IBAction)serverControl:(id)sender {
    
    
    if ( isStart ) {
        [self stopServer];
    }
    else
        [self startServer];
    
    
}

- (IBAction)openWebSite:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:1314", self.ipTextLabel.stringValue];
    NSURL *url = [NSURL URLWithString:urlString];
    if( ![[NSWorkspace sharedWorkspace] openURL:url] )
        NSLog(@"Failed to open url: %@",[url description]);
    
    
    
}

- (IBAction)openFilesFinder:(id)sender {
    
    [[NSWorkspace sharedWorkspace] selectFile:serverPath inFileViewerRootedAtPath:nil];
    
    
}


- (void)loadView {
    [super loadView];

//    获取本地ip
    [self getIP];
    
//  设置服务器的 根目录
    [self setSerVerPath];

    
//    启动服务
    [self startServer];



}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
