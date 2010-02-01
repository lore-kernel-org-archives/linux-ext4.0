From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 07/23] vfs: Add Posix acl to rich acl mapping helpers
Date: Mon,  1 Feb 2010 11:04:49 +0530
Message-ID: <1265002505-8387-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39515 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab0BAFfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:23 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add helpers that can be used by the file system to map
posix acls to rich acl format. This enables the file system to
return rich acl mapping the posix acls stored on disk when the
file system is enabled with rich acl format.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/Makefile             |    2 +-
 fs/richacl_base.c       |    2 +-
 fs/richacl_posix.c      |  223 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |    3 +
 4 files changed, 228 insertions(+), 2 deletions(-)
 create mode 100644 fs/richacl_posix.c

diff --git a/fs/Makefile b/fs/Makefile
index 0a046a1..a5f3ee3 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -53,7 +53,7 @@ obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
 obj-$(CONFIG_FS_RICHACL)	+= richacl.o
 richacl-y			:= richacl_base.o richacl_xattr.o \
-				   richacl_compat.o
+				   richacl_compat.o richacl_posix.o
 
 obj-y				+= quota/
 
diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index e75f713..a176399 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -114,7 +114,7 @@ richacl_masks_to_mode(const struct richacl *acl)
 }
 EXPORT_SYMBOL_GPL(richacl_masks_to_mode);
 
-static unsigned int
+unsigned int
 richacl_mode_to_mask(mode_t mode)
 {
 	unsigned int mask = ACE4_POSIX_ALWAYS_ALLOWED;
diff --git a/fs/richacl_posix.c b/fs/richacl_posix.c
new file mode 100644
index 0000000..07db970
--- /dev/null
+++ b/fs/richacl_posix.c
@@ -0,0 +1,223 @@
+/*
+ * Copyright IBM Corporation, 2009
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+
+#include <linux/fs.h>
+#include <linux/richacl.h>
+#include <linux/posix_acl.h>
+
+static void posix_to_richacl(struct posix_acl *pacl, int type,
+			mode_t mode, struct richacl *acl)
+{
+	int eflags;
+	struct richace *ace;
+	unsigned short deny;
+	struct posix_acl_entry *pa, *pe, *acl_other = NULL;
+
+	if (type == ACL_TYPE_DEFAULT)
+		eflags =  ACE4_FILE_INHERIT_ACE |
+			ACE4_DIRECTORY_INHERIT_ACE | ACE4_INHERIT_ONLY_ACE;
+	else
+		eflags = 0;
+
+	BUG_ON(pacl->a_count < 3);
+	/* Go to the last saved  entry */
+	ace = acl->a_entries + acl->a_count;
+	FOREACH_ACL_ENTRY(pa, pacl, pe) {
+		switch (pa->e_tag) {
+		case ACL_USER_OBJ:
+		{
+			/* Everything that is not granted we deny */
+			deny = ~pa->e_perm ;
+			if (deny & 0x7) {
+				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
+				ace->e_flags = eflags;
+				ace->e_mask = richacl_mode_to_mask(deny);
+				richace_set_who(ace, richace_owner_who);
+				acl->a_count++;
+				ace++;
+			}
+			/* Add allow entry */
+			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+			ace->e_flags = eflags;
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			ace->e_mask |= ACE4_WRITE_ATTRIBUTES | ACE4_WRITE_ACL;
+			richace_set_who(ace, richace_owner_who);
+			acl->a_count++;
+			ace++;
+			break;
+		}
+		case ACL_USER:
+		{
+			/* Everything that is not granted we deny */
+			deny = ~pa->e_perm ;
+			if (deny & 0x7) {
+				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
+				ace->e_flags = eflags;
+				ace->e_mask = richacl_mode_to_mask(deny);
+				ace->u.e_id = pa->e_id;
+				acl->a_count++;
+				ace++;
+			}
+			/* Add allow entry */
+			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+			ace->e_flags = eflags;
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			ace->u.e_id = pa->e_id;
+			acl->a_count++;
+			ace++;
+			break;
+
+		}
+		case ACL_GROUP_OBJ:
+		{
+			/*
+			 * In the case of group we apply allow first
+			 * since a person can be in different group
+			 */
+			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+			ace->e_flags = eflags;
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			richace_set_who(ace, richace_group_who);
+			acl->a_count++;
+			ace++;
+			break;
+
+		}
+		case ACL_GROUP:
+		{
+			/* Add allow entries only */
+			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+			ace->e_flags = eflags | ACE4_IDENTIFIER_GROUP;
+			ace->e_mask = richacl_mode_to_mask(pa->e_perm);
+			ace->u.e_id = pa->e_id;
+			acl->a_count++;
+			ace++;
+			break;
+
+		}
+		case ACL_MASK:
+		{
+			/*
+			 * We can ignore ACL_MASK values. We derive the
+			 * respective values from the inode mode values
+			 */
+			break;
+		}
+		case ACL_OTHER:
+		{
+			/*
+			 * We should precess ACL_OTHER only after getting all
+			 * user and group pa and then adding there respective
+			 * deny entries
+			 */
+			acl_other = pa;
+			break;
+
+		}
+		}
+	}
+	/*
+	 * Now add the deny entries for ACL_GROUP and ACL_GROUP_OBJ entries
+	 */
+	FOREACH_ACL_ENTRY(pa, pacl, pe) {
+		switch (pa->e_tag) {
+		case ACL_USER_OBJ:
+		case ACL_USER:
+		case ACL_MASK:
+		case ACL_OTHER:
+			break;
+		case ACL_GROUP_OBJ:
+		{
+			/* Everything that is not granted we deny */
+			deny = ~pa->e_perm ;
+			if (deny & 0x7) {
+				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
+				ace->e_flags = eflags;
+				ace->e_mask = richacl_mode_to_mask(deny);
+				richace_set_who(ace, richace_group_who);
+				acl->a_count++;
+				ace++;
+			}
+			break;
+		}
+		case ACL_GROUP:
+		{
+			/* Everything that is not granted we deny */
+			deny = ~pa->e_perm ;
+			if (deny & 0x7) {
+				ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
+				ace->e_flags = eflags | ACE4_IDENTIFIER_GROUP;
+				ace->e_mask = richacl_mode_to_mask(deny);
+				ace->u.e_id = pa->e_id;
+				acl->a_count++;
+				ace++;
+			}
+			break;
+		}
+		}
+	}
+	/* Now handle ACL_OTHER entry */
+	if (acl_other) {
+		ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = eflags;
+		ace->e_mask = richacl_mode_to_mask(acl_other->e_perm);
+		richace_set_who(ace, richace_everyone_who);
+		acl->a_count++;
+		ace++;
+	}
+
+	/* set acl mask values */
+	acl->a_owner_mask = richacl_mode_to_mask(mode >> 6);
+	acl->a_group_mask = richacl_mode_to_mask(mode >> 3);
+	acl->a_other_mask = richacl_mode_to_mask(mode);
+
+	return;
+}
+
+struct richacl *map_posix_to_richacl(struct inode *inode,
+				struct posix_acl *pacl,
+				struct posix_acl *dpacl)
+{
+
+	struct richacl *acl;
+	int size = 0;
+
+	if (pacl) {
+		if (posix_acl_valid(pacl) < 0)
+			return ERR_PTR(-EINVAL);
+		size += 2*pacl->a_count;
+	}
+
+	if (dpacl) {
+		if (posix_acl_valid(dpacl) < 0)
+			return ERR_PTR(-EINVAL);
+		size += 2*dpacl->a_count;
+	}
+
+	/* Allocate the worst case one deny, allow pair each */
+	acl = richacl_alloc(size);
+	if (acl == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	/* We will count actual number of entries when we map */
+	acl->a_count = 0;
+	if (pacl)
+		posix_to_richacl(pacl, ACL_TYPE_ACCESS , inode->i_mode, acl);
+
+	if (dpacl)
+		posix_to_richacl(dpacl, ACL_TYPE_DEFAULT, inode->i_mode, acl);
+
+	return acl;
+}
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index f9089dc..b08fdf1 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -228,8 +228,11 @@ extern int richace_is_same_who(const struct richace *, const struct richace *);
 extern int richace_set_who(struct richace *ace, const char *who);
 extern struct richacl *richacl_inherit(const struct richacl *, mode_t);
 extern int richacl_masks_to_mode(const struct richacl *);
+extern unsigned int richacl_mode_to_mask(mode_t mode);
 extern struct richacl *richacl_chmod(struct richacl *, mode_t);
 extern int richacl_apply_masks(struct richacl **acl);
 extern int richacl_write_through(struct richacl **acl);
+extern struct richacl *map_posix_to_richacl(struct inode *, struct posix_acl *,
+					struct posix_acl *);
 
 #endif /* __RICHACL_H */
-- 
1.7.0.rc0.48.gdace5

