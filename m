From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/5] vfs: Add additional owner identifier
Date: Thu,  4 Mar 2010 21:34:33 +0300
Message-ID: <1267727677-11956-2-git-send-email-dmonakhov@openvz.org>
References: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46597 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab0CDSeu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Mar 2010 13:34:50 -0500
In-Reply-To: <1267727677-11956-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add project inode identifier. Project ID may be used as
auxiliary owner specifier in addition to standard uid/gid.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/Kconfig            |    7 +++++++
 include/linux/fs.h    |    4 ++++
 include/linux/xattr.h |    3 +++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 5f85b59..23957c0 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -54,6 +54,13 @@ config FILE_LOCKING
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
index 30eee24..0218906 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -753,6 +753,10 @@ struct inode {
 #ifdef CONFIG_QUOTA
 	struct dquot		*i_dquot[MAXQUOTAS];
 #endif
+#ifdef CONFIG_PROJECT_ID
+	/* Project id, protected by i_mutex similar to i_uid/i_gid */
+	__u32 			i_prjid;
+#endif
 	struct list_head	i_devices;
 	union {
 		struct pipe_inode_info	*i_pipe;
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index fb9b7e6..9d85a4b 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -33,6 +33,9 @@
 #define XATTR_USER_PREFIX "user."
 #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
 
+#define XATTR_PRJID "system.project_id"
+#define XATTR_PRJID_LEN (sizeof (XATTR_PRJID))
+
 struct inode;
 struct dentry;
 
-- 
1.6.6

