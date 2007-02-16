From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: data=journal busted
Date: Fri, 16 Feb 2007 15:19:10 -0800
Message-ID: <20070216151910.5dd6fdec.akpm@linux-foundation.org>
References: <20070215204445.411d2760.akpm@linux-foundation.org>
	<20070216145022.12e86c7d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXBPXTY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 18:19:24 -0500
In-Reply-To: <20070216145022.12e86c7d.randy.dunlap@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 Feb 2007 14:50:22 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 15 Feb 2007 20:44:45 -0800 Andrew Morton wrote:
> 
> > 
> > I have a report from a google person who just did some basic
> > power-it-off-during-a-write testing on 2.6.20's ext3.  ordered-data is OK,
> > but data=journal came back with crap in the file data.
> > 
> > Is anyone doing any formal recovery stress-testing?
> > 
> > I suspect we should resurrect and formalise my old
> > make-the-disk-stop-accepting-writes-when-a-timer-goes-off thing.  It was
> > very useful for stress-testing recovery.
> 
> Where is your make-troubles patch, please sir?

gee, it's all buried in the ext3 debug patch

<resurrects, makes it compile>


But that's just the concept.  I think the core should be formalisation of the
concept, so that other journalling filesystems can use it.

And that concept is: make a device stop accepting writes when an interrupt
goes off.  I think using a timer is appropriate, and I think setting that
timer at [re]mount-time is suitable.  So it'd be a matter of hooking that
into the block layer (or the drivers) at the appropriate point, exposing
the APIs to the filesystems and then wiring up ext4.

Perhaps it has some synergy with the new fault-injection code, dunno.



otoh, perhaps filesystems don't need to be involved at all.  Just do

	echo 42 > /sys/block/sda3/reject-writes-after-this-many-milliseconds

	while [ $(cat /sys/block/sda3/reject...) -gt 0 ]
	do
		sleep 1
	done

	<kill test app>
	<unmount>
	<mount>
	<unmount>
	<fsck>
	<mount>
	<check contents of files>
	<repeat>




 drivers/ide/ide-io.c         |   23 ++
 fs/Kconfig                   |    4 
 fs/Makefile                  |    2 
 fs/buffer.c                  |  103 ++++++++++++-
 fs/direct-io.c               |    1 
 fs/ext3/inode.c              |    7 
 fs/ext3/namei.c              |   40 ++++-
 fs/ext3/super.c              |   82 ++++++++++
 fs/ext3/xattr.c              |    4 
 fs/jbd-kernel.c              |  255 +++++++++++++++++++++++++++++++++
 fs/jbd/commit.c              |   17 +-
 fs/jbd/transaction.c         |   45 +++--
 include/linux/buffer-trace.h |   83 ++++++++++
 include/linux/buffer_head.h  |    4 
 include/linux/jbd.h          |   24 +--
 15 files changed, 650 insertions(+), 44 deletions(-)

diff -puN drivers/ide/ide-io.c~ext3-debug drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c~ext3-debug
+++ a/drivers/ide/ide-io.c
@@ -999,6 +999,29 @@ static ide_startstop_t start_request (id
 		HWIF(drive)->name, (unsigned long) rq);
 #endif
 
+#ifdef CONFIG_JBD_DEBUG
+	{
+		/*
+		 * Silently stop writing to this disk to simulate a crash.
+		 */
+		extern struct block_device *journal_no_write[2];
+		int i;
+
+		if (!(rq->cmd_flags & REQ_RW))
+			goto its_a_read;
+
+		for (i = 0; i < 2; i++) {
+			struct block_device *bdev = journal_no_write[i];
+			if (bdev && bdev_get_queue(bdev) == rq->q) {
+				printk("%s: write suppressed\n", __FUNCTION__);
+				ide_end_request(drive, 1, rq->nr_sectors);
+				return ide_stopped;
+			}
+		}
+	}
+its_a_read:
+	;
+#endif
 	/* bail early if we've exceeded max_failures */
 	if (drive->max_failures && (drive->failures > drive->max_failures)) {
 		goto kill_rq;
diff -puN fs/Kconfig~ext3-debug fs/Kconfig
--- a/fs/Kconfig~ext3-debug
+++ a/fs/Kconfig
@@ -265,6 +265,10 @@ config JBD2_DEBUG
 	  generated.  To turn debugging off again, do
 	  "echo 0 > /proc/sys/fs/jbd2-debug".
 
+config BUFFER_DEBUG
+	bool "buffer-layer tracing"
+	depends on JBD
+
 config FS_MBCACHE
 # Meta block cache for Extended Attributes (ext2/ext3/ext4)
 	tristate
diff -puN fs/Makefile~ext3-debug fs/Makefile
--- a/fs/Makefile~ext3-debug
+++ a/fs/Makefile
@@ -31,6 +31,8 @@ obj-$(CONFIG_BINFMT_AOUT)	+= binfmt_aout
 obj-$(CONFIG_BINFMT_EM86)	+= binfmt_em86.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
 
+obj-$(CONFIG_BUFFER_DEBUG)	+= jbd-kernel.o
+
 # binfmt_script is always there
 obj-y				+= binfmt_script.o
 
diff -puN fs/buffer.c~ext3-debug fs/buffer.c
--- a/fs/buffer.c~ext3-debug
+++ a/fs/buffer.c
@@ -35,6 +35,8 @@
 #include <linux/hash.h>
 #include <linux/suspend.h>
 #include <linux/buffer_head.h>
+#include <linux/buffer-trace.h>
+#include <linux/jbd.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/bio.h>
 #include <linux/notifier.h>
@@ -53,6 +55,7 @@ init_buffer(struct buffer_head *bh, bh_e
 {
 	bh->b_end_io = handler;
 	bh->b_private = private;
+	buffer_trace_init(&bh->b_history);
 }
 
 static int sync_buffer(void *word)
@@ -61,6 +64,7 @@ static int sync_buffer(void *word)
 	struct buffer_head *bh
 		= container_of(word, struct buffer_head, b_state);
 
+	BUFFER_TRACE(bh, "enter");
 	smp_mb();
 	bd = bh->b_bdev;
 	if (bd)
@@ -106,6 +110,7 @@ static void buffer_io_error(struct buffe
 {
 	char b[BDEVNAME_SIZE];
 
+	BUFFER_TRACE(bh, "I/O error");
 	printk(KERN_ERR "Buffer I/O error on device %s, logical block %Lu\n",
 			bdevname(bh->b_bdev, b),
 			(unsigned long long)bh->b_blocknr);
@@ -117,10 +122,12 @@ static void buffer_io_error(struct buffe
  */
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
 {
+	BUFFER_TRACE(bh, "enter");
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
 		/* This happens, due to failed READA attempts. */
+		BUFFER_TRACE(bh, "clear uptodate");
 		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
@@ -132,8 +139,10 @@ void end_buffer_write_sync(struct buffer
 	char b[BDEVNAME_SIZE];
 
 	if (uptodate) {
+		BUFFER_TRACE(bh, "uptodate");
 		set_buffer_uptodate(bh);
 	} else {
+		BUFFER_TRACE(bh, "Not uptodate");
 		if (!buffer_eopnotsupp(bh) && printk_ratelimit()) {
 			buffer_io_error(bh);
 			printk(KERN_WARNING "lost page write due to "
@@ -141,6 +150,7 @@ void end_buffer_write_sync(struct buffer
 				       bdevname(bh->b_bdev, b));
 		}
 		set_buffer_write_io_error(bh);
+		BUFFER_TRACE(bh, "clear uptodate");
 		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
@@ -379,12 +389,15 @@ static void end_buffer_async_read(struct
 	struct page *page;
 	int page_uptodate = 1;
 
+	BUFFER_TRACE(bh, "enter");
+
 	BUG_ON(!buffer_async_read(bh));
 
 	page = bh->b_page;
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
+		BUFFER_TRACE(bh, "clear uptodate");
 		clear_buffer_uptodate(bh);
 		if (printk_ratelimit())
 			buffer_io_error(bh);
@@ -441,6 +454,8 @@ static void end_buffer_async_write(struc
 	struct buffer_head *tmp;
 	struct page *page;
 
+	BUFFER_TRACE(bh, "enter");
+
 	BUG_ON(!buffer_async_write(bh));
 
 	page = bh->b_page;
@@ -456,6 +471,7 @@ static void end_buffer_async_write(struc
 		set_bit(AS_EIO, &page->mapping->flags);
 		set_buffer_write_io_error(bh);
 		clear_buffer_uptodate(bh);
+		BUFFER_TRACE(bh, "clear uptodate");
 		SetPageError(page);
 	}
 
@@ -666,6 +682,7 @@ void mark_buffer_dirty_inode(struct buff
 	struct address_space *mapping = inode->i_mapping;
 	struct address_space *buffer_mapping = bh->b_page->mapping;
 
+	BUFFER_TRACE(bh, "mark dirty");
 	mark_buffer_dirty(bh);
 	if (!mapping->assoc_mapping) {
 		mapping->assoc_mapping = buffer_mapping;
@@ -720,7 +737,25 @@ int __set_page_dirty_buffers(struct page
 		struct buffer_head *bh = head;
 
 		do {
-			set_buffer_dirty(bh);
+			if (buffer_uptodate(bh)) {
+				BUFFER_TRACE(bh, "set dirty");
+				/* The following test can only succeed
+				 * if jbd is built in, not if it's a
+				 * module... */
+#ifdef CONFIG_JBD
+				if (buffer_jbd(bh)) {
+					struct journal_head *jh;
+
+					jh = journal_add_journal_head(bh);
+					WARN_ON(jh->b_jlist == BJ_Metadata);
+					journal_put_journal_head(jh);
+				}
+#endif
+				set_buffer_dirty(bh);
+			} else {
+				printk("%s: !uptodate buffer\n", __FUNCTION__);
+				buffer_assertion_failure(bh);
+			}
 			bh = bh->b_this_page;
 		} while (bh != head);
 	}
@@ -912,6 +947,7 @@ no_grow:
 		do {
 			bh = head;
 			head = head->b_this_page;
+			bh->b_this_page = NULL;
 			free_buffer_head(bh);
 		} while (head);
 	}
@@ -1143,6 +1179,7 @@ __getblk_slow(struct block_device *bdev,
  */
 void fastcall mark_buffer_dirty(struct buffer_head *bh)
 {
+	BUFFER_TRACE(bh, "entry");
 	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
 		__set_page_dirty_nobuffers(bh->b_page);
 }
@@ -1156,12 +1193,14 @@ void fastcall mark_buffer_dirty(struct b
  */
 void __brelse(struct buffer_head * buf)
 {
+	BUFFER_TRACE(buf, "entry");
 	if (atomic_read(&buf->b_count)) {
 		put_bh(buf);
 		return;
 	}
 	printk(KERN_ERR "VFS: brelse: Trying to free free buffer\n");
 	WARN_ON(1);
+	buffer_assertion_failure(buf);
 }
 
 /*
@@ -1170,6 +1209,7 @@ void __brelse(struct buffer_head * buf)
  */
 void __bforget(struct buffer_head *bh)
 {
+	BUFFER_TRACE(bh, "enter");
 	clear_buffer_dirty(bh);
 	if (!list_empty(&bh->b_assoc_buffers)) {
 		struct address_space *buffer_mapping = bh->b_page->mapping;
@@ -1433,6 +1473,7 @@ EXPORT_SYMBOL(set_bh_page);
  */
 static void discard_buffer(struct buffer_head * bh)
 {
+	BUFFER_TRACE(bh, "enter");
 	lock_buffer(bh);
 	clear_buffer_dirty(bh);
 	bh->b_bdev = NULL;
@@ -1554,6 +1595,7 @@ void unmap_underlying_metadata(struct bl
 
 	old_bh = __find_get_block_slow(bdev, block);
 	if (old_bh) {
+		BUFFER_TRACE(old_bh, "alias: unmap it");
 		clear_buffer_dirty(old_bh);
 		wait_on_buffer(old_bh);
 		clear_buffer_req(old_bh);
@@ -1634,6 +1676,7 @@ static int __block_write_full_page(struc
 			/*
 			 * The buffer was zeroed by block_write_full_page()
 			 */
+			BUFFER_TRACE(bh, "outside last_block");
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
@@ -1642,6 +1685,8 @@ static int __block_write_full_page(struc
 			if (err)
 				goto recover;
 			if (buffer_new(bh)) {
+				BUFFER_TRACE(bh, "new: call "
+						"unmap_underlying_metadata");
 				/* blockdev mappings never come here */
 				clear_buffer_new(bh);
 				unmap_underlying_metadata(bh->b_bdev,
@@ -1669,6 +1714,11 @@ static int __block_write_full_page(struc
 			continue;
 		}
 		if (test_clear_buffer_dirty(bh)) {
+			if (!buffer_uptodate(bh)) {
+				printk("%s: dirty non-uptodate buffer\n",
+						__FUNCTION__);
+				buffer_assertion_failure(bh);
+			}
 			mark_buffer_async_write(bh);
 		} else {
 			unlock_buffer(bh);
@@ -1730,6 +1780,7 @@ recover:
 	/* Recovery: lock and submit the mapped buffers */
 	do {
 		if (buffer_mapped(bh) && buffer_dirty(bh)) {
+			BUFFER_TRACE(bh, "lock it");
 			lock_buffer(bh);
 			mark_buffer_async_write(bh);
 		} else {
@@ -1796,9 +1847,12 @@ static int __block_prepare_write(struct 
 			if (err)
 				break;
 			if (buffer_new(bh)) {
+				BUFFER_TRACE(bh, "new: call "
+						"unmap_underlying_metadata");
 				unmap_underlying_metadata(bh->b_bdev,
 							bh->b_blocknr);
 				if (PageUptodate(page)) {
+					BUFFER_TRACE(bh, "setting uptodate");
 					set_buffer_uptodate(bh);
 					continue;
 				}
@@ -1819,13 +1873,16 @@ static int __block_prepare_write(struct 
 			}
 		}
 		if (PageUptodate(page)) {
-			if (!buffer_uptodate(bh))
+			if (!buffer_uptodate(bh)) {
+				BUFFER_TRACE(bh, "setting uptodate");
 				set_buffer_uptodate(bh);
+			}
 			continue; 
 		}
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
+			BUFFER_TRACE(bh, "reading");
 			ll_rw_block(READ, 1, &bh);
 			*wait_bh++=bh;
 		}
@@ -1869,6 +1926,7 @@ static int __block_prepare_write(struct 
 			flush_dcache_page(page);
 			kunmap_atomic(kaddr, KM_USER0);
 			set_buffer_uptodate(bh);
+			BUFFER_TRACE(bh, "mark dirty");
 			mark_buffer_dirty(bh);
 		}
 next_bh:
@@ -1897,6 +1955,7 @@ static int __block_commit_write(struct i
 				partial = 1;
 		} else {
 			set_buffer_uptodate(bh);
+			BUFFER_TRACE(bh, "mark dirty");
 			mark_buffer_dirty(bh);
 		}
 	}
@@ -2223,6 +2282,7 @@ static void end_buffer_read_nobh(struct 
 		set_buffer_uptodate(bh);
 	} else {
 		/* This happens, due to failed READA attempts. */
+		BUFFER_TRACE(bh, "clear uptodate");
 		clear_buffer_uptodate(bh);
 	}
 	unlock_buffer(bh);
@@ -2315,6 +2375,7 @@ int nobh_prepare_write(struct page *page
 			bh->b_data = (char *)(long)block_start;
 			bh->b_bdev = map_bh.b_bdev;
 			bh->b_private = NULL;
+			buffer_trace_init(&bh->b_history);
 			read_bh[nr_reads++] = bh;
 		}
 	}
@@ -2423,6 +2484,10 @@ int nobh_writepage(struct page *page, ge
 		 * they may have been added in ext3_writepage().  Make them
 		 * freeable here, so the page does not leak.
 		 */
+		if (page_has_buffers(page)) {
+			struct buffer_head *b = page_buffers(page);
+			BUFFER_TRACE(b, "EIO");
+		}
 #if 0
 		/* Not really sure about this  - do we need this ? */
 		if (page->mapping->a_ops->invalidatepage)
@@ -2432,6 +2497,11 @@ int nobh_writepage(struct page *page, ge
 		return 0; /* don't care */
 	}
 
+	if (page_has_buffers(page)) {
+		struct buffer_head *b = page_buffers(page);
+		BUFFER_TRACE(b, "partial");
+	}
+
 	/*
 	 * The page straddles i_size.  It must be zeroed out on each and every
 	 * writepage invocation because it may be mmapped.  "A file is mapped
@@ -2560,6 +2630,7 @@ int block_truncate_page(struct address_s
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr, KM_USER0);
 
+	BUFFER_TRACE(bh, "mark dirty");
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2618,8 +2689,10 @@ sector_t generic_block_bmap(struct addre
 {
 	struct buffer_head tmp;
 	struct inode *inode = mapping->host;
+
 	tmp.b_state = 0;
 	tmp.b_blocknr = 0;
+	tmp.b_page = NULL;
 	tmp.b_size = 1 << inode->i_blkbits;
 	get_block(inode, block, &tmp, 0);
 	return tmp.b_blocknr;
@@ -2647,9 +2720,11 @@ int submit_bh(int rw, struct buffer_head
 	struct bio *bio;
 	int ret = 0;
 
-	BUG_ON(!buffer_locked(bh));
-	BUG_ON(!buffer_mapped(bh));
-	BUG_ON(!bh->b_end_io);
+	BUFFER_TRACE(bh, "enter");
+
+	J_ASSERT_BH(bh, buffer_locked(bh));
+	J_ASSERT_BH(bh, buffer_mapped(bh));
+	J_ASSERT_BH(bh, bh->b_end_io != NULL);
 
 	if (buffer_ordered(bh) && (rw == WRITE))
 		rw = WRITE_BARRIER;
@@ -2661,6 +2736,11 @@ int submit_bh(int rw, struct buffer_head
 	if (test_set_buffer_req(bh) && (rw == WRITE || rw == WRITE_BARRIER))
 		clear_buffer_write_io_error(bh);
 
+	if (rw == WRITE)
+		BUFFER_TRACE(bh, "write");
+	else
+		BUFFER_TRACE(bh, "read");
+
 	/*
 	 * from here on down, it's all bio -- do the initial mapping,
 	 * submit_bio -> generic_make_request may further map this bio around
@@ -2871,6 +2951,7 @@ out:
 
 		do {
 			struct buffer_head *next = bh->b_this_page;
+			bh->b_this_page = NULL;
 			free_buffer_head(bh);
 			bh = next;
 		} while (bh != buffers_to_free);
@@ -2956,6 +3037,7 @@ struct buffer_head *alloc_buffer_head(gf
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
 		put_cpu_var(bh_accounting);
+		buffer_trace_init(&ret->b_history);
 	}
 	return ret;
 }
@@ -2963,7 +3045,16 @@ EXPORT_SYMBOL(alloc_buffer_head);
 
 void free_buffer_head(struct buffer_head *bh)
 {
-	BUG_ON(!list_empty(&bh->b_assoc_buffers));
+	J_ASSERT_BH(bh, bh->b_this_page == NULL);
+	J_ASSERT_BH(bh, list_empty(&bh->b_assoc_buffers));
+#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE)
+	if (buffer_jbd(bh)) {
+		J_ASSERT_BH(bh, bh2jh(bh)->b_transaction == 0);
+		J_ASSERT_BH(bh, bh2jh(bh)->b_next_transaction == 0);
+		J_ASSERT_BH(bh, bh2jh(bh)->b_frozen_data == 0);
+		J_ASSERT_BH(bh, bh2jh(bh)->b_committed_data == 0);
+	}
+#endif
 	kmem_cache_free(bh_cachep, bh);
 	get_cpu_var(bh_accounting).nr--;
 	recalc_bh_state();
diff -puN fs/direct-io.c~ext3-debug fs/direct-io.c
--- a/fs/direct-io.c~ext3-debug
+++ a/fs/direct-io.c
@@ -531,6 +531,7 @@ static int get_more_blocks(struct dio *d
 
 		map_bh->b_state = 0;
 		map_bh->b_size = fs_count << dio->inode->i_blkbits;
+		map_bh->b_page = 0;
 
 		create = dio->rw & WRITE;
 		if (dio->lock_type == DIO_LOCKING) {
diff -puN fs/ext3/inode.c~ext3-debug fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-debug
+++ a/fs/ext3/inode.c
@@ -1007,6 +1007,7 @@ struct buffer_head *ext3_getblk(handle_t
 
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
+	dummy.b_page = NULL;
 	buffer_trace_init(&dummy.b_history);
 	err = ext3_get_blocks_handle(handle, inode, block, 1,
 					&dummy, create, 1);
@@ -1513,6 +1514,11 @@ static int ext3_ordered_writepage(struct
 	walk_page_buffers(handle, page_bufs, 0,
 			PAGE_CACHE_SIZE, NULL, bget_one);
 
+	{
+		struct buffer_head *b = page_buffers(page);
+		BUFFER_TRACE(b, "call block_write_full_page");
+	}
+
 	ret = block_write_full_page(page, ext3_get_block, wbc);
 
 	/*
@@ -1914,6 +1920,7 @@ static int ext3_block_truncate_page(hand
 	} else {
 		if (ext3_should_order_data(inode))
 			err = ext3_journal_dirty_data(handle, bh);
+		BUFFER_TRACE(bh, "mark dirty");
 		mark_buffer_dirty(bh);
 	}
 
diff -puN fs/ext3/namei.c~ext3-debug fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-debug
+++ a/fs/ext3/namei.c
@@ -63,6 +63,7 @@ static struct buffer_head *ext3_append(h
 		EXT3_I(inode)->i_disksize = inode->i_size;
 		ext3_journal_get_write_access(handle,bh);
 	}
+	BUFFER_TRACE(bh, "exit");
 	return bh;
 }
 
@@ -343,6 +344,7 @@ dx_probe(struct dentry *dentry, struct i
 		dir = dentry->d_parent->d_inode;
 	if (!(bh = ext3_bread (NULL,dir, 0, 0, err)))
 		goto fail;
+	BUFFER_TRACE(bh, "bread it");
 	root = (struct dx_root *) bh->b_data;
 	if (root->info.hash_version != DX_HASH_TEA &&
 	    root->info.hash_version != DX_HASH_HALF_MD4 &&
@@ -417,18 +419,21 @@ dx_probe(struct dentry *dentry, struct i
 
 		at = p - 1;
 		dxtrace(printk(" %x->%u\n", at == entries? 0: dx_get_hash(at), dx_get_block(at)));
+		BUFFER_TRACE(bh, "add to frame");
 		frame->bh = bh;
 		frame->entries = entries;
 		frame->at = at;
 		if (!indirect--) return frame;
 		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
+		BUFFER_TRACE(bh, "read it");
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
 		assert (dx_get_limit(entries) == dx_node_limit (dir));
 		frame++;
 	}
 fail2:
 	while (frame >= frame_in) {
+		BUFFER_TRACE(bh, "brelse it");
 		brelse(frame->bh);
 		frame--;
 	}
@@ -441,8 +446,11 @@ static void dx_release (struct dx_frame 
 	if (frames[0].bh == NULL)
 		return;
 
-	if (((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels)
+	if (((struct dx_root *) frames[0].bh->b_data)->info.indirect_levels) {
+		BUFFER_TRACE(frames[1].bh, "brelse it");
 		brelse(frames[1].bh);
+	}
+	BUFFER_TRACE(frames[0].bh, "brelse it");
 	brelse(frames[0].bh);
 }
 
@@ -975,6 +983,8 @@ static struct buffer_head * ext3_dx_find
 			dx_release (frames);
 			return bh;
 		}
+		BUFFER_TRACE(bh, "brelse it");
+		BUFFER_TRACE(bh, "brelse it");
 		brelse (bh);
 		/* Check to see if we should continue to search */
 		retval = ext3_htree_next_block(dir, hash, frame,
@@ -1009,6 +1019,7 @@ static struct dentry *ext3_lookup(struct
 	inode = NULL;
 	if (bh) {
 		unsigned long ino = le32_to_cpu(de->inode);
+		BUFFER_TRACE(bh, "brelse it");
 		brelse (bh);
 		if (!ext3_valid_inum(dir->i_sb, ino)) {
 			ext3_error(dir->i_sb, "ext3_lookup",
@@ -1138,16 +1149,20 @@ static struct ext3_dir_entry_2 *do_split
 
 	bh2 = ext3_append (handle, dir, &newblock, error);
 	if (!(bh2)) {
+		BUFFER_TRACE(*bh, "brelse it");
 		brelse(*bh);
 		*bh = NULL;
 		goto errout;
 	}
 
+	BUFFER_TRACE(bh2, "using it");
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext3_journal_get_write_access(handle, *bh);
 	if (err) {
 	journal_error:
+		BUFFER_TRACE(*bh, "brelse");
 		brelse(*bh);
+		BUFFER_TRACE(bh2, "brelse");
 		brelse(bh2);
 		*bh = NULL;
 		ext3_std_error(dir->i_sb, err);
@@ -1183,6 +1198,8 @@ static struct ext3_dir_entry_2 *do_split
 	/* Which block gets the new entry? */
 	if (hinfo->hash >= hash2)
 	{
+		BUFFER_TRACE(*bh, "swapping");
+		BUFFER_TRACE(bh2, "swapping");
 		swap(*bh, bh2);
 		de = de2;
 	}
@@ -1191,8 +1208,11 @@ static struct ext3_dir_entry_2 *do_split
 	if (err)
 		goto journal_error;
 	err = ext3_journal_dirty_metadata (handle, frame->bh);
-	if (err)
+	if (err) {
+		BUFFER_TRACE(bh2, "error");
 		goto journal_error;
+	}
+	BUFFER_TRACE(*bh, "brelse");
 	brelse (bh2);
 	dxtrace(dx_show_index ("frame", frame->entries));
 errout:
@@ -1235,6 +1255,7 @@ static int add_dirent_to_buf(handle_t *h
 				return -EIO;
 			}
 			if (ext3_match (namelen, name, de)) {
+				BUFFER_TRACE(bh, "brelse");
 				brelse (bh);
 				return -EEXIST;
 			}
@@ -1292,6 +1313,7 @@ static int add_dirent_to_buf(handle_t *h
 	err = ext3_journal_dirty_metadata(handle, bh);
 	if (err)
 		ext3_std_error(dir->i_sb, err);
+	BUFFER_TRACE(bh, "brelse");
 	brelse(bh);
 	return 0;
 }
@@ -1322,6 +1344,7 @@ static int make_indexed_dir(handle_t *ha
 
 	blocksize =  dir->i_sb->s_blocksize;
 	dxtrace(printk("Creating index\n"));
+	BUFFER_TRACE(bh, "get write access");
 	retval = ext3_journal_get_write_access(handle, bh);
 	if (retval) {
 		ext3_std_error(dir->i_sb, retval);
@@ -1366,6 +1389,7 @@ static int make_indexed_dir(handle_t *ha
 	frame = frames;
 	frame->entries = entries;
 	frame->at = entries;
+	BUFFER_TRACE(bh, "adding to frame");
 	frame->bh = bh;
 	bh = bh2;
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
@@ -1421,6 +1445,7 @@ static int ext3_add_entry (handle_t *han
 		bh = ext3_bread(handle, dir, block, 0, &retval);
 		if(!bh)
 			return retval;
+		BUFFER_TRACE(bh, "read it");
 		retval = add_dirent_to_buf(handle, dentry, inode, NULL, bh);
 		if (retval != -ENOSPC)
 			return retval;
@@ -1435,6 +1460,7 @@ static int ext3_add_entry (handle_t *han
 	bh = ext3_append(handle, dir, &block, &retval);
 	if (!bh)
 		return retval;
+	BUFFER_TRACE(bh, "append returned it");
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
 	de->inode = 0;
 	de->rec_len = cpu_to_le16(blocksize);
@@ -1499,6 +1525,7 @@ static int ext3_dx_add_entry(handle_t *h
 		bh2 = ext3_append (handle, dir, &newblock, &err);
 		if (!(bh2))
 			goto cleanup;
+		BUFFER_TRACE(bh2, "append returned it");
 		node2 = (struct dx_node *)(bh2->b_data);
 		entries2 = node2->entries;
 		node2->fake.rec_len = cpu_to_le16(sb->s_blocksize);
@@ -1528,6 +1555,8 @@ static int ext3_dx_add_entry(handle_t *h
 			if (at - entries >= icount1) {
 				frame->at = at = at - entries - icount1 + entries2;
 				frame->entries = entries = entries2;
+				BUFFER_TRACE(frame->bh, "swap");
+				BUFFER_TRACE(bh2, "swap");
 				swap(frame->bh, bh2);
 			}
 			dx_insert_block (frames + 0, hash2, newblock);
@@ -1537,6 +1566,7 @@ static int ext3_dx_add_entry(handle_t *h
 			err = ext3_journal_dirty_metadata(handle, bh2);
 			if (err)
 				goto journal_error;
+			BUFFER_TRACE(bh2, "brelse");
 			brelse (bh2);
 		} else {
 			dxtrace(printk("Creating second level index...\n"));
@@ -1553,6 +1583,8 @@ static int ext3_dx_add_entry(handle_t *h
 			frame = frames + 1;
 			frame->at = at = at - entries + entries2;
 			frame->entries = entries = entries2;
+			BUFFER_TRACE(frame->bh, "overwrite");
+			BUFFER_TRACE(bh2, "add to frame");
 			frame->bh = bh2;
 			err = ext3_journal_get_write_access(handle,
 							     frame->bh);
@@ -1571,8 +1603,10 @@ static int ext3_dx_add_entry(handle_t *h
 journal_error:
 	ext3_std_error(dir->i_sb, err);
 cleanup:
-	if (bh)
+	if (bh) {
+		BUFFER_TRACE(bh, "brelse");
 		brelse(bh);
+	}
 	dx_release(frames);
 	return err;
 }
diff -puN fs/ext3/super.c~ext3-debug fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-debug
+++ a/fs/ext3/super.c
@@ -42,6 +42,10 @@
 #include "acl.h"
 #include "namei.h"
 
+#ifdef CONFIG_JBD_DEBUG
+static int ext3_ro_after; /* Make fs read-only after this many jiffies */
+#endif
+
 static int ext3_load_journal(struct super_block *, struct ext3_super_block *,
 			     unsigned long journal_devnum);
 static int ext3_create_journal(struct super_block *, struct ext3_super_block *,
@@ -62,6 +66,65 @@ static void ext3_unlockfs(struct super_b
 static void ext3_write_super (struct super_block * sb);
 static void ext3_write_super_lockfs(struct super_block *sb);
 
+#ifdef CONFIG_JBD_DEBUG
+struct block_device *journal_no_write[2];
+
+/*
+ * Debug code for turning filesystems "read-only" after a specified
+ * amount of time.  This is for crash/recovery testing.
+ */
+
+static void make_rdonly(struct block_device *bdev,
+			struct block_device **no_write)
+{
+	char b[BDEVNAME_SIZE];
+
+	if (bdev) {
+		printk(KERN_WARNING "Turning device %s read-only\n",
+		       bdevname(bdev, b));
+		*no_write = bdev;
+	}
+}
+
+static void turn_fs_readonly(unsigned long arg)
+{
+	struct super_block *sb = (struct super_block *)arg;
+
+	make_rdonly(sb->s_bdev, &journal_no_write[0]);
+	make_rdonly(EXT3_SB(sb)->s_journal->j_dev, &journal_no_write[1]);
+	wake_up(&EXT3_SB(sb)->ro_wait_queue);
+}
+
+static void setup_ro_after(struct super_block *sb)
+{
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	init_timer(&sbi->turn_ro_timer);
+	if (ext3_ro_after) {
+		printk(KERN_DEBUG "fs will go read-only in %d jiffies\n",
+		       ext3_ro_after);
+		init_waitqueue_head(&sbi->ro_wait_queue);
+		journal_no_write[0] = NULL;
+		journal_no_write[1] = NULL;
+		sbi->turn_ro_timer.function = turn_fs_readonly;
+		sbi->turn_ro_timer.data = (unsigned long)sb;
+		sbi->turn_ro_timer.expires = jiffies + ext3_ro_after;
+		ext3_ro_after = 0;
+		add_timer(&sbi->turn_ro_timer);
+	}
+}
+
+static void clear_ro_after(struct super_block *sb)
+{
+	del_timer_sync(&EXT3_SB(sb)->turn_ro_timer);
+	journal_no_write[0] = NULL;
+	journal_no_write[1] = NULL;
+	ext3_ro_after = 0;
+}
+#else
+#define setup_ro_after(sb)	do {} while (0)
+#define clear_ro_after(sb)	do {} while (0)
+#endif
+
 /*
  * Wrappers for journal_start/end.
  *
@@ -431,6 +494,7 @@ static void ext3_put_super (struct super
 		invalidate_bdev(sbi->journal_bdev, 0);
 		ext3_blkdev_remove(sbi);
 	}
+	clear_ro_after(sb);
 	sb->s_fs_info = NULL;
 	kfree(sbi);
 	return;
@@ -670,6 +734,7 @@ enum {
 	Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
 	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_nouid32, Opt_nocheck, Opt_debug, Opt_oldalloc, Opt_orlov,
+	Opt_ro_after,
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
@@ -699,6 +764,7 @@ static match_table_t tokens = {
 	{Opt_debug, "debug"},
 	{Opt_oldalloc, "oldalloc"},
 	{Opt_orlov, "orlov"},
+	{Opt_ro_after, "ro_after"},
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_acl, "acl"},
@@ -832,6 +898,13 @@ static int parse_options (char *options,
 		case Opt_orlov:
 			clear_opt (sbi->s_mount_opt, OLDALLOC);
 			break;
+#ifdef CONFIG_JBD_DEBUG
+		case Opt_ro_after:
+			if (match_int(&args[0], &option))
+				return 0;
+			ext3_ro_after = option;
+			break;
+#endif
 #ifdef CONFIG_EXT3_FS_XATTR
 		case Opt_user_xattr:
 			set_opt (sbi->s_mount_opt, XATTR_USER);
@@ -1167,6 +1240,7 @@ static int ext3_setup_super(struct super
 	} else {
 		printk("internal journal\n");
 	}
+	setup_ro_after(sb);
 	return res;
 }
 
@@ -1410,6 +1484,10 @@ static int ext3_fill_super (struct super
 	int needs_recovery;
 	__le32 features;
 
+#ifdef CONFIG_JBD_DEBUG
+	ext3_ro_after = 0;
+#endif
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
@@ -1417,6 +1495,7 @@ static int ext3_fill_super (struct super
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT3_DEF_RESUID;
 	sbi->s_resgid = EXT3_DEF_RESGID;
+	setup_ro_after(sb);
 
 	unlock_kernel();
 
@@ -2165,6 +2244,8 @@ static void ext3_clear_journal_err(struc
 
 	journal = EXT3_SB(sb)->s_journal;
 
+	clear_ro_after(sb);
+
 	/*
 	 * Now check for any error status which may have been recorded in the
 	 * journal by a prior ext3_error() or ext3_abort()
@@ -2231,6 +2312,7 @@ static int ext3_sync_fs(struct super_blo
 		if (wait)
 			log_wait_commit(EXT3_SB(sb)->s_journal, target);
 	}
+	setup_ro_after(sb);
 	return 0;
 }
 
diff -puN fs/ext3/xattr.c~ext3-debug fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext3-debug
+++ a/fs/ext3/xattr.c
@@ -479,12 +479,14 @@ ext3_xattr_release_block(handle_t *handl
 	ce = mb_cache_entry_get(ext3_xattr_cache, bh->b_bdev, bh->b_blocknr);
 	if (BHDR(bh)->h_refcount == cpu_to_le32(1)) {
 		ea_bdebug(bh, "refcount now=0; freeing");
+		BUFFER_TRACE(bh, "xattr delete");
 		if (ce)
 			mb_cache_entry_free(ce);
 		ext3_free_blocks(handle, inode, bh->b_blocknr, 1);
 		get_bh(bh);
 		ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
+		BUFFER_TRACE(bh, "xattr deref");
 		if (ext3_journal_get_write_access(handle, bh) == 0) {
 			lock_buffer(bh);
 			BHDR(bh)->h_refcount = cpu_to_le32(
@@ -755,6 +757,7 @@ ext3_xattr_block_set(handle_t *handle, s
 inserted:
 	if (!IS_LAST_ENTRY(s->first)) {
 		new_bh = ext3_xattr_cache_find(inode, header(s->base), &ce);
+		BUFFER_TRACE2(new_bh, bs->bh, "xattr cache looked up");
 		if (new_bh) {
 			/* We found an identical block in the cache. */
 			if (new_bh == bs->bh)
@@ -800,6 +803,7 @@ inserted:
 			ea_idebug(inode, "creating block %d", block);
 
 			new_bh = sb_getblk(sb, block);
+			BUFFER_TRACE(new_bh, "new xattr block");
 			if (!new_bh) {
 getblk_failed:
 				ext3_free_blocks(handle, inode, block, 1);
diff -puN /dev/null fs/jbd-kernel.c
--- /dev/null
+++ a/fs/jbd-kernel.c
@@ -0,0 +1,255 @@
+/*
+ * fs/jbd-kernel.c
+ *
+ * Support code for the Journalling Block Device layer.
+ * This file contains things which have to be in-kernel when
+ * JBD is a module.
+ *
+ * 15 May 2001	Andrew Morton <andrewm@uow.edu.au>
+ *	Created
+ */
+
+#include <linux/fs.h>
+#include <linux/jbd.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+
+/*
+ * Some sanity testing which is called from mark_buffer_clean(),
+ * and must be present in the main kernel.
+ */
+
+void jbd_preclean_buffer_check(struct buffer_head *bh)
+{
+	if (buffer_jbd(bh)) {
+		struct journal_head *jh = bh2jh(bh);
+
+		transaction_t *transaction = jh->b_transaction;
+		journal_t *journal;
+
+		if (jh->b_jlist == 0 && transaction == NULL)
+			return;
+
+		J_ASSERT_JH(jh, transaction != NULL);
+		/* The kernel may be unmapping old data.  We expect it
+		 * to be dirty in that case, unless the buffer has
+		 * already been forgotten by a transaction. */
+		if (jh->b_jlist != BJ_Forget) {
+#if 1
+			if (!buffer_dirty(bh)) {
+				printk("%s: clean of clean buffer\n",
+					__FUNCTION__);
+				print_buffer_trace(bh);
+				return;
+			}
+#endif
+			J_ASSERT_BH(bh, buffer_dirty(bh));
+		}
+
+		journal = transaction->t_journal;
+		J_ASSERT_JH(jh,
+			    transaction == journal->j_running_transaction ||
+			    transaction == journal->j_committing_transaction);
+	}
+}
+EXPORT_SYMBOL(jbd_preclean_buffer_check);
+
+/*
+ * Support functions for BUFFER_TRACE()
+ */
+
+static spinlock_t trace_lock = SPIN_LOCK_UNLOCKED;
+
+void buffer_trace(const char *function, struct buffer_head *dest,
+		struct buffer_head *src, char *info)
+{
+	struct buffer_history_item *bhist_i;
+	struct page *page;
+	unsigned long flags;
+
+	if (dest == 0 || src == 0)
+		return;
+
+	spin_lock_irqsave(&trace_lock, flags);
+
+	/*
+	 * Sometimes we don't initialise the ring pointers. (locally declared
+	 * temp buffer_heads). Feebly attempt to detect and correct that here.
+	 */
+	if ((dest->b_history.b_history_head - dest->b_history.b_history_tail >
+				BUFFER_HISTORY_SIZE)) {
+		dest->b_history.b_history_head = 0;
+		dest->b_history.b_history_tail = 0;
+	}
+	bhist_i = dest->b_history.b +
+		(dest->b_history.b_history_head & (BUFFER_HISTORY_SIZE - 1));
+	bhist_i->function = function;
+	bhist_i->info = info;
+	bhist_i->b_state = src->b_state;
+	page = src->b_page;
+	if (page)
+		bhist_i->pg_dirty = !!PageDirty(page);
+	else
+		bhist_i->pg_dirty = 0;
+
+#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE)
+	bhist_i->b_trans_is_running = 0;
+	bhist_i->b_trans_is_committing = 0;
+	bhist_i->b_blocknr = src->b_blocknr;
+	if (buffer_jbd(src)) {
+		struct journal_head *jh;
+		journal_t *journal;
+		transaction_t *transaction;
+
+		/* Footwork to avoid racing with journal_remove_journal_head */
+		jh = src->b_private;
+		if (jh == 0)
+			goto raced;
+		transaction = jh->b_transaction;
+		if (src->b_private == 0)
+			goto raced;
+		bhist_i->b_jcount = jh->b_jcount;
+		bhist_i->b_jbd = 1;
+		bhist_i->b_jlist = jh->b_jlist;
+		bhist_i->b_frozen_data = jh->b_frozen_data;
+		bhist_i->b_committed_data = jh->b_committed_data;
+		bhist_i->b_transaction = !!jh->b_transaction;
+		bhist_i->b_next_transaction = !!jh->b_next_transaction;
+		bhist_i->b_cp_transaction = !!jh->b_cp_transaction;
+
+		if (transaction) {
+			journal = transaction->t_journal;
+			bhist_i->b_trans_is_running = transaction ==
+					journal->j_running_transaction;
+			bhist_i->b_trans_is_committing = transaction ==
+					journal->j_committing_transaction;
+		}
+	} else {
+raced:
+		bhist_i->b_jcount = 0;
+		bhist_i->b_jbd = 0;
+		bhist_i->b_jlist = 0;
+		bhist_i->b_frozen_data = 0;
+		bhist_i->b_committed_data = 0;
+		bhist_i->b_transaction = 0;
+		bhist_i->b_next_transaction = 0;
+		bhist_i->b_cp_transaction = 0;
+	}
+#endif	/* defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE) */
+
+	bhist_i->cpu = smp_processor_id();
+	bhist_i->b_count = atomic_read(&src->b_count);
+
+	dest->b_history.b_history_head++;
+	if (dest->b_history.b_history_head - dest->b_history.b_history_tail >
+				BUFFER_HISTORY_SIZE)
+		dest->b_history.b_history_tail =
+			dest->b_history.b_history_head - BUFFER_HISTORY_SIZE;
+
+	spin_unlock_irqrestore(&trace_lock, flags);
+}
+
+static const char *b_jlist_to_string(unsigned int b_list)
+{
+	switch (b_list) {
+#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE)
+	case BJ_None:		return "BJ_None";
+	case BJ_SyncData:	return "BJ_SyncData";
+	case BJ_Metadata:	return "BJ_Metadata";
+	case BJ_Forget:		return "BJ_Forget";
+	case BJ_IO:		return "BJ_IO";
+	case BJ_Shadow:		return "BJ_Shadow";
+	case BJ_LogCtl:		return "BJ_LogCtl";
+	case BJ_Reserved:	return "BJ_Reserved";
+	case BJ_Locked:		return "BJ_Locked";
+#endif
+	default:		return "Bad b_jlist";
+	}
+}
+
+static void print_one_hist(struct buffer_history_item *bhist_i)
+{
+	printk(" %s():%s\n", bhist_i->function, bhist_i->info);
+	printk("     b_state:0x%lx b_jlist:%s cpu:%d b_count:%d b_blocknr:%lu\n",
+			bhist_i->b_state,
+			b_jlist_to_string(bhist_i->b_jlist),
+			bhist_i->cpu,
+			bhist_i->b_count,
+			bhist_i->b_blocknr);
+#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE)
+	printk("     b_jbd:%u b_frozen_data:%p b_committed_data:%p\n",
+			bhist_i->b_jbd,
+			bhist_i->b_frozen_data,
+			bhist_i->b_committed_data);
+	printk("     b_transaction:%u b_next_transaction:%u "
+			"b_cp_transaction:%u b_trans_is_running:%u\n",
+			bhist_i->b_transaction,
+			bhist_i->b_next_transaction,
+			bhist_i->b_cp_transaction,
+			bhist_i->b_trans_is_running);
+	printk("     b_trans_is_comitting:%u b_jcount:%u pg_dirty:%u",
+			bhist_i->b_trans_is_committing,
+			bhist_i->b_jcount,
+			bhist_i->pg_dirty);
+#endif
+	printk("\n");
+}
+
+void print_buffer_fields(struct buffer_head *bh)
+{
+	printk("b_blocknr:%llu b_count:%d\n",
+		(unsigned long long)bh->b_blocknr, atomic_read(&bh->b_count));
+	printk("b_this_page:%p b_data:%p b_page:%p\n",
+			bh->b_this_page, bh->b_data, bh->b_page);
+#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE)
+	if (buffer_jbd(bh)) {
+		struct journal_head *jh = bh2jh(bh);
+
+		printk("b_jlist:%u b_frozen_data:%p b_committed_data:%p\n",
+			jh->b_jlist, jh->b_frozen_data, jh->b_committed_data);
+		printk(" b_transaction:%p b_next_transaction:%p "
+				"b_cp_transaction:%p\n",
+			jh->b_transaction, jh->b_next_transaction,
+			jh->b_cp_transaction);
+		printk("b_cpnext:%p b_cpprev:%p\n",
+			jh->b_cpnext, jh->b_cpprev);
+	}
+#endif
+}
+
+void print_buffer_trace(struct buffer_head *bh)
+{
+	unsigned long idx, count;
+	unsigned long flags;
+
+	printk("buffer trace for buffer at 0x%p (I am CPU %d)\n",
+			bh, smp_processor_id());
+	BUFFER_TRACE(bh, "");		/* Record state now */
+
+	spin_lock_irqsave(&trace_lock, flags);
+	for (	idx = bh->b_history.b_history_tail, count = 0;
+		idx < bh->b_history.b_history_head &&
+			count < BUFFER_HISTORY_SIZE;
+		idx++, count++)
+		print_one_hist(bh->b_history.b +
+			(idx & (BUFFER_HISTORY_SIZE - 1)));
+
+	print_buffer_fields(bh);
+	spin_unlock_irqrestore(&trace_lock, flags);
+	dump_stack();
+	printk("\n");
+}
+
+static struct buffer_head *failed_buffer_head;	/* For access with debuggers */
+
+void buffer_assertion_failure(struct buffer_head *bh)
+{
+	console_verbose();
+	failed_buffer_head = bh;
+	print_buffer_trace(bh);
+}
+EXPORT_SYMBOL(buffer_trace);
+EXPORT_SYMBOL(print_buffer_trace);
+EXPORT_SYMBOL(buffer_assertion_failure);
+EXPORT_SYMBOL(print_buffer_fields);
diff -puN fs/jbd/commit.c~ext3-debug fs/jbd/commit.c
--- a/fs/jbd/commit.c~ext3-debug
+++ a/fs/jbd/commit.c
@@ -28,10 +28,12 @@
 static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 {
 	BUFFER_TRACE(bh, "");
-	if (uptodate)
+	if (uptodate) {
 		set_buffer_uptodate(bh);
-	else
+	} else {
+		BUFFER_TRACE(bh, "clear uptodate");
 		clear_buffer_uptodate(bh);
+	}
 	unlock_buffer(bh);
 }
 
@@ -255,7 +257,7 @@ write_out_data:
 			put_bh(bh);
 		} else {
 			BUFFER_TRACE(bh, "writeout complete: unfile");
-			__journal_unfile_buffer(jh);
+			__journal_unfile_buffer(journal, jh);
 			jbd_unlock_bh_state(bh);
 			if (locked)
 				unlock_buffer(bh);
@@ -454,7 +456,7 @@ void journal_commit_transaction(journal_
 			continue;
 		}
 		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
-			__journal_unfile_buffer(jh);
+			__journal_unfile_buffer(journal, jh);
 			jbd_unlock_bh_state(bh);
 			journal_remove_journal_head(bh);
 			put_bh(bh);
@@ -826,6 +828,7 @@ restart_loop:
 		 * behind for writeback and gets reallocated for another
 		 * use in a different page. */
 		if (buffer_freed(bh)) {
+			BUFFER_TRACE(bh, "buffer_freed");
 			clear_buffer_freed(bh);
 			clear_buffer_jbddirty(bh);
 		}
@@ -834,9 +837,11 @@ restart_loop:
 			JBUFFER_TRACE(jh, "add to new checkpointing trans");
 			__journal_insert_checkpoint(jh, commit_transaction);
 			JBUFFER_TRACE(jh, "refile for checkpoint writeback");
-			__journal_refile_buffer(jh);
+			__journal_refile_buffer(journal, jh);
+			JBUFFER_TRACE(jh, "did writepage hack");
 			jbd_unlock_bh_state(bh);
 		} else {
+			BUFFER_TRACE(bh, "not jbddirty");
 			J_ASSERT_BH(bh, !buffer_dirty(bh));
 			/* The buffer on BJ_Forget list and not jbddirty means
 			 * it has been freed by this transaction and hence it
@@ -846,7 +851,7 @@ restart_loop:
 			 * disk and before we process the buffer on BJ_Forget
 			 * list. */
 			JBUFFER_TRACE(jh, "refile or unfile freed buffer");
-			__journal_refile_buffer(jh);
+			__journal_refile_buffer(journal, jh);
 			if (!jh->b_transaction) {
 				jbd_unlock_bh_state(bh);
 				 /* needs a brelse */
diff -puN fs/jbd/transaction.c~ext3-debug fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~ext3-debug
+++ a/fs/jbd/transaction.c
@@ -27,7 +27,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
-static void __journal_temp_unlink_buffer(struct journal_head *jh);
+static void __journal_temp_unlink_buffer(journal_t *journal,
+					struct journal_head *jh);
 
 /*
  * get_transaction: obtain a new transaction_t object.
@@ -1049,7 +1050,7 @@ int journal_dirty_data(handle_t *handle,
 			/* journal_clean_data_list() may have got there first */
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
-				__journal_temp_unlink_buffer(jh);
+				__journal_temp_unlink_buffer(journal, jh);
 				/* It still points to the committing
 				 * transaction; move it to this one so
 				 * that the refile assert checks are
@@ -1068,7 +1069,7 @@ int journal_dirty_data(handle_t *handle,
 		if (jh->b_jlist != BJ_SyncData && jh->b_jlist != BJ_Locked) {
 			JBUFFER_TRACE(jh, "not on correct data list: unfile");
 			J_ASSERT_JH(jh, jh->b_jlist != BJ_Shadow);
-			__journal_temp_unlink_buffer(jh);
+			__journal_temp_unlink_buffer(journal, jh);
 			jh->b_transaction = handle->h_transaction;
 			JBUFFER_TRACE(jh, "file as data");
 			__journal_file_buffer(jh, handle->h_transaction,
@@ -1264,10 +1265,10 @@ int journal_forget (handle_t *handle, st
 		 */
 
 		if (jh->b_cp_transaction) {
-			__journal_temp_unlink_buffer(jh);
+			__journal_temp_unlink_buffer(journal, jh);
 			__journal_file_buffer(jh, transaction, BJ_Forget);
 		} else {
-			__journal_unfile_buffer(jh);
+			__journal_unfile_buffer(journal, jh);
 			journal_remove_journal_head(bh);
 			__brelse(bh);
 			if (!buffer_jbd(bh)) {
@@ -1457,6 +1458,8 @@ int journal_force_commit(journal_t *jour
 static inline void
 __blist_add_buffer(struct journal_head **list, struct journal_head *jh)
 {
+	J_ASSERT_JH(jh, jh->b_tnext == NULL);
+	J_ASSERT_JH(jh, jh->b_tprev == NULL);
 	if (!*list) {
 		jh->b_tnext = jh->b_tprev = jh;
 		*list = jh;
@@ -1481,6 +1484,8 @@ __blist_add_buffer(struct journal_head *
 static inline void
 __blist_del_buffer(struct journal_head **list, struct journal_head *jh)
 {
+	J_ASSERT_JH(jh, jh->b_tnext != NULL);
+	J_ASSERT_JH(jh, jh->b_tprev != NULL);
 	if (*list == jh) {
 		*list = jh->b_tnext;
 		if (*list == jh)
@@ -1488,6 +1493,8 @@ __blist_del_buffer(struct journal_head *
 	}
 	jh->b_tprev->b_tnext = jh->b_tnext;
 	jh->b_tnext->b_tprev = jh->b_tprev;
+	jh->b_tprev = NULL;
+	jh->b_tnext = NULL;
 }
 
 /*
@@ -1501,7 +1508,8 @@ __blist_del_buffer(struct journal_head *
  *
  * Called under j_list_lock.  The journal may not be locked.
  */
-static void __journal_temp_unlink_buffer(struct journal_head *jh)
+static void __journal_temp_unlink_buffer(journal_t *journal,
+					struct journal_head *jh)
 {
 	struct journal_head **list = NULL;
 	transaction_t *transaction;
@@ -1553,9 +1561,9 @@ static void __journal_temp_unlink_buffer
 		mark_buffer_dirty(bh);	/* Expose it to the VM */
 }
 
-void __journal_unfile_buffer(struct journal_head *jh)
+void __journal_unfile_buffer(journal_t *journal, struct journal_head *jh)
 {
-	__journal_temp_unlink_buffer(jh);
+	__journal_temp_unlink_buffer(journal, jh);
 	jh->b_transaction = NULL;
 }
 
@@ -1563,7 +1571,7 @@ void journal_unfile_buffer(journal_t *jo
 {
 	jbd_lock_bh_state(jh2bh(jh));
 	spin_lock(&journal->j_list_lock);
-	__journal_unfile_buffer(jh);
+	__journal_unfile_buffer(journal, jh);
 	spin_unlock(&journal->j_list_lock);
 	jbd_unlock_bh_state(jh2bh(jh));
 }
@@ -1591,7 +1599,7 @@ __journal_try_to_free_buffer(journal_t *
 		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
 			/* A written-back ordered data buffer */
 			JBUFFER_TRACE(jh, "release data");
-			__journal_unfile_buffer(jh);
+			__journal_unfile_buffer(journal, jh);
 			journal_remove_journal_head(bh);
 			__brelse(bh);
 		}
@@ -1696,7 +1704,8 @@ static int __dispose_buffer(struct journ
 	int may_free = 1;
 	struct buffer_head *bh = jh2bh(jh);
 
-	__journal_unfile_buffer(jh);
+	JBUFFER_TRACE(jh, "unfile");
+	__journal_unfile_buffer(transaction->t_journal, jh);
 
 	if (jh->b_cp_transaction) {
 		JBUFFER_TRACE(jh, "on running+cp transaction");
@@ -1950,6 +1959,7 @@ void __journal_file_buffer(struct journa
 	int was_dirty = 0;
 	struct buffer_head *bh = jh2bh(jh);
 
+	BUFFER_TRACE(bh, "entry");
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
 	assert_spin_locked(&transaction->t_journal->j_list_lock);
 
@@ -1972,7 +1982,7 @@ void __journal_file_buffer(struct journa
 	}
 
 	if (jh->b_transaction)
-		__journal_temp_unlink_buffer(jh);
+		__journal_temp_unlink_buffer(transaction->t_journal, jh);
 	jh->b_transaction = transaction;
 
 	switch (jlist) {
@@ -2012,6 +2022,7 @@ void __journal_file_buffer(struct journa
 
 	if (was_dirty)
 		set_buffer_jbddirty(bh);
+	BUFFER_TRACE(bh, "filed");
 }
 
 void journal_file_buffer(struct journal_head *jh,
@@ -2034,18 +2045,20 @@ void journal_file_buffer(struct journal_
  *
  * Called under jbd_lock_bh_state(jh2bh(jh))
  */
-void __journal_refile_buffer(struct journal_head *jh)
+void __journal_refile_buffer(journal_t *journal, struct journal_head *jh)
 {
 	int was_dirty;
 	struct buffer_head *bh = jh2bh(jh);
 
+	JBUFFER_TRACE(jh, "entry");
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
 	if (jh->b_transaction)
 		assert_spin_locked(&jh->b_transaction->t_journal->j_list_lock);
 
 	/* If the buffer is now unused, just drop it. */
 	if (jh->b_next_transaction == NULL) {
-		__journal_unfile_buffer(jh);
+		BUFFER_TRACE(bh, "unfile");
+		__journal_unfile_buffer(journal, jh);
 		return;
 	}
 
@@ -2055,7 +2068,7 @@ void __journal_refile_buffer(struct jour
 	 */
 
 	was_dirty = test_clear_buffer_jbddirty(bh);
-	__journal_temp_unlink_buffer(jh);
+	__journal_temp_unlink_buffer(journal, jh);
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
 	__journal_file_buffer(jh, jh->b_transaction,
@@ -2087,7 +2100,7 @@ void journal_refile_buffer(journal_t *jo
 	jbd_lock_bh_state(bh);
 	spin_lock(&journal->j_list_lock);
 
-	__journal_refile_buffer(jh);
+	__journal_refile_buffer(journal, jh);
 	jbd_unlock_bh_state(bh);
 	journal_remove_journal_head(bh);
 
diff -puN /dev/null include/linux/buffer-trace.h
--- /dev/null
+++ a/include/linux/buffer-trace.h
@@ -0,0 +1,83 @@
+/*
+ * include/linux/buffer-trace.h
+ *
+ * Debugging support for recording buffer_head state transitions
+ *
+ * May 2001, akpm
+ *	Created
+ */
+
+#ifndef BUFFER_TRACE_H_INCLUDED
+#define BUFFER_TRACE_H_INCLUDED
+
+#ifdef CONFIG_BUFFER_DEBUG
+
+/* The number of records per buffer_head.  Must be a power of two */
+#define BUFFER_HISTORY_SIZE	32
+
+struct buffer_head;
+
+/* This gets embedded in struct buffer_head */
+struct buffer_history {
+	struct buffer_history_item {
+		const char *function;
+		char *info;
+		unsigned long b_state;
+		unsigned b_list:3;
+		unsigned b_jlist:4;
+		unsigned pg_dirty:1;
+		unsigned cpu:3;
+		unsigned b_count:8;
+		unsigned long b_blocknr;	/* For src != dest */
+#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE)
+		unsigned b_jcount:4;
+		unsigned b_jbd:1;
+		unsigned b_transaction:1;
+		unsigned b_next_transaction:1;
+		unsigned b_cp_transaction:1;
+		unsigned b_trans_is_running:1;
+		unsigned b_trans_is_committing:1;
+		void *b_frozen_data;
+		void *b_committed_data;
+#endif
+	} b[BUFFER_HISTORY_SIZE];
+	unsigned long b_history_head;	/* Next place to write */
+	unsigned long b_history_tail;	/* Oldest valid entry */
+};
+
+static inline void buffer_trace_init(struct buffer_history *bhist)
+{
+	bhist->b_history_head = 0;
+	bhist->b_history_tail = 0;
+}
+extern void buffer_trace(const char *function, struct buffer_head *dest,
+			struct buffer_head *src, char *info);
+extern void print_buffer_fields(struct buffer_head *bh);
+extern void print_buffer_trace(struct buffer_head *bh);
+
+#define BUFFER_STRINGIFY2(X)		#X
+#define BUFFER_STRINGIFY(X)		BUFFER_STRINGIFY2(X)
+
+#define BUFFER_TRACE2(dest, src, info)				\
+	do {							\
+		buffer_trace(__FUNCTION__, (dest), (src),	\
+			"["__FILE__":"				\
+			BUFFER_STRINGIFY(__LINE__)"] " info);	\
+	} while (0)
+
+#define BUFFER_TRACE(bh, info) BUFFER_TRACE2(bh, bh, info)
+#define JBUFFER_TRACE(jh, info)	BUFFER_TRACE(jh2bh(jh), info)
+
+#else		/* CONFIG_BUFFER_DEBUG */
+
+#define buffer_trace_init(bh)	do {} while (0)
+#define print_buffer_fields(bh)	do {} while (0)
+#define print_buffer_trace(bh)	do {} while (0)
+#define BUFFER_TRACE(bh, info)	do {} while (0)
+#define BUFFER_TRACE2(bh, bh2, info)	do {} while (0)
+#define JBUFFER_TRACE(jh, info)	do {} while (0)
+
+#endif		/* CONFIG_BUFFER_DEBUG */
+
+#endif		/* BUFFER_TRACE_H_INCLUDED */
+
diff -puN include/linux/buffer_head.h~ext3-debug include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~ext3-debug
+++ a/include/linux/buffer_head.h
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/wait.h>
 #include <asm/atomic.h>
+#include <linux/buffer-trace.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -73,6 +74,9 @@ struct buffer_head {
 	struct address_space *b_assoc_map;	/* mapping this buffer is
 						   associated with */
 	atomic_t b_count;		/* users using this buffer_head */
+#ifdef CONFIG_BUFFER_DEBUG
+	struct buffer_history b_history;
+#endif
 };
 
 /*
diff -puN include/linux/jbd.h~ext3-debug include/linux/jbd.h
--- a/include/linux/jbd.h~ext3-debug
+++ a/include/linux/jbd.h
@@ -43,7 +43,7 @@
  * hardware _can_ fail, but for debugging purposes when running tests on
  * known-good hardware we may want to trap these errors.
  */
-#undef JBD_PARANOID_IOFAIL
+#define JBD_PARANOID_IOFAIL
 
 /*
  * The default maximum commit age, in seconds.
@@ -57,7 +57,9 @@
  * CONFIG_JBD_DEBUG is on.
  */
 #define JBD_EXPENSIVE_CHECKING
+
 extern int journal_enable_debug;
+extern struct block_device *journal_no_write[2];
 
 #define jbd_debug(n, f, a...)						\
 	do {								\
@@ -270,6 +272,7 @@ void buffer_assertion_failure(struct buf
 #else
 #define J_ASSERT_BH(bh, expr)	J_ASSERT(expr)
 #define J_ASSERT_JH(jh, expr)	J_ASSERT(expr)
+#define buffer_assertion_failure(bh) do { } while (0)
 #endif
 
 #else
@@ -277,9 +280,9 @@ void buffer_assertion_failure(struct buf
 #endif		/* JBD_ASSERTIONS */
 
 #if defined(JBD_PARANOID_IOFAIL)
-#define J_EXPECT(expr, why...)		J_ASSERT(expr)
-#define J_EXPECT_BH(bh, expr, why...)	J_ASSERT_BH(bh, expr)
-#define J_EXPECT_JH(jh, expr, why...)	J_ASSERT_JH(jh, expr)
+#define J_EXPECT(expr, why...)		({ J_ASSERT(expr); 1; })
+#define J_EXPECT_BH(bh, expr, why...)	({ J_ASSERT_BH(bh, expr); 1; })
+#define J_EXPECT_JH(jh, expr, why...)	({ J_ASSERT_JH(jh, expr); 1; })
 #else
 #define __journal_expect(expr, why...)					     \
 	({								     \
@@ -840,8 +843,8 @@ struct journal_s
 
 /* Filing buffers */
 extern void journal_unfile_buffer(journal_t *, struct journal_head *);
-extern void __journal_unfile_buffer(struct journal_head *);
-extern void __journal_refile_buffer(struct journal_head *);
+extern void __journal_unfile_buffer(journal_t *, struct journal_head *);
+extern void __journal_refile_buffer(journal_t *, struct journal_head *);
 extern void journal_refile_buffer(journal_t *, struct journal_head *);
 extern void __journal_file_buffer(struct journal_head *, transaction_t *, int);
 extern void __journal_free_buffer(struct journal_head *bh);
@@ -1069,6 +1072,8 @@ static inline int jbd_space_needed(journ
  * Definitions which augment the buffer_head layer
  */
 
+/* JBD additions */
+
 /* journaling buffer types */
 #define BJ_None		0	/* Not journaled */
 #define BJ_SyncData	1	/* Normal data: flush before commit */
@@ -1085,13 +1090,6 @@ extern int jbd_blocks_per_page(struct in
 
 #ifdef __KERNEL__
 
-#define buffer_trace_init(bh)	do {} while (0)
-#define print_buffer_fields(bh)	do {} while (0)
-#define print_buffer_trace(bh)	do {} while (0)
-#define BUFFER_TRACE(bh, info)	do {} while (0)
-#define BUFFER_TRACE2(bh, bh2, info)	do {} while (0)
-#define JBUFFER_TRACE(jh, info)	do {} while (0)
-
 #endif	/* __KERNEL__ */
 
 #endif	/* _LINUX_JBD_H */
_
