From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Date: Wed, 14 Jan 2009 16:12:28 +0100
Message-ID: <1231945948-23676-2-git-send-email-jack@suse.cz>
References: <1231945948-23676-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	pavel@suse.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56986 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753024AbZANPMa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 10:12:30 -0500
In-Reply-To: <1231945948-23676-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To be really safe that the data hit the platter, we should also flush drive's
writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: pavel@suse.cz
---
 fs/ext2/dir.c   |    5 ++++-
 fs/ext2/fsync.c |    7 +++++--
 fs/ext2/inode.c |    7 +++++++
 fs/ext2/xattr.c |    6 +++++-
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 2999d72..d6cb59f 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -25,6 +25,7 @@
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
@@ -97,8 +98,10 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 
 	if (IS_DIRSYNC(dir)) {
 		err = write_one_page(page, 1);
-		if (!err)
+		if (!err) {
 			err = ext2_sync_inode(dir);
+			blkdev_issue_flush(dir->i_sb->s_bdev, NULL);
+		}
 	} else {
 		unlock_page(page);
 	}
diff --git a/fs/ext2/fsync.c b/fs/ext2/fsync.c
index fc66c93..9cd1838 100644
--- a/fs/ext2/fsync.c
+++ b/fs/ext2/fsync.c
@@ -24,6 +24,7 @@
 
 #include "ext2.h"
 #include <linux/buffer_head.h>		/* for sync_mapping_buffers() */
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 
 
 /*
@@ -39,12 +40,14 @@ int ext2_sync_file(struct file *file, struct dentry *dentry, int datasync)
 
 	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode->i_state & I_DIRTY))
-		return ret;
+		goto out;
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		return ret;
+		goto out;
 
 	err = ext2_sync_inode(inode);
 	if (ret == 0)
 		ret = err;
+out:
+	blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
 }
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 23fff2f..49b479e 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -33,6 +33,7 @@
 #include <linux/mpage.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/blkdev.h>	/* for blkdev_issue_flush() */
 #include "ext2.h"
 #include "acl.h"
 #include "xip.h"
@@ -68,9 +69,14 @@ void ext2_delete_inode (struct inode * inode)
 	mark_inode_dirty(inode);
 	ext2_update_inode(inode, inode_needs_sync(inode));
 
+	/* Make sure inode deletion really gets to disk. Disk write caches
+	 * are flushed either in ext2_truncate() or we do it explicitly */
 	inode->i_size = 0;
 	if (inode->i_blocks)
 		ext2_truncate (inode);
+	else if (inode_needs_sync(inode))
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+
 	ext2_free_inode (inode);
 
 	return;
@@ -1104,6 +1110,7 @@ do_indirects:
 	if (inode_needs_sync(inode)) {
 		sync_mapping_buffers(inode->i_mapping);
 		ext2_sync_inode (inode);
+		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	} else {
 		mark_inode_dirty(inode);
 	}
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 987a526..d480216 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -60,6 +60,7 @@
 #include <linux/mbcache.h>
 #include <linux/quotaops.h>
 #include <linux/rwsem.h>
+#include <linux/blkdev.h>		/* for blkdev_issue_flush() */
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -702,6 +703,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 				DQUOT_FREE_BLOCK(inode, 1);
 			goto cleanup;
 		}
+		blkdev_issue_flush(sb->s_bdev, NULL);
 	} else
 		mark_inode_dirty(inode);
 
@@ -792,8 +794,10 @@ ext2_xattr_delete_inode(struct inode *inode)
 			le32_to_cpu(HDR(bh)->h_refcount));
 		unlock_buffer(bh);
 		mark_buffer_dirty(bh);
-		if (IS_SYNC(inode))
+		if (IS_SYNC(inode)) {
 			sync_dirty_buffer(bh);
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		}
 		DQUOT_FREE_BLOCK(inode, 1);
 	}
 	EXT2_I(inode)->i_file_acl = 0;
-- 
1.6.0.2

