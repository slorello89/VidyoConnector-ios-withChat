/**
{file:
    {name: ParticipantViewController.m}
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
#import <Foundation/Foundation.h>
#import "ParticipantViewController.h"
#import "VidyoConnectorAppDelegate.h"
#import "Logger.h"

@interface ParticipantViewController () {
@private
    Logger *logger;
}
@end

@implementation ParticipantViewController

@synthesize tableView, participants;

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.dataSource = self;
    [[(VidyoConnectorAppDelegate *)[[UIApplication sharedApplication] delegate] vidyoConnector] registerParticipantEventListener:self];
    participants = [NSMutableDictionary dictionary];
}

#pragma mark UITableViewSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!participants) // data not ready?
        return 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [participants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = ([participants allValues])[indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark Participant callbacks

- (void)onParticipantJoined:(VCParticipant*)participant {
    [logger Log:[NSString stringWithFormat:@"onParticipantJoined: name=%@", [participant getName]]];
    [[self participants] setObject:[participant getName] forKey:[participant getId]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)onParticipantLeft:(VCParticipant*)participant {
    [logger Log:[NSString stringWithFormat:@"onParticipantLeft: name=%@", [participant getName]]];
    [participants removeObjectForKey: [participant getId]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)onDynamicParticipantChanged:(NSMutableArray*)participants {
    [logger Log:@"onDynamicParticipantChanged"];
}
- (void)onLoudestParticipantChanged:(VCParticipant*)participant AudioOnly:(BOOL)audioOnly {
    [logger Log:[NSString stringWithFormat:@"onLoudestParticipantChanged: name=%@ audioOnly=%d", [participant getName], audioOnly]];
}

@end
