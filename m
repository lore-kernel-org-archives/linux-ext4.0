From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Remove s_dirt handling
Date: Sat, 31 Mar 2012 14:38:51 +0200
Message-ID: <1333197531-5190-1-git-send-email-jack@suse.cz>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2DATnB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Apr 2012 15:43:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Places which modify superblock feature / state fields mark the superblock
buffer dirty so it is written out by flusher thread. Thus there's no need to
set s_dirt there.

The only other fields changing in the superblock are the numbers of free
blocks, free inodes and s_wtime. There's no real need to write (or even
compute) these periodically. Free blocks / inodes counters are recomputed on
every mount from group counters anyway and value of s_wtime is only
informational and imprecise anyway. So it should be enough to write these
opportunistically on mount, remount, umount, and sync_fs times.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/balloc.c |    2 --
 fs/ext2/ialloc.c |    2 --
 fs/ext2/super.c  |    3 ---
 fs/ext2/xattr.c  |    1 -
 4 files changed, 0 insertions(+), 8 deletions(-)

 As Artem wants to cleanup superblock dirty handling, I think we can just
make things simpler and remove it from ext2 altogether. Anyone against it?

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index a8cbe1b..a9bba1e 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -165,7 +165,6 @@ static void release_blocks(struct super_block *sb, int count)
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 		percpu_counter_add(&sbi->s_freeblocks_counter, count);
-		sb->s_dirt = 1;
 	}
 }
 
@@ -180,7 +179,6 @@ static void group_adjust_blocks(struct super_block *sb, int group_no,
 		free_blocks = le16_to_cpu(desc->bg_free_blocks_count);
 		desc->bg_free_blocks_count = cpu_to_le16(free_blocks + count);
 		spin_unlock(sb_bgl_lock(sbi, group_no));
-		sb->s_dirt = 1;
 		mark_buffer_dirty(bh);
 	}
 }
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 8b15cf8..c13eb7b 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -81,7 +81,6 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
-	sb->s_dirt = 1;
 	mark_buffer_dirty(bh);
 }
 
@@ -543,7 +542,6 @@ got:
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 
-	sb->s_dirt = 1;
 	mark_buffer_dirty(bh2);
 	if (test_opt(sb, GRPID)) {
 		inode->i_mode = mode;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d141758..9d6995c 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1158,7 +1158,6 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	if (wait)
 		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
 }
 
 /*
@@ -1191,8 +1190,6 @@ void ext2_write_super(struct super_block *sb)
 {
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
 }
 
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 6dcafc7..b6754db 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -339,7 +339,6 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	EXT2_SET_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR);
 	spin_unlock(&EXT2_SB(sb)->s_lock);
-	sb->s_dirt = 1;
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 }
 
-- 
1.7.1

