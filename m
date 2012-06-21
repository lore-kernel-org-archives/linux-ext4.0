From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/5] Add additional owner identifier
Date: Thu, 21 Jun 2012 13:08:49 +0400
Message-ID: <1340269733-25922-2-git-send-email-dmonakhov@openvz.org>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org>
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
index c8554b5..1932458 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -60,6 +60,13 @@ config FILE_LOCKING
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
index b0a6d44..6779fc2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1739,6 +1739,7 @@ struct super_operations {
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	int (*nr_cached_objects)(struct super_block *);
 	void (*free_cached_objects)(struct super_block *, int);
+	u32 (*get_prjid)(const struct inode *inode);
 };
 
 /*
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index e5d1220..f8a83c3 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -61,6 +61,9 @@
 
 #include <linux/types.h>
 
+#define XATTR_PRJID "system.project_id"
+#define XATTR_PRJID_LEN (sizeof (XATTR_PRJID))
+
 struct inode;
 struct dentry;
 
-- 
1.7.1

