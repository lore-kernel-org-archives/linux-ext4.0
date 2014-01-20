From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 01/12] libext2fs: fix off-by-one bug in ext2fs_extent_insert()
Date: Mon, 20 Jan 2014 00:54:03 -0500
Message-ID: <1390197254-14583-2-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49962 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaATFy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:28 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When inserting the first extent into an empty inode, the
ext2fs_extent_insert() leaves path->left set to 1 instead of 0.  Since
path->curr is pointing at the last (only) extent in the file,
path->left should be 0.

This is mostly harmless, and gets corrected fairly quickly if the
calling applicaton jumps to a different part of the extent tree ---
for example, by calling ext2fs_extent_goto(), or calling
ext2fs_extent_get with the flags argument set to EXT2_EXTENT_ROOT.
Which is why we hadn't noticed this problem until now.

However, if you insert four extents using ext2fs_extent_insert, the
fourth insert will end up copying too many bytes in the i_block[]
array, since path->left is one larger than it should be.  This results
in the inode fields i_generation, i_file_acl, and i_size_high getting
zeroed out.

This problem can be replicated as follows:

% cp /dev/null /tmp/foo.img
% mke2fs -F -t ext4 /tmp/foo.img 100
% debugfs -w /tmp/foo.img
debugfs: write /dev/null foo
debugfs: set_inode_field foo i_size_hi 1
debugfs: stat foo
 <----- note that the inode's size is 4294967296
debugfs: extent_open foo
debugfs (extent ino 12): insert --after 0 1 100
debugfs (extent ino 12): insert --after 1 1 101
debugfs (extent ino 12): insert --after 2 1 102
debugfs (extent ino 12): insert --after 3 1 103
debugfs (extent ino 12): extent_close
debugfs: stat foo
 <----- note that the inode's size is now 0
debugfs: quit

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 5cdc2e4..6f4f1d2 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1092,8 +1092,10 @@ errcode_t ext2fs_extent_insert(ext2_extent_handle_t handle, int flags,
 			ix++;
 			path->left--;
 		}
-	} else
+	} else {
 		ix = EXT_FIRST_INDEX(eh);
+		path->left = -1;
+	}
 
 	path->curr = ix;
 
-- 
1.8.5.rc3.362.gdf10213

