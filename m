From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: Avoid crashing on NULL ptr dereference on a filesystem error
Date: Tue, 25 May 2010 00:18:36 -0400
Message-ID: <1274761117-26560-1-git-send-email-tytso@mit.edu>
References: <20100525041737.GB5556@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49557 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab0EYESj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 00:18:39 -0400
In-Reply-To: <20100525041737.GB5556@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the EOFBLOCK_FL flag is set when it should not be and the inode is
zero length, then eh_entries is zero, and ex is NULL, so dereferencing
ex to print ex->ee_block causes a kernel OOPS in
ext4_ext_map_blocks().

On top of that, the error message which is printed isn't very helpful.
So we fix this by printing something more explanatory which doesn't
involve trying to print ex->ee_block.

Addresses-Google-Bug: #2655740

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 595ab6d..aeec5c7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3370,8 +3370,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (unlikely(path[depth].p_ext == NULL && depth != 0)) {
 		EXT4_ERROR_INODE(inode, "bad extent address "
-				 "iblock: %d, depth: %d pblock %lld",
-				 map->m_lblk, depth, path[depth].p_block);
+				 "lblock: %lu, depth: %d pblock %lld",
+				 (unsigned long) map->m_lblk, depth,
+				 path[depth].p_block);
 		err = -EIO;
 		goto out2;
 	}
@@ -3501,8 +3502,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	if (unlikely(ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))) {
 		if (unlikely(!eh->eh_entries)) {
 			EXT4_ERROR_INODE(inode,
-					 "eh->eh_entries == 0 ee_block %d",
-					 ex->ee_block);
+					 "eh->eh_entries == 0 and "
+					 "EOFBLOCKS_FL set");
 			err = -EIO;
 			goto out2;
 		}
-- 
1.6.6.1.1.g974db.dirty

