From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 10/23] richacl: Add separate file and dir acl masks
Date: Mon,  1 Feb 2010 11:04:52 +0530
Message-ID: <1265002505-8387-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_base.c       |   54 +++++++++++++++++++++++++++--------------------
 fs/richacl_posix.c      |   27 ++++++++++++-----------
 include/linux/richacl.h |    2 +-
 3 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index a176399..0d8953c 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -76,23 +76,23 @@ richacl_clone(const struct richacl *acl)
  * make sure that we do not mask them if they are set, so that users who
  * rely on these flags won't get confused.
  */
-#define ACE4_POSIX_MODE_READ ( \
-	ACE4_READ_DATA | ACE4_LIST_DIRECTORY)
-#define ACE4_POSIX_MODE_WRITE ( \
-	ACE4_WRITE_DATA | ACE4_ADD_FILE | \
-	ACE4_APPEND_DATA | ACE4_ADD_SUBDIRECTORY | \
+#define ACE4_POSIX_MODE_FILE_READ ACE4_READ_DATA
+#define ACE4_POSIX_MODE_FILE_WRITE ( \
+	ACE4_WRITE_DATA | ACE4_APPEND_DATA)
+#define ACE4_POSIX_MODE_DIR_READ ACE4_LIST_DIRECTORY
+#define ACE4_POSIX_MODE_DIR_WRITE ( \
+	ACE4_ADD_FILE | ACE4_ADD_SUBDIRECTORY | \
 	ACE4_DELETE_CHILD)
-#define ACE4_POSIX_MODE_EXEC ( \
-	ACE4_EXECUTE)
+#define ACE4_POSIX_MODE_EXEC	ACE4_EXECUTE
 
 static int
 richacl_mask_to_mode(unsigned int mask)
 {
 	int mode = 0;
 
-	if (mask & ACE4_POSIX_MODE_READ)
+	if (mask & (ACE4_POSIX_MODE_FILE_READ |	ACE4_POSIX_MODE_DIR_READ))
 		mode |= MAY_READ;
-	if (mask & ACE4_POSIX_MODE_WRITE)
+	if (mask & (ACE4_POSIX_MODE_FILE_WRITE | ACE4_POSIX_MODE_DIR_WRITE))
 		mode |= MAY_WRITE;
 	if (mask & ACE4_POSIX_MODE_EXEC)
 		mode |= MAY_EXEC;
@@ -115,14 +115,21 @@ richacl_masks_to_mode(const struct richacl *acl)
 EXPORT_SYMBOL_GPL(richacl_masks_to_mode);
 
 unsigned int
-richacl_mode_to_mask(mode_t mode)
+richacl_mode_to_mask(mode_t mode, int is_dir)
 {
 	unsigned int mask = ACE4_POSIX_ALWAYS_ALLOWED;
 
-	if (mode & MAY_READ)
-		mask |= ACE4_POSIX_MODE_READ;
-	if (mode & MAY_WRITE)
-		mask |= ACE4_POSIX_MODE_WRITE;
+	if (is_dir) {
+		if (mode & MAY_READ)
+			mask |= ACE4_POSIX_MODE_DIR_READ;
+		if (mode & MAY_WRITE)
+			mask |= ACE4_POSIX_MODE_DIR_WRITE;
+	} else {
+		if (mode & MAY_READ)
+			mask |= ACE4_POSIX_MODE_FILE_READ;
+		if (mode & MAY_WRITE)
+			mask |= ACE4_POSIX_MODE_FILE_WRITE;
+	}
 	if (mode & MAY_EXEC)
 		mask |= ACE4_POSIX_MODE_EXEC;
 
@@ -141,12 +148,13 @@ richacl_mode_to_mask(mode_t mode)
 struct richacl *
 richacl_chmod(struct richacl *acl, mode_t mode)
 {
+	int is_dir = S_ISDIR(mode);
 	unsigned int owner_mask, group_mask, other_mask;
 	struct richacl *clone;
 
-	owner_mask = richacl_mode_to_mask(mode >> 6);
-	group_mask = richacl_mode_to_mask(mode >> 3);
-	other_mask = richacl_mode_to_mask(mode);
+	owner_mask = richacl_mode_to_mask(mode >> 6, is_dir);
+	group_mask = richacl_mode_to_mask(mode >> 3, is_dir);
+	other_mask = richacl_mode_to_mask(mode, is_dir);
 
 	if (acl->a_owner_mask == owner_mask &&
 	    acl->a_group_mask == group_mask &&
@@ -352,7 +360,7 @@ int richacl_generic_permission(struct inode *inode, unsigned int mask)
 		mode >>= 6;
 	else if (in_group_p(inode->i_gid))
 		mode >>= 3;
-	if (!(mask & ~richacl_mode_to_mask(mode)))
+	if (!(mask & ~richacl_mode_to_mask(mode, S_ISDIR(inode->i_mode))))
 		return 0;
 	return richacl_capability_check(inode, mask);
 }
@@ -497,9 +505,9 @@ richacl_inherit(const struct richacl *dir_acl, mode_t mode)
 	const struct richace *dir_ace;
 	struct richacl *acl;
 	struct richace *ace;
-	int count = 0;
+	int count = 0, is_dir = S_ISDIR(mode);
 
-	if (S_ISDIR(mode)) {
+	if (is_dir) {
 		richacl_for_each_entry(dir_ace, dir_acl) {
 			if (!richace_is_inheritable(dir_ace))
 				continue;
@@ -555,9 +563,9 @@ richacl_inherit(const struct richacl *dir_acl, mode_t mode)
 		richacl_compute_max_masks(acl);
 
 	/* Apply the create mode. */
-	acl->a_owner_mask &= richacl_mode_to_mask(mode >> 6);
-	acl->a_group_mask &= richacl_mode_to_mask(mode >> 3);
-	acl->a_other_mask &= richacl_mode_to_mask(mode);
+	acl->a_owner_mask &= richacl_mode_to_mask(mode >> 6, is_dir);
+	acl->a_group_mask &= richacl_mode_to_mask(mode >> 3, is_dir);
+	acl->a_other_mask &= richacl_mode_to_mask(mode, is_dir);
 
 	if (richacl_write_through(&acl)) {
 		richacl_put(acl);
diff --git a/fs/richacl_posix.c b/fs/richacl_posix.c
index 3cf2124..437d3ac 100644
--- a/fs/richacl_posix.c
+++ b/fs/richacl_posix.c
@@ -20,11 +20,12 @@
 static void posix_to_richacl(struct posix_acl *pacl, int type,
 			mode_t mode, struct richacl *acl)
 {
-	int eflags;
+	int eflags, is_dir;
 	struct richace *ace;
 	unsigned short deny;
 	struct posix_acl_entry *pa, *pe, *acl_other = NULL;
 
+	is_dir = S_ISDIR(mode);
 	if (type == ACL_TYPE_DEFAULT)
 		eflags =  ACE4_FILE_INHERIT_ACE |
 			ACE4_DIRECTORY_INHERIT_ACE | ACE4_INHERIT_ONLY_ACE;
@@ -43,7 +44,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			if (deny & 0x7) {
 				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
 				ace->e_flags = eflags;
-				ace->e_mask = richacl_mode_to_mask(deny);
+				ace->e_mask = richacl_mode_to_mask(deny, is_dir);
 				richace_set_who(ace, richace_owner_who);
 				acl->a_count++;
 				ace++;
@@ -51,7 +52,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			/* Add allow entry */
 			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
 			ace->e_flags = eflags;
-			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm, is_dir);
 			ace->e_mask |= ACE4_WRITE_ATTRIBUTES | ACE4_WRITE_ACL;
 			richace_set_who(ace, richace_owner_who);
 			acl->a_count++;
@@ -65,7 +66,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			if (deny & 0x7) {
 				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
 				ace->e_flags = eflags;
-				ace->e_mask = richacl_mode_to_mask(deny);
+				ace->e_mask = richacl_mode_to_mask(deny, is_dir);
 				ace->u.e_id = pa->e_id;
 				acl->a_count++;
 				ace++;
@@ -73,7 +74,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			/* Add allow entry */
 			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
 			ace->e_flags = eflags;
-			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm, is_dir);
 			ace->u.e_id = pa->e_id;
 			acl->a_count++;
 			ace++;
@@ -88,7 +89,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			 */
 			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
 			ace->e_flags = eflags;
-			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm, is_dir);
 			richace_set_who(ace, richace_group_who);
 			acl->a_count++;
 			ace++;
@@ -100,7 +101,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			/* Add allow entries only */
 			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
 			ace->e_flags = eflags | ACE4_IDENTIFIER_GROUP;
-			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm, is_dir);
 			ace->u.e_id = pa->e_id;
 			acl->a_count++;
 			ace++;
@@ -145,7 +146,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			if (deny & 0x7) {
 				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
 				ace->e_flags = eflags;
-				ace->e_mask = richacl_mode_to_mask(deny);
+				ace->e_mask = richacl_mode_to_mask(deny, is_dir);
 				richace_set_who(ace, richace_group_who);
 				acl->a_count++;
 				ace++;
@@ -159,7 +160,7 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 			if (deny & 0x7) {
 				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
 				ace->e_flags = eflags | ACE4_IDENTIFIER_GROUP;
-				ace->e_mask = richacl_mode_to_mask(deny);
+				ace->e_mask = richacl_mode_to_mask(deny, is_dir);
 				ace->u.e_id = pa->e_id;
 				acl->a_count++;
 				ace++;
@@ -172,16 +173,16 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 	if (acl_other) {
 		ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
 		ace->e_flags = eflags;
-		ace->e_mask = richacl_mode_to_mask(acl_other->e_perm);
+		ace->e_mask = richacl_mode_to_mask(acl_other->e_perm, is_dir);
 		richace_set_who(ace, richace_everyone_who);
 		acl->a_count++;
 		ace++;
 	}
 
 	/* set acl mask values */
-	acl->a_owner_mask = richacl_mode_to_mask(mode >> 6);
-	acl->a_group_mask = richacl_mode_to_mask(mode >> 3);
-	acl->a_other_mask = richacl_mode_to_mask(mode);
+	acl->a_owner_mask = richacl_mode_to_mask(mode >> 6, is_dir);
+	acl->a_group_mask = richacl_mode_to_mask(mode >> 3, is_dir);
+	acl->a_other_mask = richacl_mode_to_mask(mode, is_dir);
 
 	/*
 	 * Mark that the acl as mapped from posix
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 41d93d8..b0df740 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -230,7 +230,7 @@ extern int richace_is_same_who(const struct richace *, const struct richace *);
 extern int richace_set_who(struct richace *ace, const char *who);
 extern struct richacl *richacl_inherit(const struct richacl *, mode_t);
 extern int richacl_masks_to_mode(const struct richacl *);
-extern unsigned int richacl_mode_to_mask(mode_t mode);
+extern unsigned int richacl_mode_to_mask(mode_t, int);
 extern struct richacl *richacl_chmod(struct richacl *, mode_t);
 extern int richacl_apply_masks(struct richacl **acl);
 extern int richacl_write_through(struct richacl **acl);
-- 
1.7.0.rc0.48.gdace5

