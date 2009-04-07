From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/3] block_write_full_page: Use synchronous writes for
	WBC_SYNC_ALL writebacks
Date: Tue, 7 Apr 2009 15:09:13 -0400
Message-ID: <20090407190913.GA31723@mit.edu>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> <1238185471-31152-2-git-send-email-tytso@mit.edu> <20090406232141.ebdb426a.akpm@linux-foundation.org> <20090406235052.1ea47513.akpm@linux-foundation.org> <20090407070835.GM5178@kernel.dk> <20090407002313.fcdd1da0.akpm@linux-foundation.org> <20090407075732.GO5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jack@suse.cz
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53818 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbZDGTJZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Apr 2009 15:09:25 -0400
Content-Disposition: inline
In-Reply-To: <20090407075732.GO5178@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 07, 2009 at 09:57:32AM +0200, Jens Axboe wrote:
> > > It looks like a good candidate for WRITE_SYNC_PLUG instead,
> > 

So is this patch sane?  (Compile-tested only, since I'm at a
conference at the moment).  Am I using the proper abstraction to
unplug the block device?  If not, it might be nice to document the
preferred for callers into the block layer.

(BTW, I was looking at Documentation/biodoc.txt, and I found some
clearly old documentation bits: "This is just the same as in 2.4 so
far, though per-device unplugging support is anticipated for 2.5."  :-)

					- Ted

[RFQ] Smart unplugging for page writeback

Now that we have a distinction between WRITE_SYNC and WRITE_SYNC_PLUG,
use WRITE_SYNC_PLUG in block_write_full_page(), and then before we
wait for page writebacks to complete in jbd, jbd2, and filemap, call
blk_unplug() to make sure the writes are on the way to the disk.

diff --git a/fs/buffer.c b/fs/buffer.c
index 977e12a..95b5390 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1646,7 +1646,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	struct buffer_head *bh, *head;
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
-	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
+	int write_op = (wbc->sync_mode == WB_SYNC_ALL ?
+			WRITE_SYNC_PLUG : WRITE);
 
 	BUG_ON(!PageLocked(page));
 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index a8e8513..3e6726f 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/bio.h>
+#include <linux/blkdev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -196,6 +197,7 @@ static int journal_submit_data_buffers(journal_t *journal,
 	int locked;
 	int bufs = 0;
 	struct buffer_head **wbuf = journal->j_wbuf;
+	struct block_device *fs_bdev = 0;
 	int err = 0;
 
 	/*
@@ -213,6 +215,7 @@ write_out_data:
 	while (commit_transaction->t_sync_datalist) {
 		jh = commit_transaction->t_sync_datalist;
 		bh = jh2bh(jh);
+		fs_bdev = bh->b_bdev;
 		locked = 0;
 
 		/* Get reference just to make sure buffer does not disappear
@@ -290,6 +293,8 @@ write_out_data:
 	}
 	spin_unlock(&journal->j_list_lock);
 	journal_do_submit_data(wbuf, bufs, write_op);
+	if (fs_bdev)
+		blk_unplug(bdev_get_queue(fs_bdev));
 
 	return err;
 }
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 282750c..b5448dd 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -26,6 +26,7 @@
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/bio.h>
+#include <linux/blkdev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -176,6 +177,7 @@ static int journal_wait_on_commit_record(journal_t *journal,
 
 retry:
 	clear_buffer_dirty(bh);
+	blk_unplug(bdev_get_queue(bh->b_bdev));
 	wait_on_buffer(bh);
 	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
 		printk(KERN_WARNING
@@ -241,10 +243,12 @@ static int journal_submit_data_buffers(journal_t *journal,
 	struct jbd2_inode *jinode;
 	int err, ret = 0;
 	struct address_space *mapping;
+	struct block_device *fs_bdev = 0;
 
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
 		mapping = jinode->i_vfs_inode->i_mapping;
+		fs_bdev = jinode->i_vfs_inode->i_sb->s_bdev;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
 		/*
@@ -262,6 +266,8 @@ static int journal_submit_data_buffers(journal_t *journal,
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
 	spin_unlock(&journal->j_list_lock);
+	if (fs_bdev)
+		blk_unplug(bdev_get_queue(fs_bdev));
 	return ret;
 }
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 2e2d38e..eff2ed9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -274,6 +274,10 @@ int wait_on_page_writeback_range(struct address_space *mapping,
 	if (end < start)
 		return 0;
 
+	if (mapping->host && mapping->host->i_sb && mapping->host->i_sb &&
+	    mapping->host->i_sb->s_bdev)
+		blk_unplug(bdev_get_queue(mapping->host->i_sb->s_bdev));
+
 	pagevec_init(&pvec, 0);
 	index = start;
 	while ((index <= end) &&
