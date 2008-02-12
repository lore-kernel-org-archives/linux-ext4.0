From: marcin.slusarz@gmail.com
Subject: [PATCH] ext2: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:14 +0100
Message-ID: <1202857582-15450-10-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:8053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760624AbYBLXJq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Feb 2008 18:09:46 -0500
Received: by fg-out-1718.google.com with SMTP id e21so4228506fga.17
        for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 15:09:45 -0800 (PST)
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
					expression_in_cpu_byteorder);
with:
	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext2/ialloc.c |   12 ++++--------
 fs/ext2/super.c  |    2 +-
 fs/ext2/xattr.c  |    9 +++------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 5deb8b7..0f3e3f3 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -75,11 +75,9 @@ static void ext2_release_inode(struct super_block *sb, int group, int dir)
 	}
 
 	spin_lock(sb_bgl_lock(EXT2_SB(sb), group));
-	desc->bg_free_inodes_count =
-		cpu_to_le16(le16_to_cpu(desc->bg_free_inodes_count) + 1);
+	le16_add_cpu(&desc->bg_free_inodes_count, 1);
 	if (dir)
-		desc->bg_used_dirs_count =
-			cpu_to_le16(le16_to_cpu(desc->bg_used_dirs_count) - 1);
+		le16_add_cpu(&desc->bg_used_dirs_count, -1);
 	spin_unlock(sb_bgl_lock(EXT2_SB(sb), group));
 	if (dir)
 		percpu_counter_dec(&EXT2_SB(sb)->s_dirs_counter);
@@ -539,13 +537,11 @@ got:
 		percpu_counter_inc(&sbi->s_dirs_counter);
 
 	spin_lock(sb_bgl_lock(sbi, group));
-	gdp->bg_free_inodes_count =
-                cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+	le16_add_cpu(&gdp->bg_free_inodes_count, -1);
 	if (S_ISDIR(mode)) {
 		if (sbi->s_debts[group] < 255)
 			sbi->s_debts[group]++;
-		gdp->bg_used_dirs_count =
-			cpu_to_le16(le16_to_cpu(gdp->bg_used_dirs_count) + 1);
+		le16_add_cpu(&gdp->bg_used_dirs_count, 1);
 	} else {
 		if (sbi->s_debts[group])
 			sbi->s_debts[group]--;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 108f739..7e68673 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -603,7 +603,7 @@ static int ext2_setup_super (struct super_block * sb,
 			"running e2fsck is recommended\n");
 	if (!le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT2_DFL_MAX_MNT_COUNT);
-	es->s_mnt_count=cpu_to_le16(le16_to_cpu(es->s_mnt_count) + 1);
+	le16_add_cpu(&es->s_mnt_count, 1);
 	ext2_write_super(sb);
 	if (test_opt (sb, DEBUG))
 		printk ("[EXT II FS %s, %s, bs=%lu, fs=%lu, gc=%lu, "
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 3e8683d..495ec0d 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -646,8 +646,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 					unlock_buffer(new_bh);
 					goto cleanup;
 				}
-				HDR(new_bh)->h_refcount = cpu_to_le32(1 +
-					le32_to_cpu(HDR(new_bh)->h_refcount));
+				le32_add_cpu(&HDR(new_bh)->h_refcount, 1);
 				ea_bdebug(new_bh, "refcount now=%d",
 					le32_to_cpu(HDR(new_bh)->h_refcount));
 			}
@@ -731,8 +730,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			bforget(old_bh);
 		} else {
 			/* Decrement the refcount only. */
-			HDR(old_bh)->h_refcount = cpu_to_le32(
-				le32_to_cpu(HDR(old_bh)->h_refcount) - 1);
+			le32_add_cpu(&HDR(old_bh)->h_refcount, -1);
 			if (ce)
 				mb_cache_entry_release(ce);
 			DQUOT_FREE_BLOCK(inode, 1);
@@ -789,8 +787,7 @@ ext2_xattr_delete_inode(struct inode *inode)
 		bforget(bh);
 		unlock_buffer(bh);
 	} else {
-		HDR(bh)->h_refcount = cpu_to_le32(
-			le32_to_cpu(HDR(bh)->h_refcount) - 1);
+		le32_add_cpu(&HDR(bh)->h_refcount, -1);
 		if (ce)
 			mb_cache_entry_release(ce);
 		ea_bdebug(bh, "refcount now=%d",
-- 
1.5.3.7
