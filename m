From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/21] e2fsck: handle inline data symlinks
Date: Mon, 04 Aug 2014 18:06:08 -0700
Message-ID: <20140805010608.2611.12472.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40322 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaHEBGN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:06:13 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Perform some basic checks on inline-data symlinks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 74c70ca..f7c1fbb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -183,6 +183,8 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		return 0;
 
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
+		if (inode->i_flags & EXT4_INLINE_DATA_FL)
+			return 0;
 		if (inode->i_size > fs->blocksize)
 			return 0;
 		if (ext2fs_extent_open2(fs, ino, inode, &handle))
@@ -217,6 +219,8 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 
 	blocks = ext2fs_inode_data_blocks2(fs, inode);
 	if (blocks) {
+		if (inode->i_flags & EXT4_INLINE_DATA_FL)
+			return 0;
 		if ((inode->i_size >= fs->blocksize) ||
 		    (blocks != fs->blocksize >> 9) ||
 		    (inode->i_block[0] < fs->super->s_first_data_block) ||
@@ -233,6 +237,27 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 		len = strnlen(buf, fs->blocksize);
 		if (len == fs->blocksize)
 			return 0;
+	} else if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		char *inline_buf = NULL;
+		size_t inline_sz = 0;
+
+		if (ext2fs_inline_data_size(fs, ino, &inline_sz))
+			return 0;
+		if (inode->i_size != inline_sz)
+			return 0;
+		if (ext2fs_get_mem(inline_sz + 1, &inline_buf))
+			return 0;
+		i = 0;
+		if (ext2fs_inline_data_get(fs, ino, inode, inline_buf, NULL))
+			goto exit_inline;
+		inline_buf[inline_sz] = 0;
+		len = strnlen(inline_buf, inline_sz);
+		if (len != inline_sz)
+			goto exit_inline;
+		i = 1;
+exit_inline:
+		ext2fs_free_mem(&inline_buf);
+		return i;
 	} else {
 		if (inode->i_size >= sizeof(inode->i_block))
 			return 0;

