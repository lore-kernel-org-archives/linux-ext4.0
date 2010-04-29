From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC] ext4: Don't send extra barrier during fsync if there are no
	dirty pages.
Date: Thu, 29 Apr 2010 16:51:02 -0700
Message-ID: <20100429235102.GC15607@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45479 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933504Ab0D3R4d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Apr 2010 13:56:33 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm.  A while ago I was complaining that an evil program that calls fsync() in
a loop will send a continuous stream of write barriers to the hard disk.  Ted
theorized that it might be possible to set a flag in ext4_writepage and clear
it in ext4_sync_file; if we happen to enter ext4_sync_file and the flag isn't
set (meaning that nothing has been dirtied since the last fsync()) then we
could skip issuing the barrier.

Here's an experimental patch to do something sort of like that.  From a quick
run with blktrace, it seems to skip the redundant barriers and improves the ffsb
mail server scores.  However, I haven't done extensive power failure testing to
see how much data it can destroy.  For that matter I'm not even 100% sure it's
correct at what it aims to do.

Just throwing this out there, though.  Nothing's blown up ... yet. :P
---
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/ext4.h  |    2 ++
 fs/ext4/fsync.c |    7 +++++--
 fs/ext4/inode.c |    5 +++++
 3 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..3b70195 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1025,6 +1025,8 @@ struct ext4_sb_info {
 
 	/* workqueue for dio unwritten */
 	struct workqueue_struct *dio_unwritten_wq;
+
+	atomic_t unflushed_writes;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0d0c323..441f872 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -52,7 +52,8 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	journal_t *journal = sbi->s_journal;
 	int ret;
 	tid_t commit_tid;
 
@@ -102,7 +103,9 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		    (journal->j_flags & JBD2_BARRIER))
 			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 		jbd2_log_wait_commit(journal, commit_tid);
-	} else if (journal->j_flags & JBD2_BARRIER)
+	} else if (journal->j_flags & JBD2_BARRIER && atomic_read(&sbi->unflushed_writes)) {
+		atomic_set(&sbi->unflushed_writes, 0);
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+	}
 	return ret;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5381802..e501abd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2718,6 +2718,7 @@ static int ext4_writepage(struct page *page,
 	unsigned int len;
 	struct buffer_head *page_bufs = NULL;
 	struct inode *inode = page->mapping->host;
+	struct ext4_sb_info *sbi = EXT4_SB(page->mapping->host->i_sb);
 
 	trace_ext4_writepage(inode, page);
 	size = i_size_read(inode);
@@ -2726,6 +2727,8 @@ static int ext4_writepage(struct page *page,
 	else
 		len = PAGE_CACHE_SIZE;
 
+	atomic_set(&sbi->unflushed_writes, 1);
+
 	if (page_has_buffers(page)) {
 		page_bufs = page_buffers(page);
 		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
@@ -2872,6 +2875,8 @@ static int ext4_da_writepages(struct address_space *mapping,
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 		range_whole = 1;
 
+	atomic_set(&sbi->unflushed_writes, 1);
+
 	range_cyclic = wbc->range_cyclic;
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
