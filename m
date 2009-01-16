From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: ignore i_size_high for directories
Date: Fri, 16 Jan 2009 11:59:08 -0500
Message-ID: <1232125148-13785-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45250 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZAPQ7L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 11:59:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Directories are not allowed to be bigger than 2TB, so don't use
i_size_high when reading the inode.  E2fsck should complain about
these inodes, but the simplest thing to do for the kernel is simply to
not consult i_size_high for directory inodes.

This prevents an intentially corrupted filesystem from causing the
kernel to burn a huge amount of CPU and issuing error messages such
as:

EXT4-fs warning (device loop0): ext4_block_to_path: block 135090028 > max

Thanks to David Maciejak from Fortinet's FortiGuard Global Security
Research Team for reporting this issue.

http://bugzilla.kernel.org/show_bug.cgi?id=12375

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/ext4.h  |    7 +++++--
 fs/ext4/inode.c |    4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c668e43..42396a6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1206,8 +1206,11 @@ static inline void ext4_r_blocks_count_set(struct ext4_super_block *es,
 
 static inline loff_t ext4_isize(struct ext4_inode *raw_inode)
 {
-	return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
-		le32_to_cpu(raw_inode->i_size_lo);
+	if (S_ISDIR(le16_to_cpu(raw_inode->i_mode)))
+		return (loff_t) le32_to_cpu(raw_inode->i_size_lo);
+	else
+		return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
+			le32_to_cpu(raw_inode->i_size_lo);
 }
 
 static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a6444ce..49484ba 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -360,9 +360,9 @@ static int ext4_block_to_path(struct inode *inode,
 		final = ptrs;
 	} else {
 		ext4_warning(inode->i_sb, "ext4_block_to_path",
-				"block %lu > max",
+				"block %lu > max in inode %lu",
 				i_block + direct_blocks +
-				indirect_blocks + double_blocks);
+				indirect_blocks + double_blocks, inode->i_ino);
 	}
 	if (boundary)
 		*boundary = final - 1 - (i_block & (ptrs - 1));
-- 
1.6.0.4.8.g36f27.dirty

