From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/5] vfs: Add additional owner identifier
Date: Thu, 18 Mar 2010 17:02:46 +0300
Message-ID: <1268920970-9061-2-git-send-email-dmonakhov@openvz.org>
References: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu, adilger@sun.com,
	hch@infradead.org, jack@suse.cz, david@fromorbit.com,
	viro@ZenIV.linux.org.uk, xemul@openvz.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40021 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0CRODB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 10:03:01 -0400
In-Reply-To: <1268920970-9061-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add project inode identifier. Project ID may be used as
auxiliary owner specifier in addition to standard uid/gid.
---
 fs/Kconfig            |    7 +++++++
 fs/attr.c             |   10 +++++++++-
 include/linux/fs.h    |    8 ++++++++
 include/linux/xattr.h |    3 +++
 4 files changed, 27 insertions(+), 1 deletions(-)

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
 
diff --git a/fs/attr.c b/fs/attr.c
index 0815e93..2894cc7 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -32,6 +32,9 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
 	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
 		goto error;
 
+	if ((ia_valid & ATTR_PRJID) && !capable(CAP_SYS_RESOURCE))
+		goto error;
+
 	/* Make sure caller can chgrp. */
 	if ((ia_valid & ATTR_GID) &&
 	    (current_fsuid() != inode->i_uid ||
@@ -119,6 +122,10 @@ int inode_setattr(struct inode * inode, struct iattr * attr)
 		inode->i_uid = attr->ia_uid;
 	if (ia_valid & ATTR_GID)
 		inode->i_gid = attr->ia_gid;
+#ifdef CONFIG_PROJECT_ID
+	if (ia_valid & ATTR_PRJID)
+		inode->i_prjid = attr->ia_prjid;
+#endif
 	if (ia_valid & ATTR_ATIME)
 		inode->i_atime = timespec_trunc(attr->ia_atime,
 						inode->i_sb->s_time_gran);
@@ -149,7 +156,8 @@ int notify_change(struct dentry * dentry, struct iattr * attr)
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
-	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_TIMES_SET)) {
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_PRJID |
+				ATTR_TIMES_SET)) {
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 48aee87..0c9dadb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -438,6 +438,7 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define ATTR_KILL_PRIV	(1 << 14)
 #define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
 #define ATTR_TIMES_SET	(1 << 16)
+#define ATTR_PRJID	(1 << 17)
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
@@ -453,6 +454,9 @@ struct iattr {
 	umode_t		ia_mode;
 	uid_t		ia_uid;
 	gid_t		ia_gid;
+#ifdef CONFIG_PROJECT_ID
+	unsigned int	ia_prjid;
+#endif
 	loff_t		ia_size;
 	struct timespec	ia_atime;
 	struct timespec	ia_mtime;
@@ -756,6 +760,10 @@ struct inode {
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
1.6.6.1

