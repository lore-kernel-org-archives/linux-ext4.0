From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [URGENT PATCH] ext4: fix potential deadlock in ext4_evict_inode()
Date: Fri, 26 Aug 2011 05:17:18 -0400
Message-ID: <20110826091718.GA3179@infradead.org>
References: <E1QwnAu-00087H-8X@tytso-glaptop.cam.corp.google.com>
 <20110826073507.GZ3162@dastard>
 <20110826084403.GA3162@dastard>
 <20110826085057.GA13311@infradead.org>
 <4E57630B.7000202@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40858
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab1HZJRX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Aug 2011 05:17:23 -0400
Content-Disposition: inline
In-Reply-To: <4E57630B.7000202@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 05:10:35PM +0800, Tao Ma wrote:
> yeah, the DIO read on a buffer write file issue is also another side
> effect of it.[1]
> So could you please talk a little more about how xfs handle it now?

The thing I have queued up for 3.2 makes it very simple:  we do not
track I/O ends any more at all, outside of the workqueue.

For buffered I/O we only mark the page uptodate when all unwritten
extent conversion and size updates have finished.  All data integrity
callers and inode eviction wait for the pages to be update so we are
covered.

For direct I/O we only call inode_dio_done and aio_complete once all
unwritten extent size updates are done.  Inodes can't be evicted until
we drop a reference to the inode, which can't happen until the
sync or async dio is done and we drop the inode reference the VFS
holds for it.  Sync and fsync are only guaranteed to pick up I/O
that has returned to userspace, so we are covered for that as well.

