From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv4 06/17] EXT2: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:49:01 +0300
Message-ID: <1274795352-3551-7-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/balloc.c |    4 ++--
 fs/ext2/ialloc.c |    4 ++--
 fs/ext2/super.c  |    6 +++---
 fs/ext2/xattr.c  |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index e8766a3..f2e830e 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -165,7 +165,7 @@ static void release_blocks(struct super_block *sb, int count)
 		struct ext2_sb_info *sbi = EXT2_SB(sb);
 
 		percpu_counter_add(&sbi->s_freeblocks_counter, count);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 }
 
@@ -180,7 +180,7 @@ static void group_adjust_blocks(struct super_block *sb, int group_no,
 		free_blocks = le16_to_cpu(desc->bg_free_blocks_count);
 		desc->bg_free_blocks_count = cpu_to_le16(free_blocks + count);
 		spin_unlock(sb_bgl_lock(sbi, group_no));
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		mark_buffer_dirty(bh);
 	}
 }
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 938dbc7..bd2a472 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -81,7 +81,7 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(bh);
 }
 
@@ -547,7 +547,7 @@ got:
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(bh2);
 	if (test_opt(sb, GRPID)) {
 		inode->i_mode = mode;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 71e9eb1..b8e23d3 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -119,7 +119,7 @@ static void ext2_put_super (struct super_block * sb)
 	int i;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		ext2_write_super(sb);
 
 	ext2_xattr_put_super(sb);
@@ -1147,7 +1147,7 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	if (wait)
 		sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 }
 
 /*
@@ -1181,7 +1181,7 @@ void ext2_write_super(struct super_block *sb)
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
 	else
-		sb->s_dirt = 0;
+		mark_sb_clean(sb);
 }
 
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..b2e9cfb 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -348,7 +348,7 @@ static void ext2_xattr_update_super_block(struct super_block *sb)
 	spin_lock(&EXT2_SB(sb)->s_lock);
 	EXT2_SET_COMPAT_FEATURE(sb, EXT2_FEATURE_COMPAT_EXT_ATTR);
 	spin_unlock(&EXT2_SB(sb)->s_lock);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 }
 
-- 
1.6.6.1
