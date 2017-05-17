From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: RE: Re: Re: [PATCH] ext4: hand over jobs handling discard commands
 on commit complete phase to kworkers
Date: Wed, 17 May 2017 23:47:11 +0000
Message-ID: <20170517234711epcms1p58f4f1cc3fa6824c344c7ea74ce2d1ab2@epcms1p5>
References: <20170517081840.GC22737@quack2.suse.cz>
        <20170516151153.GB7316@quack2.suse.cz>
        <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
        <20170517012406epcms1p8d4e5c4e54bf7e97c5856b1d62af6cd83@epcms1p8>
        <CGME20170516073738epcas1p42daa31d04ae9d07eae07d9fcee6708a2@epcms1p5>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>, "jack@suse.com" <jack@suse.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:29807 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEQXrN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 May 2017 19:47:13 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20170517234712epoutp01b24c494e9d2c11de0083e82fdd179cd1~-iYsoIqpk1807518075epoutp01R
        for <linux-ext4@vger.kernel.org>; Wed, 17 May 2017 23:47:12 +0000 (GMT)
In-Reply-To: <20170517081840.GC22737@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > We already freed all the blocks in the block bitmap and increased

> > sbi->s_freeclusters_counter in ext4_free_blocks() in advance of

> > ext4_free_data_callback() which is handling discard commands and releasing

> > blocks in the buddy cache. So, I think that it's ok about ENOSPC, because

> > we are ckecking whether we can allocate the blocks or not using

> > ext4_claim_free_clusters(), which is just seeing sbi->s_freeclusters_counter,

> > and the blocks were already freed from on-disk block bitmap.

 

> No, there is a fundamental problem there. You cannot reuse the blocks until

> ext4_free_data_callback() is finished so this is effectively making blocks

> still used (as you could discard newly written data). And I'm pretty sure

> the allocator takes care not to return blocks for which

> ext4_free_data_callback() hasn't finished. And currently we use transaction

> commit as a way to force releasing of blocks to the allocator which your

> patch breaks.



> > Yes, I agree with you about that the discard handling will be still slow.

> > However, by hiding this, we can get a better responsiveness of fsync() from

> > 30s to 0.255s in the worst case and this is very important to mobile environments

> > where fsync() delay means the users have to wait to do the next action in a while.

> > For the higher file fragmentation, even now, we cannot free the blocks fastly

> > in the buddy cache because we have to handle all the discard commands before

> > freeing blocks in the buddy. So, we already have the same problem now. :-)

 

> No, currently the fragmentation isn't as bad as everybody is stalled

> waiting for discard to finish. So latencies are crap but file

> fragmentation is reduced. And if you just offload discarding (and let's

> assume we can fix those ENOSPC problems), you just postpone the problems

> by a bit - if you get a load that is constantly allocating and freeing

> blocks, you'll soon hit a situation where you are effectively waiting for

> discard anyway because all blocks are queued in the discard queue.



I know the block allocator cannot reuse the blocks that are not discarded yet

and I thought the allocator would find another feasible blocks within the blocks

which are not marked as used in the buddy. It's true normally. But, on the low

free space condition, aha, you're right, the block allocator might find the shorter

size of chunk than the requested size or none of blocks and it might cause

filesystem fragmentation. Making free blocks in the buddy ASAP is also very

important for the filesystem not to be fragmented. I have overlooked that point.

Now, I can understand what you are saying. Thank you so much.



As Christoph and you said, using __blkdev_issue_discard() function for parallel

discard commands handling on the commit phase will be better solution.

I will be back with this solution soon.



Thank you guys again.
