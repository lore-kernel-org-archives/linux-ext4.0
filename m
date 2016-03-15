From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Tue, 15 Mar 2016 11:46:34 +0100
Message-ID: <20160315104634.GG17942@quack.suse.cz>
References: <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
 <20160313042723.GC29218@thunk.org>
 <20160314073928.GD5213@quack.suse.cz>
 <20160314143635.GM29218@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbcCOKq3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 06:46:29 -0400
Content-Disposition: inline
In-Reply-To: <20160314143635.GM29218@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 14-03-16 10:36:35, Ted Tso wrote:
> On Mon, Mar 14, 2016 at 08:39:28AM +0100, Jan Kara wrote:
> > No, that won't be enough. blkdev_issue_flush() is not guaranteed to do
> > anything to IOs which have not reported completion before
> > blkdev_issue_flush() was called. Specifically, CFQ will queue submitted bio
> > in its internal RB tree, following flush request completely bypasses this
> > tree and goes directly to the disk where it flushes caches. And only later
> > CFQ decides to schedule async writeback from the flusher thread which is
> > queued in the RB tree...
> 
> Oh, right.  I am forgetting about the flushing mahchinery rewrite.
> Thanks for pointing that out.
> 
> But what we *could* do is to swap those two calls and then in the case
> where delalloc is enabled, could maintain a list of inodes where we
> only need to call filemap_fdatawait(), and not initiate writeback for
> any dirty pages which had been caused by non-allocating writes.

We actually don't need to swap those two calls - page is already marked as
under writeback in

  mpage_map_and_submit_buffers() -> mpage_submit_page -> ext4_bio_write_page

which gets called while we still hold the transaction handle. I agree
calling filemap_fdatawait() from JBD2 during commit should be enough to fix
issues with delalloc writeback. I'm just somewhat afraid that it will be
more fragile: If we add inode to transaction's list in ext4_map_blocks(),
we are pretty sure there's no way to allocate block to an inode without
introducing data exposure issues (which are then very hard to spot). If we
depend on callers of ext4_map_blocks() to properly add inode to appropriate
transaction list, we have much more places to check. I'll think whether we
could make this more robust.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
