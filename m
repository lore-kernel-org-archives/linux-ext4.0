From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC v2] ext4: Don't send extra barrier during fsync if there are
	no dirty pages.
Date: Tue, 29 Jun 2010 13:51:02 -0700
Message-ID: <20100629205102.GM15515@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:53837 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab0F2UvQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jun 2010 16:51:16 -0400
Content-Disposition: inline
In-Reply-To: <1273002566.3755.10.camel@mingming-laptop>
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

This second version of the patch uses the inode state flags and (suboptimally)
also catches directio writes.  It might be a better idea to try to coordinate
all the barrier requests across the whole filesystem, though that's a bit more
difficult.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/ext4.h  |    1 +
 fs/ext4/fsync.c |    5 ++++-
 fs/ext4/inode.c |    7 +++++++
 3 files changed, 12 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..d2e8e40 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1181,6 +1181,7 @@ enum {
 	EXT4_STATE_EXT_MIGRATE,		/* Inode is migrating */
 	EXT4_STATE_DIO_UNWRITTEN,	/* need convert on dio done*/
 	EXT4_STATE_NEWENTRY,		/* File just added to dir */
+	EXT4_STATE_DIRTY_DATA,		/* dirty data, need barrier */
 };
 
 #define EXT4_INODE_BIT_FNS(name, field)					\
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 592adf2..96625c3 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -130,8 +130,11 @@ int ext4_sync_file(struct file *file, int datasync)
 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
 					NULL, BLKDEV_IFL_WAIT);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
-	} else if (journal->j_flags & JBD2_BARRIER)
+	} else if (journal->j_flags & JBD2_BARRIER &&
+		   ext4_test_inode_state(inode, EXT4_STATE_DIRTY_DATA)) {
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
 			BLKDEV_IFL_WAIT);
+		ext4_clear_inode_state(inode, EXT4_STATE_DIRTY_DATA);
+	}
 	return ret;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 42272d6..486d349 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2685,6 +2685,8 @@ static int ext4_writepage(struct page *page,
 	else
 		len = PAGE_CACHE_SIZE;
 
+	ext4_set_inode_state(inode, EXT4_STATE_DIRTY_DATA);
+
 	if (page_has_buffers(page)) {
 		page_bufs = page_buffers(page);
 		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
@@ -2948,6 +2950,8 @@ static int ext4_da_writepages(struct address_space *mapping,
 	if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 		range_whole = 1;
 
+	ext4_set_inode_state(inode, EXT4_STATE_DIRTY_DATA);
+
 	range_cyclic = wbc->range_cyclic;
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
@@ -3996,6 +4000,9 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
+	if (rw == WRITE)
+		ext4_set_inode_state(inode, EXT4_STATE_DIRTY_DATA);
+
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
 
