//
//  Ascript.h
//  Proxie
//
//  Created by Lucas casteletti on 3/20/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//

//ALL PARAMTERS PASED ARE On/Off
//RECEIVED YES/NO

#import <Foundation/Foundation.h>
#import "CProxy.h"

@interface Ascript : NSObject

#pragma mark -
#pragma mark Interface List Method Declaration
+ (NSMutableArray *)getInterfaceList;
#pragma mark -
#pragma mark Auto Proxy Discovery Declaration
+ (NSString *)getProxyAutoDiscoveryForInterface:(NSString *)networkservice;
+ (void)setProxyAutoDiscovery:(NSString *)state ForInterface:(NSString *)networkservice;
#pragma mark -
#pragma mark Web Proxy (HTTP) Declaration
+ (NSString *)getWebProxyStateForInterface:(NSString *)networkservice;
+ (CProxy *)getWebProxyForInterface:(NSString *)networkservice;
+ (void)setWebProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice;
+ (void)setWebProxyState:(NSString *)state ForInterface:(NSString *)networkservice;
#pragma mark -
#pragma mark Secure Web Proxy (HTTPS) Declaration
+(NSString *)getSecureWebProxyStateForInterface:(NSString *)networkservice;
+ (CProxy *)getSecureWebProxyForInterface:(NSString *)networkservice;
+ (void)setSecureWebProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice;
+ (void)setSecureWebProxyState:(NSString *)state ForInterface:(NSString *)networkservice;
#pragma mark -
#pragma mark FTP Declaration
+ (NSString *)getFTPProxyStateForInterface:(NSString *)networkservice;
+ (CProxy *)getFTPProxyForInterface:(NSString *)networkservice;
+ (void)setFTPProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice;
+ (void)setFTPProxyState:(NSString *)state ForInterface:(NSString *)networkservice;
#pragma mark -
#pragma mark Gopher Declaration
+ (NSString *)getGopherProxyStateForInterface:(NSString *)networkservice;
+ (CProxy *)getGopherProxyForInterface:(NSString *)networkservice;
+ (void)setGopherProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice;
+ (void)setGopherProxyState:(NSString *)state ForInterface:(NSString *)networkservice;

@end