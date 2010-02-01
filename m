From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 09/23] ext4: Add posix acl to rich acl mapping
Date: Mon,  1 Feb 2010 11:04:51 +0530
Message-ID: <1265002505-8387-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52764 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0BAFfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:23 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have richacl format enabled on ext4 we don't return the posix acl
value stored in the inode. This ensures that we only follow one acl model
when enabled. In our case if we have richacl format enabled we always
enforce richacl mode. But we also need to obey the posix acl restrictions
placed on the inode. For this we map the posix acls to richacl format
and use richacl to validate access permissions. We can also use this
to migrate posix acl to rich acl by doing a --get followed by a --set
using richacl tools. We have ACL4_POSIX_MAPPED flag set to indicate that
the richacl values returned is derived out of posix acl. This gives the
user a chance to validate the mapping before migrating to richacl format.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/acl.c     |   14 ++++++---
 fs/ext4/acl.h     |    1 +
 fs/ext4/richacl.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 75 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 5f09df4..e17e1a9 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -152,8 +152,10 @@ fail:
  * Inode operation get_posix_acl().
  *
  * inode->i_mutex: don't care
+ * We don't check whether posix acl is enabled or not.
+ * Caller should make sure of that.
  */
-static struct posix_acl *
+struct posix_acl *
 ext4_get_acl(struct inode *inode, int type)
 {
 	int name_index;
@@ -161,9 +163,6 @@ ext4_get_acl(struct inode *inode, int type)
 	struct posix_acl *acl;
 	int retval;
 
-	if (!posix_acl_enabled(inode->i_sb))
-		return NULL;
-
 	acl = get_cached_acl(inode, type);
 	if (acl != ACL_NOT_CACHED)
 		return acl;
@@ -261,7 +260,12 @@ ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 int
 ext4_check_acl(struct inode *inode, int mask)
 {
-	struct posix_acl *acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
+	struct posix_acl *acl;
+
+	if (!posix_acl_enabled(inode->i_sb))
+		return -EAGAIN;
+
+	acl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
 
 	if (IS_ERR(acl))
 		return PTR_ERR(acl);
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 9d843d5..3e47cf3 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -57,6 +57,7 @@ static inline int ext4_acl_count(size_t size)
 extern int ext4_check_acl(struct inode *, int);
 extern int ext4_acl_chmod(struct inode *);
 extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
+extern struct posix_acl *ext4_get_acl(struct inode *inode, int type);
 
 #else  /* CONFIG_EXT4_FS_POSIX_ACL */
 #include <linux/sched.h>
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
index 1c78086..a8702c7 100644
--- a/fs/ext4/richacl.c
+++ b/fs/ext4/richacl.c
@@ -20,6 +20,7 @@
 #include "ext4_jbd2.h"
 #include "xattr.h"
 #include "richacl.h"
+#include "acl.h"
 
 static inline struct richacl *
 ext4_iget_richacl(struct inode *inode)
@@ -47,13 +48,60 @@ ext4_iset_richacl(struct inode *inode, struct richacl *acl)
 	spin_unlock(&inode->i_lock);
 }
 
+static int ext4_map_pacl_to_richacl(struct inode *inode,
+				struct richacl **richacl)
+{
+	int retval = 0;
+	struct posix_acl *pacl = NULL, *dpacl = NULL;
+
+	*richacl  = NULL;
+	pacl = ext4_get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(pacl))
+		return PTR_ERR(pacl);
+
+
+	if (S_ISDIR(inode->i_mode)) {
+		dpacl = ext4_get_acl(inode, ACL_TYPE_DEFAULT);
+		if (IS_ERR(dpacl)) {
+			/* we need to fail for all errors
+			 * we will continue only with NULL dpacl
+			 * which is ENODATA on dpacl
+			 */
+			posix_acl_release(pacl);
+			return PTR_ERR(dpacl);
+		}
+	}
+
+	if (pacl == NULL && dpacl != NULL) {
+		/*
+		 * We have a default acl list. So derive the access acl
+		 * list from the mode so that we get a richacl that
+		 * include mode bits
+		 */
+		pacl = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
+	}
+
+	if (pacl == NULL && dpacl == NULL)
+		return -ENODATA;
+
+	*richacl = map_posix_to_richacl(inode, pacl, dpacl);
+
+	if (IS_ERR(*richacl)) {
+		retval  = PTR_ERR(*richacl);
+		*richacl = NULL;
+	}
+	posix_acl_release(pacl);
+	posix_acl_release(dpacl);
+	return retval;
+}
+
 static struct richacl *
 ext4_get_richacl(struct inode *inode)
 {
 	const int name_index = EXT4_XATTR_INDEX_RICHACL;
 	void *value = NULL;
 	struct richacl *acl;
-	int retval;
+	int retval = 0;
 
 	if (!richacl_enabled(inode->i_sb))
 		return NULL;
@@ -61,22 +109,31 @@ ext4_get_richacl(struct inode *inode)
 	acl = ext4_iget_richacl(inode);
 	if (acl != EXT4_RICHACL_NOT_CACHED)
 		return acl;
+
 	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
 		value = kmalloc(retval, GFP_KERNEL);
 		if (!value)
 			return ERR_PTR(-ENOMEM);
 		retval = ext4_xattr_get(inode, name_index, "", value, retval);
+		if (retval > 0) {
+			acl = richacl_from_xattr(value, retval);
+			if (acl == ERR_PTR(-EINVAL))
+				acl = ERR_PTR(-EIO);
+		}
+		kfree(value);
+	} else if (retval == -ENODATA) {
+		/*
+		 * Check whether we have posix acl stored.
+		 * If so convert them to richacl
+		 */
+		retval = ext4_map_pacl_to_richacl(inode, &acl);
 	}
-	if (retval > 0) {
-		acl = richacl_from_xattr(value, retval);
-		if (acl == ERR_PTR(-EINVAL))
-			acl = ERR_PTR(-EIO);
-	} else if (retval == -ENODATA || retval == -ENOSYS)
+
+	if (retval == -ENODATA || retval == -ENOSYS)
 		acl = NULL;
-	else
+	else if (retval < 0)
 		acl = ERR_PTR(retval);
-	kfree(value);
 
 	if (!IS_ERR(acl))
 		ext4_iset_richacl(inode, acl);
-- 
1.7.0.rc0.48.gdace5

