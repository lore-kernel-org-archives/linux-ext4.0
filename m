From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.27 21/24] ext4: only use i_size_high for regular files
Date: Tue, 17 Feb 2009 10:58:41 -0500
Message-ID: <1234886324-15105-22-git-send-email-tytso@mit.edu>
References: <1234886324-15105-1-git-send-email-tytso@mit.edu>
 <1234886324-15105-2-git-send-email-tytso@mit.edu>
 <1234886324-15105-3-git-send-email-tytso@mit.edu>
 <1234886324-15105-4-git-send-email-tytso@mit.edu>
 <1234886324-15105-5-git-send-email-tytso@mit.edu>
 <1234886324-15105-6-git-send-email-tytso@mit.edu>
 <1234886324-15105-7-git-send-email-tytso@mit.edu>
 <1234886324-15105-8-git-send-email-tytso@mit.edu>
 <1234886324-15105-9-git-send-email-tytso@mit.edu>
 <1234886324-15105-10-git-send-email-tytso@mit.edu>
 <1234886324-15105-11-git-send-email-tytso@mit.edu>
 <1234886324-15105-12-git-send-email-tytso@mit.edu>
 <1234886324-15105-13-git-send-email-tytso@mit.edu>
 <1234886324-15105-14-git-send-email-tytso@mit.edu>
 <1234886324-15105-15-git-send-email-tytso@mit.edu>
 <1234886324-15105-16-git-send-email-tytso@mit.edu>
 <1234886324-15105-17-git-send-email-tytso@mit.edu>
 <1234886324-15105-18-git-send-email-tytso@mit.edu>
 <1234886324-15105-19-git-send-email-tytso@mit.edu>
 <1234886324-15105-20-git-send-email-tytso@mit.edu>
 <1234886324-15105-21-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56257 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbZBQQPM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:15:12 -0500
In-Reply-To: <1234886324-15105-21-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Directories are not allowed to be bigger than 2GB, so don't use
i_size_high for anything other than regular files.  E2fsck should
complain about these inodes, but the simplest thing to do for the
kernel is to only use i_size_high for regular files.

This prevents an intentially corrupted filesystem from causing the
kernel to burn a huge amount of CPU and issuing error messages such
as:

EXT4-fs warning (device loop0): ext4_block_to_path: block 135090028 > max

Thanks to David Maciejak from Fortinet's FortiGuard Global Security
Research Team for reporting this issue.

http://bugzilla.kernel.org/show_bug.cgi?id=12375

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit 06a279d636734da32bb62dd2f7b0ade666f65d7c)
---
 fs/ext4/ext4.h  |    7 +++++--
 fs/ext4/inode.c |    4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2f7b639..85f58af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1174,8 +1174,11 @@ static inline void ext4_r_blocks_count_set(struct ext4_super_block *es,
 
 static inline loff_t ext4_isize(struct ext4_inode *raw_inode)
 {
-	return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
-		le32_to_cpu(raw_inode->i_size_lo);
+	if (S_ISREG(le16_to_cpu(raw_inode->i_mode)))
+		return ((loff_t)le32_to_cpu(raw_inode->i_size_high) << 32) |
+			le32_to_cpu(raw_inode->i_size_lo);
+	else
+		return (loff_t) le32_to_cpu(raw_inode->i_size_lo);
 }
 
 static inline void ext4_isize_set(struct ext4_inode *raw_inode, loff_t i_size)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3616845..6e7f085 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -351,9 +351,9 @@ static int ext4_block_to_path(struct inode *inode,
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
1.5.6.3

