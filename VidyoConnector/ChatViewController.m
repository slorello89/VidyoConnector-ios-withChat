/**
{file:
    {name: ChatViewController.m}
    {description: .}
    {copyright:
        (c) 2017-2018 Vidyo, Inc.,
        433 Hackensack Avenue, 7th Floor,
        Hackensack, NJ  07601.

        All rights reserved.

        The information contained herein is proprietary to Vidyo, Inc.
        and shall not be reproduced, copied (in whole or in part), adapted,
        modified, disseminated, transmitted, transcribed, stored in a retrieval
        system, or translated into any language in any form by any means
        without the express written consent of Vidyo, Inc.
                          ***** CONFIDENTIAL *****
    }
}
*/
#import "ChatViewController.h"
#import "VidyoConnectorAppDelegate.h"
#import "Logger.h"

@implementation Message
@end

@interface ChatViewController () {
    Logger *logger;
}
@end

@implementation ChatViewController

@synthesize chatMessages, tableView, messageText;

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    chatMessages = [NSMutableArray array];
    [[(VidyoConnectorAppDelegate *)[[UIApplication sharedApplication] delegate] vidyoConnector] registerMessageEventListener:self];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark ChatMessageInterfaceImplementation

-(void) onChatMessageReceived:(VCParticipant*)participant ChatMessage:(VCChatMessage*)chatMessage {
    Message *theMessage = [Message alloc];
    if ([chatMessage type] == VCChatMessageTypeChat) {
        [logger Log:[NSString stringWithFormat:@"onChatMessageReceived: name=%@, message=%@", [participant getName], [chatMessage body]]];

        theMessage->name = [participant getName];
        theMessage->text = [chatMessage body];

        [chatMessages addObject:theMessage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.chatMessages count] -1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        });
    } else if ([chatMessage type] == VCChatMessageTypeMediaStart || [chatMessage type] == VCChatMessageTypeMediaStop) {
        [chatMessages removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }    
}

#pragma mark -
#pragma mark actions

- (IBAction)sendChatMessage:(id)sender {
    NSString *message = [messageText text];
    if (message.length) {
        [logger Log:[NSString stringWithFormat:@"sendChatMessage: %@", [messageText text]]];
        [[(VidyoConnectorAppDelegate *)[[UIApplication sharedApplication] delegate] vidyoConnector] sendChatMessage:(const char*)[message UTF8String]];
        Message *theMessage = [Message alloc];
        theMessage->name = @"you";
        theMessage->text = [messageText text];
        [chatMessages addObject:theMessage];
        messageText.text = @"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textFieldShouldReturn:self.messageText];
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.chatMessages count] - 1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        });
    }
}

#pragma mark -
#pragma mark UITableViewSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return 0 if data isn't ready; 1 otherwise.
    return chatMessages ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"genericCell" forIndexPath:indexPath];
    
    Message *theMessage = [chatMessages objectAtIndex:indexPath.row];
    NSMutableString *displayString = [NSMutableString string];
    [displayString appendString:@""];
    [displayString appendString:[theMessage->name copy]];
    [displayString appendString:@":  "];
    [displayString appendString:[theMessage->text copy]];
    cell.textLabel.text = displayString;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    return cell;
}

#pragma mark -
#pragma mark keyboardHandling

- (IBAction)dismissKeyboard:(id)sender {
    if (messageText.isFirstResponder) {
        [self textFieldShouldReturn:messageText];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == messageText) {
        [messageText resignFirstResponder];
    }
    return YES;
}

@end
