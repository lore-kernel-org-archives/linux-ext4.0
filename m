From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 16/17] vfs: Cache richacl in struct inode
Date: Thu, 29 Jul 2010 23:27:54 +0530
Message-ID: <1280426275-4602-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

Cache richacls in struct inode and not individually in each filesystem.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h          |    4 ----
 fs/ext4/inode.c         |    3 ---
 fs/ext4/richacl.c       |   34 ++++------------------------------
 fs/ext4/richacl.h       |    3 ---
 fs/ext4/super.c         |   10 ----------
 fs/inode.c              |   24 +++++++++++++++++++-----
 include/linux/fs.h      |   12 ++++++++++--
 include/linux/richacl.h |   41 +++++++++++++++++++++++++++++++++++++++++
 8 files changed, 74 insertions(+), 57 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 966d0cb..651379b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -836,10 +836,6 @@ struct ext4_inode_info {
 	 */
 	tid_t i_sync_tid;
 	tid_t i_datasync_tid;
-#ifdef CONFIG_EXT4_FS_RICHACL
-	struct richacl   *i_richacl;
-#endif
-
 };
 
 /*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 93550e3..66a8c57 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5021,9 +5021,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 
 	ei->i_state_flags = 0;
-#ifdef CONFIG_EXT4_FS_RICHACL
-	ei->i_richacl = EXT4_RICHACL_NOT_CACHED;
-#endif
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
 	/* We now have enough fields to check if the inode was active or not.
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
index 5dfba2b..5b9e839 100644
--- a/fs/ext4/richacl.c
+++ b/fs/ext4/richacl.c
@@ -22,32 +22,6 @@
 #include "acl.h"
 #include "richacl.h"
 
-static inline struct richacl *
-ext4_iget_richacl(struct inode *inode)
-{
-	struct richacl *acl = EXT4_RICHACL_NOT_CACHED;
-	struct ext4_inode_info *ei = EXT4_I(inode);
-
-	spin_lock(&inode->i_lock);
-	if (ei->i_richacl != EXT4_RICHACL_NOT_CACHED)
-		acl = richacl_get(ei->i_richacl);
-	spin_unlock(&inode->i_lock);
-
-	return acl;
-}
-
-static inline void
-ext4_iset_richacl(struct inode *inode, struct richacl *acl)
-{
-	struct ext4_inode_info *ei = EXT4_I(inode);
-
-	spin_lock(&inode->i_lock);
-	if (ei->i_richacl != EXT4_RICHACL_NOT_CACHED)
-		richacl_put(ei->i_richacl);
-	ei->i_richacl = richacl_get(acl);
-	spin_unlock(&inode->i_lock);
-}
-
 static struct richacl *
 ext4_get_richacl(struct inode *inode)
 {
@@ -58,8 +32,8 @@ ext4_get_richacl(struct inode *inode)
 
 	if (!IS_RICHACL(inode))
 		return ERR_PTR(-EOPNOTSUPP);
-	acl = ext4_iget_richacl(inode);
-	if (acl != EXT4_RICHACL_NOT_CACHED)
+	acl = get_cached_richacl(inode);
+	if (acl != ACL_NOT_CACHED)
 		return acl;
 	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
@@ -79,7 +53,7 @@ ext4_get_richacl(struct inode *inode)
 	kfree(value);
 
 	if (!IS_ERR_OR_NULL(acl))
-		ext4_iset_richacl(inode, acl);
+		set_cached_richacl(inode, acl);
 
 	return acl;
 }
@@ -114,7 +88,7 @@ ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
 		retval = ext4_xattr_set(inode, name_index, "", value, size, 0);
 	kfree(value);
 	if (!retval)
-		ext4_iset_richacl(inode, acl);
+		set_cached_richacl(inode, acl);
 
 	return retval;
 }
diff --git a/fs/ext4/richacl.h b/fs/ext4/richacl.h
index 00d89f2..1d52914 100644
--- a/fs/ext4/richacl.h
+++ b/fs/ext4/richacl.h
@@ -21,9 +21,6 @@
 
 # define EXT4_IS_RICHACL(inode) IS_RICHACL(inode)
 
-/* Value for i_richacl if RICHACL has not been cached */
-# define EXT4_RICHACL_NOT_CACHED ((void *)-1)
-
 extern int ext4_permission(struct inode *, int);
 extern int ext4_richacl_permission(struct inode *, unsigned int);
 extern int ext4_may_create(struct inode *, int);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 520ab44..d0d3766 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -741,9 +741,6 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei = kmem_cache_alloc(ext4_inode_cachep, GFP_NOFS);
 	if (!ei)
 		return NULL;
-#ifdef CONFIG_EXT4_FS_RICHACL
-	ei->i_richacl = EXT4_RICHACL_NOT_CACHED;
-#endif
 	ei->vfs_inode.i_version = 1;
 	ei->vfs_inode.i_data.writeback_index = 0;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
@@ -819,13 +816,6 @@ static void destroy_inodecache(void)
 static void ext4_clear_inode(struct inode *inode)
 {
 	dquot_drop(inode);
-#ifdef CONFIG_EXT4_FS_RICHACL
-	if (EXT4_I(inode)->i_richacl &&
-		EXT4_I(inode)->i_richacl != EXT4_RICHACL_NOT_CACHED) {
-		richacl_put(EXT4_I(inode)->i_richacl);
-		EXT4_I(inode)->i_richacl = EXT4_RICHACL_NOT_CACHED;
-	}
-#endif
 	ext4_discard_preallocations(inode);
 	if (EXT4_JOURNAL(inode))
 		jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
diff --git a/fs/inode.c b/fs/inode.c
index 2bee20a..796f4a8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/mount.h>
 #include <linux/async.h>
 #include <linux/posix_acl.h>
+#include <linux/richacl.h>
 
 /*
  * This is needed for the following functions:
@@ -186,7 +187,12 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
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
@@ -228,10 +234,18 @@ void __destroy_inode(struct inode *inode)
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
 }
 EXPORT_SYMBOL(__destroy_inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2a65863..745adfd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -728,6 +728,7 @@ static inline int mapping_writably_mapped(struct address_space *mapping)
 #endif
 
 struct posix_acl;
+struct richacl;
 #define ACL_NOT_CACHED ((void *)(-1))
 
 struct inode {
@@ -793,10 +794,17 @@ struct inode {
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
index bb0c9b2..93634bc 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -189,6 +189,47 @@ richacl_put(struct richacl *acl)
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
+	spin_lock(&inode->i_lock);;
+	old = inode->i_richacl;
+	inode->i_richacl = ACL_NOT_CACHED;
+	spin_unlock(&inode->i_lock);
+	if (old != ACL_NOT_CACHED)
+		richacl_put(old);
+}
+#endif
+
 static inline int
 richacl_is_auto_inherit(const struct richacl *acl)
 {
-- 
1.7.0.4

_______________________________________________
NOTE: THIS LIST IS DEPRECATED.  Please use linux-nfs@vger.kernel.org instead.
(To subscribe to linux-nfs@vger.kernel.org: send "subscribe linux-nfs" in the body of a message to majordomo@vger.kernel.org.)

NFSv4 mailing list
NFSv4@linux-nfs.org
http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4
