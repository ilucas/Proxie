//
//  CProxy.h
//  Proxie
//
//  Created by Lucas casteletti on 3/20/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//

#import <Foundation/Foundation.h>

@interface CProxy : NSObject{
@private
    NSString *enabled;
    NSString *type;
    NSString *address;
    NSString *port;
    NSString *auth;
    NSString *login;
    NSString *pass;
}

@property (copy) NSString *enabled;
@property (copy) NSString *type;
@property (copy) NSString *address;
@property (copy) NSString *port;
@property (copy) NSString *login;
@property (copy) NSString *pass;
@property (copy) NSString *auth;
@property (nonatomic, assign) BOOL Enabool;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)Dictionary;
- (BOOL)getAuthAsBool;

@end