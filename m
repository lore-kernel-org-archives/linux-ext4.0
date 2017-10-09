From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 3.2 50/74] ext3: Don't clear SGID when inheriting ACLs
Date: Mon, 09 Oct 2017 13:30:34 +0100
Message-ID: <lsq.1507552234.684260090@decadent.org.uk>
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

From: Ben Hutchings <ben@decadent.org.uk>

Based on Jan Kara's fix for ext2 (commit a992f2d38e4c), from which the
following description is taken:

> When new directory 'DIR1' is created in a directory 'DIR0' with SGID bit
> set, DIR1 is expected to have SGID bit set (and owning group equal to
> the owning group of 'DIR0'). However when 'DIR0' also has some default
> ACLs that 'DIR1' inherits, setting these ACLs will result in SGID bit on
> 'DIR1' to get cleared if user is not member of the owning group.
>
> Fix the problem by creating __ext2_set_acl() function that does not call
> posix_acl_update_mode() and use it when inheriting ACLs. That prevents
> SGID bit clearing and the mode has been properly set by
> posix_acl_create() anyway.

Fixes: 073931017b49 ("posix_acl: Clear SGID bit when setting file permissions")
Cc: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext3/acl.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -178,14 +178,9 @@ ext3_get_acl(struct inode *inode, int ty
 	return acl;
 }
 
-/*
- * Set the access or default ACL of an inode.
- *
- * inode->i_mutex: down unless called from ext3_new_inode
- */
 static int
-ext3_set_acl(handle_t *handle, struct inode *inode, int type,
-	     struct posix_acl *acl)
+__ext3_set_acl(handle_t *handle, struct inode *inode, int type,
+	       struct posix_acl *acl)
 {
 	int name_index;
 	void *value = NULL;
@@ -198,13 +193,6 @@ ext3_set_acl(handle_t *handle, struct in
 	switch(type) {
 		case ACL_TYPE_ACCESS:
 			name_index = EXT3_XATTR_INDEX_POSIX_ACL_ACCESS;
-			if (acl) {
-				error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
-				if (error)
-					return error;
-				inode->i_ctime = CURRENT_TIME_SEC;
-				ext3_mark_inode_dirty(handle, inode);
-			}
 			break;
 
 		case ACL_TYPE_DEFAULT:
@@ -234,6 +222,27 @@ ext3_set_acl(handle_t *handle, struct in
 }
 
 /*
+ * Set the access or default ACL of an inode.
+ *
+ * inode->i_mutex: down
+ */
+static int
+ext3_set_acl(handle_t *handle, struct inode *inode, int type,
+	     struct posix_acl *acl)
+{
+	int error;
+
+	if (type == ACL_TYPE_ACCESS && acl) {
+		error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
+		if (error)
+			return error;
+		inode->i_ctime = CURRENT_TIME_SEC;
+		ext3_mark_inode_dirty(handle, inode);
+	}
+	return __ext3_set_acl(handle, inode, type, acl);
+}
+
+/*
  * Initialize the ACLs of a new inode. Called from ext3_new_inode.
  *
  * dir->i_mutex: down
@@ -256,8 +265,8 @@ ext3_init_acl(handle_t *handle, struct i
 	}
 	if (test_opt(inode->i_sb, POSIX_ACL) && acl) {
 		if (S_ISDIR(inode->i_mode)) {
-			error = ext3_set_acl(handle, inode,
-					     ACL_TYPE_DEFAULT, acl);
+			error = __ext3_set_acl(handle, inode,
+					       ACL_TYPE_DEFAULT, acl);
 			if (error)
 				goto cleanup;
 		}
@@ -267,7 +276,7 @@ ext3_init_acl(handle_t *handle, struct i
 
 		if (error > 0) {
 			/* This is an extended ACL */
-			error = ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
+			error = __ext3_set_acl(handle, inode, ACL_TYPE_ACCESS, acl);
 		}
 	}
 cleanup:
