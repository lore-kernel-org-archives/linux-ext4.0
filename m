From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 19/21] ext4: Let fiemap work with inline data.
Date: Sun, 18 Dec 2011 22:24:36 +0800
Message-ID: <1324218278-2460-19-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
index a0063b7..45e1c12 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4923,6 +4923,15 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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
index 3159f32..4203aa4 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -15,6 +15,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include <linux/fiemap.h>
 
 #define EXT4_XATTR_SYSTEM_DATA_NAME	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1519,3 +1520,37 @@ int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 
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
index 55bb2fc..6bfdf9c 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -181,6 +181,9 @@ extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
 						       void **buf,
 						       int *buf_size,
 						       int *retval);
+extern int ext4_inline_data_fiemap(struct inode *inode,
+				   struct fiemap_extent_info *fieinfo,
+				   int *has_inline);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -391,6 +394,13 @@ ext4_get_first_inline_block(struct inode *inode,
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
1.7.0.4
