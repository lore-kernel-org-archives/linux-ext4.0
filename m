From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 23/28] ext4: Avoid crashing on NULL ptr dereference on a filesystem error
Date: Tue,  1 Jun 2010 12:13:10 -0400
Message-ID: <1275408795-17487-23-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56868 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756804Ab0FAQNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:21 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit f70f362b4a6fe47c239dbfb3efc0cc2c10e4f09c upstream (as of v2.6.34-git13)

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
index a1d3f7c..8e8a7a4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3381,8 +3381,9 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (unlikely(path[depth].p_ext == NULL && depth != 0)) {
 		EXT4_ERROR_INODE(inode, "bad extent address "
-				 "iblock: %d, depth: %d pblock %lld",
-				 iblock, depth, path[depth].p_block);
+				 "iblock: %lu, depth: %d pblock %lld",
+				 (unsigned long) iblock, depth,
+				 path[depth].p_block);
 		err = -EIO;
 		goto out2;
 	}
@@ -3512,8 +3513,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
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

