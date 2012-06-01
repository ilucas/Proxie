//
//  fileManager.h
//  Proxie
//
//  Created by Lucas casteletti on 5/16/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//

#import <Foundation/Foundation.h>

@interface fileManager : NSObject
+ (NSMutableArray *)loadFile;
+ (void)saveFile:(NSArray *)objects;
+ (NSArray *)importFile;
+ (void)exportFile;//copy user xml
@end