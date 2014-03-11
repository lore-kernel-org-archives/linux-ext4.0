From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/49] libext2fs: during inlinedata expand, don't corrupt inode
Date: Mon, 10 Mar 2014 23:55:15 -0700
Message-ID: <20140311065515.30585.24716.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21333 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaCKGzS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:18 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When expanding an inline data inode, it's possible that the reduction
in the size of the EA structures causes the freeing of the EA block,
which changes the inode.  If this happens, the local version of the
inode that ext2fs_inline_data_expand was modifying will be out of sync
with what's on the disk.  This local copy gets written out to disk
after a block allocation, at which point it's possible that the inode
EA block and logical block zero point to the same physical block,
which is bad news.

Therefore, write the local copy to disk before removing the inline
data EA, and reread it afterwards.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inline_data.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index a9ec923..f3cd375 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -460,9 +460,22 @@ errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
 	}
 
 	memset((void *)inode.i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
+	/*
+	 * NOTE: We must do this write -> ea_remove -> read cycle here because
+	 * removing the inline data EA can free the EA block, which is a change
+	 * that our stack copy of the inode will never see.  If that happens,
+	 * we can end up with the EA block and lblk 0 pointing to the same
+	 * pblk, which is bad news.
+	 */
+	retval = ext2fs_write_inode(fs, ino, &inode);
+	if (retval)
+		goto errout;
 	retval = ext2fs_inline_data_ea_remove(fs, ino);
 	if (retval)
 		goto errout;
+	retval = ext2fs_read_inode(fs, ino, &inode);
+	if (retval)
+		goto errout;
 
 	if (LINUX_S_ISDIR(inode.i_mode)) {
 		retval = ext2fs_inline_data_dir_expand(fs, ino, &inode,

