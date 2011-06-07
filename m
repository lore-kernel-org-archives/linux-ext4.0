From: amir73il@users.sourceforge.net
Subject: [PATCH v1 20/36] ext4: snapshot control - fix new snapshot
Date: Tue,  7 Jun 2011 18:07:47 +0300
Message-ID: <1307459283-22130-21-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:52 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:52 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

On snapshot take, after copying the pre-allocated blocks, some are
fixed to make the snapshot image appear as a valid Ext4 file system.
The has_snapshot flags is cleared from the super block as well as
the last_snapshot field and all snapshot inodes are cleared
(to appear as empty inodes).


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h         |    2 +
 fs/ext4/inode.c        |    4 +-
 fs/ext4/snapshot_ctl.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e76faae..198d7d4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1839,6 +1839,8 @@ struct buffer_head *ext4_bread(handle_t *, struct inode *,
 int ext4_get_block(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh_result, int create);
 
+extern blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
+		struct ext4_inode_info *ei);
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1558a7b..d703a55 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5178,8 +5178,8 @@ void ext4_get_inode_flags(struct ext4_inode_info *ei)
 	} while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl);
 }
 
-static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
-				  struct ext4_inode_info *ei)
+blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
+			  struct ext4_inode_info *ei)
 {
 	blkcnt_t i_blocks ;
 	struct inode *inode = &(ei->vfs_inode);
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 9d915a9..360581d 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -393,6 +393,7 @@ static int ext4_snapshot_create(struct inode *inode)
 	unsigned long ino;
 	struct ext4_iloc iloc;
 	ext4_fsblk_t bmap_blk = 0, imap_blk = 0, inode_blk = 0;
+	ext4_fsblk_t prev_inode_blk = 0;
 	ext4_fsblk_t snapshot_blocks = ext4_blocks_count(sbi->s_es);
 	if (active_snapshot) {
 		snapshot_debug(1, "failed to add snapshot because active "
@@ -540,7 +541,9 @@ static int ext4_snapshot_create(struct inode *inode)
 		goto out_handle;
 	}
 
-	ino = inode->i_ino;
+	/* start with root inode and continue with snapshot list */
+	ino = EXT4_ROOT_INO;
+alloc_inode_blocks:
 	/*
 	 * pre-allocate the following blocks in the new snapshot:
 	 * - block and inode bitmap blocks of ino's block group
@@ -553,6 +556,11 @@ static int ext4_snapshot_create(struct inode *inode)
 
 	inode_blk = ext4_get_inode_block(sb, ino, &iloc);
 
+	if (!inode_blk || inode_blk == prev_inode_blk)
+		goto next_snapshot;
+
+	/* not same inode and bitmap blocks as prev snapshot */
+	prev_inode_blk = inode_blk;
 	bmap_blk = 0;
 	imap_blk = 0;
 	desc = ext4_get_group_desc(sb, iloc.block_group, NULL);
@@ -601,6 +609,10 @@ next_snapshot:
 			err = -EIO;
 		goto out_handle;
 	}
+	if (ino == EXT4_ROOT_INO) {
+		ino = inode->i_ino;
+		goto alloc_inode_blocks;
+	}
 	snapshot_debug(1, "snapshot (%u) created\n", inode->i_generation);
 	err = 0;
 out_handle:
@@ -693,6 +705,10 @@ int ext4_snapshot_take(struct inode *inode)
 	struct inode *curr_inode;
 	struct ext4_iloc iloc;
 	struct ext4_group_desc *desc;
+	ext4_fsblk_t prev_inode_blk = 0;
+	struct ext4_inode *raw_inode;
+	blkcnt_t excluded_blocks = 0;
+	int fixing = 0;
 	int i;
 	int err = -EIO;
 
@@ -752,7 +768,9 @@ int ext4_snapshot_take(struct inode *inode)
 			goto out_unlockfs;
 	}
 
-	curr_inode = inode;
+	/* start with root inode and continue with snapshot list */
+	curr_inode = sb->s_root->d_inode;
+copy_inode_blocks:
 	/*
 	 * copy the following blocks to the new snapshot:
 	 * - block and inode bitmap blocks of curr_inode block group
@@ -769,6 +787,11 @@ int ext4_snapshot_take(struct inode *inode)
 		err = err ? : -EIO;
 		goto out_unlockfs;
 	}
+	if (fixing)
+		goto fix_inode_copy;
+	if (iloc.bh->b_blocknr == prev_inode_blk)
+		goto next_inode;
+	prev_inode_blk = iloc.bh->b_blocknr;
 	brelse(bhs[COPY_BLOCK_BITMAP]);
 	bhs[COPY_BLOCK_BITMAP] = sb_bread(sb,
 			ext4_block_bitmap(sb, desc));
@@ -784,12 +807,59 @@ int ext4_snapshot_take(struct inode *inode)
 			goto out_unlockfs;
 		mask = NULL;
 	}
+	/* this is the copy pass */
+	goto next_inode;
+fix_inode_copy:
+	/* this is the fixing pass */
+	/* get snapshot copy of raw inode */
+	brelse(sbh);
+	sbh = ext4_getblk(NULL, inode,
+			SNAPSHOT_IBLOCK(iloc.bh->b_blocknr),
+			SNAPMAP_READ, &err);
+	if (!sbh)
+		goto out_unlockfs;
+	iloc.bh = sbh;
+	raw_inode = ext4_raw_inode(&iloc);
+	/*
+	 * Snapshot inode blocks are excluded from COW bitmap,
+	 * so they appear to be not allocated in the snapshot's
+	 * block bitmap.  If we want the snapshot image to pass
+	 * fsck with no errors, we need to detach those blocks
+	 * from the copy of the snapshot inode, so we fix the
+	 * snapshot inodes to appear as empty regular files.
+	 */
+	excluded_blocks += ext4_inode_blocks(raw_inode,
+			EXT4_I(curr_inode)) >>
+		(curr_inode->i_blkbits - 9);
+	lock_buffer(sbh);
+	ext4_isize_set(raw_inode, 0);
+	raw_inode->i_blocks_lo = 0;
+	raw_inode->i_blocks_high = 0;
+	raw_inode->i_flags &= cpu_to_le32(~EXT4_SNAPFILE_FL);
+	memset(raw_inode->i_block, 0, sizeof(raw_inode->i_block));
+	unlock_buffer(sbh);
+	mark_buffer_dirty(sbh);
+	sync_dirty_buffer(sbh);
+
+next_inode:
+	if (curr_inode->i_ino == EXT4_ROOT_INO) {
+		curr_inode = inode;
+		goto copy_inode_blocks;
+	}
 
 	/*
 	 * copy super block to snapshot and fix it
 	 */
 	lock_buffer(es_bh);
 	memcpy(es_bh->b_data, sbi->s_sbh->b_data, sb->s_blocksize);
+	/* set the IS_SNAPSHOT flag to signal fsck this is a snapshot */
+	es->s_flags |= cpu_to_le32(EXT4_FLAGS_IS_SNAPSHOT);
+	/* reset snapshots list in snapshot's super block copy */
+	es->s_snapshot_inum = 0;
+	es->s_snapshot_list = 0;
+	/* fix free blocks count after clearing old snapshot inode blocks */
+	ext4_free_blocks_count_set(es, ext4_free_blocks_count(es) +
+				excluded_blocks);
 	set_buffer_uptodate(es_bh);
 	unlock_buffer(es_bh);
 	mark_buffer_dirty(es_bh);
-- 
1.7.4.1

