From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/49] libext2fs: fix iblocks correctly when expanding an
 inline_data file
Date: Mon, 10 Mar 2014 23:55:02 -0700
Message-ID: <20140311065502.30585.81788.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32283 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaCKGzG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:06 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

i_blocks covers the number of blocks allocated to an inode for data,
extents, and ACL blocks.  Since it's possible for a file to have a
separate ACL block and inline data, we must be careful when expanding
an inline data file to adjust, not set, the value of i_blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inline_data.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 72e8fa3..a9ec923 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -372,7 +372,9 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
 	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT3_FEATURE_INCOMPAT_EXTENTS))
 		inode->i_flags |= EXT4_EXTENTS_FL;
 	inode->i_flags &= ~EXT4_INLINE_DATA_FL;
-	ext2fs_iblk_set(fs, inode, 1);
+	retval = ext2fs_iblk_add_blocks(fs, inode, 1);
+	if (retval)
+		goto errout;
 	inode->i_size = fs->blocksize;
 	retval = ext2fs_bmap2(fs, ino, inode, 0, BMAP_SET, 0, 0, &blk);
 	if (retval)
@@ -410,7 +412,6 @@ ext2fs_inline_data_file_expand(ext2_filsys fs, ext2_ino_t ino,
 		inode->i_flags |= EXT4_EXTENTS_FL;
 	}
 	inode->i_flags &= ~EXT4_INLINE_DATA_FL;
-	ext2fs_iblk_set(fs, inode, 0);
 	inode->i_size = 0;
 	retval = ext2fs_write_inode(fs, ino, inode);
 	if (retval)

