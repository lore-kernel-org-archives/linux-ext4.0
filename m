From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCHv4 07/17] EXT4: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:49:02 +0300
Message-ID: <1274795352-3551-8-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/balloc.c  |    2 +-
 fs/ext4/file.c    |    2 +-
 fs/ext4/ialloc.c  |    4 ++--
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    4 ++--
 fs/ext4/resize.c  |    4 ++--
 fs/ext4/super.c   |    6 +++---
 fs/ext4/xattr.c   |    2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index d2f37a5..36b35cf 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -477,7 +477,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	ret = ext4_handle_dirty_metadata(handle, NULL, gd_bh);
 	if (!err)
 		err = ret;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 error_return:
 	brelse(bitmap_bh);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d0776e4..edef79f 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -123,7 +123,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		if (!IS_ERR(cp)) {
 			memcpy(sbi->s_es->s_last_mounted, cp,
 			       sizeof(sbi->s_es->s_last_mounted));
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 		}
 	}
 	return dquot_file_open(inode, filp);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1a0e183..2de625e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -289,7 +289,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
 	if (!fatal)
 		fatal = err;
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, fatal);
@@ -972,7 +972,7 @@ got:
 	percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	if (sbi->s_log_groups_per_flex) {
 		flex_group = ext4_flex_group(sbi, group);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3e0f6af..158c6d9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5276,7 +5276,7 @@ static int ext4_do_update_inode(handle_t *handle,
 			ext4_update_dynamic_rev(sb);
 			EXT4_SET_RO_COMPAT_FEATURE(sb,
 					EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
-			sb->s_dirt = 1;
+			mark_sb_dirty(sb);
 			ext4_handle_sync(handle);
 			err = ext4_handle_dirty_metadata(handle, NULL,
 					EXT4_SB(sb)->s_sbh);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b423a36..1f363a0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2762,7 +2762,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	err = ext4_handle_dirty_metadata(handle, NULL, gdp_bh);
 
 out_err:
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	brelse(bitmap_bh);
 	return err;
 }
@@ -4630,7 +4630,7 @@ do_more:
 		put_bh(bitmap_bh);
 		goto do_more;
 	}
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 error_return:
 	if (freed)
 		dquot_free_block(inode, freed);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5692c48..fe7cc90 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -921,7 +921,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	}
 
 	ext4_handle_dirty_metadata(handle, NULL, sbi->s_sbh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 exit_journal:
 	mutex_unlock(&sbi->s_resize_lock);
@@ -1045,7 +1045,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	}
 	ext4_blocks_count_set(es, o_blocks_count + add);
 	ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 	mutex_unlock(&EXT4_SB(sb)->s_resize_lock);
 	ext4_debug("freeing blocks %llu through %llu\n", o_blocks_count,
 		   o_blocks_count + add);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..b4ebc48 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -650,7 +650,7 @@ static void ext4_put_super(struct super_block *sb)
 
 	lock_super(sb);
 	lock_kernel();
-	if (sb->s_dirt)
+	if (is_sb_dirty(sb))
 		ext4_commit_super(sb, 1);
 
 	if (sbi->s_journal) {
@@ -2680,7 +2680,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 #else
 		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 	}
 
 	if (sbi->s_blocks_per_group > blocksize * 8) {
@@ -3387,7 +3387,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 					&EXT4_SB(sb)->s_freeblocks_counter));
 	es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
 					&EXT4_SB(sb)->s_freeinodes_counter));
-	sb->s_dirt = 0;
+	mark_sb_clean(sb);
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 2de0e95..a8032a5 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -460,7 +460,7 @@ static void ext4_xattr_update_super_block(handle_t *handle,
 
 	if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
 		EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);
 	}
 }
-- 
1.6.6.1

