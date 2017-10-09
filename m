From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.2 48/74] ext2: Don't clear SGID when inheriting ACLs
Date: Mon, 09 Oct 2017 13:30:34 +0100
Message-ID: <lsq.1507552234.482387091@decadent.org.uk>
References: <lsq.1507552233.547064726@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>,
        linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <lsq.1507552233.547064726@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

3.2.94-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a992f2d38e4ce17b8c7d1f7f67b2de0eebdea069 upstream.

When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
set, DIR1 is expected to have SGID bit set (and owning group equal to
the owning group of 'DIR0'). However when 'DIR0' also has some default
ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
'DIR1' to get cleared if user is not member of the owning group.

Fix the problem by creating __ext2_set_acl() function that does not call
posix_acl_update_mode() and use it when inheriting ACLs. That prevents
SGID bit clearing and the mode has been properly set by
posix_acl_create() anyway.

Fixes: 073931017b49d9458aa351605b43a7e34598caef
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.2:
 - Keep using CURRENT_TIME_SEC
 - Change parameter order of ext2_set_acl() to match upstream
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext2/acl.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -174,11 +174,8 @@ ext2_get_acl(struct inode *inode, int ty
 	return acl;
 }
 
-/*
- * inode->i_mutex: down
- */
 static int
-ext2_set_acl(struct inode *inode, int type, struct posix_acl *acl)
+__ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int name_index;
 	void *value = NULL;
@@ -193,13 +190,6 @@ ext2_set_acl(struct inode *inode, int ty
 	switch(type) {
 		case ACL_TYPE_ACCESS:
 			name_index = EXT2_XATTR_INDEX_POSIX_ACL_ACCESS;
-			if (acl) {
-				error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
-				if (error)
-					return error;
-				inode->i_ctime = CURRENT_TIME_SEC;
-				mark_inode_dirty(inode);
-			}
 			break;
 
 		case ACL_TYPE_DEFAULT:
@@ -226,6 +216,24 @@ ext2_set_acl(struct inode *inode, int ty
 }
 
 /*
+ * inode->i_mutex: down
+ */
+static int
+ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
+{
+	int error;
+
+	if (type == ACL_TYPE_ACCESS && acl) {
+		error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		if (error)
+			return error;
+		inode->i_ctime = CURRENT_TIME_SEC;
+		mark_inode_dirty(inode);
+	}
+	return __ext2_set_acl(inode, acl, type);
+}
+
+/*
  * Initialize the ACLs of a new inode. Called from ext2_new_inode.
  *
  * dir->i_mutex: down
@@ -248,7 +256,7 @@ ext2_init_acl(struct inode *inode, struc
 	}
 	if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
 		if (S_ISDIR(inode->i_mode)) {
-			error = ext2_set_acl(inode, ACL_TYPE_DEFAULT, acl);
+			error = __ext2_set_acl(inode, acl, ACL_TYPE_DEFAULT);
 			if (error)
 				goto cleanup;
 		}
@@ -257,7 +265,7 @@ ext2_init_acl(struct inode *inode, struc
 			return error;
 		if (error > 0) {
 			/* This is an extended ACL */
-			error = ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);
+			error = __ext2_set_acl(inode, acl, ACL_TYPE_ACCESS);
 		}
 	}
 cleanup:
@@ -295,7 +303,7 @@ ext2_acl_chmod(struct inode *inode)
 	error = posix_acl_chmod(&acl, GFP_KERNEL, inode->i_mode);
 	if (error)
 		return error;
-	error = ext2_set_acl(inode, ACL_TYPE_ACCESS, acl);
+	error = ext2_set_acl(inode, acl, ACL_TYPE_ACCESS);
 	posix_acl_release(acl);
 	return error;
 }
@@ -378,7 +386,7 @@ ext2_xattr_set_acl(struct dentry *dentry
 	} else
 		acl = NULL;
 
-	error = ext2_set_acl(dentry->d_inode, type, acl);
+	error = ext2_set_acl(dentry->d_inode, acl, type);
 
 release_and_out:
 	posix_acl_release(acl);
