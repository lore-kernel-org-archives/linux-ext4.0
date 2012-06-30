From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 22/23] ext4: let fallocate handle inline data correctly.
Date: Sat, 30 Jun 2012 23:45:23 +0800
Message-ID: <1341071124-4976-22-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52631 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755595Ab2F3Pt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:57 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1SkzuU-0006eg-DW
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:35 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
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
index e6089be..87432bc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4367,6 +4367,10 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
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
index e77639c..3337e71 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1786,3 +1786,42 @@ out:
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
index 58abcc9..98f22c6 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -191,6 +191,7 @@ extern int ext4_try_to_evict_inline_data(handle_t *handle,
 					 int needed);
 extern void ext4_inline_data_truncate(struct inode *inode, int *has_inline);
 
+extern int ext4_convert_inline_data(struct inode *inode);
 # else  /* CONFIG_EXT4_FS_XATTR */
 
 static inline int
@@ -415,6 +416,10 @@ static inline void ext4_inline_data_truncate(struct inode *inode,
 	return;
 }
 
+static int int ext4_convert_inline_data(struct inode *inode)
+{
+	return 0;
+}
 # endif  /* CONFIG_EXT4_FS_XATTR */
 
 #ifdef CONFIG_EXT4_FS_SECURITY
-- 
1.7.0.4

