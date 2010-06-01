From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 35/40] ext4: Avoid crashing on NULL ptr dereference on a filesystem error
Date: Tue,  1 Jun 2010 08:03:22 -0400
Message-ID: <1275393807-14369-35-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47285 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
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
index 5b1c104..e2d9bfb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3275,8 +3275,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
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
@@ -3412,8 +3412,11 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
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

