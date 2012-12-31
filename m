From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH 8/9 v1] ext4: refine unwritten extent conversion
Date: Mon, 31 Dec 2012 17:36:21 +0100
Message-ID: <20121231163621.GI7564@quack.suse.cz>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
 <1356335742-11793-9-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2LaQgZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Dec 2012 11:36:25 -0500
Content-Disposition: inline
In-Reply-To: <1356335742-11793-9-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 24-12-12 15:55:41, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently all unwritten extent conversion work is pushed into a workqueue to be
> done because DIO end_io is in a irq context and this conversion needs to take
> i_data_sem locking.  But we couldn't take a semaphore in a irq context.  After
> tracking all extent status, we can first convert this unwritten extent in extent
> status tree, and call aio_complete() and inode_dio_done() to notify upper level
> that this dio has done.  We don't need to be worried about exposing a stale data
> because we first try to lookup in extent status tree.  So it makes us to see the
> latest extent status.  Meanwhile we queue a work to convert this unwritten
> extent in extent tree.  After this improvement, reader also needn't wait this
> conversion to be done when dioread_nolock is enabled.
> 
> CC: Jan Kara <jack@suse.cz>
> CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> CC: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
> [Cc' to Jan, Darrick, and Christoph because Christoph is trying to handle
> O_(D)SYNC for AIO]
> 
> Hi Jan, Darrick, and Christoph,
> 
> This patch refines the unwritten extent conversion in ext4.  Now we can call
> aio_complete() and inode_dio_done() in end_io function.  I believe Christoph's
> patch also can work well after applied this patch.  Could you please review
> this patch?
  Umm, I don't understand one thing (please bear with me, I've not followed
extent status tree work in detail): After you report IO completion, you
must make sure subsequent read returns data you wrote. Thus you would need
to track also physical location of all extents that are written but not yet
converted in the extent status tree. I'm not sure which patches are in
flight but it's definitely not happening right now and it seems to me it
would complicate the extent status tree (effectively making a full extent
cache out of it, making it considerably heavier etc.). If extent tree is
really going that way, then what you propose is probably a good idea. I'm
still somewhat uneasy about completing the IO before it's really on disk
(we still need flushing of conversions in various places) but doing the
conversion before completing the IO has its own (locking) issues especially
for writeback path. So the solution using extent status tree is fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
