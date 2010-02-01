From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 15/23] richacl: Delete posix acl if present on richacl set
Date: Mon,  1 Feb 2010 11:04:57 +0530
Message-ID: <1265002505-8387-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:36847 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0BAFfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:23 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When trying to set richacl on a file system object if we
have ACL4_POSIX_MAPPED flag set on the acl delete posix
acl stored with the object. This helps us to migrate from
posix acl to richacl. If we have posix acl stored with
the inode, a getxattr on the inode would return a mapped
richacl with ACL4_POSIX_MAPPED set. Now when we set the
acl back it will result in posix acl being deleted and
richacl being stored.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/acl.c     |    2 +-
 fs/ext4/acl.h     |    2 ++
 fs/ext4/richacl.c |   26 ++++++++++++++++++++++++--
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index e17e1a9..3dd3058 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -203,7 +203,7 @@ ext4_get_acl(struct inode *inode, int type)
  *
  * inode->i_mutex: down unless called from ext4_new_inode
  */
-static int
+int
 ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 	     struct posix_acl *acl)
 {
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 3e47cf3..adcb6e7 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -58,6 +58,8 @@ extern int ext4_check_acl(struct inode *, int);
 extern int ext4_acl_chmod(struct inode *);
 extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
 extern struct posix_acl *ext4_get_acl(struct inode *inode, int type);
+extern int ext4_set_acl(handle_t *handle, struct inode *inode, int type,
+			struct posix_acl *acl);
 
 #else  /* CONFIG_EXT4_FS_POSIX_ACL */
 #include <linux/sched.h>
diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
index 73c14dd..ca8f28e 100644
--- a/fs/ext4/richacl.c
+++ b/fs/ext4/richacl.c
@@ -368,6 +368,7 @@ ext4_xattr_set_richacl(struct dentry *dentry, const char *name,
 {
 	handle_t *handle;
 	struct richacl *acl = NULL;
+	struct posix_acl *pacl = NULL, *pdacl = NULL;
 	int retval, retries = 0;
 	struct inode *inode = dentry->d_inode;
 
@@ -388,18 +389,39 @@ ext4_xattr_set_richacl(struct dentry *dentry, const char *name,
 
 		inode->i_mode &= ~S_IRWXUGO;
 		inode->i_mode |= richacl_masks_to_mode(acl);
-	}
+		/*
+		 * check whether we have posix acl. If so delete them
+		 *
+		 */
 
+		if (acl->a_flags & ACL4_POSIX_MAPPED) {
+			pacl  = ext4_get_acl(inode, ACL_TYPE_ACCESS);
+			pdacl = ext4_get_acl(inode, ACL_TYPE_DEFAULT);
+			acl->a_flags &= ~ACL4_POSIX_MAPPED;
+		}
+	}
 retry:
 	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ext4_mark_inode_dirty(handle, inode);
+	if (pacl)
+		ext4_set_acl(handle, inode, ACL_TYPE_ACCESS, NULL);
+	if (pdacl)
+		ext4_set_acl(handle, inode, ACL_TYPE_DEFAULT, NULL);
+
 	retval = ext4_set_richacl(handle, inode, acl);
 	ext4_journal_stop(handle);
-	if (retval == ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (retval == ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries)) {
+		posix_acl_release(pacl);
+		posix_acl_release(pdacl);
+		pacl = pdacl = NULL;
 		goto retry;
+	}
 	richacl_put(acl);
+	posix_acl_release(pacl);
+	posix_acl_release(pdacl);
+	pacl = pdacl = NULL;
 	return retval;
 }
 
-- 
1.7.0.rc0.48.gdace5

