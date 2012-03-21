From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH 4/8] ext2: intruduce ext2_mark_super_dirty
Date: Wed, 21 Mar 2012 18:14:31 +0200
Message-ID: <1332346475-1441-5-git-send-email-dedekind1@gmail.com>
References: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332346475-1441-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Introduce a helper function for marking the superblock as dirty. This is just a
preparation for further changes which will make ext2 fully manage its own
superblock and not rely on VFS services like periodic '->write_super()'
callback invocations.

Note: the final goal is to get rid of the 'sync_supers()' kernel thread which
wakes up every 5 seconds and even if there is nothing to do. Thus, we are
pushing superblock management from VFS down to file-systems.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/ext2/balloc.c |    4 ++--
 fs/ext2/ext2.h   |    1 +
 fs/ext2/ialloc.c |    4 ++--
 fs/ext2/super.c  |    5 +++++
 fs/ext2/xattr.c  |    2 +-
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index a8cbe1b..dc9ee12 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -165,7 +165,7 @@ static void release_blocks(struct super_block *sb, int count)
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 		percpu_counter_add(&sbi->s_freeblocks_counter, count);
-		sb->s_dirt = 1;
+		ext2_mark_super_dirty(sb);
 	}
 }
 
@@ -180,7 +180,7 @@ static void group_adjust_blocks(struct super_block *sb, int group_no,
 		free_blocks = le16_to_cpu(desc->bg_free_blocks_count);
 		desc->bg_free_blocks_count = cpu_to_le16(free_blocks + count);
 		spin_unlock(sb_bgl_lock(sbi, group_no));
-		sb->s_dirt = 1;
+		ext2_mark_super_dirty(sb);
 		mark_buffer_dirty(bh);
 	}
 }
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 75ad433..4dc8e55 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -135,6 +135,7 @@ extern long ext2_compat_ioctl(struct file *, unsigned int, unsigned long);
 struct dentry *ext2_get_parent(struct dentry *child);
 
 /* super.c */
+extern void ext2_mark_super_dirty(struct super_block *sb);
 extern __printf(3, 4)
 void ext2_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 8b15cf8..9688749 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -81,7 +81,7 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
-	sb->s_dirt = 1;
+	ext2_mark_super_dirty(sb);
 	mark_buffer_dirty(bh);
 }
 
@@ -543,7 +543,7 @@ got:
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 
-	sb->s_dirt = 1;
+	ext2_mark_super_dirty(sb);
 	mark_buffer_dirty(bh2);
 	if (test_opt(sb, GRPID)) {
 		inode->i_mode = mode;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index d141758..134c750 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1195,6 +1195,11 @@ void ext2_write_super(struct super_block *sb)
 		sb->s_dirt = 0;
 }
 
+void ext2_mark_super_dirty(struct super_block *sb)
+{
+	sb->s_dirt = 1;
+}
+
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
 {
 	struct ext2_sb_info * sbi = EXT2_SB(sb);
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 6dcafc7..a04d280 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -339,7 +339,7 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	EXT2_SET_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR);
 	spin_unlock(&EXT2_SB(sb)->s_lock);
-	sb->s_dirt = 1;
+	ext2_mark_super_dirty(sb);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 }
 
-- 
1.7.7.6
