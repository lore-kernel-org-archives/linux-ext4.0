From: Jan Kara <jack@suse.cz>
Subject: Re: generic/232 test failures on 4.14-rc1
Date: Mon, 25 Sep 2017 15:59:46 +0200
Message-ID: <20170925135946.GB8004@quack2.suse.cz>
References: <20170921154846.re5vcyn3bugdbie5@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52098 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934254AbdIYN7s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 25 Sep 2017 09:59:48 -0400
Content-Disposition: inline
In-Reply-To: <20170921154846.re5vcyn3bugdbie5@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 21-09-17 11:48:46, Eric Whitney wrote:
> I'm seeing generic/232 fail from time to time when running a 4.14-rc1 kernel
> on xfstest-bld's most recent kvm-xfstests test appliance.  In one set of
> trials, it failed in the same manner 4 out of 10 times when running the 4k test
> configuration for ext4.
> 
> The failure bisects to "quota: Do not acquire dqio_sem for dquot overwrites in
> v2 format" (ab2b86360f6e).  When this patch was reverted in a 4.14-rc1 kernel,
> the failure did not reoccur in a series of 20 trials.

Thanks for debugging this! I'd just note that the commit hash of that
change is different for me - d2faa415166b2883428efa92f451774ef44373ac.

> Example output from the failed test:
> 
> QA output created by 232
> 
> Testing fsstress
> 
> seed = S
> Comparing user usage
> 218a219
> > #3740     --       4       0       0              1     0     0       
> 245a247
> > #45       --       0       0       0              1     0     0     
> 
> Note:  I'm also seeing a similar failure for generic/233, but the patch
> containing the root cause likely comes somewhere after ab2b86360f6e.  I'll post
> another bug report once I locate it.

I'll try to debug this further. Thanks for report!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
