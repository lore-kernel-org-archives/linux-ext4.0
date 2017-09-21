From: Eric Whitney <enwlinux@gmail.com>
Subject: generic/232 test failures on 4.14-rc1
Date: Thu, 21 Sep 2017 11:48:46 -0400
Message-ID: <20170921154846.re5vcyn3bugdbie5@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:57049 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbdIUPsv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Sep 2017 11:48:51 -0400
Received: by mail-qk0-f169.google.com with SMTP id g128so1283587qke.13
        for <linux-ext4@vger.kernel.org>; Thu, 21 Sep 2017 08:48:50 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm seeing generic/232 fail from time to time when running a 4.14-rc1 kernel
on xfstest-bld's most recent kvm-xfstests test appliance.  In one set of
trials, it failed in the same manner 4 out of 10 times when running the 4k test
configuration for ext4.

The failure bisects to "quota: Do not acquire dqio_sem for dquot overwrites in
v2 format" (ab2b86360f6e).  When this patch was reverted in a 4.14-rc1 kernel,
the failure did not reoccur in a series of 20 trials.

Example output from the failed test:

QA output created by 232

Testing fsstress

seed = S
Comparing user usage
218a219
> #3740     --       4       0       0              1     0     0       
245a247
> #45       --       0       0       0              1     0     0     

Note:  I'm also seeing a similar failure for generic/233, but the patch
containing the root cause likely comes somewhere after ab2b86360f6e.  I'll post
another bug report once I locate it.

Thanks,
Eric
