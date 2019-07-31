/**
{file:
    {name: TabViewController.m}
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
#import "TabController.h"

@interface TabController ()
@end

@implementation TabController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Force view controllers (each tab) to pre-load
    for (UIViewController *controller in self.viewControllers) {
        [controller view];
    }
}

@end
