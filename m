From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/7] libext2fs: Fix ext2fs_iblk_{add,sub}_blocks() when the i_blocks_hi is non-zero
Date: Thu, 22 Jul 2010 10:03:13 -0400
Message-ID: <1279807398-13680-3-git-send-email-tytso@mit.edu>
References: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Renzo Davoli <renzo@cs.unibo.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34069 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759421Ab0GVODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 10:03:22 -0400
In-Reply-To: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/i_block.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/i_block.c b/lib/ext2fs/i_block.c
index 822776d..39d93ee 100644
--- a/lib/ext2fs/i_block.c
+++ b/lib/ext2fs/i_block.c
@@ -31,6 +31,9 @@ errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
 {
 	unsigned long long b = inode->i_blocks;
 
+	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+		b += ((long long) inode->osd2.linux2.l_i_blocks_hi) << 32;
+
 	if (!(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
@@ -38,11 +41,9 @@ errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
 
 	b += num_blocks;
 
-	if (fs->super->s_feature_ro_compat &
-	    EXT4_FEATURE_RO_COMPAT_HUGE_FILE) {
-		b += ((long long) inode->osd2.linux2.l_i_blocks_hi) << 32;
+	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
 		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
-	} else if (b > 0xFFFFFFFF)
+	else if (b > 0xFFFFFFFF)
 		return EOVERFLOW;
 	inode->i_blocks = b & 0xFFFFFFFF;
 	return 0;
@@ -53,6 +54,9 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 {
 	unsigned long long b = inode->i_blocks;
 
+	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+		b += ((long long) inode->osd2.linux2.l_i_blocks_hi) << 32;
+
 	if (!(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
@@ -63,11 +67,8 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 
 	b -= num_blocks;
 
-	if (fs->super->s_feature_ro_compat &
-	    EXT4_FEATURE_RO_COMPAT_HUGE_FILE) {
-		b += ((long long) inode->osd2.linux2.l_i_blocks_hi) << 32;
+	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
 		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
-	}
 	inode->i_blocks = b & 0xFFFFFFFF;
 	return 0;
 }
-- 
1.7.0.4

