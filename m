From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 02/18] fs: add get_acl helper
Date: Wed, 11 Dec 2013 02:42:45 -0800
Message-ID: <20131211104526.648135334@bombadil.infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Mark Fasheh <mfasheh-IBi9RG/b67k@public.gmane.org>,
	Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>,
	reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andreas Gruenbacher <andreas.gruenbacher-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0002-fs-add-get_acl-helper.patch
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Factor out the code to get an ACL either from the inode or disk from
check_acl, so that it can be used elsewhere later on.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/namei.c                |   24 +++---------------------
 fs/posix_acl.c            |   26 ++++++++++++++++++++++++++
 include/linux/posix_acl.h |    2 ++
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c53d3a9..8acd1e8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -235,27 +235,9 @@ static int check_acl(struct inode *inode, int mask)
 	        return posix_acl_permission(inode, acl, mask & ~MAY_NOT_BLOCK);
 	}
 
-	acl = get_cached_acl(inode, ACL_TYPE_ACCESS);
-
-	/*
-	 * A filesystem can force a ACL callback by just never filling the
-	 * ACL cache. But normally you'd fill the cache either at inode
-	 * instantiation time, or on the first ->get_acl call.
-	 *
-	 * If the filesystem doesn't have a get_acl() function at all, we'll
-	 * just create the negative cache entry.
-	 */
-	if (acl == ACL_NOT_CACHED) {
-	        if (inode->i_op->get_acl) {
-			acl = inode->i_op->get_acl(inode, ACL_TYPE_ACCESS);
-			if (IS_ERR(acl))
-				return PTR_ERR(acl);
-		} else {
-		        set_cached_acl(inode, ACL_TYPE_ACCESS, NULL);
-		        return -EAGAIN;
-		}
-	}
-
+	acl = get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
 	if (acl) {
 	        int error = posix_acl_permission(inode, acl, mask);
 	        posix_acl_release(acl);
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 8bd2135..f2c48f8 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -418,3 +418,29 @@ posix_acl_chmod(struct posix_acl **acl, gfp_t gfp, umode_t mode)
 	return err;
 }
 EXPORT_SYMBOL(posix_acl_chmod);
+
+struct posix_acl *get_acl(struct inode *inode, int type)
+{
+	struct posix_acl *acl;
+
+	acl = get_cached_acl(inode, type);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
+	if (!IS_POSIXACL(inode))
+		return NULL;
+
+	/*
+	 * A filesystem can force a ACL callback by just never filling the
+	 * ACL cache. But normally you'd fill the cache either at inode
+	 * instantiation time, or on the first ->get_acl call.
+	 *
+	 * If the filesystem doesn't have a get_acl() function at all, we'll
+	 * just create the negative cache entry.
+	 */
+	if (!inode->i_op->get_acl) {
+		set_cached_acl(inode, type, NULL);
+		return ERR_PTR(-EAGAIN);
+	}
+	return inode->i_op->get_acl(inode, type);
+}
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7931efe..a8d9918 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -175,4 +175,6 @@ static inline void cache_no_acl(struct inode *inode)
 #endif
 }
 
+struct posix_acl *get_acl(struct inode *inode, int type);
+
 #endif  /* __LINUX_POSIX_ACL_H */
-- 
1.7.10.4


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
