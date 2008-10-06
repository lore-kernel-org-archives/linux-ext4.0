From: Theodore Tso <tytso@mit.edu>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Mon, 6 Oct 2008 13:55:02 -0400
Message-ID: <20081006175502.GA12937@mit.edu>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Cc: Quentin Godfroy <godfroy@clipper.ens.fr>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43783 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753393AbYJFRzP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 13:55:15 -0400
Content-Disposition: inline
In-Reply-To: <48EA2F20.7020309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here are updates to the two patches I sent you.  The first fixes some
printk labels and requires that the debugging dump ioctl be triggered
by root; the second fixes the think-o that Eric pointed out earlier
this morning.

						- Ted


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dump-in-use-buffers

Add a ioctl which dumps out all of the in-use buffer heads for a block device

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index c23177e..c2a788d 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -786,6 +786,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	switch (cmd) {
 	case HDIO_GETGEO:
 		return compat_hdio_getgeo(disk, bdev, compat_ptr(arg));
+	case BLKDUMPUSEDBUFFERS:
 	case BLKFLSBUF:
 	case BLKROSET:
 	/*
diff --git a/block/ioctl.c b/block/ioctl.c
index 77185e5..5eba4d6 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -279,6 +279,11 @@ int blkdev_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 			return -EFAULT;
 		return 0;
 	}
+	case BLKDUMPUSEDBUFFERS:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+		dump_used_buffers(bdev);
+		return 0;
 	}
 
 	lock_kernel();
diff --git a/fs/buffer.c b/fs/buffer.c
index ac78d4c..34ffeb4 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -33,6 +33,7 @@
 #include <linux/writeback.h>
 #include <linux/hash.h>
 #include <linux/suspend.h>
+#include <linux/pagevec.h>
 #include <linux/buffer_head.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/bio.h>
@@ -247,6 +248,45 @@ void thaw_bdev(struct block_device *bdev, struct super_block *sb)
 }
 EXPORT_SYMBOL(thaw_bdev);
 
+void dump_used_buffers(struct block_device *bdev)
+{
+	struct inode *bd_inode = bdev->bd_inode;
+	struct address_space *bd_mapping = bd_inode->i_mapping;
+	struct buffer_head *bh, *head;
+	struct pagevec pvec;
+	unsigned long index = 0;
+	int nr_pages, i, count, total = 0;
+	char b[BDEVNAME_SIZE];
+
+	spin_lock(&bd_mapping->private_lock);
+	printk(KERN_INFO "Begin dump of block device %s\n", bdevname(bdev, b));
+	while (1) {
+		nr_pages = pagevec_lookup(&pvec, bd_mapping, index, PAGEVEC_SIZE);
+		if (nr_pages == 0)
+			break;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+			index = page->index + 1;
+
+			if (!page_has_buffers(page))
+				continue;
+			bh = head = page_buffers(page);
+			do {
+				count = atomic_read(&bh->b_count);
+				if (count) {
+					printk(KERN_INFO
+					       "buffer in-use: block %Lu count %d\n",
+					       (unsigned long long) bh->b_blocknr, count);
+					total++;
+				}
+				bh = bh->b_this_page;
+			} while (bh != head);
+		}
+	}
+	printk(KERN_INFO "Total number of in-use buffers: %d\n", total);
+	spin_unlock(&bd_mapping->private_lock);
+}
+
 /*
  * Various filesystems appear to want __find_get_block to be non-blocking.
  * But it's the page lock which protects the buffers.  To get around this,
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index eadaab4..1c48dff 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -193,6 +193,7 @@ void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
 int bh_submit_read(struct buffer_head *bh);
+void dump_used_buffers(struct block_device *bdev);
 
 extern int buffer_heads_over_limit;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 580b513..ae0ab82 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -222,6 +222,7 @@ extern int dir_notify_enable;
 #define BLKTRACESTART _IO(0x12,116)
 #define BLKTRACESTOP _IO(0x12,117)
 #define BLKTRACETEARDOWN _IO(0x12,118)
+#define BLKDUMPUSEDBUFFERS _IO(0x12,119)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fix-jbd2-buffer-head-leak

jbd2: Fix buffer head leak when writing the commit block

Also make sure the buffer heads are marked clean before submitting bh
for writing.  The previous code was marking the buffer head dirty,
which would have forced an unneeded write (and seek) to the journal
for no good reason.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index e91f051..0d3814a 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -127,8 +127,7 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
-	get_bh(bh);
-	set_buffer_dirty(bh);
+	clear_buffer_dirty(bh);
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
 
@@ -158,7 +157,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		/* And try again, without the barrier */
 		lock_buffer(bh);
 		set_buffer_uptodate(bh);
-		set_buffer_dirty(bh);
+		clear_buffer_dirty(bh);
 		ret = submit_bh(WRITE, bh);
 	}
 	*cbh = bh;

--SLDf9lqlvOQaIe6s--
