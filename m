From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/47] libext2fs: add a way to check the theoretical maximum
 extent tree depth
Date: Fri, 07 Nov 2014 13:52:12 -0800
Message-ID: <20141107215212.883.11364.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35697 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaKGVwQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:52:16 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add an API so that client programs can discover a reasonable maximum
extent tree depth.  This will eventually be used by e2fsck as one of
the criteria to decide if an extent-based file should have its extent
tree rebuilt.

Turn some related magic numbers into constants while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h       |    1 +
 lib/ext2fs/ext3_extents.h |    2 ++
 lib/ext2fs/extent.c       |   33 +++++++++++++++++++++++++++++----
 3 files changed, 32 insertions(+), 4 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index afe4fd5..c3142f7 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1218,6 +1218,7 @@ extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 extern errcode_t ext2fs_extent_goto2(ext2_extent_handle_t handle,
 				     int leaf_level, blk64_t blk);
 extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
+size_t ext2fs_max_extent_depth(ext2_extent_handle_t handle);
 
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index 66c23fd..f73a332 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -98,6 +98,8 @@ struct ext3_ext_path {
  */
 #define EXT_INIT_MAX_LEN	(1UL << 15)
 #define EXT_UNINIT_MAX_LEN	(EXT_INIT_MAX_LEN - 1)
+#define EXT_MAX_EXTENT_LBLK	(((__u64) 1 << 32) - 1)
+#define EXT_MAX_EXTENT_PBLK	(((__u64) 1 << 48) - 1)
 
 #define EXT_FIRST_EXTENT(__hdr__) \
 	((struct ext3_extent *) (((char *) (__hdr__)) +		\
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index afb79c8..b1130f6 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1697,14 +1697,39 @@ errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
 
 	info->curr_level = handle->level;
 	info->max_depth = handle->max_depth;
-	info->max_lblk = ((__u64) 1 << 32) - 1;
-	info->max_pblk = ((__u64) 1 << 48) - 1;
-	info->max_len = (1UL << 15);
-	info->max_uninit_len = (1UL << 15) - 1;
+	info->max_lblk = EXT_MAX_EXTENT_LBLK;
+	info->max_pblk = EXT_MAX_EXTENT_PBLK;
+	info->max_len = EXT_INIT_MAX_LEN;
+	info->max_uninit_len = EXT_UNINIT_MAX_LEN;
 
 	return 0;
 }
 
+static int ul_log2(unsigned long arg)
+{
+	int	l = 0;
+
+	arg >>= 1;
+	while (arg) {
+		l++;
+		arg >>= 1;
+	}
+	return l;
+}
+
+size_t ext2fs_max_extent_depth(ext2_extent_handle_t handle)
+{
+	size_t iblock_sz = sizeof(((struct ext2_inode *)NULL)->i_block);
+	size_t iblock_extents = (iblock_sz - sizeof(struct ext3_extent_header)) /
+				sizeof(struct ext3_extent);
+	size_t extents_per_block = (handle->fs->blocksize -
+				    sizeof(struct ext3_extent_header)) /
+				   sizeof(struct ext3_extent);
+
+	return 1 + ((ul_log2(EXT_MAX_EXTENT_LBLK) - ul_log2(iblock_extents)) /
+		    ul_log2(extents_per_block));
+}
+
 #ifdef DEBUG
 /*
  * Override debugfs's prompt

