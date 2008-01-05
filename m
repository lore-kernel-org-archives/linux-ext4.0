From: marcin.slusarz@gmail.com
Subject: [PATCH 2/3] ext3: replace all adds to little endians variables with le*_add_cpu
Date: Sat,  5 Jan 2008 16:36:21 +0100
Message-ID: <1199547382-29969-3-git-send-email-marcin.slusarz@gmail.com>
References: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>,
	OCFS2-devel <ocfs2-devel@oss.oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, xfs-masters@oss.sgi.com,
	Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756432AbYAEPgK@vger.kernel.org>
In-Reply-To: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

replace all:
	little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
				expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
sparse didn't generate any new warning with this patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 fs/ext3/balloc.c |    7 ++-----
 fs/ext3/ialloc.c |   12 ++++--------
 fs/ext3/resize.c |   12 ++++--------
 fs/ext3/super.c  |    2 +-
 fs/ext3/xattr.c  |    6 ++----
 5 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index a8ba7e8..89f320f 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -566,9 +566,7 @@ do_more:
 	jbd_unlock_bh_state(bitmap_bh);
 
 	spin_lock(sb_bgl_lock(sbi, block_group));
-	desc->bg_free_blocks_count =
-		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
-			group_freed);
+	le16_add_cpu(&desc->bg_free_blocks_count, group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_add(&sbi->s_freeblocks_counter, count);
 
@@ -1630,8 +1628,7 @@ allocated:
 			ret_block, goal_hits, goal_attempts);
 
 	spin_lock(sb_bgl_lock(sbi, group_no));
-	gdp->bg_free_blocks_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
+	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 1bc8cd8..3b6b9da 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -164,11 +164,9 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 
 		if (gdp) {
 			spin_lock(sb_bgl_lock(sbi, block_group));
-			gdp->bg_free_inodes_count = cpu_to_le16(
-				le16_to_cpu(gdp->bg_free_inodes_count) + 1);
+			le16_add_cpu(&gdp->bg_free_inodes_count, 1);
 			if (is_directory)
-				gdp->bg_used_dirs_count = cpu_to_le16(
-				  le16_to_cpu(gdp->bg_used_dirs_count) - 1);
+				le16_add_cpu(&gdp->bg_used_dirs_count, -1);
 			spin_unlock(sb_bgl_lock(sbi, block_group));
 			percpu_counter_inc(&sbi->s_freeinodes_counter);
 			if (is_directory)
@@ -527,11 +525,9 @@ got:
 	err = ext3_journal_get_write_access(handle, bh2);
 	if (err) goto fail;
 	spin_lock(sb_bgl_lock(sbi, group));
-	gdp->bg_free_inodes_count =
-		cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+	le16_add_cpu(&gdp->bg_free_inodes_count, -1);
 	if (S_ISDIR(mode)) {
-		gdp->bg_used_dirs_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_used_dirs_count) + 1);
+		le16_add_cpu(&gdp->bg_used_dirs_count, 1);
 	}
 	spin_unlock(sb_bgl_lock(sbi, group));
 	BUFFER_TRACE(bh2, "call ext3_journal_dirty_metadata");
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 44de145..5b402a7 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -518,8 +518,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	EXT3_SB(sb)->s_gdb_count++;
 	kfree(o_group_desc);
 
-	es->s_reserved_gdt_blocks =
-		cpu_to_le16(le16_to_cpu(es->s_reserved_gdt_blocks) - 1);
+	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
 	ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
 
 	return 0;
@@ -891,10 +890,8 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 	 * blocks/inodes before the group is live won't actually let us
 	 * allocate the new space yet.
 	 */
-	es->s_blocks_count = cpu_to_le32(le32_to_cpu(es->s_blocks_count) +
-		input->blocks_count);
-	es->s_inodes_count = cpu_to_le32(le32_to_cpu(es->s_inodes_count) +
-		EXT3_INODES_PER_GROUP(sb));
+	le32_add_cpu(&es->s_blocks_count, input->blocks_count);
+	le32_add_cpu(&es->s_inodes_count, EXT3_INODES_PER_GROUP(sb));
 
 	/*
 	 * We need to protect s_groups_count against other CPUs seeing
@@ -927,8 +924,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
-	es->s_r_blocks_count = cpu_to_le32(le32_to_cpu(es->s_r_blocks_count) +
-		input->reserved_blocks);
+	le32_add_cpu(&es->s_r_blocks_count, input->reserved_blocks);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeblocks_counter,
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 92f03b6..70da5a3 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1224,7 +1224,7 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT3_DFL_MAX_MNT_COUNT);
-	es->s_mnt_count=cpu_to_le16(le16_to_cpu(es->s_mnt_count) + 1);
+	le16_add_cpu(&es->s_mnt_count, 1);
 	es->s_mtime = cpu_to_le32(get_seconds());
 	ext3_update_dynamic_rev(sb);
 	EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index 4083738..fb89c29 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -492,8 +492,7 @@ ext3_xattr_release_block(handle_t *handle, struct inode *inode,
 		get_bh(bh);
 		ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
 	} else {
-		BHDR(bh)->h_refcount = cpu_to_le32(
-				le32_to_cpu(BHDR(bh)->h_refcount) - 1);
+		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		error = ext3_journal_dirty_metadata(handle, bh);
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
@@ -780,8 +779,7 @@ inserted:
 				if (error)
 					goto cleanup_dquot;
 				lock_buffer(new_bh);
-				BHDR(new_bh)->h_refcount = cpu_to_le32(1 +
-					le32_to_cpu(BHDR(new_bh)->h_refcount));
+				le32_add_cpu(&BHDR(new_bh)->h_refcount, 1);
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
 				unlock_buffer(new_bh);
-- 
1.5.3.7

