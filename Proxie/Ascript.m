
#import "Ascript.h"

@interface Ascript ()
+ (NSString *)runTaskWithArguments:(NSArray *)arguments;
+ (NSString *)parseState:(NSString *)chunks;
+ (CProxy *)parseCProxy:(NSString *)chunks ofType:(NSString *)type;
@end

@implementation Ascript

#pragma mark -
#pragma mark Runnner

+ (NSString *)runTaskWithArguments:(NSArray *)arguments{
    NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    NSData *data;
    [task setLaunchPath: LaunchPathDir];
    [task setStandardOutput: pipe];
    [task setArguments: arguments];
    [task launch];
    [task release];

    data = [file readDataToEndOfFile];
    
    NSString *string = [[[NSString alloc] initWithData: data
                                              encoding: NSUTF8StringEncoding] autorelease];
    
    //NSLog (@"\n%@", string);
    return string;
}   

#pragma mark Parser

+ (NSString *)parseState:(NSString *)chunks{
    NSString *line; //get the first line. only one needed in this case
    [[NSScanner scannerWithString:chunks] scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString: &line];
    NSArray *array = [line componentsSeparatedByString:@":"];
    NSString *string = [[[array objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    string = [string stringByReplacingOccurrencesOfString:@"yes" withString:CPOnState];
    string = [string stringByReplacingOccurrencesOfString:@"no" withString:CPOffState];
    return string;
}

+ (CProxy *)parseCProxy:(NSString *)chunks ofType:(NSString *)type{
    CProxy *proxy = [[[CProxy alloc] init] autorelease];
    NSString *line = [[NSString alloc] init];
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    NSScanner *scanner = [NSScanner scannerWithString:chunks];
    while ([scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]  intoString: &line]) {
        //NSLog(@"%@",line);
        [array addObject:[[[NSArray arrayWithArray:[line componentsSeparatedByString:@":"]] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    
    NSString *string = [[array objectAtIndex:0] lowercaseString];
    string = [string stringByReplacingOccurrencesOfString:@"yes" withString:CPOnState];
    string = [string stringByReplacingOccurrencesOfString:@"no" withString:CPOffState];
    
    [proxy setEnabled:string];
    [proxy setAddress:[array objectAtIndex:1]];
    [proxy setPort:[array objectAtIndex:2]];
    [proxy setAuth:[array objectAtIndex:3]];
    [proxy setType:type];
    return proxy;
}

#pragma mark -

+ (NSMutableArray *)getInterfaceList{
    //Return only Enabled: status
    NSMutableArray *interfaceList = [[[NSMutableArray alloc] init] autorelease];
    NSString *line;
    NSScanner *scanner = [NSScanner scannerWithString:[self runTaskWithArguments:[NSArray arrayWithObjects:@"-listallnetworkservices", nil]]];
    while ([scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]  intoString: &line]) {
        //NSLog(@"%@",line);
        [interfaceList addObject:line];
    }
    return interfaceList;
}

#pragma mark -
#pragma mark Auto Discovery Method

+ (NSString *)getProxyAutoDiscoveryForInterface:(NSString *)networkservice{
    //Usage: networksetup -getproxyautodiscovery <networkservice>
    NSArray *array = [[self runTaskWithArguments:
                       [NSArray arrayWithObjects:@"-getproxyautodiscovery",networkservice, nil]]
                      componentsSeparatedByString: @":"];
    return [[array objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (void)setProxyAutoDiscovery:(NSString *)state ForInterface:(NSString *)networkservice{
    //Usage: networksetup -setproxyautodiscovery <networkservice> <on off>
    [self runTaskWithArguments:[NSArray arrayWithObjects:@"-setproxyautodiscovery", networkservice, state, nil]];
}

#pragma mark Web Proxy Methods

+ (NSString *)getWebProxyStateForInterface:(NSString *)networkservice{
    //Usage: networksetup -getwebproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getwebproxy",networkservice, nil]];
    return [self parseState:string];
}

+ (CProxy *)getWebProxyForInterface:(NSString *)networkservice{
    //Usage: networksetup -getwebproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getwebproxy",networkservice, nil]];
    return [self parseCProxy:string ofType:httpKey];
}

+ (void)setWebProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice{
    //Usage: networksetup -setwebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>    
    if ([proxy getAuthAsBool]){
        [self runTaskWithArguments:[NSArray arrayWithObjects:@"-setwebproxy",
                                    networkservice,
                                    proxy.address,
                                    proxy.port,
                                    proxy.auth,
                                    proxy.login,
                                    proxy.pass,
                                    nil]];
    }else{
        [self runTaskWithArguments:[NSArray arrayWithObjects:@"-setwebproxy",
                                    networkservice,
                                    proxy.address,
                                    proxy.port,
                                    proxy.auth,
                                    nil]];
    }
}

+ (void)setWebProxyState:(NSString *)state ForInterface:(NSString *)networkservice{
    //Usage: networksetup -setwebproxystate <networkservice> <on off>
    [self runTaskWithArguments:[NSArray arrayWithObjects:@"-setwebproxystate", networkservice, state, nil]];
}

#pragma mark Secure Web Proxy Methods

+ (NSString *)getSecureWebProxyStateForInterface:(NSString *)networkservice{
    //Usage: networksetup -getsecurewebproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getsecurewebproxy",networkservice, nil]];
    return [self parseState:string];
}

+ (CProxy *)getSecureWebProxyForInterface:(NSString *)networkservice{
    //Usage: networksetup -getsecurewebproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getsecurewebproxy",networkservice, nil]];
    return [self parseCProxy:string ofType:httpsKey];
}

+ (void)setSecureWebProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice{
    //Usage: networksetup -setsecurewebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
    if ([proxy getAuthAsBool]){
        [self runTaskWithArguments:[NSArray arrayWithObjects:@"-setsecurewebproxy",
                                    networkservice,
                                    proxy.address,
                                    proxy.port,
                                    proxy.auth,
                                    proxy.login,
                                    proxy.pass,
                                    nil]];
    }else{
        [self runTaskWithArguments:[NSArray arrayWithObjects:@"-setsecurewebproxy",
                                    networkservice,
                                    proxy.address,
                                    proxy.port,
                                    proxy.auth,
                                    nil]];
    }
}

+ (void)setSecureWebProxyState:(NSString *)state ForInterface:(NSString *)networkservice{
    //Usage: networksetup -setsecurewebproxystate <networkservice> <on off>
    [self runTaskWithArguments:[NSArray arrayWithObjects:@"-setsecurewebproxystate", networkservice, state, nil]];
}

#pragma mark FTP Methods

+ (NSString *)getFTPProxyStateForInterface:(NSString *)networkservice{
    //Usage: networksetup -getftpproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getftpproxy",networkservice, nil]];
    return [self parseState:string];
}

+ (CProxy *)getFTPProxyForInterface:(NSString *)networkservice{
    //Usage: networksetup -getftpproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getftpproxy",networkservice, nil]];
    return [self parseCProxy:string ofType:ftpKey];
}

+ (void)setFTPProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice{
    
}

+ (void)setFTPProxyState:(NSString *)state ForInterface:(NSString *)networkservice{
    
}

#pragma mark Gopher Methods

+ (NSString *)getGopherProxyStateForInterface:(NSString *)networkservice{
    //Usage: networksetup -getgopherproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getgopherproxy",networkservice, nil]];
    return [self parseState:string];
}

+ (CProxy *)getGopherProxyForInterface:(NSString *)networkservice{ 
    //Usage: networksetup -getgopherproxy <networkservice>
    NSString *string = [self runTaskWithArguments:[NSArray arrayWithObjects:@"-getgopherproxy",networkservice, nil]];
    return [self parseCProxy:string ofType:ghopherKey];
}

+ (void)setGopherProxy:(CProxy *)proxy ForInterface:(NSString *)networkservice{
    
}

+ (void)setGopherProxyState:(NSString *)state ForInterface:(NSString *)networkservice{
    
}

@end