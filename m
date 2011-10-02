From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/6] Add additional owner identifier
Date: Sun,  2 Oct 2011 23:44:37 +0400
Message-ID: <1317584681-29967-2-git-send-email-dmonakhov@openvz.org>
References: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, viro@ZenIV.linux.org.uk,
	adityakali@google.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1JBTlP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 15:41:15 -0400
In-Reply-To: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add project inode identifier. Project ID may be used as
auxiliary owner specifier in addition to standard uid/gid.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/Kconfig            |    7 +++++++
 include/linux/fs.h    |    1 +
 include/linux/xattr.h |    3 +++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 5f4c45d..f3f1b12 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -56,6 +56,13 @@ config FILE_LOCKING
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
index e7b118c..9059ad4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1670,6 +1670,7 @@ struct super_operations {
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

