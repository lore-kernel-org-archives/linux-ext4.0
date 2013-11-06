From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] ext4: return non-zero st_blocks for inline data
Date: Wed,  6 Nov 2013 03:42:32 -0700
Message-ID: <1383734552-12991-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57514 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3KFKwK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Nov 2013 05:52:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Return a non-zero st_blocks to userspace for statfs() and friends.
Some versions of tar will assume that files with st_blocks == 0
do not contain any data and will skip reading them entirely.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 fs/ext4/inode.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbfe13b..e832a6a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4532,6 +4532,15 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	generic_fillattr(inode, stat);
 
 	/*
+	 * If there is inline data in the inode, the inode will normally not
+	 * have data blocks allocated (it may have an external xattr block).
+	 * Report at least one sector for such files, so tools like tar, rsync,
+	 * others doen't incorrectly think the file is completely sparse.
+	 */
+	if (unlikely(ext4_has_inline_data(inode)))
+		stat->blocks += (stat->size + 511) >> 9;
+
+	/*
 	 * We can't update i_blocks if the block allocation is delayed
 	 * otherwise in the case of system crash before the real block
 	 * allocation is done, we will have i_blocks inconsistent with
@@ -4542,9 +4551,9 @@ int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	 * blocks for this file.
 	 */
 	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
-				EXT4_I(inode)->i_reserved_data_blocks);
+				   EXT4_I(inode)->i_reserved_data_blocks);
+	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits - 9);
 
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
 	return 0;
 }
 
-- 
1.7.3.4

