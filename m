From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ext2: Replace tests of write IO errors using buffer_uptodate
Date: Thu,  5 Jan 2012 15:40:07 +0100
Message-ID: <1325774407-28531-4-git-send-email-jack@suse.cz>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1325774407-28531-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Replace old tests whether IO error happened during write using buffer_uptodate
flag. This allows us to mark filesystem as not needing clearing of
buffer_uptodate flag on write IO error which stops bogus warnings from
mark_buffer_dirty after IO errors and allows us to remove code trying to avoid
these warnings in common case.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c |    5 ++---
 fs/ext2/super.c |   23 +----------------------
 fs/ext2/xattr.c |    5 ++---
 3 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 91a6945..dc70d6b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1506,11 +1506,10 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 		raw_inode->i_block[n] = ei->i_data[n];
 	mark_buffer_dirty(bh);
 	if (do_sync) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
+		err = sync_dirty_buffer(bh);
+		if (err) {
 			printk ("IO error syncing ext2 inode [%s:%08lx]\n",
 				sb->s_id, (unsigned long) ino);
-			err = -EIO;
 		}
 	}
 	ei->i_state &= ~EXT2_STATE_NEW;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index bd8ac16..1e775e5 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1129,30 +1129,9 @@ failed_unlock:
 	return ret;
 }
 
-static void ext2_clear_super_error(struct super_block *sb)
-{
-	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
-
-	if (buffer_write_io_error(sbh)) {
-		/*
-		 * Oh, dear.  A previous attempt to write the
-		 * superblock failed.  This could happen because the
-		 * USB device was yanked out.  Or it could happen to
-		 * be a transient write error and maybe the block will
-		 * be remapped.  Nothing we can do but to retry the
-		 * write and hope for the best.
-		 */
-		ext2_msg(sb, KERN_ERR,
-		       "previous I/O error to superblock detected\n");
-		clear_buffer_write_io_error(sbh);
-		set_buffer_uptodate(sbh);
-	}
-}
-
 static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 			    int wait)
 {
-	ext2_clear_super_error(sb);
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
@@ -1492,7 +1471,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext2_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HANDLE_WRITE_ERROR,
 };
 
 static int __init init_ext2_fs(void)
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index d27b71f..d6e7a7a 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -680,9 +680,8 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 		}
 		mark_buffer_dirty(new_bh);
 		if (IS_SYNC(inode)) {
-			sync_dirty_buffer(new_bh);
-			error = -EIO;
-			if (buffer_req(new_bh) && !buffer_uptodate(new_bh))
+			error = sync_dirty_buffer(new_bh);
+			if (error)
 				goto cleanup;
 		}
 	}
-- 
1.7.1
