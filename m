From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 2/2 V2] Add SEEK_HOLE/SEEK_DATA support
Date: Wed, 28 Sep 2011 14:39:40 +0800
Message-ID: <4E82C12C.4030805@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Sunil Mushran <sunil.mushran@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43121 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1I1Gjz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 02:39:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add SEEK_HOLE/SEEK_DATA support.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/ext4/ext4.h         |    4 ++
 fs/ext4/ext4_extents.h |    8 +++++
 fs/ext4/extents.c      |   75
++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/file.c         |   15 +++++----
 4 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..9eda477 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2222,6 +2222,10 @@ extern int ext4_move_extents(struct file *o_filp,
struct file *d_filp,
 			     __u64 start_orig, __u64 start_donor,
 			     __u64 len, __u64 *moved_len);

+/* extents.c */
+extern int ext4_find_desired_extent(struct inode *inode, loff_t *offset,
+				    int origin);
+
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
 extern void ext4_exit_pageio(void);
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 095c36f..ca7a339 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -116,6 +116,14 @@ struct ext4_ext_path {
 };

 /*
+ * Structure for retrieving extent offset for SEEK_DATA/SEEK_HOLE.
+ */
+struct ext4_extent_seek_info {
+	unsigned int origin;	/* SEEK_DATA or SEEK_HOLE */
+	loff_t offset;		/* input/output offset */
+};
+
+/*
  * structure for external API
  */

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 06e88d4..4c78061 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4122,6 +4122,81 @@ static int ext4_ext_fiemap_cb(struct inode
*inode, ext4_lblk_t next,
 	return EXT_CONTINUE;
 }

+/*
+ * Callback function called for each extent to gather SEEK_DATA/SEEK_HOLE
+ * information.
+ */
+static int ext4_ext_seek_cb(struct inode *inode, ext4_lblk_t next,
+			    struct ext4_ext_cache *newex,
+			    struct ext4_extent *ex, void *data)
+{
+	__u64	logical;
+	int	ret = 0;
+	unsigned char blksize_bits;
+	struct ext4_extent_seek_info *ext_seek_info = data;
+
+	blksize_bits = inode->i_sb->s_blocksize_bits;
+	logical = (__u64)newex->ec_block << blksize_bits;
+
+	if (newex->ec_start == 0) {
+		ret = ext4_get_delayed_extent(inode, next, newex, &logical, 0);
+		if (ret == EXT_CONTINUE) {
+			/*
+			 * A hole found, return EXT_BREAK and fill ext_seek_info
+			 * ->offset with logical for SEEK_HOLE, or just return.
+			 */
+			if (ext_seek_info->origin == SEEK_HOLE) {
+				ext_seek_info->offset = logical;
+				return EXT_BREAK;
+			} else {
+				return ret;
+			}
+		}
+		/* found a delayed extent */
+	}
+
+	if (ext_seek_info->origin == SEEK_DATA) {
+		ext_seek_info->offset = logical;
+		return EXT_BREAK;
+	}
+
+	return EXT_CONTINUE;
+}
+
+int ext4_find_desired_extent(struct inode *inode, loff_t *offset, int
origin)
+{
+	ext4_lblk_t start_blk;
+	ext4_lblk_t end_blk;
+	ext4_lblk_t len_blks;
+	struct ext4_extent_seek_info ext_seek_info;
+	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
+	int error = 0;
+
+	/*
+	 * FIXME: do we need to support old block based file?
+	 * Generally, we would like to gather extents info over
+	 * SEEK_DATA/SEEK_HOLE interface for efficient sparse file
+	 * read only.
+	 */
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		return -ENOTSUPP;
+
+	start_blk = *offset >> blkbits;
+	if (start_blk >= EXT_MAX_BLOCKS)
+		return -ENXIO;
+
+	end_blk = i_size_read(inode) >> blkbits;
+	len_blks = ((ext4_lblk_t)end_blk) - start_blk + 1;
+
+	ext_seek_info.origin = origin;
+	error = ext4_ext_walk_space(inode, start_blk, len_blks,
+				    ext4_ext_seek_cb, &ext_seek_info);
+	if (!error)
+		*offset = ext_seek_info.offset;
+
+	return error;
+}
+
 /* fiemap flags we can handle specified here */
 #define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..58c8c0a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -219,6 +219,7 @@ loff_t ext4_llseek(struct file *file, loff_t offset,
int origin)
 {
 	struct inode *inode = file->f_mapping->host;
 	loff_t maxbytes;
+	int ret;

 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
@@ -241,21 +242,21 @@ loff_t ext4_llseek(struct file *file, loff_t
offset, int origin)
 		 * In the generic case the entire file is data, so as long as
 		 * offset isn't at the end of the file then the offset is data.
 		 */
-		if (offset >= inode->i_size) {
-			mutex_unlock(&inode->i_mutex);
-			return -ENXIO;
-		}
-		break;
 	case SEEK_HOLE:
 		/*
 		 * There is a virtual hole at the end of the file, so as long as
 		 * offset isn't i_size or larger, return i_size.
 		 */
-		if (offset >= inode->i_size) {
+		if (offset >= i_size_read(inode)) {
 			mutex_unlock(&inode->i_mutex);
 			return -ENXIO;
 		}
-		offset = inode->i_size;
+
+		ret = ext4_find_desired_extent(inode, &offset, origin);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
 		break;
 	}

-- 
1.7.4.1
