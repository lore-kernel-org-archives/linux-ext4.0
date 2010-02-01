From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 13/23] richacl: Follow nfs4 acl delete definition
Date: Mon,  1 Feb 2010 11:04:55 +0530
Message-ID: <1265002505-8387-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We SHOULD allow unlink if either ACE4_DELETE is permitted on the target,
or ACE4_DELETE_CHILD is permitted on the parent. (Note that this is true
even if the parent or target explicitly denies one of these permissions.)

If the ACLs in question neither explicitly ALLOW nor DENY either of the above,
and if MODE4_SVTX is not set on the parent, then the we SHOULD allow the
removal if and only if ACE4_ADD_FILE is permitted. In the case where MODE4_SVTX
is set, the we may also require the remover to own either the parent or the
target, or may require the target to be writable.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/richacl.c       |   41 ++++++++++++++++++++++++++++++++++++-
 fs/richacl_base.c       |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |    2 +
 3 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/richacl.c b/fs/ext4/richacl.c
index a8702c7..73c14dd 100644
--- a/fs/ext4/richacl.c
+++ b/fs/ext4/richacl.c
@@ -190,6 +190,28 @@ ext4_richacl_permission(struct inode *inode, unsigned int mask)
 	return retval;
 }
 
+int ext4_richacl_mask_present(struct inode *inode, unsigned int mask)
+{
+	struct richacl *acl;
+	int retval;
+
+	if (!richacl_enabled(inode->i_sb))
+		BUG();
+
+	acl = ext4_get_richacl(inode);
+	if (!acl)
+		return 0;
+	else if (IS_ERR(acl))
+		return 0;
+	else {
+		retval = richacl_mask_present(inode, acl, mask);
+		richacl_put(acl);
+	}
+
+	return retval;
+
+
+}
 int ext4_may_create(struct inode *dir, int isdir)
 {
 	int error;
@@ -223,10 +245,25 @@ int ext4_may_delete(struct inode *dir, struct inode *inode)
 	if (richacl_enabled(inode->i_sb)) {
 		error = ext4_richacl_permission(dir,
 					ACE4_DELETE_CHILD|ACE4_EXECUTE);
-		if (!error && check_sticky(dir, inode))
-			error = -EPERM;
 		if (error && !ext4_richacl_permission(inode, ACE4_DELETE))
 			error = 0;
+
+		if (!error)
+			return error;
+
+		/*
+		 * if we neither explicity allow nor deny both the above
+		 * then are depend on stick and add file flag
+		 */
+		if (!ext4_richacl_mask_present(dir, ACE4_DELETE_CHILD) &&
+			!ext4_richacl_mask_present(inode, ACE4_DELETE)) {
+
+			error =	ext4_richacl_permission(dir,
+					ACE4_ADD_FILE | ACE4_EXECUTE);
+			if (!error && check_sticky(dir, inode))
+				error = -EPERM;
+		}
+
 	} else {
 		error = ext4_permission(dir, MAY_WRITE | MAY_EXEC);
 		if (!error && check_sticky(dir, inode))
diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index b5c28cf..4a340d7 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -350,6 +350,56 @@ is_everyone:
 EXPORT_SYMBOL_GPL(richacl_permission);
 
 /**
+ * richacl_mask_present - check whether the specified masks are present in the acl
+ * @inode:	inode to check
+ * @acl:	rich acl of the inode
+ * @mask:	requested access (ACE4_* bitmask)
+ *
+ * Check wether the specified mask are explicity specified in the allow or
+ * deny aces. If not return 0. If yes return 1;
+ */
+int richacl_mask_present(struct inode *inode, const struct richacl *acl,
+		       unsigned int mask)
+{
+	const struct richace *ace;
+
+	richacl_for_each_entry(ace, acl) {
+		unsigned int ace_mask = ace->e_mask;
+
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_owner(ace)) {
+			if (current_fsuid() != inode->i_uid)
+				continue;
+		} else if (richace_is_group(ace)) {
+			if (!in_group_p(inode->i_gid))
+				continue;
+		} else if (richace_is_unix_id(ace)) {
+			if (ace->e_flags & ACE4_IDENTIFIER_GROUP) {
+				if (!in_group_p(ace->u.e_id))
+					continue;
+			} else {
+				if (current_fsuid() != ace->u.e_id)
+					continue;
+			}
+		}
+		if (mask & ace_mask)
+			/* ace contain some of the mask */
+			mask &= ~ace_mask;
+
+		if (!mask)
+			break;
+	}
+
+	if (mask)
+		/* some of the mask specified are not present */
+		return 0;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(richacl_mask_present);
+
+/**
  * richacl_generic_permission  -  permission check algorithm without explicit acl
  * @inode:	inode to check permissions for
  * @mask:	requested access (ACE4_* bitmask)
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index de71ca5..705e061 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -225,6 +225,8 @@ extern struct richacl *richacl_clone(const struct richacl *acl);
 extern unsigned int richacl_want_to_mask(int want, int is_dir);
 extern int richacl_permission(struct inode *,
 			const struct richacl *, unsigned int);
+extern int richacl_mask_present(struct inode *,
+			const struct richacl *, unsigned int);
 extern int richacl_generic_permission(struct inode *, unsigned int);
 extern int richace_is_same_who(const struct richace *, const struct richace *);
 extern int richace_set_who(struct richace *ace, const char *who);
-- 
1.7.0.rc0.48.gdace5

