From: Jan Kara <jack@suse.cz>
Subject: [PATCH 25/26] ext4: Don't wait for extent conversion in ext4_punch_hole()
Date: Fri, 31 May 2013 11:42:58 +0200
Message-ID: <1369993379-13017-26-git-send-email-jack@suse.cz>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3EaJnS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:18 -0400
In-Reply-To: <1369993379-13017-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't have to wait for extent conversion in ext4_punch_hole() as
buffered IO for the punched range has been flushed and waited upon (thus
all extent conversions for that range have completed). Also we wait for
all DIO to finish using inode_dio_wait() so there cannot be any extent
conversions pending due to direct IO.

Also remove ext4_flush_unwritten_io() since it's unused now.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  1 -
 fs/ext4/inode.c   |  3 ---
 fs/ext4/page-io.c | 16 ----------------
 3 files changed, 20 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1352901..c161746 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2003,7 +2003,6 @@ static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
 
 /* fsync.c */
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
-extern int ext4_flush_unwritten_io(struct inode *);
 
 /* hash.c */
 extern int ext4fs_dirhash(const char *name, int len, struct
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index deab352..c55b09a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3564,9 +3564,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	ext4_inode_block_unlocked_dio(inode);
-	ret = ext4_flush_unwritten_io(inode);
-	if (ret)
-		goto out_dio;
 	inode_dio_wait(inode);
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 0f65561..6ee5bd3 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -281,22 +281,6 @@ void ext4_end_io_unrsv_work(struct work_struct *work)
 	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_unrsv_conversion_list);
 }
 
-int ext4_flush_unwritten_io(struct inode *inode)
-{
-	int ret, err;
-
-	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex) &&
-		     !(inode->i_state & I_FREEING));
-	ret = ext4_do_flush_completed_IO(inode,
-					 &EXT4_I(inode)->i_rsv_conversion_list);
-	err = ext4_do_flush_completed_IO(inode,
-					 &EXT4_I(inode)->i_unrsv_conversion_list);
-	if (!ret)
-		ret = err;
-	ext4_unwritten_wait(inode);
-	return ret;
-}
