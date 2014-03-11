From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/49] libext2fs: don't fail when doing a strict rewrite of
 inline data
Date: Mon, 10 Mar 2014 23:54:56 -0700
Message-ID: <20140311065456.30585.47345.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21231 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaCKGy7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:59 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_inline_data_set() tries to ensure that there is sufficient free
space in the inode to store the inline data.  Unfortunately, it gets
the check wrong -- ext2fs_xattr_inode_max_size() returns the amount of
unused bytes in the EA area, and _data_set() doesn't factor in the
size of the existing inline data.  Therefore, a strict rewrite of an
N-byte inlinedata with another N-byte inlinedata fails.

Fix the code to do the size check correctly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inline_data.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 9a786fc..72e8fa3 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -522,7 +522,7 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2_inode inode_buf;
 	struct ext2_inline_data data;
 	errcode_t retval;
-	size_t max_size;
+	size_t free_ea_size, existing_size, free_inode_size;
 
 	if (!inode) {
 		retval = ext2fs_read_inode(fs, ino, &inode_buf);
@@ -536,11 +536,20 @@ errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
 		return ext2fs_write_inode(fs, ino, inode);
 	}
 
-	retval = ext2fs_xattr_inode_max_size(fs, ino, &max_size);
+	retval = ext2fs_xattr_inode_max_size(fs, ino, &free_ea_size);
 	if (retval)
 		return retval;
 
-	if (size - EXT4_MIN_INLINE_DATA_SIZE > max_size)
+	retval = ext2fs_inline_data_size(fs, ino, &existing_size);
+	if (retval)
+		return retval;
+
+	if (existing_size < EXT4_MIN_INLINE_DATA_SIZE)
+		free_inode_size = EXT4_MIN_INLINE_DATA_SIZE - existing_size;
+	else
+		free_inode_size = 0;
+
+	if (size > existing_size + free_ea_size + free_inode_size)
 		return EXT2_ET_INLINE_DATA_NO_SPACE;
 
 	memcpy((void *)inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);

