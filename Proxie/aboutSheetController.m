//
//  aboutSheetController.m
//  Proxie
//
//  Created by Lucas casteletti on 5/17/12.
//  Copyright (c) 2012 MyNoNameCompany. All rights and lefts reserved.
//  
//  github.com/ilucas/Proxie
//

#import "aboutSheetController.h"

@implementation aboutSheetController

- (IBAction)btthelp:(id)sender{
    [NSApp beginSheet:self->aboutWindow
       modalForWindow:[NSApp mainWindow]
        modalDelegate:self
       didEndSelector:NULL
          contextInfo:NULL];
}

- (IBAction)bttclose:(id)sender{
    [self->aboutWindow orderOut:nil];
    [NSApp endSheet:self->aboutWindow];
}

- (void)awakeFromNib{
    [lblversion setStringValue:[NSString stringWithFormat:@"v%@",CFBundleVersion]];
}

- (IBAction)github:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:githubURL]];
}

@end