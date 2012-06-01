//
//  Proxie
//
//  Created by Lucas casteletti on 3/18/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//

#import "Proxie.h"
#import "Ascript.h"
#import "fileManager.h"

@interface ProxieOwner ()
- (IBAction)doubleClick:(id)sender;//TableView Double click Action
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
@end

@implementation ProxieOwner

#pragma mark -
#pragma mark Init

- (id)init {
    self = [super init];
    if (self) {
        array = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)awakeFromNib{
    actualProxy = [[CProxy alloc] init];
    expanded = true;
    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(doubleClick:)];
    [self loadFiletoTableView];
    //Load the Network Interface menu
    [interfacebutton removeAllItems];
    [interfacebutton addItemsWithTitles:[Ascript getInterfaceList]];
    [interfacebutton removeItemAtIndex:0];//Remove "An asterisk (*) denotes that a network service is disabled." 
}

- (void)mainViewDidLoad{ 
    [self refresh:self];
    [self tableViewSelectionDidChange:nil];
    
    //Hide FTP Ghoper Socks (not implemented yet)
    [[poptrocol itemAtIndex:1] setHidden:true];
    [[poptrocol itemAtIndex:2] setHidden:true];
    [[poptrocol itemAtIndex:3] setHidden:true];
}

#pragma mark -
#pragma mark Main Window Action

-(IBAction)bttadd:(id)sender{
    [poptrocol selectItemAtIndex:0];
    [chksecure setState:0];
    [chkpassrequire setState:0];
    [txtusername setEnabled:false];
    [txtpass setEnabled:false];
    [txtaddress setStringValue:@""];
    [txtport setIntValue:3128];
    [txtusername setStringValue:@""];
    [txtpass setStringValue:@""];
    [lbladdress setTextColor:[NSColor blackColor]];
    [lblpass setTextColor:[NSColor blackColor]];
    [lblport setTextColor:[NSColor blackColor]];
    [lblusername setTextColor:[NSColor blackColor]];
    [txtaddress becomeFirstResponder];
    
    if (!expanded) {
        expanded = true;
        [self Resize:true];
    }
    
    [NSApp beginSheet:self->addSheet
       modalForWindow:[NSApp mainWindow]
        modalDelegate:self
       didEndSelector:NULL
          contextInfo:NULL];
}

-(IBAction)bttremove:(id)sender{
    NSInteger row = [tableView selectedRow];
    if (row != -1){
        if (![[NSUserDefaults standardUserDefaults] boolForKey:removeAlertSuppressKey]){
            NSAlert *alert = [[NSAlert alertWithMessageText:@"Comfirm Item Remove"
                                              defaultButton:@"Remove"
                                            alternateButton:@"Cancel"
                                                otherButton:nil
                                  informativeTextWithFormat:[NSString stringWithFormat:@"Are you sure you want to remove: \n%@",[[array objectAtIndex:row] objectForKey:addressKey]]] autorelease];
            [alert setAlertStyle:NSWarningAlertStyle];//Don't work in PrefPane
            [alert setShowsSuppressionButton:true];
            [alert beginSheetModalForWindow:[NSApp mainWindow]
                              modalDelegate:self
                             didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                                contextInfo:nil];
        }
    }
}

- (IBAction)bttmenu:(NSPopUpButton *)sender {//use tag
    NSString *title = [sender titleOfSelectedItem];
    
    if ([title isEqualToString:@"Import"]) {
        //NSLog(@"imp");
    }else if ([title isEqualToString:@"Export"]) {
        //NSLog(@"exp");
    }else if ([title isEqualToString:@"Download"]) {
        //not implemented yet
    }
}

-(void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
	if(returnCode == NSAlertDefaultReturn){
        [array removeObjectAtIndex:[tableView selectedRow]];
        [tableView reloadData];
	}
    if ([[alert suppressionButton] state] == NSOnState)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:removeAlertSuppressKey];
}

-(void)bttapply:(id)sender{
    NSString *SelectedInterface = [interfacebutton titleOfSelectedItem];
    CProxy *proxy = [[CProxy alloc] initWithDictionary:[array objectAtIndex:[tableView selectedRow]]];
    
    [Ascript setWebProxy:proxy ForInterface:SelectedInterface];
    [Ascript setWebProxyState:CPOnState ForInterface:SelectedInterface];
    [switcher setState:NSOnState];
    if ([[proxy type] isEqualToString:httpsKey]){//HTTPS
        [Ascript setSecureWebProxy:proxy ForInterface:SelectedInterface];
        [Ascript setSecureWebProxyState:CPOnState ForInterface:SelectedInterface];
    }
    
    if ([chkautodiscovery state])
        [Ascript setProxyAutoDiscovery:CPOnState ForInterface:[interfacebutton titleOfSelectedItem]];
    else
        [Ascript setProxyAutoDiscovery:CPOffState ForInterface:[interfacebutton titleOfSelectedItem]];
    
    [proxy release];
    [self refresh:self];
}

- (IBAction)switcher:(id)sender { 
    NSString *SelectedInterface = [interfacebutton titleOfSelectedItem];
    if (![[actualProxy address] isEqualToString:@""]){//assuming is blank = switch is off
        if ([switcher state]) {
            NSLog(@"on");
            [actualProxy setEnabool:NO];
            [Ascript setWebProxyState:CPOnState ForInterface:SelectedInterface];
            if ([[actualProxy type] isEqualToString:httpsKey])//HTTPS
                [Ascript setSecureWebProxyState:CPOnState ForInterface:SelectedInterface];
            [lblapstatus setStringValue:@"Enabled"];
        }else {
            NSLog(@"off");
            [Ascript setWebProxyState:CPOffState ForInterface:SelectedInterface];
            if ([[actualProxy type] isEqualToString:httpsKey])//HTTPS
                [Ascript setSecureWebProxyState:CPOffState ForInterface:SelectedInterface];
            [lblapstatus setStringValue:@"Disabled"];
        }
    }else {
        [switcher setState:NSOffState animate:YES];
    }
    //Can't call switch here
}

- (IBAction)refresh:(id)sender{
    NSString *SelectedInterface = [interfacebutton titleOfSelectedItem];
    actualProxy = [Ascript getWebProxyForInterface:SelectedInterface];
    
    //Check if is HTTPS
    if ([[Ascript getSecureWebProxyForInterface:SelectedInterface] Enabool])    
        [actualProxy setType:httpsKey];
    
    //is any proxy enabled?
    if ([actualProxy Enabool])
        [switcher setState:NSOnState];
    else
        [switcher setState:NSOffState];
    
    //Auto Proxy Discovery Setup
    if ([[Ascript getProxyAutoDiscoveryForInterface:SelectedInterface] isEqualToString:CPOnState])
        [chkautodiscovery setState:NSOnState];
    else
        [chkautodiscovery setState:NSOffState];
    
    //Actual proxy label Setup
    if (![[actualProxy address] isEqualToString:@""]) {
        [lblapaddress setStringValue:actualProxy.address];
        [lblapprotocol setStringValue:actualProxy.type];
        if ([actualProxy Enabool])
            [lblapstatus setStringValue:@"Enabled"];
        else
            [lblapstatus setStringValue:@"Disabled"];
        
        if ([actualProxy.port integerValue] == 0) 
            [lblapport setStringValue:@""];
        else
            [lblapport setStringValue:actualProxy.port];
    }else {//if blank leave blank
        [lblapaddress setStringValue:@""];
        [lblapport setStringValue:@""];
        [lblapprotocol setStringValue:@""];
        [lblapstatus setStringValue:@""];
    }
}

-(void)windowWillClose:(NSNotification *)notification{
    if ([array count] > 0)
        [fileManager saveFile:array];
}

#pragma mark -
#pragma mark Sheet

-(void)closesheet{
    [self->addSheet orderOut:nil];
    [NSApp endSheet:self->addSheet];
    //[self.addSheet close];
    //self.addSheet = nil;
}

-(IBAction)bttok:(id)sender{
    bool isOk = YES;
    if ([[[txtaddress stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        isOk = NO;
        [lbladdress setTextColor:[NSColor redColor]];
    }else {
        [lbladdress setTextColor:[NSColor blackColor]];
    }
    if ([[[txtport stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        isOk = NO;
        [lblport setTextColor:[NSColor redColor]];
    }else {
        [lblport setTextColor:[NSColor blackColor]];
    }
    if ([chkpassrequire state]) {
        if ([[[txtusername stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            isOk = NO;
            [lblusername setTextColor:[NSColor redColor]];
        }else {
            [lblusername setTextColor:[NSColor blackColor]];
        }
        if ([[[txtpass stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
            isOk = NO;
            [lblpass setTextColor:[NSColor redColor]];
        }else {
            [lblpass setTextColor:[NSColor blackColor]];
        }
    }else {
        [lblusername setTextColor:[NSColor blackColor]];
        [lblpass setTextColor:[NSColor blackColor]];
    }
    
    if (isOk) {
        CProxy *proxy = [[CProxy alloc] init];
        switch ([poptrocol indexOfSelectedItem]) {
            case 0://HTTP
                if ([chksecure state])
                    [proxy setType:httpsKey];
                else 
                    [proxy setType:httpKey];
                break;
            case 1://socks
                [proxy setType:socksKey];
                break;
            case 2://ftp
                [proxy setType:ftpKey];
                break;
            case 3://gopher
                [proxy setType:ghopherKey];
                break;
            default:
                break;
        }
        
        [proxy setAddress:[txtaddress stringValue]];
        [proxy setPort:[txtport stringValue]];
        [proxy setEnabool:NO];
        if ([chkpassrequire state]) {
            [proxy setAuth:CPOnState];
            [proxy setLogin:[txtusername stringValue]];
            [proxy setPass:[txtpass stringValue]];
        }else
            [proxy setAuth:CPOffState];
        
        [arrayController addObject:[proxy Dictionary]];
        [proxy release];
        [self closesheet];
    }
}

-(IBAction)bttcancel:(id)sender{
    [self closesheet];
}

-(void)Resize:(bool)isNew{
    NSRect newposition;
    if (!expanded) {
        [chksecure setTransparent:true];
        
        int newWinHeight = 245;
        int newWinWidth = 312;
        if (isNew)
            newposition = NSMakeRect(addSheet.frame.origin.x - (newWinWidth - (int)(NSWidth(addSheet.frame))), addSheet.frame.origin.y - (newWinHeight - (int)(NSHeight(addSheet.frame))), newWinWidth, newWinHeight);
        else
            newposition = NSMakeRect(addSheet.frame.origin.x - (newWinWidth - (int)(NSWidth(addSheet.frame))), addSheet.frame.origin.y - (newWinHeight - (int)(NSHeight(addSheet.frame))), addSheet.frame.size.width, newWinHeight);
        
        [addSheet setMaxSize:NSMakeSize(450, 245)];
        [addSheet setMinSize:NSMakeSize(312, 245)];
        [addSheet setFrame:newposition display:YES animate:YES];
    }else {
        [chksecure setTransparent:false];
        
        int newWinHeight = 275;
        int newWinWidth = 312;
        
        if (isNew)
            newposition = NSMakeRect(addSheet.frame.origin.x - (newWinWidth - (int)(NSWidth(addSheet.frame))), addSheet.frame.origin.y - (newWinHeight - (int)(NSHeight(addSheet.frame))), newWinWidth, newWinHeight); 
        else
            newposition = NSMakeRect(addSheet.frame.origin.x - (newWinWidth - (int)(NSWidth(addSheet.frame))), addSheet.frame.origin.y - (newWinHeight - (int)(NSHeight(addSheet.frame))), addSheet.frame.size.width, newWinHeight); 
        
        [addSheet setMaxSize:NSMakeSize(450, 275)];
        [addSheet setMinSize:NSMakeSize(312, 275)];
        [addSheet setFrame:newposition display:YES animate:YES];
    }
}

-(IBAction)poptrocol:(id)sender {
    switch ([poptrocol indexOfSelectedItem]) {
        case 0://HTTP
            [lbladdress setStringValue:@"HTTP Proxy Address"];
            [txtport setIntValue:3128];
            expanded = true;
            [self Resize:false];//open
            break;
        case 1:
            [lbladdress setStringValue:@"SOCKS Proxy Address"];
            [txtport setIntValue:1080];
            expanded = false;
            [self Resize:false];
            break;
        case 2:
            [lbladdress setStringValue:@"FTP Proxy Address"];
            [txtport setIntValue:2121];
            expanded = false;
            [self Resize:false];
            break;
        case 3:
            [lbladdress setStringValue:@"Gopher Proxy Address"];
            [txtport setIntValue:70];
            expanded = false;
            [self Resize:false];
            break;
        default:
            break;
    }
}

-(IBAction)chkpassrequire:(id)sender {
    if ([chkpassrequire state]) {
        [txtusername setEnabled:true];
        [txtusername becomeFirstResponder];//focus
        [txtpass setEnabled:true];
    }else {
        [txtusername setEnabled:false];
        [txtpass setEnabled:false];
    }
}

#pragma mark -
#pragma mark PopOver Controller

-(IBAction)popassrequire:(id)sender{
    if ([popassrequire state]) {       
        [popOver setContentSize:NSMakeSize(266, 198)];
        NSRect newRect = NSMakeRect(12, 105, popassrequire.frame.size.width, popassrequire.frame.size.height);
        [popassrequire setFrame:newRect];
        [popbox setHidden:false];
    }else {
        [popOver setContentSize:NSMakeSize(266, 110)];
        NSRect newRect = NSMakeRect(12, 10, popassrequire.frame.size.width, popassrequire.frame.size.height);
        [popassrequire setFrame:newRect];
        [popbox setHidden:true];
    }
}

-(IBAction)popapply:(id)sender{
    NSInteger row = [tableView selectedRow];
    CProxy *proxy = [[CProxy alloc] initWithDictionary:[array objectAtIndex:row]];
    
    [proxy setAddress:[popaddress stringValue]];
    [proxy setPort:[popport stringValue]];
    if ([popassrequire state]){
        [proxy setLogin:[poplogin stringValue]];
        [proxy setPass:[popass stringValue]];
        [proxy setAuth:CPOnState];
    }
    else 
        [proxy setAuth:CPOffState];
    
    [array replaceObjectAtIndex:row withObject:[proxy Dictionary]];
    [proxy release];
    [popOver close];
}

#pragma mark -
#pragma mark TableView Controller

-(IBAction)doubleClick:(id)sender{//PopOver
    NSInteger row = [tableView selectedRow];
    if (row != -1) {
        CProxy *proxy = [[CProxy alloc] initWithDictionary:[array objectAtIndex:row]];
        if ([proxy getAuthAsBool]) {
            [popassrequire setState:NSOnState];
            [poplogin setStringValue:proxy.login];
            [popass setStringValue:proxy.pass];
        }else{
            [popassrequire setState:NSOffState];            
        }
        [self popassrequire:self];
        [popaddress setStringValue:proxy.address];
        [popport setStringValue:proxy.port];
        
        [proxy release];
        [popOver showRelativeToRect:[tableView frameOfCellAtColumn:0 row:row] ofView:[tableView superview] preferredEdge:NSMaxXEdge];
    }
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSInteger row = [tableView selectedRow];
    if (row != -1){
        NSDictionary *dict = [array objectAtIndex:row];
        [aboxaddress setStringValue:[dict objectForKey:addressKey]];
        [aboxport setStringValue:[dict objectForKey:portKey]];
        [aboxtype setStringValue:[dict objectForKey:typeKey]];
        [aboxauth setStringValue:[dict objectForKey:authKey]];
        [bttapply setState:NSOnState];
    }else {
        [aboxaddress setStringValue:@""];
        [aboxport setStringValue:@""];
        [aboxtype setStringValue:@""];
        [aboxauth setStringValue:@""];
        [bttapply setState:NSOffState];
    }
}

-(void)loadFiletoTableView{    
    NSMutableArray *tmp = [fileManager loadFile];
    for (NSDictionary *dict in tmp)
        [arrayController addObject:dict];
}

@end