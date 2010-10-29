From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] vfs: Add additional owner identifier
Date: Fri, 29 Oct 2010 17:03:37 +0400
Message-ID: <1288357420-7178-2-git-send-email-dmonakhov@openvz.org>
References: <1288357420-7178-1-git-send-email-dmonakhov@openvz.org>
Cc: viro@ZenIV.linux.org.uk, jack@suse.cz, linux-ext4@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1288357420-7178-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch add project inode identifier. Project ID may be used as
auxiliary owner specifier in addition to standard uid/gid.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/Kconfig            |    7 +++++++
 include/linux/fs.h    |    1 +
 include/linux/xattr.h |    3 +++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index c49e224..4250f0b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -58,6 +58,13 @@ config FILE_LOCKING
 	  This option enables standard file locking support, required
           for filesystems like NFS and for the flock() system
           call. Disabling this option saves about 11k.
+config PROJECT_ID
+	bool "Enable project inode identifier"
+	default y
+	help
+	  This option enables project inode identifier. Project ID
+	  may be used as auxiliary owner specifier in addition to
+	  standard uid/gid.
 
 source "fs/notify/Kconfig"
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 24dd5d5..cba9a65 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1611,6 +1611,7 @@ struct super_operations {
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	int (*trim_fs) (struct super_block *, struct fstrim_range *);
+	u32 (*get_prjid)(const struct inode *inode);
 };
 
 /*
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index f1e5bde..2f64a1c 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -47,6 +47,9 @@
 #define XATTR_CAPS_SUFFIX "capability"
 #define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
 
+#define XATTR_PRJID "system.project_id"
+#define XATTR_PRJID_LEN (sizeof (XATTR_PRJID))
+
 struct inode;
 struct dentry;
 
-- 
1.6.5.2

