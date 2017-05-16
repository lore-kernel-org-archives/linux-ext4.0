From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: hand over jobs handling discard commands on commit
 complete phase to kworkers
Date: Tue, 16 May 2017 17:11:53 +0200
Message-ID: <20170516151153.GB7316@quack2.suse.cz>
References: <CGME20170516073738epcas1p42daa31d04ae9d07eae07d9fcee6708a2@epcas1p4.samsung.com>
 <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59573 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753481AbdEPPME (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 May 2017 11:12:04 -0400
Content-Disposition: inline
In-Reply-To: <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-05-17 16:37:42, Daeho Jeong wrote:
> Now, when we mount ext4 filesystem with '-o discard' option, we have to
> issue all the discard commands for the blocks to be deallocated and
> wait for the completion of the commands on the commit complete phase.
> Because this procedure might involve a lot of sequential combinations of
> issuing discard commands and waiting for that, the delay of this
> procedure might be too much long, even to half a minute in our test,
> and it results in long commit delay and fsync() performance degradation.
> 
> If we process these jobs handlig discard commands with work items and
> delegate the jobs to kworkers, the journaling thread doesn't need to
> wait for the discard command handling anymore, and the sequentially
> handled discard commands will be handled in parallel by several kworkers
> and discard command handling performance also will be enhanced.
> By doing this, half a minute delay of a single commit in the worst case
> has been enhanced to 255ms in our test.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Tested-by: Hobin Woo <hobin.woo@samsung.com>
> Tested-by: Kitae Lee <kitae87.lee@samsung.com>

So I see several problems with this. Firstly, it breaks the ENOSPC handling
logic which relies on the fact that after forcing a transaction commit all
blocks held by the transaction are released - now they will be released
only after the work is completed and thus we can prematurely report ENOSPC.
Secondly, offloading the discard work doesn't change the fundamental fact
that discard is slow (for some devices) and this change just hides this
fact at the possible cost of for example higher file fragmentation as a
result of delayed block freeing. Also the outstanding queue of discard
requests isn't limited in any way again leading to possible strange
allocation / ENOSPC issues.

So I agree with Christoph that you should rather submit discards directly
from jbd2 thread as we do now, just submit all of them and then wait for
completion to allow parallel processing in the device. And if the device
doesn't support fast enough parallel processing of discards then 'discard'
mount option isn't really suited for such device and no amount of
offloading is going to fix that fact.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
