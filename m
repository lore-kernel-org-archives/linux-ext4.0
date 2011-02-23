From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V5 22/24] vfs: Cache richacl in struct inode
Date: Wed, 23 Feb 2011 19:22:09 +0530
Message-ID: <1298469131-16555-23-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
To: sfrench@us.ibm.com, agruen@linbit.com, dilger.kernel@dilger.ca,
	sandeen@redhat.com, tytso@mit.edu, bfields@fieldses.org,
	jlayton@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Cache richacls in struct inode so that this doesn't have to be done
individually in each filesystem.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/inode.c              |   24 ++++++++++++++++----
 include/linux/fs.h      |   12 ++++++++-
 include/linux/richacl.h |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index da85e56..381edca 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/posix_acl.h>
 #include <linux/ima.h>
+#include <linux/richacl.h>
 
 /*
  * This is needed for the following functions:
@@ -219,7 +220,12 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_private = NULL;
 	inode->i_mapping = mapping;
 #ifdef CONFIG_FS_POSIX_ACL
-	inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
+	if (IS_POSIXACL(inode))
+		inode->i_acl = inode->i_default_acl = ACL_NOT_CACHED;
+#endif
+#ifdef CONFIG_FS_RICHACL
+	if (IS_RICHACL(inode))
+		inode->i_richacl = ACL_NOT_CACHED;
 #endif
 
 #ifdef CONFIG_FSNOTIFY
@@ -269,10 +275,18 @@ void __destroy_inode(struct inode *inode)
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
 #ifdef CONFIG_FS_POSIX_ACL
-	if (inode->i_acl && inode->i_acl != ACL_NOT_CACHED)
-		posix_acl_release(inode->i_acl);
-	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
-		posix_acl_release(inode->i_default_acl);
+	if (IS_POSIXACL(inode)) {
+		if (inode->i_acl != ACL_NOT_CACHED)
+			posix_acl_release(inode->i_acl);
+		if (inode->i_default_acl != ACL_NOT_CACHED)
+			posix_acl_release(inode->i_default_acl);
+	}
+#endif
+#ifdef CONFIG_FS_RICHACL
+	if (IS_RICHACL(inode)) {
+		if (inode->i_richacl != ACL_NOT_CACHED)
+			richacl_put(inode->i_richacl);
+	}
 #endif
 	this_cpu_dec(nr_inodes);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1627592..77ce324 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -754,6 +754,7 @@ static inline int mapping_writably_mapped(struct address_space *mapping)
 #endif
 
 struct posix_acl;
+struct richacl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
@@ -824,10 +825,17 @@ struct inode {
 #ifdef CONFIG_SECURITY
 	void			*i_security;
 #endif
+	union {
 #ifdef CONFIG_FS_POSIX_ACL
-	struct posix_acl	*i_acl;
-	struct posix_acl	*i_default_acl;
+		struct {
+			struct posix_acl *i_acl;
+			struct posix_acl *i_default_acl;
+		};
 #endif
+#ifdef CONFIG_FS_RICHACL
+		struct richacl	*i_richacl;
+#endif
+	};
 	void			*i_private; /* fs or device private pointer */
 };
 
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 23befbc..c788a91 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -189,6 +189,59 @@ richacl_put(struct richacl *acl)
 		kfree(acl);
 }
 
+#ifdef CONFIG_FS_RICHACL
+static inline struct richacl *get_cached_richacl(struct inode *inode)
+{
+	struct richacl **p, *acl;
+
+	p = &inode->i_richacl;
+	acl = ACCESS_ONCE(*p);
+	if (acl) {
+		spin_lock(&inode->i_lock);
+		acl = *p;
+		if (acl != ACL_NOT_CACHED)
+			acl = richacl_get(acl);
+		spin_unlock(&inode->i_lock);
+	}
+	return acl;
+}
+
+static inline void set_cached_richacl(struct inode *inode,
+				      struct richacl *acl)
+{
+	struct richacl *old = NULL;
+	spin_lock(&inode->i_lock);
+	old = inode->i_richacl;
+	inode->i_richacl = richacl_get(acl);
+	spin_unlock(&inode->i_lock);
+	if (old != ACL_NOT_CACHED)
+		richacl_put(old);
+}
+
+static inline void forget_cached_richacl(struct inode *inode)
+{
+	struct richacl *old = NULL;
+	spin_lock(&inode->i_lock);
+	old = inode->i_richacl;
+	inode->i_richacl = ACL_NOT_CACHED;
+	spin_unlock(&inode->i_lock);
+	if (old != ACL_NOT_CACHED)
+		richacl_put(old);
+}
+
+static inline int negative_cached_richacl(struct inode *inode)
+{
+	struct richacl **p, *acl;
+
+	p = &inode->i_richacl;
+	acl = ACCESS_ONCE(*p);
+	if (acl)
+		return 0;
+	return 1;
+}
+
+#endif
+
 static inline int
 richacl_is_auto_inherit(const struct richacl *acl)
 {
-- 
1.7.1
