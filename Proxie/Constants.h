//
//  Proxie
//
//  Created by Lucas casteletti on 3/18/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//
//  someRandom Constants
//

//Dictionary Key
#define addressKey  @"address"
#define typeKey     @"type"
#define enabledKey  @"enabled"
#define portKey     @"port"
#define authKey     @"authenticated"
#define loginKey    @"login"
#define passwordKey @"password"

//Type Keys
#define httpKey     @"HTTP"
#define httpsKey    @"HTTPS"
#define socksKey    @"Socks"
#define ftpKey      @"FTP"
#define ghopherKey  @"Gopher"

//State
#define CPOnState     @"On"  //@"Yes"
#define CPOffState    @"Off" //@"No"

//UserDefaults
#define removeAlertSuppressKey  @"RemoveAlertSuppress"

//URL
#define githubURL               @"http://www.github.com/ilucas"
#define LaunchPathDir           @"/usr/sbin/networksetup"

//Bundle version
#define CFBundleVersion [[[NSBundle bundleWithIdentifier: @"com.ilucas.Proxie"] infoDictionary] \
valueForKey:@"CFBundleVersion"]
#define CFBundleShortVersionString [[[NSBundle bundleWithIdentifier: @"com.ilucas.Proxie"] infoDictionary] \
valueForKey:@"CFBundleShortVersionString"]