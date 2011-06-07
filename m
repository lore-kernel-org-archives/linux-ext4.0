From: amir73il@users.sourceforge.net
Subject: [PATCH v1 21/36] ext4: snapshot control - reserve disk space for snapshot
Date: Tue,  7 Jun 2011 18:07:48 +0300
Message-ID: <1307459283-22130-22-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:55 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:54 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Ensure there is enough disk space for snapshot file future use.
Reserve disk space on snapshot take based on file system overhead
size, number of directories and number of blocks/inodes in use.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/balloc.c       |   25 +++++++++++++++++++++++++
 fs/ext4/ext4.h         |    2 ++
 fs/ext4/mballoc.c      |    6 ++++++
 fs/ext4/snapshot_ctl.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c        |   16 +++++++++++++++-
 5 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 8f1803f..1c140e4 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -372,6 +372,8 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 {
 	s64 free_blocks, dirty_blocks, root_blocks;
+	ext4_fsblk_t snapshot_r_blocks;
+	handle_t *handle = journal_current_handle();
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
 	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
@@ -379,6 +381,29 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 	dirty_blocks = percpu_counter_read_positive(dbc);
 	root_blocks = ext4_r_blocks_count(sbi->s_es);
 
+	if (ext4_snapshot_active(sbi)) {
+		if (unlikely(free_blocks < (nblocks + dirty_blocks)))
+			/* sorry, but we're really out of space */
+			return 0;
+		if (handle && unlikely(IS_COWING(handle)))
+			/* any available space may be used by COWing task */
+			return 1;
+		/* reserve blocks for active snapshot */
+		snapshot_r_blocks =
+			le64_to_cpu(sbi->s_es->s_snapshot_r_blocks_count);
+		/*
+		 * The last snapshot_r_blocks are reserved for active snapshot
+		 * and may not be allocated even by root.
+		 */
+		if (free_blocks < (nblocks + dirty_blocks + snapshot_r_blocks))
+			return 0;
+		/*
+		 * Mortal users must reserve blocks for both snapshot and
+		 * root user.
+		 */
+		root_blocks += snapshot_r_blocks;
+	}
+
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
 		free_blocks  = percpu_counter_sum_positive(fbc);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 198d7d4..8d82125 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1963,6 +1963,8 @@ extern __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 group,
 				   struct ext4_group_desc *gdp);
 extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
 				       struct ext4_group_desc *gdp);
+struct kstatfs;
+extern int ext4_statfs_sb(struct super_block *sb, struct kstatfs *buf);
 
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6e4d960..899c12c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4296,10 +4296,16 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 			return 0;
 		}
 		reserv_blks = ar->len;
+		if (unlikely(ar->flags & EXT4_MB_HINT_COWING)) {
+			/* don't fail when allocating blocks for COW */
+			dquot_alloc_block_nofail(ar->inode, ar->len);
+			goto nofail;
+		}
 		while (ar->len && dquot_alloc_block(ar->inode, ar->len)) {
 			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
 			ar->len--;
 		}
+nofail:
 		inquota = ar->len;
 		if (ar->len == 0) {
 			*errp = -EDQUOT;
diff --git a/fs/ext4/snapshot_ctl.c b/fs/ext4/snapshot_ctl.c
index 360581d..a610025 100644
--- a/fs/ext4/snapshot_ctl.c
+++ b/fs/ext4/snapshot_ctl.c
@@ -711,6 +711,8 @@ int ext4_snapshot_take(struct inode *inode)
 	int fixing = 0;
 	int i;
 	int err = -EIO;
+	u64 snapshot_r_blocks;
+	struct kstatfs statfs;
 
 	if (!sbi->s_sbh)
 		goto out_err;
@@ -739,6 +741,47 @@ int ext4_snapshot_take(struct inode *inode)
 	}
 
 	err = -EIO;
+	/* update fs statistics to calculate snapshot reserved space */
+	if (ext4_statfs_sb(sb, &statfs)) {
+		snapshot_debug(1, "failed to statfs before snapshot (%u) "
+			       "take\n", inode->i_generation);
+		goto out_err;
+	}
+	/*
+	 * Estimate maximum disk space for snapshot file metadata based on:
+	 * 1 indirect block per 1K fs blocks (to map moved data blocks)
+	 * +1 data block per 1K fs blocks (to copy indirect blocks)
+	 * +1 data block per fs meta block (to copy meta blocks)
+	 * +1 data block per directory (to copy small directory index blocks)
+	 * +1 data block per X inodes (to copy large directory index blocks)
+	 *
+	 * We estimate no. of dir blocks from no. of allocated inode, assuming
+	 * an avg. dir record size of 64 bytes. This assumption can break in
+	 * 2 cases:
+	 *   1. long file names (in avg.)
+	 *   2. large no. of hard links (many dir records for the same inode)
+	 *
+	 * Under estimation can lead to potential ENOSPC during COW, which
+	 * will trigger an ext4_error(). Hopefully, error behavior is set to
+	 * remount-ro, so snapshot will not be corrupted.
+	 *
+	 * XXX: reserved space may be too small in data jounaling mode,
+	 *      which is currently not supported.
+	 */
+#define AVG_DIR_RECORD_SIZE_BITS 6 /* 64 bytes */
+#define AVG_INODES_PER_DIR_BLOCK \
+	(SNAPSHOT_BLOCK_SIZE_BITS - AVG_DIR_RECORD_SIZE_BITS)
+	snapshot_r_blocks = 2 * (statfs.f_blocks >>
+			SNAPSHOT_ADDR_PER_BLOCK_BITS) +
+		statfs.f_spare[0] + statfs.f_spare[1] +
+		((statfs.f_files - statfs.f_ffree) >>
+		 AVG_INODES_PER_DIR_BLOCK);
+
+	/* verify enough free space before taking the snapshot */
+	if (statfs.f_bfree < snapshot_r_blocks) {
+		err = -ENOSPC;
+		goto out_err;
+	}
 
 	/*
 	 * flush journal to disk and clear the RECOVER flag
@@ -876,6 +919,7 @@ next_inode:
 		goto out_unlockfs;
 
 	/* set as on-disk active snapshot */
+	sbi->s_es->s_snapshot_r_blocks_count = cpu_to_le64(snapshot_r_blocks);
 
 	sbi->s_es->s_snapshot_id =
 		cpu_to_le32(le32_to_cpu(sbi->s_es->s_snapshot_id) + 1);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dbe5651..a7be485 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4515,7 +4515,11 @@ restore_opts:
 
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct super_block *sb = dentry->d_sb;
+	return ext4_statfs_sb(dentry->d_sb, buf);
+}
+
+int ext4_statfs_sb(struct super_block *sb, struct kstatfs *buf)
+{
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	u64 fsid;
@@ -4567,6 +4571,16 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
+	if (ext4_snapshot_active(sbi)) {
+		if (buf->f_bfree < ext4_r_blocks_count(es) +
+				le64_to_cpu(es->s_snapshot_r_blocks_count))
+			buf->f_bavail = 0;
+		else
+			buf->f_bavail -=
+				le64_to_cpu(es->s_snapshot_r_blocks_count);
+	}
+	buf->f_spare[0] = percpu_counter_sum_positive(&sbi->s_dirs_counter);
+	buf->f_spare[1] = sbi->s_overhead_last;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	buf->f_namelen = EXT4_NAME_LEN;
-- 
1.7.4.1

