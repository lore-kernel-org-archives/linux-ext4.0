From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 06/23] vfs: Implement those parts of Automatic Inheritance (AI) which are safe under POSIX
Date: Mon,  1 Feb 2010 11:04:48 +0530
Message-ID: <1265002505-8387-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

From: Andreas Gruenbacher <agruen@suse.de>

If AI is disabled for a directory (ACL4_AUTO_INHERIT
not set), nothing changes. If AI is enabled for a directory, the
create-time inheritance algorithm changes as follows:

* All inherited ACEs will have the ACE4_INHERITED_ACE flag set.

* The create mode is applied to the ACL (by setting the file masks),
which means that the ACL must no longer be subject to AI permission
propagation, and so the ACL4_PROTECTED is set.

By itelf, this is relatively useless because it will not allow
permissions to propagate, but AI aware applications can clear the
ACL4_PROTECTED flag when they know what they are doing, and this will
enable AI permission propagation.

It would be nice if AI aware applications could indicate this fact to
the kernel so that the kernel can avoid setting the ACL4_PROTECTED flag
in the first place, but there is no such user-space interface at this
point.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_base.c       |   12 ++++++++++--
 include/linux/richacl.h |   26 +++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index de99340..e75f713 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -150,7 +150,8 @@ richacl_chmod(struct richacl *acl, mode_t mode)
 
 	if (acl->a_owner_mask == owner_mask &&
 	    acl->a_group_mask == group_mask &&
-	    acl->a_other_mask == other_mask)
+	    acl->a_other_mask == other_mask &&
+	    (!richacl_is_auto_inherit(acl) || richacl_is_protected(acl)))
 		return acl;
 
 	clone = richacl_clone(acl);
@@ -161,6 +162,8 @@ richacl_chmod(struct richacl *acl, mode_t mode)
 	clone->a_owner_mask = owner_mask;
 	clone->a_group_mask = group_mask;
 	clone->a_other_mask = other_mask;
+	if (richacl_is_auto_inherit(clone))
+		clone->a_flags |= ACL4_PROTECTED;
 
 	if (richacl_write_through(&clone)) {
 		richacl_put(clone);
@@ -561,7 +564,12 @@ richacl_inherit(const struct richacl *dir_acl, mode_t mode)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	acl->a_flags = (dir_acl->a_flags & ACL4_WRITE_THROUGH);
+	acl->a_flags = (dir_acl->a_flags & ~ACL4_PROTECTED);
+	if (richacl_is_auto_inherit(acl)) {
+		richacl_for_each_entry(ace, acl)
+			ace->e_flags |= ACE4_INHERITED_ACE;
+		acl->a_flags |= ACL4_PROTECTED;
+	}
 
 	return acl;
 }
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index c56f152..f9089dc 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -33,10 +33,16 @@ struct richacl {
 	     _ace--)
 
 /* a_flags values */
+#define ACL4_AUTO_INHERIT		0x01
+#define ACL4_PROTECTED			0x02
+#define ACL4_DEFAULTED			0x04
 #define ACL4_WRITE_THROUGH		0x40
 
-#define ACL4_VALID_FLAGS \
-	ACL4_WRITE_THROUGH
+#define ACL4_VALID_FLAGS ( \
+	ACL4_AUTO_INHERIT | \
+	ACL4_PROTECTED | \
+	ACL4_DEFAULTED | \
+	ACL4_WRITE_THROUGH)
 
 /* e_type values */
 #define ACE4_ACCESS_ALLOWED_ACE_TYPE	0x0000
@@ -52,6 +58,7 @@ struct richacl {
 /*#define ACE4_SUCCESSFUL_ACCESS_ACE_FLAG	0x0010*/
 /*#define ACE4_FAILED_ACCESS_ACE_FLAG	0x0020*/
 #define ACE4_IDENTIFIER_GROUP		0x0040
+#define ACE4_INHERITED_ACE		0x0080
 /* in-memory representation only */
 #define ACE4_SPECIAL_WHO		0x4000
 
@@ -60,7 +67,8 @@ struct richacl {
 	ACE4_DIRECTORY_INHERIT_ACE | \
 	ACE4_NO_PROPAGATE_INHERIT_ACE | \
 	ACE4_INHERIT_ONLY_ACE | \
-	ACE4_IDENTIFIER_GROUP)
+	ACE4_IDENTIFIER_GROUP | \
+	ACE4_INHERITED_ACE)
 
 /* e_mask bitflags */
 #define ACE4_READ_DATA			0x00000001
@@ -137,6 +145,18 @@ extern const char richace_group_who[];
 extern const char richace_everyone_who[];
 
 static inline int
+richacl_is_auto_inherit(const struct richacl *acl)
+{
+	return acl->a_flags & ACL4_AUTO_INHERIT;
+}
+
+static inline int
+richacl_is_protected(const struct richacl *acl)
+{
+	return acl->a_flags & ACL4_PROTECTED;
+}
+
+static inline int
 richace_is_owner(const struct richace *ace)
 {
 	return (ace->e_flags & ACE4_SPECIAL_WHO) &&
-- 
1.7.0.rc0.48.gdace5

