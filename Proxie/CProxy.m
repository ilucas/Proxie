//
//  CProxy.m
//  Proxie
//
//  Created by Lucas casteletti on 3/20/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//
//  github.com/ilucas/Proxie
//  

#import "CProxy.h"

@implementation CProxy
@synthesize enabled;
@synthesize type;
@synthesize address;
@synthesize port;
@synthesize auth;
@synthesize login;
@synthesize pass;

- (id)init
{
    self = [super init];
    if (self) {
        enabled = [[NSString alloc] initWithString:CPOffState];
        type    = [[NSString alloc] init];
        address = [[NSString alloc] init];
        port    = [[NSString alloc] init];
        auth    = [[NSString alloc] init];
        login   = [[NSString alloc] init];
        pass    = [[NSString alloc] init];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        enabled = [dict objectForKey:enabledKey];
        type    = [dict objectForKey:typeKey];
        address = [dict objectForKey:addressKey];
        port    = [dict objectForKey:portKey];
        auth    = [dict objectForKey:authKey];
        login   = [dict objectForKey:loginKey];
        pass    = [dict objectForKey:passwordKey];
    }
    return self;
}

- (BOOL)getAuthAsBool{//convertToBOOL
    //Convert On/Off String to BOOL
    NSString *string = [[[NSString alloc] initWithString:[self auth]] autorelease];
    string = [string stringByReplacingOccurrencesOfString:CPOnState withString:@"YES"];
    string = [string stringByReplacingOccurrencesOfString:CPOffState withString:@"NO"];
    return [string boolValue];
}

- (BOOL)Enabool{
    //Convert On/Off String to BOOL
    NSString *string = [[[NSString alloc] initWithString:[self enabled]] autorelease];
    string = [string stringByReplacingOccurrencesOfString:CPOnState withString:@"YES"];
    string = [string stringByReplacingOccurrencesOfString:CPOffState withString:@"NO"];
    return [string boolValue];
}

- (void)setEnabool:(BOOL)value{
    enabled = value ? CPOnState : CPOffState;
}


- (NSDictionary *)Dictionary{
    NSDictionary *dict;
    if ([self getAuthAsBool]) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                address,addressKey,
                port,portKey,
                type,typeKey,
                enabled,enabledKey,
                auth,authKey,
                login,loginKey,
                pass,passwordKey,
                nil];
    }else {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                address,addressKey,
                port,portKey,
                type,typeKey,
                enabled,enabledKey,
                auth,authKey,
                nil];
    }
    return dict;
}

- (void)dealloc{
    [enabled release];
    [type release];
    [address release];
    [port release];
    [login release];
    [pass release];
    [super dealloc];
}

@end