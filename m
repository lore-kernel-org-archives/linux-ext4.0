From: Tao Ma <tm@tao.ma>
Subject: [PATCH V6 22/23] ext4: let fallocate handle inline data correctly.
Date: Fri, 14 Sep 2012 19:25:10 +0800
Message-ID: <1347621911-4104-22-git-send-email-tm@tao.ma>
References: <1347621512-3660-1-git-send-email-tm@tao.ma>
 <1347621911-4104-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:46164 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752918Ab2INLeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Sep 2012 07:34:09 -0400
Received: from [182.92.247.2] (port=60014 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TCU1l-0001sO-Do
	for linux-ext4@vger.kernel.org; Fri, 14 Sep 2012 05:25:41 -0600
In-Reply-To: <1347621911-4104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

If we are punching hole in a file, we will return ENOTSUPP.
As for the fallocation of some extents, we will convert the
inline data to a normal extent based file first.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/extents.c |    4 ++++
 fs/ext4/inline.c  |   39 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/xattr.h   |    5 +++++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index fc52ad9..e7b72b3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4379,6 +4379,10 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(file, offset, len);
 
+	ret = ext4_convert_inline_data(inode);
+	if (ret)
+		return ret;
+
 	trace_ext4_fallocate_enter(inode, offset, len, mode);
 	map.m_lblk = offset >> blkbits;
 	/*
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index bff1f23..d98eb46 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1837,3 +1837,42 @@ out:
 	ext4_journal_stop(handle);
 	return;
 }
+
+int ext4_convert_inline_data(struct inode *inode)
+{
+	int error, needed_blocks;
+	handle_t *handle;
+	struct ext4_iloc iloc;
+
+	if (!ext4_has_inline_data(inode)) {
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		return 0;
+	}
+
+	needed_blocks = ext4_writepage_trans_blocks(inode);
+
+	iloc.bh = NULL;
+	error = ext4_get_inode_loc(inode, &iloc);
+	if (error)
+		return error;
+
+	handle = ext4_journal_start(inode, needed_blocks);
+	if (IS_ERR(handle)) {
+		error = PTR_ERR(handle);
+		goto out_free;
+	}
+
+	down_write(&EXT4_I(inode)->xattr_sem);
+	if (!ext4_has_inline_data(inode)) {
+		up_write(&EXT4_I(inode)->xattr_sem);
+		goto out;
+	}
+
+	error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	up_write(&EXT4_I(inode)->xattr_sem);
+out:
+	ext4_journal_stop(handle);
+out_free:
+	brelse(iloc.bh);
+	return error;
+}
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 0aef19e..9a7986c 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -192,6 +192,7 @@ extern int ext4_try_to_evict_inline_data(handle_t *handle,
 					 int needed);
 extern void ext4_inline_data_truncate(struct inode *inode, int *has_inline);
 
+extern int ext4_convert_inline_data(struct inode *inode);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -418,6 +419,10 @@ static inline void ext4_inline_data_truncate(struct inode *inode,
 	return;
 }
 
+static int int ext4_convert_inline_data(struct inode *inode)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.1

