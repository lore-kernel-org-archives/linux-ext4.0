From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/47] libext2fs: refactor extent head creation
Date: Fri, 07 Nov 2014 13:51:32 -0800
Message-ID: <20141107215132.883.2460.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35433 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:37 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't open-code the creation of the extent tree header, since
ext2fs_extent_open2() knows how to take care of this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inline_data.c |   19 ++++++++-----------
 misc/create_inode.c      |   18 +++++++-----------
 2 files changed, 15 insertions(+), 22 deletions(-)


diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 88e08e7..6260c5f 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -412,19 +412,16 @@ ext2fs_inline_data_file_expand(ext2_filsys fs, ext2_ino_t ino,
 	errcode_t retval;
 
 	/* Update inode */
+	memset(inode->i_block, 0, sizeof(inode->i_block));
 	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				      EXT3_FEATURE_INCOMPAT_EXTENTS)) {
-		int i;
-		struct ext3_extent_header *eh;
-
-		eh = (struct ext3_extent_header *) &inode->i_block[0];
-		eh->eh_depth = 0;
-		eh->eh_entries = 0;
-		eh->eh_magic = ext2fs_cpu_to_le16(EXT3_EXT_MAGIC);
-		i = (sizeof(inode->i_block) - sizeof(*eh)) /
-			sizeof(struct ext3_extent);
-		eh->eh_max = ext2fs_cpu_to_le16(i);
-		inode->i_flags |= EXT4_EXTENTS_FL;
+		ext2_extent_handle_t handle;
+
+		inode->i_flags &= ~EXT4_EXTENTS_FL;
+		retval = ext2fs_extent_open2(fs, ino, inode, &handle);
+		if (retval)
+			return retval;
+		ext2fs_extent_free(handle);
 	}
 	inode->i_flags &= ~EXT4_INLINE_DATA_FL;
 	inode->i_size = 0;
diff --git a/misc/create_inode.c b/misc/create_inode.c
index cf7c097..a024d1c 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -518,17 +518,13 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 		inode.i_flags |= EXT4_INLINE_DATA_FL;
 	} else if (fs->super->s_feature_incompat &
 		   EXT3_FEATURE_INCOMPAT_EXTENTS) {
-		int i;
-		struct ext3_extent_header *eh;
