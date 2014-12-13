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


#define KServerPath @"serverPath"

@implementation ViewController

- (void)getIP {
    [IPDetector getLANIPAddressWithCompletion:^(NSString *IPAddress) {
        NSLog(@"%@", IPAddress);
        self.ipTextLabel.stringValue = IPAddress;

        
        //    生产索引目录
        //    index.html
        //    allfile.json
        //    allfile.html
        [self buildPathFile];
    }];
    
}

- (void)setSerVerPath {
    
    [self stopServer];
    
    
    self.serverPathTextLabel.stringValue = serverPath;
    NSString *webPath = serverPath;
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
    
    pathString = [NSHomeDirectory() stringByAppendingPathComponent:@"Yoo同步盘"];
    
    NSLog(@"%@", pathString);
    serverPath = pathString;
    
    [[NSUserDefaults standardUserDefaults] setObject:serverPath forKey:KServerPath];
    
    
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:serverPath];
    
    

    NSError *error;
    bool isSuccess =  [filemgr createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    
    if ( ! isSuccess) {
        NSLog(@"创建同步盘文件夹错误");
    }
    

}

- (void)buildPathFile {
    
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
    NSString *indexHtml = [NSString stringWithFormat:@"%@/index.html", serverPath];
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
    
//    生成 index.html 文件
    

    htmlString = nil;
    htmlString = [NSMutableString string];
    
    [htmlString appendFormat:@"<html>"];
    [htmlString appendFormat:@"<head>"];
    [htmlString appendFormat:@"<meta charset=\"utf-8\">"];
    [htmlString appendFormat:@"<title>Yoo的同步盘~</title>"];
    [htmlString appendFormat:@"</head>"];
    [htmlString appendFormat:@"<body>"];
    
    [htmlString appendFormat:@"<h1> %@</h1><br />", @"启动成功"];
    [htmlString appendFormat:@"<a href=\"/allFile.html\"> %@</a><br />", @"查看所有文件"];

    
    [htmlString appendFormat:@"</body>"];
    [htmlString appendFormat:@"</html>"];

    
    
    
    [htmlString writeToFile:indexHtml atomically:YES encoding:NSUTF8StringEncoding error:nil];

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

- (IBAction)setServerPath:(id)sender {
    

    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:FALSE];
    [openDlg setCanChooseDirectories:TRUE];
    [openDlg setAllowsMultipleSelection:FALSE];
    [openDlg setAllowsOtherFileTypes:FALSE];
    
    if ([openDlg runModal] == NSOKButton)
    {
        
        
        NSString* fileNameOpened = [[[openDlg URLs] objectAtIndex:0] path];
        [self.serverPathTextLabel setStringValue:fileNameOpened];
        
        serverPath = fileNameOpened;
        [[NSUserDefaults standardUserDefaults] setObject:serverPath forKey:KServerPath];

        [self reSetServerSetting];
        
        
    }
}



- (void)reSetServerSetting {
    
    
    //  设置服务器的 根目录
    [self setSerVerPath];
    
//    生成目录文件
    [self buildPathFile];
    
    //    启动服务
    [self startServer];
    
}

- (void)loadView {
    [super loadView];
    
//    生成用户目录
    
    serverPath = [[NSUserDefaults standardUserDefaults] objectForKey:KServerPath];

    if ( ! serverPath   ) {
        [self buildPath];
    }


//    获取本地ip
    [self getIP];
    


    [self reSetServerSetting];

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
