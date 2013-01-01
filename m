From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH 8/9 v1] ext4: refine unwritten extent conversion
Date: Tue, 1 Jan 2013 13:24:45 +0800
Message-ID: <20130101052445.GC7546@gmail.com>
References: <1356335742-11793-1-git-send-email-wenqing.lz@taobao.com>
 <1356335742-11793-9-git-send-email-wenqing.lz@taobao.com>
 <20121231215815.GM7564@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45121 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3AAFLJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2013 00:11:09 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7311176pbc.33
        for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2012 21:11:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121231215815.GM7564@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 31, 2012 at 10:58:15PM +0100, Jan Kara wrote:
> On Mon 24-12-12 15:55:41, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Currently all unwritten extent conversion work is pushed into a workqueue to be
> > done because DIO end_io is in a irq context and this conversion needs to take
> > i_data_sem locking.  But we couldn't take a semaphore in a irq context.  After
> > tracking all extent status, we can first convert this unwritten extent in extent
> > status tree, and call aio_complete() and inode_dio_done() to notify upper level
> > that this dio has done.  We don't need to be worried about exposing a stale data
> > because we first try to lookup in extent status tree.  So it makes us to see the
> > latest extent status.  Meanwhile we queue a work to convert this unwritten
> > extent in extent tree.  After this improvement, reader also needn't wait this
> > conversion to be done when dioread_nolock is enabled.
> > 
> > CC: Jan Kara <jack@suse.cz>
> > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > CC: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>   OK, so after reading other patches this should work fine. Just I think we
> should somehow mark in the extent status tree that the extent tree is
> inconsistent with what's on disk - something like extent dirty bit. It will
> be set for UNWRITTEN extents where conversion is pending logically it would
> also make sence to have it set for DELAYED extents. Then if we need to
> reclaim some extents due to memory pressure we know we have to keep dirty
> extents because those cache irreplacible information. What do you think?

Dirty bit is a good idea for UNWRITTEN extent because we can feel free
to reclaim all WRITTEN extents and all UNWRITTEN extents that are
without dirty bit.  But we can not reclaim DEALYED extents no matter
whether they are dirty or not because they are used to lookup an delayed
extent in fiemap, seek_data/hole, and bigalloc.  So at least DEALYED
extent must be kept in status tree.  That is why in step 1 status tree
only tracks all DELAYED extents in the tree.

Thanks,
                                                - Zheng
