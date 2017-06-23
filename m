From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4] ext4: change sequential discard handling on commit
 complete phase into parallel manner
Date: Thu, 22 Jun 2017 23:58:13 -0400
Message-ID: <20170623035813.ak5yop2zjuozx5ya@thunk.org>
References: <CGME20170614023440epcas5p2b3ae4895d5db43632e6c4d2b2cc0d3c7@epcas5p2.samsung.com>
 <1497407683-17025-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, hch@infradead.org, linux-ext4@vger.kernel.org
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34660 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754295AbdFWD6n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Jun 2017 23:58:43 -0400
Content-Disposition: inline
In-Reply-To: <1497407683-17025-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 14, 2017 at 11:34:42AM +0900, Daeho Jeong wrote:
> Now, when we mount ext4 filesystem with '-o discard' option, we have to
> issue all the discard commands for the blocks to be deallocated and
> wait for the completion of the commands on the commit complete phase.
> Because this procedure might involve a lot of sequential combinations of
> issuing discard commands and waiting for that, the delay of this
> procedure might be too much long, even to 17.0s in our test,
> and it results in long commit delay and fsync() performance degradation.
> 
> To reduce this kind of delay, instead of adding callback for each
> extent and handling all of them in a sequential manner on commit phase,
> we instead add a separate list of extents to free to the superblock and
> then process this list at once after transaction commits so that
> we can issue all the discard commands in a parallel manner like XFS
> filesystem.
> 
> Finally, we could enhance the discard command handling performance.
> The result was such that 17.0s delay of a single commit in the worst
> case has been enhanced to 4.8s.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Tested-by: Hobin Woo <hobin.woo@samsung.com>
> Tested-by: Kitae Lee <kitae87.lee@samsung.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.  Since the one-line summary was longer than 80
characters, I shortened it to:

    ext4: send parallel discards on commit completions

    	       			    	   - Ted
