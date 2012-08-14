//
//  Proxie
//
//  Created by Lucas casteletti on 3/18/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//

#import <PreferencePanes/PreferencePanes.h>
#import <Cocoa/Cocoa.h>
#import "CProxy.h"
#import "MBSliderButton.h"

@interface ProxieOwner: NSPreferencePane <NSWindowDelegate ,NSTableViewDelegate, NSPopoverDelegate>{
@private
    //TableView
    NSMutableArray *array;
    IBOutlet NSTableView *tableView;
    IBOutlet NSArrayController *arrayController;
    //PopOver
    IBOutlet NSPopover *popOver;
    IBOutlet NSView *popView;
    IBOutlet NSTextField *popaddress;
    IBOutlet NSTextField *popport;
    IBOutlet NSButton *popassrequire;
    IBOutlet NSTextField *poplogin;
    IBOutlet NSSecureTextField *popass;
    IBOutlet NSBox *popbox;
    //Switch
    IBOutlet MBSliderButton *switcher;
    //Network Popup Menu
    IBOutlet NSPopUpButton *interfacebutton;
    //Selected Proxy box
    IBOutlet NSTextField *aboxaddress;
    IBOutlet NSTextField *aboxport;
    IBOutlet NSTextField *aboxtype;
    IBOutlet NSTextField *aboxauth;
    IBOutlet NSButton *chkautodiscovery;
    IBOutlet NSButton *bttapply;
    //Actual Proxy Label
    IBOutlet NSTextField *lblapaddress;//Address
    IBOutlet NSTextField *lblapport;//Port
    IBOutlet NSTextField *lblapprotocol;//Protocol
    IBOutlet NSTextField *lblapstatus;//Status
    //Sheet
    IBOutlet NSWindow *addSheet;
    IBOutlet NSButton *chksecure;
    IBOutlet NSButton *chkpassrequire;
    IBOutlet NSButton *bttcancel;
    IBOutlet NSButton *bttok;
    IBOutlet NSPopUpButton *poptrocol;
    IBOutlet NSTextField *lbladdress;
    IBOutlet NSTextField *lblport;
    IBOutlet NSTextField *lblusername;
    IBOutlet NSTextField *lblpass;
    IBOutlet NSTextField *txtaddress;
    IBOutlet NSTextField *txtport;
    IBOutlet NSTextField *txtusername;
    IBOutlet NSSecureTextField *txtpass;
    bool expanded;
}

//IBActions
- (IBAction)bttadd:(id)sender;
- (IBAction)bttremove:(id)sender;
- (IBAction)bttmenu:(NSPopUpButton *)sender;
- (IBAction)bttapply:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)bttok:(id)sender;//Sheet
- (IBAction)bttcancel:(id)sender;//Sheet
- (IBAction)poptrocol:(id)sender;//Sheet
- (IBAction)chkpassrequire:(id)sender;//Sheet
- (IBAction)popassrequire:(id)sender;//PopOver
- (IBAction)popapply:(id)sender;//PopOver
- (IBAction)switcher:(id)sender;//MBSliderButton

@end