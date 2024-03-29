/**
{file:
    {name: ParticipantViewController.h}
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
#ifndef PARTICIPANTVIEWCONTROLLER_H_INCLUDED
#define PARTICIPANTVIEWCONTROLLER_H_INCLUDED

#import <UIKit/UIKit.h>
#import <Lmi/VidyoClient/VidyoConnector_Objc.h>

@interface ParticipantViewController : UITableViewController <UITableViewDataSource, VCConnectorIRegisterParticipantEventListener>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *participants;

@end

#endif // PARTICIPANTVIEWCONTROLLER_H_INCLUDED

