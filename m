From: Theodore Tso <tytso@mit.edu>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Thu, 2 Oct 2008 20:35:48 -0400
Message-ID: <20081003003548.GA18138@mit.edu>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Quentin <godfroy@clipper.ens.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54315 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753815AbYJCAfw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 20:35:52 -0400
Content-Disposition: inline
In-Reply-To: <20080930222358.1FF30EAC415@quatramaran.ens.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2008 at 12:23:58AM +0200, Quentin wrote:
> 
> Of course. However since I unmounted and remounted /home the 'buffer' line
> is now only 59megs, and they are still not dropped when a program tries to
> malloc all the memory. I'll tell next time the problem shows up (it
> can take ten days)
> 

Are you willing to patch and recompile your kernel?  If so, the
following patch would be very helpful in determining what is going on.
It allows us to see what buffer heads are in use for a particular
block device.  Attached please the kernel patch and the user program.

      	       		       	   	  	- Ted

P.S.  Unfortunately, all of the code to debug buffer head leaks was
dropped when the buffer cache was moved into the page cache.  Any
comments about a refined version of patch getting merged into the
mainline kernel as a debugging measure?

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dump-used-buffers

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
index 77185e5..11af31c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -279,6 +279,9 @@ int blkdev_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 			return -EFAULT;
 		return 0;
 	}
+	case BLKDUMPUSEDBUFFERS:
+		dump_used_buffers(bdev);
+		return 0;
 	}
 
 	lock_kernel();
diff --git a/fs/buffer.c b/fs/buffer.c
index ac78d4c..4e4a7ce 100644
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
+					       "buffer dirty: block %Lu count %d\n",
+					       (unsigned long long) bh->b_blocknr, count);
+					total++;
+				}
+				bh = bh->b_this_page;
+			} while (bh != head);
+		}
+	}
+	printk(KERN_INFO "Total number of dirty buffers: %d\n", total);
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

--Q68bSM7Ycu6FN28Q
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="buffer_dump.c"

/*
 * buffer_dump.c --- This routine triggers a debugging ioctl which
 * dumps all buffer heads which have a non-zero bh_count.
 *
 * Copyright 1997, 2000, by Theodore Ts'o.
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mount.h>

/* For Linux, define BLKDUMPUSEDBUFFERS if necessary */
#if (!defined(BLKDUMPUSEDBUFFERS) && defined(__linux__))
#define BLKDUMPUSEDBUFFERS	_IO(0x12,119)
#endif

const char *progname;

static void usage(void)
{
	fprintf(stderr, "Usage: %s disk\n", progname);
	exit(1);
}

int main(int argc, char **argv)
{
	int	fd;

	progname = argv[0];
	if (argc != 2)
		usage();

	fd = open(argv[1], O_RDONLY, 0);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	/*
	 * Note: to reread the partition table, use the ioctl
	 * BLKRRPART instead of BLKFSLBUF.
	 */
	if (ioctl(fd, BLKDUMPUSEDBUFFERS, 0) < 0) {
		perror("ioctl BLKDUMPUSEDBUFFERS");
		exit(1);
	}
	return 0;
}

--Q68bSM7Ycu6FN28Q--
