From: Tao Ma <tm@tao.ma>
Subject: [PATCH V6 19/23] ext4: Let fiemap work with inline data.
Date: Fri, 14 Sep 2012 19:25:07 +0800
Message-ID: <1347621911-4104-19-git-send-email-tm@tao.ma>
References: <1347621512-3660-1-git-send-email-tm@tao.ma>
 <1347621911-4104-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:53767 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753347Ab2INLeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 07:34:09 -0400
Received: from [182.92.247.2] (port=60014 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TCU1i-0001sO-6v
	for linux-ext4@vger.kernel.org; Fri, 14 Sep 2012 05:25:38 -0600
In-Reply-To: <1347621911-4104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

fiemap is used to find the disk layout of a file, as for inline data,
let us just pretend like a file with just one extent.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/extents.c |    9 +++++++++
 fs/ext4/inline.c  |   35 +++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.h   |   10 ++++++++++
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 416f31d..fc52ad9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4922,6 +4922,15 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	ext4_lblk_t start_blk;
 	int error = 0;
 
+	if (ext4_has_inline_data(inode)) {
+		int has_inline = 1;
+
+		error = ext4_inline_data_fiemap(inode, fieinfo, &has_inline);
+
+		if (has_inline)
+			return error;
+	}
+
 	/* fallback to generic here if not in extents fmt */
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return generic_block_fiemap(inode, fieinfo, start, len,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index e01533f..dcf1f8e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -15,6 +15,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include <linux/fiemap.h>
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1674,3 +1675,37 @@ int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 
 	return ret;
 }
+
+int ext4_inline_data_fiemap(struct inode *inode,
+			    struct fiemap_extent_info *fieinfo,
+			    int *has_inline)
+{
+	__u64 physical = 0;
+	__u64 length;
+	__u32 flags = FIEMAP_EXTENT_DATA_INLINE | FIEMAP_EXTENT_LAST;
+	int error = 0;
+	struct ext4_iloc iloc;
+
+	down_read(&EXT4_I(inode)->xattr_sem);
+	if (!ext4_has_inline_data(inode)) {
+		*has_inline = 0;
+		goto out;
+	}
+
+	error = ext4_get_inode_loc(inode, &iloc);
+	if (error)
+		goto out;
+
+	physical = iloc.bh->b_blocknr << inode->i_sb->s_blocksize_bits;
+	physical += (char *)ext4_raw_inode(&iloc) - iloc.bh->b_data;
+	physical += offsetof(struct ext4_inode, i_block);
+	length = i_size_read(inode);
+
+	if (physical)
+		error = fiemap_fill_next_extent(fieinfo, 0, physical,
+						length, flags);
+	brelse(iloc.bh);
+out:
+	up_read(&EXT4_I(inode)->xattr_sem);
+	return (error < 0 ? error : 0);
+}
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index dbc014f..2e09ab2 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -184,6 +184,9 @@ extern int empty_inline_dir(struct inode *dir, int *has_inline_data);
 extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
 					struct ext4_dir_entry_2 **parent_de,
 					int *retval);
+extern int ext4_inline_data_fiemap(struct inode *inode,
+				   struct fiemap_extent_info *fieinfo,
+				   int *has_inline);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -396,6 +399,13 @@ ext4_get_first_inline_block(struct inode *inode,
 {
 	return NULL;
 }
+
+static inline int ext4_inline_data_fiemap(struct inode *inode,
+					  struct fiemap_extent_info *fieinfo,
+					  int *has_inline)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.1

