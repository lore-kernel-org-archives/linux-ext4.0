From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Mon, 14 Mar 2016 08:39:28 +0100
Message-ID: <20160314073928.GD5213@quack.suse.cz>
References: <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
 <20160313042723.GC29218@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbcCNHjX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2016 03:39:23 -0400
Content-Disposition: inline
In-Reply-To: <20160313042723.GC29218@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 12-03-16 23:27:23, Ted Tso wrote:
> On Thu, Jan 07, 2016 at 12:47:36PM +0100, Jan Kara wrote:
> > The problem is in all kernels starting with 3.8. Attached is a patch which
> > should fix the issue. Can you test whether it fixes the problem for you?
> 
> Sorry, I missed this patch because it was attached to an discussion
> thread.

I have actually sent this patch in a standalone thread on January 11
(http://lists.openwall.net/linux-ext4/2016/01/11/3) together with one more
cleanup.

> > The problem is that although for delayed allocated blocks we write their
> > contents immediately after allocating them, there is no guarantee that
> > the IO scheduler or device doesn't reorder things
> 
> I don't think that's the problem.  In the commit thread when we call
> blkdev_issue_flush() that acts as a barrier so the I/O scheduler won't
> reorder writes after that point, which is before we write the commit
> block.  Instead, I believe the problem is in ext4_writepages:
> 
> 		ext4_journal_stop(handle);
> 		/* Submit prepared bio */
> 		ext4_io_submit(&mpd.io_submit);
> 
> Once we release the handle, the commit can start --- *before* we have
> a chance to submit the I/O.   Oops.
> 
> I believe if we swap these two calls, it should fix the problem Huang
> was seeing.

No, that won't be enough. blkdev_issue_flush() is not guaranteed to do
anything to IOs which have not reported completion before
blkdev_issue_flush() was called. Specifically, CFQ will queue submitted bio
in its internal RB tree, following flush request completely bypasses this
tree and goes directly to the disk where it flushes caches. And only later
CFQ decides to schedule async writeback from the flusher thread which is
queued in the RB tree...

Note that the behavior has changed to be like this with the flushing
machinery rewrite. Before that, IO scheduler had to drain all the
outstanding IO requests (IO cache flush behaved like IO barrier). So your
patch would be enough with the old flushing machinery but is not enough
since 3.0 or so...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
