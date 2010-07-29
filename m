From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 09/17] richacl: Helper functions for implementing richacl
	inode operations
Date: Thu, 29 Jul 2010 23:27:47 +0530
Message-ID: <1280426275-4602-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1280426275-4602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de, adilger@sun.com,
	sandeen@redhat.com, tytso@mit.edu, bfields@citi.umich.edu,
	jlayton@redhat.com
Return-path: <nfsv4-bounces@linux-nfs.org>
In-Reply-To: <1280426275-4602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/options/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

These functions are supposed to be used by file systems so that the file
system independent code remains in the vfs.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/Makefile             |    2 +-
 fs/richacl_inode.c      |  195 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |   21 +++++
 3 files changed, 217 insertions(+), 1 deletions(-)
 create mode 100644 fs/richacl_inode.c

diff --git a/fs/Makefile b/fs/Makefile
index 9ecd045..b38cfc7 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
 obj-$(CONFIG_FS_RICHACL)	+= richacl.o
-richacl-y			:= richacl_base.o
+richacl-y			:= richacl_base.o richacl_inode.o
 
 obj-y				+= quota/
 
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
new file mode 100644
index 0000000..9e80b33
--- /dev/null
+++ b/fs/richacl_inode.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (C) 2010  Novell, Inc.
+ * Written by Andreas Gruenbacher <agruen@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/richacl.h>
+
+/**
+ * richacl_may_create  -  helper for implementing iop->may_create
+ */
+int
+richacl_may_create(struct inode *dir, int isdir,
+		int (*richacl_permission)(struct inode *, unsigned int))
+{
+	if (IS_RICHACL(dir))
+		return richacl_permission(dir,
+				ACE4_EXECUTE | (isdir ?
+				ACE4_ADD_SUBDIRECTORY : ACE4_ADD_FILE));
+	else
+		return generic_permission(dir, MAY_WRITE | MAY_EXEC,
+					  dir->i_op->check_acl);
+}
+EXPORT_SYMBOL(richacl_may_create);
+
+static int
+check_sticky(struct inode *dir, struct inode *inode)
+{
+	if (!(dir->i_mode & S_ISVTX))
+		return 0;
+	if (inode->i_uid == current_fsuid())
+		return 0;
+	if (dir->i_uid == current_fsuid())
+		return 0;
+	return !capable(CAP_FOWNER);
+}
+
+/**
+ * richacl_may_delete  -  helper for implementing iop->may_delete
+ */
+int
+richacl_may_delete(struct inode *dir, struct inode *inode, int replace,
+		   int (*richacl_permission)(struct inode *, unsigned int))
+{
+	int error;
+
+	if (IS_RICHACL(inode)) {
+		unsigned int mask = ACE4_EXECUTE | ACE4_DELETE_CHILD;
+		if (replace)
+			mask |= S_ISDIR(inode->i_mode) ?
+				ACE4_ADD_SUBDIRECTORY : ACE4_ADD_FILE;
+		error = richacl_permission(dir, mask);
+		if (error &&
+		    !richacl_permission(dir, ACE4_EXECUTE) &&
+		    !richacl_permission(inode, ACE4_DELETE))
+			error = 0;
+		else if (!error && check_sticky(dir, inode))
+			error = -EPERM;
+	} else {
+		error = generic_permission(dir, MAY_WRITE | MAY_EXEC,
+					   dir->i_op->check_acl);
+		if (!error && check_sticky(dir, inode))
+			error = -EPERM;
+	}
+
+	return error;
+}
+EXPORT_SYMBOL(richacl_may_delete);
+
+/**
+ * richacl_inode_permission  -  helper for implementing iop->permission
+ * @inode:	inode to check
+ * @acl:	rich acl of the inode (may be NULL)
+ * @mask:	requested access (ACE4_* bitmask)
+ *
+ * This function is supposed to be used by file systems for implementing the
+ * permission inode operation.
+ */
+int
+richacl_inode_permission(struct inode *inode, const struct richacl *acl,
+			 unsigned int mask)
+{
+	if (acl) {
+		if (!richacl_permission(inode, acl, mask))
+			return 0;
+	} else {
+		int mode = inode->i_mode;
+
+		if (current_fsuid() == inode->i_uid)
+			mode >>= 6;
+		else if (in_group_p(inode->i_gid))
+			mode >>= 3;
+		if (!(mask & ~richacl_mode_to_mask(mode)))
+			return 0;
+	}
+
+	/*
+	 * Keep in sync with the capability checks in generic_permission().
+	 */
+	if (!(mask & ~ACE4_POSIX_MODE_ALL)) {
+		/*
+		 * Read/write DACs are always overridable.
+		 * Executable DACs are overridable if at
+		 * least one exec bit is set.
+		 */
+		if (!(mask & ACE4_POSIX_MODE_EXEC) || execute_ok(inode))
+			if (capable(CAP_DAC_OVERRIDE))
+				return 0;
+	}
+	/*
+	 * Searching includes executable on directories, else just read.
+	 */
+	if (!(mask & ~(ACE4_READ_DATA | ACE4_LIST_DIRECTORY | ACE4_EXECUTE)) &&
+	    (S_ISDIR(inode->i_mode) || !(mask & ACE4_EXECUTE)))
+		if (capable(CAP_DAC_READ_SEARCH))
+			return 0;
+
+	return -EACCES;
+}
+EXPORT_SYMBOL_GPL(richacl_inode_permission);
+
+/**
+ * richacl_inode_change_ok  -  helper for implementing iop->setattr
+ * @inode:	inode to check
+ * @attr:	requested inode attribute changes
+ * @richacl_permission:	permission function taking an inode and ACE4_* flags
+ *
+ * Keep in sync with inode_change_ok().
+ */
+int
+richacl_inode_change_ok(struct inode *inode, struct iattr *attr,
+			int (*richacl_permission)(struct inode *, unsigned int))
+{
+	unsigned int ia_valid = attr->ia_valid;
+
+	/* If force is set do it anyway. */
+	if (ia_valid & ATTR_FORCE)
+		return 0;
+
+	/* Make sure a caller can chown. */
+	if ((ia_valid & ATTR_UID) &&
+	    (current_fsuid() != inode->i_uid ||
+	     attr->ia_uid != inode->i_uid) &&
+	    (current_fsuid() != attr->ia_uid ||
+	     richacl_permission(inode, ACE4_WRITE_OWNER)) &&
+	    !capable(CAP_CHOWN))
+		goto error;
+
+	/* Make sure caller can chgrp. */
+	if ((ia_valid & ATTR_GID)) {
+		int in_group = in_group_p(attr->ia_gid);
+		if ((current_fsuid() != inode->i_uid ||
+		    (!in_group && attr->ia_gid != inode->i_gid)) &&
+		    (!in_group ||
+		     richacl_permission(inode, ACE4_WRITE_OWNER)) &&
+		    !capable(CAP_CHOWN))
+			goto error;
+	}
+
+	/* Make sure a caller can chmod. */
+	if (ia_valid & ATTR_MODE) {
+		if (current_fsuid() != inode->i_uid &&
+		    richacl_permission(inode, ACE4_WRITE_ACL) &&
+		    !capable(CAP_FOWNER))
+			goto error;
+		/* Also check the setgid bit! */
+		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
+				inode->i_gid) && !capable(CAP_FSETID))
+			attr->ia_mode &= ~S_ISGID;
+	}
+
+	/* Check for setting the inode time. */
+	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
+		if (current_fsuid() != inode->i_uid &&
+		    richacl_permission(inode, ACE4_WRITE_ATTRIBUTES) &&
+		    !capable(CAP_FOWNER))
+			goto error;
+	}
+	return 0;
+error:
+	return -EPERM;
+}
+EXPORT_SYMBOL_GPL(richacl_inode_change_ok);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index c9d2761..f6f892d 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -292,4 +292,25 @@ extern struct richacl *richacl_chmod(struct richacl *, mode_t);
 extern int richacl_permission(struct inode *, const struct richacl *,
 			      unsigned int);
 
+/* richacl_inode.c */
+
+#ifdef CONFIG_FS_RICHACL
+extern int richacl_may_create(struct inode *, int,
+			      int (*)(struct inode *, unsigned int));
+extern int richacl_may_delete(struct inode *, struct inode *, int,
+			      int (*)(struct inode *, unsigned int));
+extern int richacl_inode_permission(struct inode *, const struct richacl *,
+				    unsigned int);
+extern int richacl_inode_change_ok(struct inode *, struct iattr *,
+				   int (*)(struct inode *, unsigned int));
+#else
+static inline int
+richacl_inode_change_ok(struct inode *inode, struct iattr *attr,
+			int (*richacl_permission)(struct inode *inode,
+						  unsigned int mask))
+{
+	return -EPERM;
+}
+#endif
+
 #endif /* __RICHACL_H */
-- 
1.7.0.4

_______________________________________________
NOTE: THIS LIST IS DEPRECATED.  Please use linux-nfs@vger.kernel.org instead.
(To subscribe to linux-nfs@vger.kernel.org: send "subscribe linux-nfs" in the body of a message to majordomo@vger.kernel.org.)

NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
