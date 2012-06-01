//
//  aboutSheetController.h
//  Proxie
//
//  Created by Lucas casteletti on 5/17/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//

#import <Cocoa/Cocoa.h>

@interface aboutSheetController : NSObject <NSWindowDelegate>{
@private
    IBOutlet NSTextField *lblversion;
    IBOutlet NSWindow *aboutWindow;
}

- (IBAction)github:(id)sender;
- (IBAction)btthelp:(id)sender;
- (IBAction)bttclose:(id)sender;

@end