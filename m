From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 19/30] ext4: snapshot control - reserve disk space for snapshot
Date: Mon,  9 May 2011 19:41:37 +0300
Message-ID: <1304959308-11122-20-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1EIQoD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:44:03 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:44:02 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Ensure there is enough disk space for snapshot file future use.
Reserve disk space on snapshot take based on file system overhead
size, number of directories and number of blocks/inodes in use.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/balloc.c  |   25 +++++++++++++++++++++++++
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/mballoc.c |    6 ++++++
 fs/ext4/super.c   |   16 +++++++++++++++-
 4 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 350f502..7d22e50 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -370,6 +370,8 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 {
 	s64 free_blocks, dirty_blocks, root_blocks;
+	ext4_fsblk_t snapshot_r_blocks;
+	handle_t *handle = journal_current_handle();
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
 	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
@@ -377,6 +379,29 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
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
index c04a031..884033f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1974,6 +1974,8 @@ extern __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 group,
 				   struct ext4_group_desc *gdp);
 extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
 				       struct ext4_group_desc *gdp);
+struct kstatfs;
+extern int ext4_statfs_sb(struct super_block *sb, struct kstatfs *buf);
 
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d43f493..4813b15 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4290,10 +4290,16 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
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
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d26831a..a768b63 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4464,7 +4464,11 @@ restore_opts:
 
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
@@ -4516,6 +4520,16 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
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
1.7.0.4

