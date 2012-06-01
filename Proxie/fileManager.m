//
//  fileManager.m
//  Proxie
//
//  Created by Lucas casteletti on 5/16/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  

#import "fileManager.h"

@interface fileManager ()
+ (NSString *)filePath;
@end

@implementation fileManager

+ (NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *Path = ([paths count] > 0) ? [paths objectAtIndex:0] :NSTemporaryDirectory();
    Path = [Path stringByAppendingPathComponent:@"Proxie"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Create the folder if needed
    if (![fileManager fileExistsAtPath:Path isDirectory:NULL]) {
        [fileManager createDirectoryAtPath:Path withIntermediateDirectories:NO attributes:nil error:nil];
        NSLog(@"\"%@\" Folder Created",Path);
    }
    NSString *file = [Path stringByAppendingPathComponent:@"ProxieList.plist"];
    //Create blank file if needed
    if (![fileManager fileExistsAtPath:file isDirectory:NO]) {
        [[NSDictionary dictionary] writeToFile:file atomically:NO];
        NSLog(@"\"%@\" File Created",file);
    }
    return [[NSBundle bundleWithPath:Path] pathForResource:@"ProxieList" ofType:@"plist"];
}

+ (NSMutableArray *)loadFile{
    return [NSMutableArray arrayWithContentsOfFile:[self filePath]];
}

+ (void)saveFile:(NSArray *)objects{
    [objects writeToFile:[self filePath] atomically:YES];
}

+ (NSArray *)importFile{
    return nil;
}

+ (void)exportFile{//copy user xml

}

@end