From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH] security: new security_inode_init_security
	API adds function callback
Date: Thu, 23 Jun 2011 17:04:11 -0400
Message-ID: <1308863051-9521-1-git-send-email-zohar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	linux-mtd@lists.infradead.org, Mimi Zohar <zohar@us.ibm.com>,
	James Morris <jmorris@namei.org>, cluster-devel@redhat.com,
	Alex Elder <aelder@sgi.com>, linux-ext4@vger.kernel.org,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Mark Fasheh <mfasheh@suse.com>, xfs-masters@oss.sgi.com,
	Joel Becker <jlbec@evilplan.org>, Steven Whitehouse <swhiteho@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>, ocfs2-devel@oss.oracle.com
To: linux-security-module@vger.kernel.org
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

The recently posted EVM/IMA-appraisal patches added a new hook
evm_inode_post_init_security() to calculate the security.evm extended
attribute(xattr) and an additional call to set_xattr().

        security_inode_init_security(&lsm_xattr)
        set_xattr(&lsm_xattr)

        evm_inode_post_init_security(&lsm_xattr, &evm_xattr)
        set_xattr(&evm_xattr)

The ensuing mailing list discussion centered around:
- Steve Whitehouse's questioning the need for two set_xattr() calls.
- Casey Schaufler's multiple LSM xattr support reminder.
- Dave Chinner's questioning the need for the new
  evm_inode_post_init_security() hook.

This patch changes the security_inode_init_security API by adding a
filesystem specific callback to write security extended attributes.
The change is in preparation for supporting the initialization of
multiple LSM xattrs and the EVM xattr.  Initially the callback function
walks an array of xattrs, writing each xattr separately, but could be
optimized to write multiple xattrs at once.

For existing security_inode_init_security() calls, which have yet to
be converted to use the new callback function, such as those in reiserfs
and ocfs2, this patch defines security_old_inode_init_security().

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/security.c          |   39 ++++++++++++++++++++++++++--
 fs/ext2/xattr_security.c     |   34 +++++++++++++-----------
 fs/ext3/xattr_security.c     |   36 ++++++++++++++-----------
 fs/ext4/xattr_security.c     |   36 ++++++++++++++-----------
 fs/btrfs/xattr.c             |   52 +++++++++++++++++++-------------------
 fs/gfs2/inode.c              |   38 +++++++++++++--------------
 fs/jffs2/security.c          |   37 ++++++++++++++------------
 fs/jfs/xattr.c               |   57 ++++++++++++++++++++---------------------
 fs/ocfs2/xattr.c             |   38 +++++++++++++++++----------
 fs/reiserfs/xattr_security.c |    4 +-
 fs/xfs/linux-2.6/xfs_iops.c  |   39 ++++++++++++++--------------
 mm/shmem.c                   |    4 +-
 include/linux/security.h     |   17 +++++++++---
 include/linux/xattr.h        |    6 ++++
 14 files changed, 252 insertions(+), 185 deletions(-)

diff --git a/security/security.c b/security/security.c
index 4ba6d4c..3464d58 100644
--- a/security/security.c
+++ b/security/security.c
@@ -18,6 +18,8 @@
 #include <linux/security.h>
 #include <linux/ima.h>
 
+#define MAX_LSM_XATTR	1
+
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
@@ -339,15 +341,46 @@ void security_inode_free(struct inode *inode)
 }
 
 int security_inode_init_security(struct inode *inode, struct inode *dir,
-				 const struct qstr *qstr, char **name,
-				 void **value, size_t *len)
+				 const struct qstr *qstr,
+				 const initxattrs initxattrs, void *fs_data)
+{
+	struct xattr new_xattrs[MAX_LSM_XATTR + 1];
+	struct xattr *lsm_xattr;
+	int ret;
+
+	if (unlikely(IS_PRIVATE(inode)))
+		return -EOPNOTSUPP;
+
+	memset(new_xattrs, 0, sizeof new_xattrs);
+	if (!initxattrs)
+		return security_ops->inode_init_security(inode, dir, qstr,
+							 NULL, NULL, NULL);
+	lsm_xattr = new_xattrs;
+	ret = security_ops->inode_init_security(inode, dir, qstr,
+						&lsm_xattr->name,
+						&lsm_xattr->value,
+						&lsm_xattr->value_len);
+	if (ret)
+		goto out;
+	ret = initxattrs(inode, new_xattrs, fs_data);
+out:
+	kfree(lsm_xattr->name);
+	kfree(lsm_xattr->value);
+
+	return (ret == -EOPNOTSUPP) ? 0 : ret;
+}
+EXPORT_SYMBOL(security_inode_init_security);
+
+int security_old_inode_init_security(struct inode *inode, struct inode *dir,
+				     const struct qstr *qstr, char **name,
+				     void **value, size_t *len)
 {
 	if (unlikely(IS_PRIVATE(inode)))
 		return -EOPNOTSUPP;
 	return security_ops->inode_init_security(inode, dir, qstr, name, value,
 						 len);
 }
-EXPORT_SYMBOL(security_inode_init_security);
+EXPORT_SYMBOL(security_old_inode_init_security);
 
 #ifdef CONFIG_SECURITY_PATH
 int security_path_mknod(struct path *dir, struct dentry *dentry, int mode,
diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index 5d979b4..fc80cf4 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -46,26 +46,28 @@ ext2_xattr_security_set(struct dentry *dentry, const char *name,
 			      value, size, flags);
 }
 
+int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		    void *fs_info)
+{
+	const struct xattr *xattr;
+	int err = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		err = ext2_xattr_set(inode, EXT2_XATTR_INDEX_SECURITY,
+				     xattr->name, xattr->value,
+				     xattr->value_len, 0);
+		if (err < 0)
+			break;
+	}
+	return err;
+}
+
 int
 ext2_init_security(struct inode *inode, struct inode *dir,
 		   const struct qstr *qstr)
 {
-	int err;
-	size_t len;
-	void *value;
-	char *name;
-
-	err = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
-	}
-	err = ext2_xattr_set(inode, EXT2_XATTR_INDEX_SECURITY,
-			     name, value, len, 0);
-	kfree(name);
-	kfree(value);
-	return err;
+	return security_inode_init_security(inode, dir, qstr,
+					    &ext2_initxattrs, NULL);
 }
 
 const struct xattr_handler ext2_xattr_security_handler = {
diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index b8d9f83..4202683 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -48,26 +48,30 @@ ext3_xattr_security_set(struct dentry *dentry, const char *name,
 			      name, value, size, flags);
 }
 
+int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		    void *fs_info)
+{
+	const struct xattr *xattr;
+	handle_t *handle = fs_info;
+	int err = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		err = ext3_xattr_set_handle(handle, inode,
+					    EXT3_XATTR_INDEX_SECURITY,
+					    xattr->name, xattr->value,
+					    xattr->value_len, 0);
+		if (err < 0)
+			break;
+	}
+	return err;
+}
+
 int
 ext3_init_security(handle_t *handle, struct inode *inode, struct inode *dir,
 		   const struct qstr *qstr)
 {
-	int err;
-	size_t len;
-	void *value;
-	char *name;
-
-	err = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
-	}
-	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
-				    name, value, len, 0);
-	kfree(name);
-	kfree(value);
-	return err;
+	return security_inode_init_security(inode, dir, qstr,
+					    &ext3_initxattrs, handle);
 }
 
 const struct xattr_handler ext3_xattr_security_handler = {
diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
index 007c3bf..e8ccf3a 100644
--- a/fs/ext4/xattr_security.c
+++ b/fs/ext4/xattr_security.c
@@ -48,26 +48,30 @@ ext4_xattr_security_set(struct dentry *dentry, const char *name,
 			      name, value, size, flags);
 }
 
+int ext4_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		    void *fs_info)
+{
+	const struct xattr *xattr;
+	handle_t *handle = fs_info;
+	int err = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		err = ext4_xattr_set_handle(handle, inode,
+					    EXT4_XATTR_INDEX_SECURITY,
+					    xattr->name, xattr->value,
+					    xattr->value_len, 0);
+		if (err < 0)
+			break;
+	}
+	return err;
+}
+
 int
 ext4_init_security(handle_t *handle, struct inode *inode, struct inode *dir,
 		   const struct qstr *qstr)
 {
-	int err;
-	size_t len;
-	void *value;
-	char *name;
-
-	err = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
-	}
-	err = ext4_xattr_set_handle(handle, inode, EXT4_XATTR_INDEX_SECURITY,
-				    name, value, len, 0);
-	kfree(name);
-	kfree(value);
-	return err;
+	return security_inode_init_security(inode, dir, qstr,
+					    &ext4_initxattrs, handle);
 }
 
 const struct xattr_handler ext4_xattr_security_handler = {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 5366fe4..53c2317 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -360,36 +360,36 @@ int btrfs_removexattr(struct dentry *dentry, const char *name)
 				XATTR_REPLACE);
 }
 
-int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
-			      struct inode *inode, struct inode *dir,
-			      const struct qstr *qstr)
+int btrfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		     void *fs_info)
 {
-	int err;
-	size_t len;
-	void *value;
-	char *suffix;
+	const struct xattr *xattr;
+	struct btrfs_trans_handle *trans = fs_info;
 	char *name;
-
-	err = security_inode_init_security(inode, dir, qstr, &suffix, &value,
-					   &len);
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
-	}
-
-	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + strlen(suffix) + 1,
-		       GFP_NOFS);
-	if (!name) {
-		err = -ENOMEM;
-	} else {
+	int err = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		name = kmalloc(XATTR_SECURITY_PREFIX_LEN + 
+			       strlen(xattr->name) + 1, GFP_NOFS);
+		if (!name) {
+			err = -ENOMEM;
+			break;
+		}
 		strcpy(name, XATTR_SECURITY_PREFIX);
-		strcpy(name + XATTR_SECURITY_PREFIX_LEN, suffix);
-		err = __btrfs_setxattr(trans, inode, name, value, len, 0);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
+		err = __btrfs_setxattr(trans, inode, name,
+				       xattr->value, xattr->value_len, 0);
 		kfree(name);
+		if (err < 0)
+			break;
 	}
-
-	kfree(suffix);
-	kfree(value);
 	return err;
 }
+
+int btrfs_xattr_security_init(struct btrfs_trans_handle *trans,
+			      struct inode *inode, struct inode *dir,
+			      const struct qstr *qstr)
+{
+	return security_inode_init_security(inode, dir, qstr,
+					    &btrfs_initxattrs, trans);
+}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 03e0c52..b6dabfe 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -624,31 +624,29 @@ fail:
 	return error;
 }
 
-static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
-			      const struct qstr *qstr)
+int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		    void *fs_info)
 {
-	int err;
-	size_t len;
-	void *value;
-	char *name;
-
-	err = security_inode_init_security(&ip->i_inode, &dip->i_inode, qstr,
-					   &name, &value, &len);
-
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			return 0;
-		return err;
+	const struct xattr *xattr;
+	int err = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		err = __gfs2_xattr_set(inode, xattr->name, xattr->value,
+				       xattr->value_len, 0,
+				       GFS2_EATYPE_SECURITY);
+		if (err < 0)
+			break;
 	}
-
-	err = __gfs2_xattr_set(&ip->i_inode, name, value, len, 0,
-			       GFS2_EATYPE_SECURITY);
-	kfree(value);
-	kfree(name);
-
 	return err;
 }
 
+static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
+			      const struct qstr *qstr)
+{
+	return security_inode_init_security(&ip->i_inode, &dip->i_inode, qstr,
+					    &gfs2_initxattrs, NULL);
+}
+
 /**
  * gfs2_create_inode - Create a new inode
  * @dir: The parent directory
diff --git a/fs/jffs2/security.c b/fs/jffs2/security.c
index cfeb716..2f27244 100644
--- a/fs/jffs2/security.c
+++ b/fs/jffs2/security.c
@@ -22,26 +22,29 @@
 #include <linux/security.h>
 #include "nodelist.h"
 
-/* ---- Initial Security Label Attachment -------------- */
-int jffs2_init_security(struct inode *inode, struct inode *dir,
-			const struct qstr *qstr)
+/* ---- Initial Security Label(s) Attachment callback --- */
+int jffs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		     void *fs_info)
 {
-	int rc;
-	size_t len;
-	void *value;
-	char *name;
-
-	rc = security_inode_init_security(inode, dir, qstr, &name, &value, &len);
-	if (rc) {
-		if (rc == -EOPNOTSUPP)
-			return 0;
-		return rc;
+	const struct xattr *xattr;
+	int err = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		err = do_jffs2_setxattr(inode, JFFS2_XPREFIX_SECURITY,
+					xattr->name, xattr->value,
+					xattr->value_len, 0);
+		if (err < 0)
+			break;
 	}
-	rc = do_jffs2_setxattr(inode, JFFS2_XPREFIX_SECURITY, name, value, len, 0);
+	return err;
+}
 
-	kfree(name);
-	kfree(value);
-	return rc;
+/* ---- Initial Security Label(s) Attachment ----------- */
+int jffs2_init_security(struct inode *inode, struct inode *dir,
+			const struct qstr *qstr)
+{
+	return security_inode_init_security(inode, dir, qstr,
+					    &jffs2_initxattrs, NULL);
 }
 
 /* ---- XATTR Handler for "security.*" ----------------- */
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 24838f1..516afd5 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -1091,38 +1091,37 @@ int jfs_removexattr(struct dentry *dentry, const char *name)
 }
 
 #ifdef CONFIG_JFS_SECURITY
-int jfs_init_security(tid_t tid, struct inode *inode, struct inode *dir,
-		      const struct qstr *qstr)
+int jfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		   void *fs_info)
 {
-	int rc;
-	size_t len;
-	void *value;
-	char *suffix;
+	const struct xattr *xattr;
+	tid_t *tid = fs_info;
 	char *name;
-
-	rc = security_inode_init_security(inode, dir, qstr, &suffix, &value,
-					  &len);
-	if (rc) {
-		if (rc == -EOPNOTSUPP)
-			return 0;
-		return rc;
-	}
-	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + 1 + strlen(suffix),
-		       GFP_NOFS);
-	if (!name) {
-		rc = -ENOMEM;
-		goto kmalloc_failed;
+	int err = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
+			       strlen(xattr->name) + 1, GFP_NOFS);
+		if (!name) {
+			err = -ENOMEM;
+			break;
+		}
+		strcpy(name, XATTR_SECURITY_PREFIX);
+		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
+		
+		err = __jfs_setxattr(*tid, inode, name, 
+				     xattr->value, xattr->value_len, 0);
+		kfree(name);
+		if (err < 0)
+			break;
 	}
-	strcpy(name, XATTR_SECURITY_PREFIX);
-	strcpy(name + XATTR_SECURITY_PREFIX_LEN, suffix);
-
-	rc = __jfs_setxattr(tid, inode, name, value, len, 0);
-
-	kfree(name);
-kmalloc_failed:
-	kfree(suffix);
-	kfree(value);
+	return err;
+}
 
-	return rc;
+int jfs_init_security(tid_t tid, struct inode *inode, struct inode *dir,
+		      const struct qstr *qstr)
+{
+	return security_inode_init_security(inode, dir, qstr,
+					    &jfs_initxattrs, &tid);
 }
 #endif
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 81ecf9c..40d9956 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7185,20 +7185,9 @@ int ocfs2_init_security_and_acl(struct inode *dir,
 {
 	int ret = 0;
 	struct buffer_head *dir_bh = NULL;
-	struct ocfs2_security_xattr_info si = {
-		.enable = 1,
-	};
 
-	ret = ocfs2_init_security_get(inode, dir, qstr, &si);
+	ret = ocfs2_init_security_get(inode, dir, qstr, NULL);
 	if (!ret) {
-		ret = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
-				      si.name, si.value, si.value_len,
-				      XATTR_CREATE);
-		if (ret) {
-			mlog_errno(ret);
-			goto leave;
-		}
-	} else if (ret != -EOPNOTSUPP) {
 		mlog_errno(ret);
 		goto leave;
 	}
@@ -7255,6 +7244,22 @@ static int ocfs2_xattr_security_set(struct dentry *dentry, const char *name,
 			       name, value, size, flags);
 }
 
+int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		     void *fs_info)
+{
+	const struct xattr *xattr;
+	int err = 0;
+
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		err = ocfs2_xattr_set(inode, OCFS2_XATTR_INDEX_SECURITY,
+				      xattr->name, xattr->value, 
+				      xattr->value_len, XATTR_CREATE);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 int ocfs2_init_security_get(struct inode *inode,
 			    struct inode *dir,
 			    const struct qstr *qstr,
@@ -7263,8 +7268,13 @@ int ocfs2_init_security_get(struct inode *inode,
 	/* check whether ocfs2 support feature xattr */
 	if (!ocfs2_supports_xattr(OCFS2_SB(dir->i_sb)))
 		return -EOPNOTSUPP;
-	return security_inode_init_security(inode, dir, qstr, &si->name,
-					    &si->value, &si->value_len);
+	if (si)
+		return security_old_inode_init_security(inode, dir, qstr,
+							&si->name, &si->value,
+							&si->value_len);
+	
+	return security_inode_init_security(inode, dir, qstr,
+					    &ocfs2_initxattrs, NULL);
 }
 
 int ocfs2_init_security_set(handle_t *handle,
diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index ef66c18..534668f 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -66,8 +66,8 @@ int reiserfs_security_init(struct inode *dir, struct inode *inode,
 	if (IS_PRIVATE(dir))
 		return 0;
 
-	error = security_inode_init_security(inode, dir, qstr, &sec->name,
-					     &sec->value, &sec->length);
+	error = security_old_inode_init_security(inode, dir, qstr, &sec->name,
+						 &sec->value, &sec->length);
 	if (error) {
 		if (error == -EOPNOTSUPP)
 			error = 0;
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index dd21784..1f8eeb8 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -93,37 +93,38 @@ xfs_mark_inode_dirty(
 		mark_inode_dirty(inode);
 }
 
+
+int xfs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+		   void *fs_info)
+{
+	const struct xattr *xattr;
+	struct xfs_inode *ip = XFS_I(inode);
+	int error = 0;
+	
+	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
+		error = xfs_attr_set(ip, xattr->name, xattr->value,
+				     xattr->value_len, ATTR_SECURE);
+		if (error < 0)
+			break;
+	}
+	return error;
+}
+
 /*
  * Hook in SELinux.  This is not quite correct yet, what we really need
  * here (as we do for default ACLs) is a mechanism by which creation of
  * these attrs can be journalled at inode creation time (along with the
  * inode, of course, such that log replay can't cause these to be lost).
  */
+
 STATIC int
 xfs_init_security(
 	struct inode	*inode,
 	struct inode	*dir,
 	const struct qstr *qstr)
 {
-	struct xfs_inode *ip = XFS_I(inode);
-	size_t		length;
-	void		*value;
-	unsigned char	*name;
-	int		error;
-
-	error = security_inode_init_security(inode, dir, qstr, (char **)&name,
-					     &value, &length);
-	if (error) {
-		if (error == -EOPNOTSUPP)
-			return 0;
-		return -error;
-	}
-
-	error = xfs_attr_set(ip, name, value, length, ATTR_SECURE);
-
-	kfree(name);
-	kfree(value);
-	return error;
+	return security_inode_init_security(inode, dir, qstr,
+					    &xfs_initxattrs, NULL);
 }
 
 static void
diff --git a/mm/shmem.c b/mm/shmem.c
index d221a1c..518f27c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1877,7 +1877,7 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 	inode = shmem_get_inode(dir->i_sb, dir, mode, dev, VM_NORESERVE);
 	if (inode) {
 		error = security_inode_init_security(inode, dir,
-						     &dentry->d_name, NULL,
+						     &dentry->d_name,
 						     NULL, NULL);
 		if (error) {
 			if (error != -EOPNOTSUPP) {
@@ -2017,7 +2017,7 @@ static int shmem_symlink(struct inode *dir, struct dentry *dentry, const char *s
 	if (!inode)
 		return -ENOSPC;
 
-	error = security_inode_init_security(inode, dir, &dentry->d_name, NULL,
+	error = security_inode_init_security(inode, dir, &dentry->d_name,
 					     NULL, NULL);
 	if (error) {
 		if (error != -EOPNOTSUPP) {
diff --git a/include/linux/security.h b/include/linux/security.h
index 8ce59ef..ebad5fb 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -36,6 +36,7 @@
 #include <linux/key.h>
 #include <linux/xfrm.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <net/flow.h>
 
 /* Maximum number of letters for an LSM name string */
@@ -147,6 +148,10 @@ extern int mmap_min_addr_handler(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+/* security_inode_init_security callback function to write xattrs */
+typedef int (*initxattrs) (struct inode *inode,
+			   const struct xattr *xattr_array, void *fs_data);
+
 #ifdef CONFIG_SECURITY
 
 struct security_mnt_opts {
@@ -1704,8 +1709,11 @@ int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
 int security_inode_alloc(struct inode *inode);
 void security_inode_free(struct inode *inode);
 int security_inode_init_security(struct inode *inode, struct inode *dir,
-				 const struct qstr *qstr, char **name,
-				 void **value, size_t *len);
+				 const struct qstr *qstr,
+				 initxattrs initxattrs, void *fs_data);
+int security_old_inode_init_security(struct inode *inode, struct inode *dir,
+				     const struct qstr *qstr, char **name,
+				     void **value, size_t *len);
 int security_inode_create(struct inode *dir, struct dentry *dentry, int mode);
 int security_inode_link(struct dentry *old_dentry, struct inode *dir,
 			 struct dentry *new_dentry);
@@ -2035,9 +2043,8 @@ static inline void security_inode_free(struct inode *inode)
 static inline int security_inode_init_security(struct inode *inode,
 						struct inode *dir,
 						const struct qstr *qstr,
-						char **name,
-						void **value,
-						size_t *len)
+						initxattrs initxattrs,
+				 		void *fs_data)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index aed54c5..7a37866 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -67,6 +67,12 @@ struct xattr_handler {
 		   size_t size, int flags, int handler_flags);
 };
 
+struct xattr {
+	char *name;
+	void *value;
+	size_t value_len;
+};
+
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
-- 
1.7.3.4


------------------------------------------------------------------------------
Simplify data backup and recovery for your virtual environment with vRanger.
Installation's a snap, and flexible recovery options mean your data is safe,
secure and there when you need it. Data protection magic?
Nope - It's vRanger. Get your free trial download today.
http://p.sf.net/sfu/quest-sfdev2dev
