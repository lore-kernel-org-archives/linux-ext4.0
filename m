From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/21] fs: add generic xattr_acl handlers
Date: Fri, 20 Dec 2013 05:16:40 -0800
Message-ID: <20131220132521.857886904@bombadil.infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com,
 Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>,
 reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
 Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline;
 filename=0005-fs-add-generic-xattr_acl-handlers.patch
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

With the ->set_acl inode operation we can implement the Posix ACL
xattr handlers in generic code instead of duplicating them all
over the tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/posix_acl.c                  |  102 +++++++++++++++++++++++++++++++++++++++
 include/linux/posix_acl_xattr.h |    3 ++
 2 files changed, 105 insertions(+)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index e329c21..3c0f659 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -17,6 +17,7 @@
 #include <linux/sched.h>
 #include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/xattr.h>
 #include <linux/export.h>
 #include <linux/user_namespace.h>
 
@@ -610,3 +611,104 @@ posix_acl_to_xattr(struct user_namespace *user_ns, const struct posix_acl *acl,
 	return real_size;
 }
 EXPORT_SYMBOL (posix_acl_to_xattr);
+
+static int
+posix_acl_xattr_get(struct dentry *dentry, const char *name,
+		void *value, size_t size, int type)
+{
+	struct posix_acl *acl;
+	int error;
+
+	if (!IS_POSIXACL(dentry->d_inode))
+		return -EOPNOTSUPP;
+	if (S_ISLNK(dentry->d_inode->i_mode))
+		return -EOPNOTSUPP;
+
+	acl = get_acl(dentry->d_inode, type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
+
+	error = posix_acl_to_xattr(&init_user_ns, acl, value, size);
+	posix_acl_release(acl);
+
+	return error;
+}
+
+static int
+posix_acl_xattr_set(struct dentry *dentry, const char *name,
+		const void *value, size_t size, int flags, int type)
+{
+	struct inode *inode = dentry->d_inode;
+	struct posix_acl *acl = NULL;
+	int ret;
+
+	if (!IS_POSIXACL(inode))
+		return -EOPNOTSUPP;
+	if (!inode->i_op->set_acl)
+		return -EOPNOTSUPP;
+
+	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
+		return value ? -EACCES : 0;
+	if (!inode_owner_or_capable(inode))
+		return -EPERM;
+
+	if (value) {
+		acl = posix_acl_from_xattr(&init_user_ns, value, size);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+
+		if (acl) {
+			ret = posix_acl_valid(acl);
+			if (ret)
+				goto out;
+		}
+	}
+
+	ret = inode->i_op->set_acl(inode, acl, type);
+out:
+	posix_acl_release(acl);
+	return ret;
+}
+
+static size_t
+posix_acl_xattr_list(struct dentry *dentry, char *list, size_t list_size,
+		const char *name, size_t name_len, int type)
+{
+	const char *xname;
+	size_t size;
+
+	if (!IS_POSIXACL(dentry->d_inode))
+		return -EOPNOTSUPP;
+	if (S_ISLNK(dentry->d_inode->i_mode))
+		return -EOPNOTSUPP;
+
+	if (type == ACL_TYPE_ACCESS)
+		xname = POSIX_ACL_XATTR_ACCESS;
+	else
+		xname = POSIX_ACL_XATTR_DEFAULT;
+
+	size = strlen(xname) + 1;
+	if (list && size <= list_size)
+		memcpy(list, xname, size);
+	return size;
+}
+
+const struct xattr_handler posix_acl_access_xattr_handler = {
+	.prefix = POSIX_ACL_XATTR_ACCESS,
+	.flags = ACL_TYPE_ACCESS,
+	.list = posix_acl_xattr_list,
+	.get = posix_acl_xattr_get,
+	.set = posix_acl_xattr_set,
+};
+EXPORT_SYMBOL_GPL(posix_acl_access_xattr_handler);
+
+const struct xattr_handler posix_acl_default_xattr_handler = {
+	.prefix = POSIX_ACL_XATTR_DEFAULT,
+	.flags = ACL_TYPE_DEFAULT,
+	.list = posix_acl_xattr_list,
+	.get = posix_acl_xattr_get,
+	.set = posix_acl_xattr_set,
+};
+EXPORT_SYMBOL_GPL(posix_acl_default_xattr_handler);
diff --git a/include/linux/posix_acl_xattr.h b/include/linux/posix_acl_xattr.h
index ad93ad0..6f14ee2 100644
--- a/include/linux/posix_acl_xattr.h
+++ b/include/linux/posix_acl_xattr.h
@@ -69,4 +69,7 @@ struct posix_acl *posix_acl_from_xattr(struct user_namespace *user_ns,
 int posix_acl_to_xattr(struct user_namespace *user_ns,
 		       const struct posix_acl *acl, void *buffer, size_t size);
 
+extern const struct xattr_handler posix_acl_access_xattr_handler;
+extern const struct xattr_handler posix_acl_default_xattr_handler;
+
 #endif	/* _POSIX_ACL_XATTR_H */
-- 
1.7.10.4



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
