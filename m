From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block_write_full_page: switch synchronous writes to
	use  WRITE_SYNC_PLUG
Date: Wed, 8 Apr 2009 10:08:44 +0200
Message-ID: <20090408080844.GW5178@kernel.dk>
References: <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk> <20090407190913.GA31723@mit.edu> <20090407193239.GE5178@kernel.dk> <20090407214421.GA7031@mit.edu> <20090407221933.GB7031@mit.edu> <20090407160944.de3c5139.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jack@suse.cz
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:54637 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZDHIIp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Apr 2009 04:08:45 -0400
Content-Disposition: inline
In-Reply-To: <20090407160944.de3c5139.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07 2009, Andrew Morton wrote:
> On Tue, 7 Apr 2009 18:19:33 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > Now that we have a distinction between WRITE_SYNC and WRITE_SYNC_PLUG,
> > use WRITE_SYNC_PLUG in __block_write_full_page() to avoid unplugging
> > the block device I/O queue between each page that gets flushed out.
> > 
> > The upstream callers of block_write_full_page() which wait for the
> > writes to finish call wait_on_buffer(), wait_on_writeback_range()
> > (which ultimately calls sync_page(), which calls
> > blk_run_backing_dev(), which will unplug the device queue), and so on.
> > 
> 
> <sob>
> 
> > 
> > We should get this applied to avoid any performance regressions
> > resulting from commit a64c8610.
> > 
> >  fs/buffer.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 977e12a..95b5390 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1646,7 +1646,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
> >  	struct buffer_head *bh, *head;
> >  	const unsigned blocksize = 1 << inode->i_blkbits;
> >  	int nr_underway = 0;
> > -	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
> > +	int write_op = (wbc->sync_mode == WB_SYNC_ALL ?
> > +			WRITE_SYNC_PLUG : WRITE);
> >  
> >  	BUG_ON(!PageLocked(page));
> 
> So how does WRITE_SYNC_PLUG differ from WRITE, and what effect does
> this change have upon kernel behaviour?

How about something like this. Comments welcome. Should we move this to
a dedicated header file? fs.h is amazingly cluttered as it is.

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 562d285..6b6597a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -87,6 +87,57 @@ struct inodes_stat_t {
  */
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
+/*
+ * The below are the various read and write types that we support. Some of
+ * them include behavioral modifiers that send information down to the
+ * block layer and IO scheduler. Terminology:
+ *
+ *	The block layer uses device plugging to defer IO a little bit, in
+ *	the hope that we will see more IO very shortly. This increases
+ *	coalescing of adjacent IO and thus reduces the number of IOs we
+ *	have to send to the device. It also allows for better queuing,
+ *	if the IO isn't mergeable. If the caller is going to be waiting
+ *	for the IO, then he must ensure that the device is unplugged so
+ *	that the IO is dispatched to the driver.
+ *
+ *	All IO is handled async in Linux. This is fine for background
+ *	writes, but for reads or writes that someone waits for completion
+ *	on, we want to notify the block layer and IO scheduler so that they
+ *	know about it. That allows them to make better scheduling
+ *	decisions. So when the below references 'sync' and 'async', it
+ *	is referencing this priority hint.
+ *
+ * With that in mind, the available types are:
+ *
+ * READ			A normal read operation. Device will be plugged.
+ * READ_SYNC		A synchronous read. Device is not plugged, caller can
+ *			immediately wait on this read without caring about
+ *			unplugging.
+ * READA		Used for read-ahead operations. Lower priority, and the
+ *			 block layer could (in theory) choose to ignore this
+ *			request if it runs into resource problems.
+ * WRITE		A normal async write. Device will be plugged.
+ * SWRITE		Like WRITE, but a special case for ll_rw_block() that
+ *			tells it to lock the buffer first. Normally a buffer
+ *			must be locked before doing IO.
+ * WRITE_SYNC_PLUG	Synchronous write. Identical to WRITE, but passes down
+ *			the hint that someone will be waiting on this IO
+ *			shortly.
+ * WRITE_SYNC		Like WRITE_SYNC_PLUG, but also unplugs the device
+ *			immediately after submission. The write equivalent
+ *			of READ_SYNC.
+ * WRITE_ODIRECT	Special case write for O_DIRECT only.
+ * SWRITE_SYNC
+ * SWRITE_SYNC_PLUG	Like WRITE_SYNC/WRITE_SYNC_PLUG, but locks the buffer.
+ *			See SWRITE.
+ * WRITE_BARRIER	Like WRITE, but tells the block layer that all
+ *			previously submitted writes must be safely on storage
+ *			before this one is started. Also guarantees that when
+ *			this write is complete, it itself is also safely on
+ *			storage. Prevents reordering of writes on both sides
+ *			of this IO.
+ *
+ */
 #define RW_MASK		1
 #define RWA_MASK	2
 #define READ 0
@@ -102,6 +153,11 @@ struct inodes_stat_t {
 			(SWRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
 #define SWRITE_SYNC	(SWRITE_SYNC_PLUG | (1 << BIO_RW_UNPLUG))
 #define WRITE_BARRIER	(WRITE | (1 << BIO_RW_BARRIER))
+
+/*
+ * These aren't really reads or writes, they pass down information about
+ * parts of device that are now unused by the file system.
+ */
 #define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
 #define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
 

-- 
Jens Axboe

