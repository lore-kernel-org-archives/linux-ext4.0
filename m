From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 13/19] debugfs: introduce one function
Date: Mon, 29 Oct 2012 12:30:55 +0800
Message-ID: <1351485061-12297-14-git-send-email-zwu.kernel@gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:44918 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab2J2Edm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2012 00:33:42 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Sun, 28 Oct 2012 22:33:41 -0600
In-Reply-To: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  The debugfs function is used to get expected dentry.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/debugfs/inode.c      |   26 ++++++++++++++++++++++++++
 include/linux/debugfs.h |    9 +++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index b607d92..c6291bc 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -354,6 +354,32 @@ exit:
 	return dentry;
 }
 
+struct dentry *debugfs_get_dentry(const char *name,
+			struct dentry *parent, int len)
+{
+	struct dentry *dentry = NULL;
+	int error = 0;
+
+	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
+				&debugfs_mount_count);
+	if (error)
+		return NULL;
+
+	if (!parent)
+		parent = debugfs_mount->mnt_root;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (!IS_ERR(dentry)) {
+		mutex_unlock(&parent->d_inode->i_mutex);
+		return dentry;
+	}
+	mutex_unlock(&parent->d_inode->i_mutex);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(debugfs_get_dentry);
+
 /**
  * debugfs_create_file - create a file in the debugfs filesystem
  * @name: a pointer to a string containing the name of the file to create.
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 66c434f..8913a4d 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -46,6 +46,9 @@ extern struct dentry *arch_debugfs_dir;
 extern const struct file_operations debugfs_file_operations;
 extern const struct inode_operations debugfs_link_operations;
 
+struct dentry *debugfs_get_dentry(const char *name,
+				struct dentry *parent, int len);
+
 struct dentry *debugfs_create_file(const char *name, umode_t mode,
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops);
@@ -103,6 +106,12 @@ bool debugfs_initialized(void);
 
 #include <linux/err.h>
 
+static inline struct dentry *debugfs_get_dentry(const char *name,
+					struct dentry *parent, int len)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 /* 
  * We do not return NULL from these functions if CONFIG_DEBUG_FS is not enabled
  * so users have a chance to detect if there was a real error or not.  We don't
-- 
1.7.6.5

