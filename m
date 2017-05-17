From: Jan Kara <jack@suse.cz>
Subject: Re: Re: [PATCH] ext4: hand over jobs handling discard commands on
 commit complete phase to kworkers
Date: Wed, 17 May 2017 10:18:40 +0200
Message-ID: <20170517081840.GC22737@quack2.suse.cz>
References: <20170516151153.GB7316@quack2.suse.cz>
 <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
 <CGME20170516073738epcas1p42daa31d04ae9d07eae07d9fcee6708a2@epcms1p8>
 <20170517012406epcms1p8d4e5c4e54bf7e97c5856b1d62af6cd83@epcms1p8>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, "jack@suse.com" <jack@suse.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752300AbdEQISn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 May 2017 04:18:43 -0400
Content-Disposition: inline
In-Reply-To: <20170517012406epcms1p8d4e5c4e54bf7e97c5856b1d62af6cd83@epcms1p8>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 17-05-17 01:24:06, Daeho Jeong wrote:
> > So I see several problems with this. Firstly, it breaks the ENOSPC handling
> > logic which relies on the fact that after forcing a transaction commit all
> > blocks held by the transaction are released - now they will be released
> > only after the work is completed and thus we can prematurely report ENOSPC.
> 
> We already freed all the blocks in the block bitmap and increased
> sbi->s_freeclusters_counter in ext4_free_blocks() in advance of
> ext4_free_data_callback() which is handling discard commands and releasing
> blocks in the buddy cache. So, I think that it's ok about ENOSPC, because
> we are ckecking whether we can allocate the blocks or not using
> ext4_claim_free_clusters(), which is just seeing sbi->s_freeclusters_counter,
> and the blocks were already freed from on-disk block bitmap.

No, there is a fundamental problem there. You cannot reuse the blocks until
ext4_free_data_callback() is finished so this is effectively making blocks
still used (as you could discard newly written data). And I'm pretty sure
the allocator takes care not to return blocks for which
ext4_free_data_callback() hasn't finished. And currently we use transaction
commit as a way to force releasing of blocks to the allocator which your
patch breaks.
 
> > Secondly, offloading the discard work doesn't change the fundamental fact
> > that discard is slow (for some devices) and this change just hides this
> > fact at the possible cost of for example higher file fragmentation as a
> > result of delayed block freeing. Also the outstanding queue of discard
> > requests isn't limited in any way again leading to possible strange
> > allocation / ENOSPC issues.
> 
> Yes, I agree with you about that the discard handling will be still slow.
> However, by hiding this, we can get a better responsiveness of fsync() from
> 30s to 0.255s in the worst case and this is very important to mobile environments
> where fsync() delay means the users have to wait to do the next action in a while.
> For the higher file fragmentation, even now, we cannot free the blocks fastly
> in the buddy cache because we have to handle all the discard commands before
> freeing blocks in the buddy. So, we already have the same problem now. :-)

No, currently the fragmentation isn't as bad as everybody is stalled
waiting for discard to finish. So latencies are crap but file
fragmentation is reduced. And if you just offload discarding (and let's
assume we can fix those ENOSPC problems), you just postpone the problems
by a bit - if you get a load that is constantly allocating and freeing
blocks, you'll soon hit a situation where you are effectively waiting for
discard anyway because all blocks are queued in the discard queue.

So my advice is: If you have slow discard, just don't use 'discard' mount
option. What is the problem with running fstrim(8) once a day instead? That
should yield much better results.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
