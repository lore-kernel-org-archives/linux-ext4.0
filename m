From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 48/53] ext4: Avoid crashing on NULL ptr dereference on a filesystem error
Date: Sun, 30 May 2010 22:50:01 -0400
Message-ID: <1275274206-3900-48-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44538 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab0EaCuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:14 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
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
 fs/ext4/extents.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ee9e2ab..d985da0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3281,8 +3281,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (path[depth].p_ext == NULL && depth != 0) {
 		ext4_error(inode->i_sb, __func__, "bad extent address "
-			   "inode: %lu, iblock: %d, depth: %d",
-			   inode->i_ino, iblock, depth);
+			   "inode: %lu, iblock: %lu, depth: %d",
+			   inode->i_ino, (unsigned long) iblock, depth);
 		err = -EIO;
 		goto out2;
 	}
@@ -3418,8 +3418,11 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		} else {
 			WARN_ON(eh->eh_entries == 0);
 			ext4_error(inode->i_sb, __func__,
-				"inode#%lu, eh->eh_entries = 0!", inode->i_ino);
-			}
+				   "inode#%lu, eh->eh_entries = 0 and "
+				   "EOFBLOCKS_FL set", inode->i_ino);
+			err = -EIO;
+			goto out2;
+		}
 	}
 	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
 	if (err) {
-- 
1.6.6.1.1.g974db.dirty

