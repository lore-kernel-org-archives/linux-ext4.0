From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Mon, 14 Mar 2016 10:36:35 -0400
Message-ID: <20160314143635.GM29218@thunk.org>
References: <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
 <20160313042723.GC29218@thunk.org>
 <20160314073928.GD5213@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41790 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbcCNOgn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2016 10:36:43 -0400
Content-Disposition: inline
In-Reply-To: <20160314073928.GD5213@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 14, 2016 at 08:39:28AM +0100, Jan Kara wrote:
> No, that won't be enough. blkdev_issue_flush() is not guaranteed to do
> anything to IOs which have not reported completion before
> blkdev_issue_flush() was called. Specifically, CFQ will queue submitted bio
> in its internal RB tree, following flush request completely bypasses this
> tree and goes directly to the disk where it flushes caches. And only later
> CFQ decides to schedule async writeback from the flusher thread which is
> queued in the RB tree...

Oh, right.  I am forgetting about the flushing mahchinery rewrite.
Thanks for pointing that out.

But what we *could* do is to swap those two calls and then in the case
where delalloc is enabled, could maintain a list of inodes where we
only need to call filemap_fdatawait(), and not initiate writeback for
any dirty pages which had been caused by non-allocating writes.

						- Ted
