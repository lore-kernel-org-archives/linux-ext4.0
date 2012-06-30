From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 19/23] ext4: Let fiemap work with inline data.
Date: Sat, 30 Jun 2012 23:45:20 +0800
Message-ID: <1341071124-4976-19-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:46556 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754344Ab2F3Pt7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:59 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SkzuL-0006eg-DL
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:26 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
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
index ca2ae18..e6089be 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4908,6 +4908,15 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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
index bc30e21..9e61dea 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -15,6 +15,7 @@
 #include "ext4.h"
 #include "xattr.h"
 #include "truncate.h"
+#include <linux/fiemap.h>
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1623,3 +1624,37 @@ int ext4_destroy_inline_data(handle_t *handle, struct inode *inode)
 
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
index 82a70e4..213c3b3 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -183,6 +183,9 @@ extern struct buffer_head *ext4_get_first_inline_block(struct inode *inode,
 						       void **buf,
 						       int *buf_size,
 						       int *retval);
+extern int ext4_inline_data_fiemap(struct inode *inode,
+				   struct fiemap_extent_info *fieinfo,
+				   int *has_inline);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -393,6 +396,13 @@ ext4_get_first_inline_block(struct inode *inode,
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

