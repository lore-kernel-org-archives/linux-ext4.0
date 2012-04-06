From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] libext2fs: use correct types in ext2fs_find_first_zero_block_bitmap2()
Date: Fri,  6 Apr 2012 11:59:05 -0700
Message-ID: <1333738746-5857-2-git-send-email-tytso@mit.edu>
References: <20120406185759.GA5584@thunk.org>
 <1333738746-5857-1-git-send-email-tytso@mit.edu>
Cc: rjones@redhat.com, sami.liedes@iki.fi,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60250 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757885Ab2DFTyN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:54:13 -0400
In-Reply-To: <1333738746-5857-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fortunately nothing was using this inline function, so we'll just fix
the types in its function signature, which were nonsensical (this was
caused by a cut-and-paste error).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/bitops.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 9382790..ae2142c 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -153,9 +153,9 @@ extern void ext2fs_fast_unmark_inode_bitmap2(ext2fs_inode_bitmap bitmap,
 extern int ext2fs_fast_test_inode_bitmap2(ext2fs_inode_bitmap bitmap,
 					  ext2_ino_t inode);
 extern errcode_t ext2fs_find_first_zero_block_bitmap2(ext2fs_block_bitmap bitmap,
-						      ext2_ino_t start,
-						      ext2_ino_t end,
-						      ext2_ino_t *out);
+						      blk64_t start,
+						      blk64_t end,
+						      blk64_t *out);
 extern errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitmap bitmap,
 						      ext2_ino_t start,
 						      ext2_ino_t end,
@@ -605,9 +605,9 @@ _INLINE_ int ext2fs_fast_test_inode_bitmap2(ext2fs_inode_bitmap bitmap,
 }
 
 _INLINE_ errcode_t ext2fs_find_first_zero_block_bitmap2(ext2fs_block_bitmap bitmap,
-							ext2_ino_t start,
-							ext2_ino_t end,
-							ext2_ino_t *out)
+							blk64_t start,
+							blk64_t end,
+							blk64_t *out)
 {
 	__u64 o;
 	errcode_t rv;
-- 
1.7.10.rc3

