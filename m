From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 03/23] vfs: rich ACL in-memory representation and manipulation
Date: Mon,  1 Feb 2010 11:04:45 +0530
Message-ID: <1265002505-8387-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

* In-memory representation (struct richacl).
* Functionality a filesystem needs such as permission checking,
  apply mode to acl, compute mode from acl, inheritance upon file
  create.
* Compute a mask-less acl from struct richacl that grants the same
  permissions. Protocols which don't understand the masks need
  this.
* Convert to/from xattrs.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/Kconfig                    |    4 +
 fs/Makefile                   |    4 +
 fs/richacl_base.c             |  568 +++++++++++++++++++++++++++++++
 fs/richacl_compat.c           |  757 +++++++++++++++++++++++++++++++++++++++++
 fs/richacl_xattr.c            |  146 ++++++++
 include/linux/richacl.h       |  208 +++++++++++
 include/linux/richacl_xattr.h |   32 ++
 7 files changed, 1719 insertions(+), 0 deletions(-)
 create mode 100644 fs/richacl_base.c
 create mode 100644 fs/richacl_compat.c
 create mode 100644 fs/richacl_xattr.c
 create mode 100644 include/linux/richacl.h
 create mode 100644 include/linux/richacl_xattr.h

diff --git a/fs/Kconfig b/fs/Kconfig
index 64d44ef..adbda7c 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -39,6 +39,10 @@ config FS_POSIX_ACL
 	bool
 	default n
 
+config FS_RICHACL
+	bool
+	default n
+
 source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 source "fs/ocfs2/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..0a046a1 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -51,6 +51,10 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
+obj-$(CONFIG_FS_RICHACL)	+= richacl.o
+richacl-y			:= richacl_base.o richacl_xattr.o \
+				   richacl_compat.o
+
 obj-y				+= quota/
 
 obj-$(CONFIG_PROC_FS)		+= proc/
diff --git a/fs/richacl_base.c b/fs/richacl_base.c
new file mode 100644
index 0000000..de99340
--- /dev/null
+++ b/fs/richacl_base.c
@@ -0,0 +1,568 @@
+/*
+ * Copyright (C) 2006 Andreas Gruenbacher <a.gruenbacher@computer.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/richacl.h>
+
+MODULE_LICENSE("GPL");
+
+/*
+ * ACL entries that have ACE4_SPECIAL_WHO set in ace->e_flags use the
+ * pointer values of these constants in ace->u.e_who to avoid massive
+ * amounts of string comparisons.
+ */
+
+const char richace_owner_who[]	  = "OWNER@";
+EXPORT_SYMBOL_GPL(richace_owner_who);
+const char richace_group_who[]	  = "GROUP@";
+EXPORT_SYMBOL_GPL(richace_group_who);
+const char richace_everyone_who[] = "EVERYONE@";
+EXPORT_SYMBOL_GPL(richace_everyone_who);
+
+/**
+ * richacl_alloc  -  allocate an acl
+ * @count:	number of entries
+ */
+struct richacl *
+richacl_alloc(int count)
+{
+	size_t size = sizeof(struct richacl) + count * sizeof(struct richace);
+	struct richacl *acl = kmalloc(size, GFP_KERNEL);
+
+	if (acl) {
+		memset(acl, 0, size);
+		atomic_set(&acl->a_refcount, 1);
+		acl->a_count = count;
+	}
+	return acl;
+}
+EXPORT_SYMBOL_GPL(richacl_alloc);
+
+/**
+ * richacl_clone  -  create a copy of an acl
+ */
+struct richacl *
+richacl_clone(const struct richacl *acl)
+{
+	int count = acl->a_count;
+	size_t size = sizeof(struct richacl) + count * sizeof(struct richace);
+	struct richacl *dup = kmalloc(size, GFP_KERNEL);
+
+	if (dup) {
+		memcpy(dup, acl, size);
+		atomic_set(&dup->a_refcount, 1);
+	}
+	return dup;
+}
+
+/*
+ * The POSIX permissions are supersets of the below mask flags.
+ *
+ * The ACE4_READ_ATTRIBUTES and ACE4_READ_ACL flags are always granted
+ * in POSIX. The ACE4_SYNCHRONIZE flag has no meaning under POSIX. We
+ * make sure that we do not mask them if they are set, so that users who
+ * rely on these flags won't get confused.
+ */
+#define ACE4_POSIX_MODE_READ ( \
+	ACE4_READ_DATA | ACE4_LIST_DIRECTORY)
+#define ACE4_POSIX_MODE_WRITE ( \
+	ACE4_WRITE_DATA | ACE4_ADD_FILE | \
+	ACE4_APPEND_DATA | ACE4_ADD_SUBDIRECTORY | \
+	ACE4_DELETE_CHILD)
+#define ACE4_POSIX_MODE_EXEC ( \
+	ACE4_EXECUTE)
+
+static int
+richacl_mask_to_mode(unsigned int mask)
+{
+	int mode = 0;
+
+	if (mask & ACE4_POSIX_MODE_READ)
+		mode |= MAY_READ;
+	if (mask & ACE4_POSIX_MODE_WRITE)
+		mode |= MAY_WRITE;
+	if (mask & ACE4_POSIX_MODE_EXEC)
+		mode |= MAY_EXEC;
+
+	return mode;
+}
+
+/**
+ * richacl_masks_to_mode  -  compute file mode permission bits from file masks
+ *
+ * Compute the file mode permission bits from the file masks in the acl.
+ */
+int
+richacl_masks_to_mode(const struct richacl *acl)
+{
+	return richacl_mask_to_mode(acl->a_owner_mask) << 6 |
+	       richacl_mask_to_mode(acl->a_group_mask) << 3 |
+	       richacl_mask_to_mode(acl->a_other_mask);
+}
+EXPORT_SYMBOL_GPL(richacl_masks_to_mode);
+
+static unsigned int
+richacl_mode_to_mask(mode_t mode)
+{
+	unsigned int mask = ACE4_POSIX_ALWAYS_ALLOWED;
+
+	if (mode & MAY_READ)
+		mask |= ACE4_POSIX_MODE_READ;
+	if (mode & MAY_WRITE)
+		mask |= ACE4_POSIX_MODE_WRITE;
+	if (mode & MAY_EXEC)
+		mask |= ACE4_POSIX_MODE_EXEC;
+
+	return mask;
+}
+
+/**
+ * richacl_chmod  -  update the file masks to reflect the new mode
+ * @mode:	file mode permission bits to apply to the @acl
+ *
+ * Converts the mask flags corresponding to the owner, group, and other file
+ * permissions and computes the file masks. Returns @acl if it already has the
+ * appropriate file masks, or updates the flags in a copy of @acl. Takes over
+ * @acl.
+ */
+struct richacl *
+richacl_chmod(struct richacl *acl, mode_t mode)
+{
+	unsigned int owner_mask, group_mask, other_mask;
+	struct richacl *clone;
+
+	owner_mask = richacl_mode_to_mask(mode >> 6);
+	group_mask = richacl_mode_to_mask(mode >> 3);
+	other_mask = richacl_mode_to_mask(mode);
+
+	if (acl->a_owner_mask == owner_mask &&
+	    acl->a_group_mask == group_mask &&
+	    acl->a_other_mask == other_mask)
+		return acl;
+
+	clone = richacl_clone(acl);
+	richacl_put(acl);
+	if (!clone)
+		return ERR_PTR(-ENOMEM);
+
+	clone->a_owner_mask = owner_mask;
+	clone->a_group_mask = group_mask;
+	clone->a_other_mask = other_mask;
+
+	if (richacl_write_through(&clone)) {
+		richacl_put(clone);
+		clone = ERR_PTR(-ENOMEM);
+	}
+	return clone;
+}
+EXPORT_SYMBOL_GPL(richacl_chmod);
+
+/**
+ * richacl_want_to_mask  - convert permission want argument to a mask
+ * @want:	@want argument of the permission inode operation
+ *
+ * When checking for append, @want is (MAY_WRITE | MAY_APPEND).
+ */
+unsigned int
+richacl_want_to_mask(int want)
+{
+	unsigned int mask = 0;
+
+	if (want & MAY_READ)
+		mask |= ACE4_READ_DATA;
+	if (want & MAY_APPEND)
+		mask |= ACE4_APPEND_DATA;
+	else if (want & MAY_WRITE)
+		mask |= ACE4_WRITE_DATA;
+	if (want & MAY_EXEC)
+		mask |= ACE4_EXECUTE;
+
+	return mask;
+}
+EXPORT_SYMBOL_GPL(richacl_want_to_mask);
+
+/**
+ * richacl_capability_check -check for capabilities overriding read/write access
+ * @inode:	inode to check
+ * @mask:	requested access (ACE4_* bitmask)
+ *
+ * Capabilities other than CAP_DAC_OVERRIDE and CAP_DAC_READ_SEARCH
+ * must be checked separately.
+ */
+static inline int richacl_capability_check(struct inode *inode,
+					unsigned int mask)
+{
+	/*
+	 * Read/write DACs are always overridable.
+	 * Executable DACs are overridable if at least one exec bit is set.
+	 */
+	if (!(mask & (ACE4_WRITE_ACL | ACE4_WRITE_OWNER)) &&
+	    (!(mask & ACE4_EXECUTE) ||
+	    (inode->i_mode & S_IXUGO) || S_ISDIR(inode->i_mode)))
+		if (capable(CAP_DAC_OVERRIDE))
+			return 0;
+
+	/*
+	 * Searching includes executable on directories, else just read.
+	 */
+	if (!(mask & ~(ACE4_READ_DATA | ACE4_EXECUTE)) &&
+	    (S_ISDIR(inode->i_mode) || !(mask & ACE4_EXECUTE)))
+		if (capable(CAP_DAC_READ_SEARCH))
+			return 0;
+
+	return -EACCES;
+}
+
+/**
+ * richacl_permission  -  permission check algorithm with masking
+ * @inode:	inode to check
+ * @acl:	rich acl of the inode
+ * @mask:	requested access (ACE4_* bitmask)
+ *
+ * Checks if the current process is granted @mask flags in @acl. With
+ * write-through, the OWNER@ is always granted the owner file mask, the
+ * GROUP@ is always granted the group file mask, and EVERYONE@ is always
+ * granted the other file mask. Otherwise, processes are only granted
+ * @mask flags which they are granted in the @acl as well as in their
+ * file mask.
+ */
+int richacl_permission(struct inode *inode, const struct richacl *acl,
+		       unsigned int mask)
+{
+	const struct richace *ace;
+	unsigned int file_mask, requested = mask, denied = 0;
+	int in_owning_group = in_group_p(inode->i_gid);
+	int owner_or_group_class = in_owning_group;
+
+	/*
+	 * A process is in the
+	 *   - owner file class if it owns the file, in the
+	 *   - group file class if it is in the file's owning group or
+	 *     it matches any of the user or group entries, and in the
+	 *   - other file class otherwise.
+	 */
+
+	richacl_for_each_entry(ace, acl) {
+		unsigned int ace_mask = ace->e_mask;
+
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_owner(ace)) {
+			if (current_fsuid() != inode->i_uid)
+				continue;
+			goto is_owner;
+		} else if (richace_is_group(ace)) {
+			if (!in_owning_group)
+				continue;
+		} else if (richace_is_unix_id(ace)) {
+			if (ace->e_flags & ACE4_IDENTIFIER_GROUP) {
+				if (!in_group_p(ace->u.e_id))
+					continue;
+			} else {
+				if (current_fsuid() != ace->u.e_id)
+					continue;
+			}
+		} else
+			goto is_everyone;
+
+		/*
+		 * Apply the group file mask to entries other than OWNER@ and
+		 * EVERYONE@. This is not required for correct access checking
+		 * but ensures that we grant the same permissions as the acl
+		 * computed by richacl_apply_masks().
+		 *
+		 * For example, without this restriction, 'group@:rw::allow'
+		 * with mode 0600 would grant rw access to owner processes
+		 * which are also in the owning group. This cannot be expressed
+		 * in an acl.
+		 */
+		if (richace_is_allow(ace))
+			ace_mask &= acl->a_group_mask;
+
+is_owner:
+		/* The process is in the owner or group file class. */
+		owner_or_group_class = 1;
+
+is_everyone:
+		/* Check which mask flags the ACE allows or denies. */
+		if (richace_is_deny(ace))
+			denied |= ace_mask & mask;
+		mask &= ~ace_mask;
+
+		/*
+		 * Keep going until we know which file class
+		 * the process is in.
+		 */
+		if (!mask && owner_or_group_class)
+			break;
+	}
+	denied |= mask;
+
+	/*
+	 * Figure out which file mask applies.
+	 * Clear write-through if the process is in the file group class but
+	 * not in the owning group, and so the denied permissions apply.
+	 */
+	if (current_fsuid() == inode->i_uid)
+		file_mask = acl->a_owner_mask;
+	else if (in_owning_group || owner_or_group_class)
+		file_mask = acl->a_group_mask;
+	else
+		file_mask = acl->a_other_mask;
+
+	denied |= requested & ~file_mask;
+	if (!denied)
+		return 0;
+	return richacl_capability_check(inode, requested);
+}
+EXPORT_SYMBOL_GPL(richacl_permission);
+
+/**
+ * richacl_generic_permission  -  permission check algorithm without explicit acl
+ * @inode:	inode to check permissions for
+ * @mask:	requested access (ACE4_* bitmask)
+ *
+ * The file mode of a file without ACL corresponds to an ACL with a single
+ * "EVERYONE:~0::ALLOW" entry, with file masks that correspond to the file mode
+ * permissions. Instead of constructing a temporary ACL and applying
+ * richacl_permission() to it, compute the identical result directly from
+ * the file mode.
+ */
+int richacl_generic_permission(struct inode *inode, unsigned int mask)
+{
+	int mode = inode->i_mode;
+
+	if (current_fsuid() == inode->i_uid)
+		mode >>= 6;
+	else if (in_group_p(inode->i_gid))
+		mode >>= 3;
+	if (!(mask & ~richacl_mode_to_mask(mode)))
+		return 0;
+	return richacl_capability_check(inode, mask);
+}
+EXPORT_SYMBOL_GPL(richacl_generic_permission);
+
+/*
+ * richace_is_same_who  -  do both acl entries refer to the same identifier?
+ */
+int
+richace_is_same_who(const struct richace *a, const struct richace *b)
+{
+#define WHO_FLAGS (ACE4_SPECIAL_WHO | ACE4_IDENTIFIER_GROUP)
+	if ((a->e_flags & WHO_FLAGS) != (b->e_flags & WHO_FLAGS))
+		return 0;
+	if (a->e_flags & ACE4_SPECIAL_WHO)
+		return a->u.e_who == b->u.e_who;
+	else
+		return a->u.e_id == b->u.e_id;
+#undef WHO_FLAGS
+}
+
+/**
+ * richacl_set_who  -  set a special who value
+ * @ace:	acl entry
+ * @who:	who value to use
+ */
+int
+richace_set_who(struct richace *ace, const char *who)
+{
+	if (!strcmp(who, richace_owner_who))
+		who = richace_owner_who;
+	else if (!strcmp(who, richace_group_who))
+		who = richace_group_who;
+	else if (!strcmp(who, richace_everyone_who))
+		who = richace_everyone_who;
+	else
+		return -EINVAL;
+
+	ace->u.e_who = who;
+	ace->e_flags |= ACE4_SPECIAL_WHO;
+	ace->e_flags &= ~ACE4_IDENTIFIER_GROUP;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(richace_set_who);
+
+/**
+ * richacl_allowed_to_who  -  mask flags allowed to a specific who value
+ *
+ * Computes the mask values allowed to a specific who value, taking
+ * EVERYONE@ entries into account.
+ */
+static unsigned int
+richacl_allowed_to_who(struct richacl *acl, struct richace *who)
+{
+	struct richace *ace;
+	unsigned int allowed = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_same_who(ace, who) ||
+		    richace_is_everyone(ace)) {
+			if (richace_is_allow(ace))
+				allowed |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				allowed &= ~ace->e_mask;
+		}
+	}
+	return allowed;
+}
+
+/**
+ * richacl_compute_max_masks  -  compute upper bound masks
+ *
+ * Computes upper bound owner, group, and other masks so that none of
+ * the mask flags allowed by the acl are disabled (for any choice of the
+ * file owner or group membership).
+ */
+static void
+richacl_compute_max_masks(struct richacl *acl)
+{
+	struct richace *ace;
+
+	acl->a_owner_mask = 0;
+	acl->a_group_mask = 0;
+	acl->a_other_mask = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+
+		if (richace_is_owner(ace)) {
+			if (richace_is_allow(ace))
+				acl->a_owner_mask |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				acl->a_owner_mask &= ~ace->e_mask;
+		} else if (richace_is_everyone(ace)) {
+			if (richace_is_allow(ace)) {
+				struct richace who = {
+					.e_flags = ACE4_SPECIAL_WHO,
+					.u.e_who = richace_group_who,
+				};
+
+				acl->a_other_mask |= ace->e_mask;
+				acl->a_group_mask |=
+					richacl_allowed_to_who(acl, &who);
+				acl->a_owner_mask |= ace->e_mask;
+			} else if (richace_is_deny(ace)) {
+				acl->a_other_mask &= ~ace->e_mask;
+				acl->a_group_mask &= ~ace->e_mask;
+				acl->a_owner_mask &= ~ace->e_mask;
+			}
+		} else {
+			if (richace_is_allow(ace)) {
+				unsigned int mask =
+					richacl_allowed_to_who(acl, ace);
+
+				acl->a_group_mask |= mask;
+				acl->a_owner_mask |= mask;
+			}
+		}
+	}
+}
+
+/**
+ * richacl_inherit  -  compute the acl a new file will inherit
+ * @dir_acl:	acl of the containing direcory
+ * @mode:	file type and create mode of the new file
+ *
+ * Given the containing directory's acl, this function will compute the
+ * acl that new files in that directory will inherit, or %NULL if
+ * @dir_acl does not contain acl entries inheritable by this file.
+ *
+ * Without write-through, the file masks in the returned acl are set to
+ * the intersection of the create mode and the maximum permissions
+ * allowed to each file class. With write-through, the file masks are
+ * set to the create mode.
+ */
+struct richacl *
+richacl_inherit(const struct richacl *dir_acl, mode_t mode)
+{
+	const struct richace *dir_ace;
+	struct richacl *acl;
+	struct richace *ace;
+	int count = 0;
+
+	if (S_ISDIR(mode)) {
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!richace_is_inheritable(dir_ace))
+				continue;
+			count++;
+		}
+		if (!count)
+			return NULL;
+		acl = richacl_alloc(count);
+		if (!acl)
+			return ERR_PTR(-ENOMEM);
+		ace = acl->a_entries;
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!richace_is_inheritable(dir_ace))
+				continue;
+			memcpy(ace, dir_ace, sizeof(struct richace));
+			if (dir_ace->e_flags & ACE4_NO_PROPAGATE_INHERIT_ACE)
+				richace_clear_inheritance_flags(ace);
+			if ((dir_ace->e_flags & ACE4_FILE_INHERIT_ACE) &&
+			    !(dir_ace->e_flags & ACE4_DIRECTORY_INHERIT_ACE))
+				ace->e_flags |= ACE4_INHERIT_ONLY_ACE;
+			ace++;
+		}
+	} else {
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!(dir_ace->e_flags & ACE4_FILE_INHERIT_ACE))
+				continue;
+			count++;
+		}
+		if (!count)
+			return NULL;
+		acl = richacl_alloc(count);
+		if (!acl)
+			return ERR_PTR(-ENOMEM);
+		ace = acl->a_entries;
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!(dir_ace->e_flags & ACE4_FILE_INHERIT_ACE))
+				continue;
+			memcpy(ace, dir_ace, sizeof(struct richace));
+			richace_clear_inheritance_flags(ace);
+			ace++;
+		}
+	}
+
+	/* The maximum max flags that the owner, group, and other classes
+	   are allowed. */
+	if (dir_acl->a_flags & ACL4_WRITE_THROUGH) {
+		acl->a_owner_mask = ACE4_VALID_MASK;
+		acl->a_group_mask = ACE4_VALID_MASK;
+		acl->a_other_mask = ACE4_VALID_MASK;
+
+		mode &= ~current_umask();
+	} else
+		richacl_compute_max_masks(acl);
+
+	/* Apply the create mode. */
+	acl->a_owner_mask &= richacl_mode_to_mask(mode >> 6);
+	acl->a_group_mask &= richacl_mode_to_mask(mode >> 3);
+	acl->a_other_mask &= richacl_mode_to_mask(mode);
+
+	if (richacl_write_through(&acl)) {
+		richacl_put(acl);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	acl->a_flags = (dir_acl->a_flags & ACL4_WRITE_THROUGH);
+
+	return acl;
+}
+EXPORT_SYMBOL_GPL(richacl_inherit);
diff --git a/fs/richacl_compat.c b/fs/richacl_compat.c
new file mode 100644
index 0000000..a985bbf
--- /dev/null
+++ b/fs/richacl_compat.c
@@ -0,0 +1,757 @@
+/*
+ * Copyright (C) 2006 Andreas Gruenbacher <a.gruenbacher@computer.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/richacl.h>
+
+/**
+ * struct richacl_alloc  -  remember how many entries are actually allocated
+ * @acl:	acl with a_count <= @count
+ * @count:	the actual number of entries allocated in @acl
+ *
+ * We pass around this structure while modifying an acl, so that we do
+ * not have to reallocate when we remove existing entries followed by
+ * adding new entries.
+ */
+struct richacl_alloc {
+	struct richacl *acl;
+	unsigned int count;
+};
+
+/**
+ * richacl_delete_entry  -  delete an entry in an acl
+ * @x:		acl and number of allocated entries
+ * @ace:	an entry in @x->acl
+ *
+ * Updates @ace so that it points to the entry before the deleted entry
+ * on return. (When deleting the first entry, @ace will point to the
+ * (non-existant) entry before the first entry). This behavior is the
+ * expected behavior when deleting entries while forward iterating over
+ * an acl.
+ */
+static void
+richacl_delete_entry(struct richacl_alloc *x, struct richace **ace)
+{
+	void *end = x->acl->a_entries + x->acl->a_count;
+
+	memmove(*ace, *ace + 1, end - (void *)(*ace + 1));
+	(*ace)--;
+	x->acl->a_count--;
+}
+
+/**
+ * richacl_insert_entry  -  insert an entry in an acl
+ * @x:		acl and number of allocated entries
+ * @ace:	entry before which the new entry shall be inserted
+ *
+ * Insert a new entry in @x->acl at position @ace, and zero-initialize
+ * it.  This may require reallocating @x->acl.
+ */
+static int
+richacl_insert_entry(struct richacl_alloc *x, struct richace **ace)
+{
+	if (x->count == x->acl->a_count) {
+		int n = *ace - x->acl->a_entries;
+		struct richacl *acl2;
+
+		acl2 = richacl_alloc(x->acl->a_count + 1);
+		if (!acl2)
+			return -1;
+		acl2->a_flags = x->acl->a_flags;
+		acl2->a_owner_mask = x->acl->a_owner_mask;
+		acl2->a_group_mask = x->acl->a_group_mask;
+		acl2->a_other_mask = x->acl->a_other_mask;
+		memcpy(acl2->a_entries, x->acl->a_entries,
+		       n * sizeof(struct richace));
+		memcpy(acl2->a_entries + n + 1, *ace,
+		       (x->acl->a_count - n) * sizeof(struct richace));
+		kfree(x->acl);
+		x->acl = acl2;
+		x->count = acl2->a_count;
+		*ace = acl2->a_entries + n;
+	} else {
+		void *end = x->acl->a_entries + x->acl->a_count;
+
+		memmove(*ace + 1, *ace, end - (void *)*ace);
+		x->acl->a_count++;
+	}
+	memset(*ace, 0, sizeof(struct richace));
+	return 0;
+}
+
+/**
+ * richace_change_mask  -  change the mask in @ace to @mask
+ * @x:		acl and number of allocated entries
+ * @ace:	entry to modify
+ * @mask:	new mask for @ace
+ *
+ * Set the effective mask of @ace to @mask. This will require splitting
+ * off a separate acl entry if @ace is inheritable. In that case, the
+ * effective- only acl entry is inserted after the inheritable acl
+ * entry, end the inheritable acl entry is set to inheritable-only. If
+ * @mode is 0, either set the original acl entry to inheritable-only if
+ * it was inheritable, or remove it otherwise.  The returned @ace points
+ * to the modified or inserted effective-only acl entry if that entry
+ * exists, to the entry that has become inheritable-only, or else to the
+ * previous entry in the acl. This is the expected behavior when
+ * modifying masks while forward iterating over an acl.
+ */
+static int
+richace_change_mask(struct richacl_alloc *x, struct richace **ace,
+			   unsigned int mask)
+{
+	if (mask && (*ace)->e_mask == mask)
+		return 0;
+	if (mask & ~ACE4_POSIX_ALWAYS_ALLOWED) {
+		if (richace_is_inheritable(*ace)) {
+			if (richacl_insert_entry(x, ace))
+				return -1;
+			memcpy(*ace, *ace + 1, sizeof(struct richace));
+			(*ace)->e_flags |= ACE4_INHERIT_ONLY_ACE;
+			(*ace)++;
+			richace_clear_inheritance_flags(*ace);
+		}
+		(*ace)->e_mask = mask;
+	} else {
+		if (richace_is_inheritable(*ace))
+			(*ace)->e_flags |= ACE4_INHERIT_ONLY_ACE;
+		else
+			richacl_delete_entry(x, ace);
+	}
+	return 0;
+}
+
+/**
+ * richacl_move_everyone_aces_down  -  move everyone@ acl entries to the end
+ * @x:		acl and number of allocated entries
+ *
+ * Move all everyone acl entries to the bottom of the acl so that only a
+ * single everyone@ allow acl entry remains at the end, and update the
+ * mask fields of all acl entries on the way. If everyone@ is not
+ * granted any permissions, no empty everyone@ acl entry is inserted.
+ *
+ * This transformation does not modify the permissions that the acl
+ * grants, but we need it to simplify successive transformations.
+ */
+static int
+richacl_move_everyone_aces_down(struct richacl_alloc *x)
+{
+	struct richace *ace;
+	unsigned int allowed = 0, denied = 0;
+
+	richacl_for_each_entry(ace, x->acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_everyone(ace)) {
+			if (richace_is_allow(ace))
+				allowed |= (ace->e_mask & ~denied);
+			else if (richace_is_deny(ace))
+				denied |= (ace->e_mask & ~allowed);
+			else
+				continue;
+			if (richace_change_mask(x, &ace, 0))
+				return -1;
+		} else {
+			if (richace_is_allow(ace)) {
+				if (richace_change_mask(x, &ace, allowed |
+						(ace->e_mask & ~denied)))
+					return -1;
+			} else if (richace_is_deny(ace)) {
+				if (richace_change_mask(x, &ace, denied |
+						(ace->e_mask & ~allowed)))
+					return -1;
+			}
+		}
+	}
+	if (allowed & ~ACE4_POSIX_ALWAYS_ALLOWED) {
+		struct richace *last_ace = ace - 1;
+
+		if (richace_is_everyone(last_ace) &&
+		    richace_is_allow(last_ace) &&
+		    richace_is_inherit_only(last_ace) &&
+		    last_ace->e_mask == allowed)
+			last_ace->e_flags &= ~ACE4_INHERIT_ONLY_ACE;
+		else {
+			if (richacl_insert_entry(x, &ace))
+				return -1;
+			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+			ace->e_flags = ACE4_SPECIAL_WHO;
+			ace->e_mask = allowed;
+			ace->u.e_who = richace_everyone_who;
+		}
+	}
+	return 0;
+}
+
+/**
+ * __richacl_propagate_everyone  -  propagate everyone@ mask flags up for @who
+ * @x:		acl and number of allocated entries
+ * @who:	identifier to propagate mask flags for
+ * @allow:	mask flags to propagate up
+ *
+ * Propagate mask flags from the trailing everyone@ allow acl entry up
+ * for the specified @who.
+ *
+ * The idea here is to precede the trailing EVERYONE@ ALLOW entry by an
+ * additional @who ALLOW entry, but with the following optimizations:
+ * (1) we don't bother setting any flags in the new @who ALLOW entry
+ * that has already been allowed or denied by a previous @who entry, (2)
+ * we merge the new @who entry with a previous @who entry if there is
+ * such a previous @who entry and there are no intervening DENY entries
+ * with mask flags that overlap the flags we care about.
+ */
+static int
+__richacl_propagate_everyone(struct richacl_alloc *x, struct richace *who,
+			  unsigned int allow)
+{
+	struct richace *allow_last = NULL, *ace;
+
+	/* Remove the mask flags from allow that are already determined for
+	   this who value, and figure out if there is an ALLOW entry for
+	   this who value that is "reachable" from the trailing EVERYONE@
+	   ALLOW ACE. */
+	richacl_for_each_entry(ace, x->acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_allow(ace)) {
+			if (richace_is_same_who(ace, who)) {
+				allow &= ~ace->e_mask;
+				allow_last = ace;
+			}
+		} else if (richace_is_deny(ace)) {
+			if (richace_is_same_who(ace, who))
+				allow &= ~ace->e_mask;
+			if (allow & ace->e_mask)
+				allow_last = NULL;
+		}
+	}
+
+	if (allow) {
+		if (allow_last)
+			return richace_change_mask(x, &allow_last,
+						   allow_last->e_mask | allow);
+		else {
+			struct richace who_copy;
+
+			ace = x->acl->a_entries + x->acl->a_count - 1;
+			memcpy(&who_copy, who, sizeof(struct richace));
+			if (richacl_insert_entry(x, &ace))
+				return -1;
+			memcpy(ace, &who_copy, sizeof(struct richace));
+			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+			richace_clear_inheritance_flags(ace);
+			ace->e_mask = allow;
+		}
+	}
+	return 0;
+}
+
+/**
+ * richacl_propagate_everyone  -  propagate everyone@ mask flags up the acl
+ * @x:		acl and number of allocated entries
+ *
+ * Make sure for owner@, group@, and all other users, groups, and
+ * special identifiers that they are allowed or denied all permissions
+ * that are granted be the trailing everyone@ acl entry. If they are
+ * not, try to add the missing permissions to existing allow acl entries
+ * for those users, or introduce additional acl entries if that is not
+ * possible.
+ *
+ * We do this so that no mask flags will get lost when finally applying
+ * the file masks to the acl entries: otherwise, with an other file mask
+ * that is more restrictive than the owner and/or group file mask, mask
+ * flags that were allowed to processes in the owner and group classes
+ * and that the other mask denies would be lost. For example, the
+ * following two acls show the problem when mode 0664 is applied to
+ * them:
+ *
+ *    masking without propagation (wrong)
+ *    ===========================================================
+ *    joe:r::allow		=> joe:r::allow
+ *    everyone@:rwx::allow	=> everyone@:r::allow
+ *    -----------------------------------------------------------
+ *    joe:w::deny		=> joe:w::deny
+ *    everyone@:rwx::allow	   everyone@:r::allow
+ *
+ * Note that the permissions of joe end up being more restrictive than
+ * what the acl would allow when first computing the allowed flags and
+ * then applying the respective mask. With propagation of permissions,
+ * we get:
+ *
+ *    masking after propagation (correct)
+ *    ===========================================================
+ *    joe:r::allow		=> joe:rw::allow
+ *				   owner@:rw::allow
+ *				   group@:rw::allow
+ *    everyone@:rwx::allow	   everyone@:r::allow
+ *    -----------------------------------------------------------
+ *    joe:w::deny		=> owner@:x::deny
+ *				   joe:w::deny
+ *				   owner@:rw::allow
+ *				   owner@:rw::allow
+ *				   joe:r::allow
+ *    everyone@:rwx::allow	   everyone@:r::allow
+ *
+ * The examples show the acls that would result from propagation with no
+ * masking performed. In fact, we do apply the respective mask to the
+ * acl entries before computing the propagation because this will save
+ * us from adding acl entries that would end up with empty mask fields
+ * after applying the masks.
+ *
+ * It is ensured that no more than one entry will be inserted for each
+ * who value, no matter how many entries each who value has already.
+ */
+static int
+richacl_propagate_everyone(struct richacl_alloc *x)
+{
+	int write_through = (x->acl->a_flags & ACL4_WRITE_THROUGH);
+	struct richace who = { .e_flags = ACE4_SPECIAL_WHO };
+	struct richace *ace;
+	unsigned int owner_allow, group_allow;
+	int retval;
+
+	if (!((x->acl->a_owner_mask | x->acl->a_group_mask) &
+	      ~x->acl->a_other_mask))
+		return 0;
+	if (!x->acl->a_count)
+		return 0;
+	ace = x->acl->a_entries + x->acl->a_count - 1;
+	if (richace_is_inherit_only(ace) || !richace_is_everyone(ace))
+		return 0;
+	if (!(ace->e_mask & ~x->acl->a_other_mask)) {
+		/* None of the allowed permissions will get masked. */
+		return 0;
+	}
+	owner_allow = ace->e_mask & x->acl->a_owner_mask;
+	group_allow = ace->e_mask & x->acl->a_group_mask;
+
+	/* Propagate everyone@ permissions through to owner@. */
+	if (owner_allow && !write_through &&
+	    (x->acl->a_owner_mask & ~x->acl->a_other_mask)) {
+		who.u.e_who = richace_owner_who;
+		retval = __richacl_propagate_everyone(x, &who, owner_allow);
+		if (retval)
+			return -1;
+	}
+
+	if (group_allow && (x->acl->a_group_mask & ~x->acl->a_other_mask)) {
+		int n;
+
+		if (!write_through) {
+			/* Propagate everyone@ permissions through to group@. */
+			who.u.e_who = richace_group_who;
+			retval = __richacl_propagate_everyone(x, &who,
+							      group_allow);
+			if (retval)
+				return -1;
+		}
+
+		/* Start from the entry before the trailing EVERYONE@ ALLOW
+		   entry. We will not hit EVERYONE@ entries in the loop. */
+		for (n = x->acl->a_count - 2; n != -1; n--) {
+			ace = x->acl->a_entries + n;
+
+			if (richace_is_inherit_only(ace) ||
+			    richace_is_owner(ace) ||
+			    richace_is_group(ace))
+				continue;
+			if (richace_is_allow(ace) || richace_is_deny(ace)) {
+				/* Any inserted entry will end up below the
+				   current entry. */
+				retval = __richacl_propagate_everyone(x, ace,
+								   group_allow);
+				if (retval)
+					return -1;
+			}
+		}
+	}
+	return 0;
+}
+
+/**
+ * __richacl_apply_masks  -  apply the masks to the acl entries
+ * @x:		acl and number of allocated entries
+ *
+ * Apply the owner file mask to owner@ entries, the intersection of the
+ * group and other file masks to everyone@ entries, and the group file
+ * mask to all other entries.
+ */
+static int
+__richacl_apply_masks(struct richacl_alloc *x)
+{
+	struct richace *ace;
+
+	richacl_for_each_entry(ace, x->acl) {
+		unsigned int mask;
+
+		if (richace_is_inherit_only(ace) || !richace_is_allow(ace))
+			continue;
+		if (richace_is_owner(ace))
+			mask = x->acl->a_owner_mask;
+		else if (richace_is_everyone(ace))
+			mask = x->acl->a_other_mask;
+		else
+			mask = x->acl->a_group_mask;
+		if (richace_change_mask(x, &ace, ace->e_mask & mask))
+			return -1;
+	}
+	return 0;
+}
+
+/**
+ * richacl_max_allowed  -  maximum mask flags that anybody is allowed
+ */
+static unsigned int
+richacl_max_allowed(struct richacl *acl)
+{
+	struct richace *ace;
+	unsigned int allowed = 0;
+
+	richacl_for_each_entry_reverse(ace, acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_allow(ace))
+			allowed |= ace->e_mask;
+		else if (richace_is_deny(ace)) {
+			if (richace_is_everyone(ace))
+				allowed &= ~ace->e_mask;
+		}
+	}
+	return allowed;
+}
+
+/**
+ * richacl_isolate_owner_class  -  limit the owner class to the owner file mask
+ * @x:		acl and number of allocated entries
+ *
+ * Make sure the owner class (owner@) is granted no more than the owner
+ * mask by first checking which permissions anyone is granted, and then
+ * denying owner@ all permissions beyond that.
+ */
+static int
+richacl_isolate_owner_class(struct richacl_alloc *x)
+{
+	struct richace *ace;
+	unsigned int allowed = 0;
+
+	allowed = richacl_max_allowed(x->acl);
+	if (allowed & ~x->acl->a_owner_mask) {
+		/* Figure out if we can update an existig OWNER@ DENY entry. */
+		richacl_for_each_entry(ace, x->acl) {
+			if (richace_is_inherit_only(ace))
+				continue;
+			if (richace_is_deny(ace)) {
+				if (richace_is_owner(ace))
+					break;
+			} else if (richace_is_allow(ace)) {
+				ace = x->acl->a_entries + x->acl->a_count;
+				break;
+			}
+		}
+		if (ace != x->acl->a_entries + x->acl->a_count) {
+			if (richace_change_mask(x, &ace, ace->e_mask |
+					(allowed & ~x->acl->a_owner_mask)))
+				return -1;
+		} else {
+			/* Insert an owner@ deny entry at the front. */
+			ace = x->acl->a_entries;
+			if (richacl_insert_entry(x, &ace))
+				return -1;
+			ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
+			ace->e_flags = ACE4_SPECIAL_WHO;
+			ace->e_mask = allowed & ~x->acl->a_owner_mask;
+			ace->u.e_who = richace_owner_who;
+		}
+	}
+	return 0;
+}
+
+/**
+ * __richacl_isolate_who  -  isolate entry from EVERYONE@ ALLOW entry
+ * @x:		acl and number of allocated entries
+ * @who:	identifier to isolate
+ * @deny:	mask flags this identifier should not be allowed
+ *
+ * Make sure that @who is not allowed any mask flags in @deny by checking
+ * which mask flags this identifier is allowed, and adding excess allowed
+ * mask flags to an existing DENY entry before the trailing EVERYONE@ ALLOW
+ * entry, or inserting such an entry.
+ */
+static int
+__richacl_isolate_who(struct richacl_alloc *x, struct richace *who,
+		      unsigned int deny)
+{
+	struct richace *ace;
+	unsigned int allowed = 0, n;
+
+	/* Compute the mask flags granted to this who value. */
+	richacl_for_each_entry_reverse(ace, x->acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_same_who(ace, who)) {
+			if (richace_is_allow(ace))
+				allowed |= ace->e_mask;
+			else if (richace_is_deny(ace))
+				allowed &= ~ace->e_mask;
+			deny &= ~ace->e_mask;
+		}
+	}
+	if (!deny)
+		return 0;
+
+	/* Figure out if we can update an existig DENY entry.  Start
+	   from the entry before the trailing EVERYONE@ ALLOW entry. We
+	   will not hit EVERYONE@ entries in the loop. */
+	for (n = x->acl->a_count - 2; n != -1; n--) {
+		ace = x->acl->a_entries + n;
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_deny(ace)) {
+			if (richace_is_same_who(ace, who))
+				break;
+		} else if (richace_is_allow(ace) &&
+			   (ace->e_mask & deny)) {
+			n = -1;
+			break;
+		}
+	}
+	if (n != -1) {
+		if (richace_change_mask(x, &ace, ace->e_mask | deny))
+			return -1;
+	} else {
+		/* Insert a eny entry before the trailing EVERYONE@ DENY
+		   entry. */
+		struct richace who_copy;
+
+		ace = x->acl->a_entries + x->acl->a_count - 1;
+		memcpy(&who_copy, who, sizeof(struct richace));
+		if (richacl_insert_entry(x, &ace))
+			return -1;
+		memcpy(ace, &who_copy, sizeof(struct richace));
+		ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
+		richace_clear_inheritance_flags(ace);
+		ace->e_mask = deny;
+	}
+	return 0;
+}
+
+/**
+ * richacl_isolate_group_class  -  limit the group class to the group file mask
+ * @x:		acl and number of allocated entries
+ *
+ * Make sure the group class (all entries except owner@ and everyone@) is
+ * granted no more than the group mask by inserting DENY entries for group
+ * class entries where necessary.
+ */
+static int
+richacl_isolate_group_class(struct richacl_alloc *x)
+{
+	struct richace who = {
+		.e_flags = ACE4_SPECIAL_WHO,
+		.u.e_who = richace_group_who,
+	};
+	struct richace *ace;
+	unsigned int deny;
+
+	if (!x->acl->a_count)
+		return 0;
+	ace = x->acl->a_entries + x->acl->a_count - 1;
+	if (richace_is_inherit_only(ace) || !richace_is_everyone(ace))
+		return 0;
+	deny = ace->e_mask & ~x->acl->a_group_mask;
+
+	if (deny) {
+		unsigned int n;
+
+		if (__richacl_isolate_who(x, &who, deny))
+			return -1;
+
+		/* Start from the entry before the trailing EVERYONE@ ALLOW
+		   entry. We will not hit EVERYONE@ entries in the loop. */
+		for (n = x->acl->a_count - 2; n != -1; n--) {
+			ace = x->acl->a_entries + n;
+
+			if (richace_is_inherit_only(ace) ||
+			    richace_is_owner(ace) ||
+			    richace_is_group(ace))
+				continue;
+			if (__richacl_isolate_who(x, ace, deny))
+				return -1;
+		}
+	}
+	return 0;
+}
+
+/**
+ * __richacl_write_through  -  grant the full masks to owner@, group@, everyone@
+ *
+ * Make sure that owner, group@, and everyone@ are allowed the full mask
+ * permissions, and not only the permissions granted both by the acl and
+ * the masks.
+ */
+static int
+__richacl_write_through(struct richacl_alloc *x)
+{
+	struct richace *ace;
+	unsigned int allowed;
+
+	/* Remove all owner@ and group@ ACEs: we re-insert them at the
+	   top. */
+	richacl_for_each_entry(ace, x->acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if ((richace_is_owner(ace) || richace_is_group(ace)) &&
+		    richace_change_mask(x, &ace, 0))
+			return -1;
+	}
+
+	/* Insert the everyone@ allow entry at the end, or update the
+	   existing entry. */
+	allowed = x->acl->a_other_mask;
+	if (allowed & ~ACE4_POSIX_ALWAYS_ALLOWED) {
+		ace = x->acl->a_entries + x->acl->a_count - 1;
+		if (x->acl->a_count && richace_is_everyone(ace) &&
+		    !richace_is_inherit_only(ace)) {
+			if (richace_change_mask(x, &ace, allowed))
+				return -1;
+		} else {
+			ace = x->acl->a_entries + x->acl->a_count;
+			if (richacl_insert_entry(x, &ace))
+				return -1;
+			ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+			ace->e_flags = ACE4_SPECIAL_WHO;
+			ace->e_mask = allowed;
+			ace->u.e_who = richace_everyone_who;
+		}
+	}
+
+	/* Compute the permissions that owner@ and group@ are already granted
+	   though the everyone@ allow entry at the end. Note that the acl
+	   contains no owner@ or group@ entries at this point. */
+	allowed = 0;
+	richacl_for_each_entry_reverse(ace, x->acl) {
+		if (richace_is_inherit_only(ace))
+			continue;
+		if (richace_is_allow(ace)) {
+			if (richace_is_everyone(ace))
+				allowed |= ace->e_mask;
+		} else if (richace_is_deny(ace))
+				allowed &= ~ace->e_mask;
+	}
+
+	/* Insert the appropriate group@ allow entry at the front. */
+	if (x->acl->a_group_mask & ~allowed) {
+		ace = x->acl->a_entries;
+		if (richacl_insert_entry(x, &ace))
+			return -1;
+		ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = ACE4_SPECIAL_WHO;
+		ace->e_mask = x->acl->a_group_mask /*& ~allowed*/;
+		ace->u.e_who = richace_group_who;
+	}
+
+	/* Insert the appropriate owner@ allow entry at the front. */
+	if (x->acl->a_owner_mask & ~allowed) {
+		ace = x->acl->a_entries;
+		if (richacl_insert_entry(x, &ace))
+			return -1;
+		ace->e_type = ACE4_ACCESS_ALLOWED_ACE_TYPE;
+		ace->e_flags = ACE4_SPECIAL_WHO;
+		ace->e_mask = x->acl->a_owner_mask /*& ~allowed*/;
+		ace->u.e_who = richace_owner_who;
+	}
+
+	/* Insert the appropriate owner@ deny entry at the front. */
+	allowed = richacl_max_allowed(x->acl);
+	if (allowed & ~x->acl->a_owner_mask) {
+		richacl_for_each_entry(ace, x->acl) {
+			if (richace_is_inherit_only(ace))
+				continue;
+			if (richace_is_allow(ace)) {
+				ace = x->acl->a_entries + x->acl->a_count;
+				break;
+			}
+			if (richace_is_deny(ace) && richace_is_owner(ace))
+				break;
+		}
+		if (ace != x->acl->a_entries + x->acl->a_count) {
+			if (richace_change_mask(x, &ace, ace->e_mask |
+					(allowed & ~x->acl->a_owner_mask)))
+				return -1;
+		} else {
+			ace = x->acl->a_entries;
+			if (richacl_insert_entry(x, &ace))
+				return -1;
+			ace->e_type = ACE4_ACCESS_DENIED_ACE_TYPE;
+			ace->e_flags = ACE4_SPECIAL_WHO;
+			ace->e_mask = allowed & ~x->acl->a_owner_mask;
+			ace->u.e_who = richace_owner_who;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * richacl_apply_masks  -  apply the masks to the acl
+ *
+ * Apply the masks so that the acl allows no more flags than the
+ * intersection between the flags that the original acl allows and the
+ * mask matching the process.
+ *
+ * Note: this algorithm may push the number of entries in the acl above
+ * ACL4_XATTR_MAX_COUNT, so a read-modify-write cycle would fail.
+ */
+int
+richacl_apply_masks(struct richacl **acl)
+{
+	struct richacl_alloc x = {
+		.acl = *acl,
+		.count = (*acl)->a_count,
+	};
+	int retval = 0;
+
+	if (richacl_move_everyone_aces_down(&x) ||
+	    richacl_propagate_everyone(&x) ||
+	    __richacl_apply_masks(&x) ||
+	    richacl_isolate_owner_class(&x) ||
+	    richacl_isolate_group_class(&x))
+		retval = -ENOMEM;
+
+	*acl = x.acl;
+	return retval;
+}
+EXPORT_SYMBOL_GPL(richacl_apply_masks);
+
+int richacl_write_through(struct richacl **acl)
+{
+	struct richacl_alloc x = {
+		.acl = *acl,
+		.count = (*acl)->a_count,
+	};
+	int retval = 0;
+
+	if (!((*acl)->a_flags & ACL4_WRITE_THROUGH))
+		goto out;
+
+	if (richacl_move_everyone_aces_down(&x) ||
+	    richacl_propagate_everyone(&x) ||
+	    __richacl_write_through(&x))
+		retval = -ENOMEM;
+
+	*acl = x.acl;
+out:
+	return retval;
+}
diff --git a/fs/richacl_xattr.c b/fs/richacl_xattr.c
new file mode 100644
index 0000000..4c04417
--- /dev/null
+++ b/fs/richacl_xattr.c
@@ -0,0 +1,146 @@
+/*
+ * Copyright (C) 2006 Andreas Gruenbacher <a.gruenbacher@computer.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/richacl_xattr.h>
+
+MODULE_LICENSE("GPL");
+
+struct richacl *
+richacl_from_xattr(const void *value, size_t size)
+{
+	const struct richacl_xattr *xattr_acl = value;
+	const struct richace_xattr *xattr_ace = (void *)(xattr_acl + 1);
+	struct richacl *acl;
+	struct richace *ace;
+	int count;
+
+	if (size < sizeof(struct richacl_xattr) ||
+	    xattr_acl->a_version != ACL4_XATTR_VERSION ||
+	    (xattr_acl->a_flags & ~ACL4_VALID_FLAGS))
+		return ERR_PTR(-EINVAL);
+
+	count = be16_to_cpu(xattr_acl->a_count);
+	if (count > ACL4_XATTR_MAX_COUNT)
+		return ERR_PTR(-EINVAL);
+
+	acl = richacl_alloc(count);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+
+	acl->a_flags = xattr_acl->a_flags;
+	acl->a_owner_mask = be32_to_cpu(xattr_acl->a_owner_mask);
+	if (acl->a_owner_mask & ~ACE4_VALID_MASK)
+		goto fail_einval;
+	acl->a_group_mask = be32_to_cpu(xattr_acl->a_group_mask);
+	if (acl->a_group_mask & ~ACE4_VALID_MASK)
+		goto fail_einval;
+	acl->a_other_mask = be32_to_cpu(xattr_acl->a_other_mask);
+	if (acl->a_other_mask & ~ACE4_VALID_MASK)
+		goto fail_einval;
+
+	richacl_for_each_entry(ace, acl) {
+		const char *who = (void *)(xattr_ace + 1), *end;
+		ssize_t used = (void *)who - value;
+
+		if (used > size)
+			goto fail_einval;
+		end = memchr(who, 0, size - used);
+		if (!end)
+			goto fail_einval;
+
+		ace->e_type = be16_to_cpu(xattr_ace->e_type);
+		ace->e_flags = be16_to_cpu(xattr_ace->e_flags);
+		ace->e_mask = be32_to_cpu(xattr_ace->e_mask);
+		ace->u.e_id = be32_to_cpu(xattr_ace->e_id);
+
+		if (ace->e_flags & ~ACE4_VALID_FLAGS) {
+			memset(ace, 0, sizeof(struct richace));
+			goto fail_einval;
+		}
+		if (ace->e_type > ACE4_ACCESS_DENIED_ACE_TYPE ||
+		    (ace->e_mask & ~ACE4_VALID_MASK))
+			goto fail_einval;
+
+		if (who == end) {
+			if (ace->u.e_id == -1)
+				goto fail_einval;  /* uid/gid needed */
+		} else if (richace_set_who(ace, who))
+			goto fail_einval;
+
+		xattr_ace = (void *)who + ALIGN(end - who + 1, 4);
+	}
+
+	return acl;
+
+fail_einval:
+	richacl_put(acl);
+	return ERR_PTR(-EINVAL);
+}
+EXPORT_SYMBOL_GPL(richacl_from_xattr);
+
+size_t
+richacl_xattr_size(const struct richacl *acl)
+{
+	size_t size = sizeof(struct richacl_xattr);
+	const struct richace *ace;
+
+	richacl_for_each_entry(ace, acl) {
+		size += sizeof(struct richace_xattr) +
+			(richace_is_unix_id(ace) ? 4 :
+			 ALIGN(strlen(ace->u.e_who) + 1, 4));
+	}
+	return size;
+}
+EXPORT_SYMBOL_GPL(richacl_xattr_size);
+
+void
+richacl_to_xattr(const struct richacl *acl, void *buffer)
+{
+	struct richacl_xattr *xattr_acl = buffer;
+	struct richace_xattr *xattr_ace;
+	const struct richace *ace;
+
+	xattr_acl->a_version = ACL4_XATTR_VERSION;
+	xattr_acl->a_flags = acl->a_flags;
+	xattr_acl->a_count = cpu_to_be16(acl->a_count);
+
+	xattr_acl->a_owner_mask = cpu_to_be32(acl->a_owner_mask);
+	xattr_acl->a_group_mask = cpu_to_be32(acl->a_group_mask);
+	xattr_acl->a_other_mask = cpu_to_be32(acl->a_other_mask);
+
+	xattr_ace = (void *)(xattr_acl + 1);
+	richacl_for_each_entry(ace, acl) {
+		xattr_ace->e_type = cpu_to_be16(ace->e_type);
+		xattr_ace->e_flags = cpu_to_be16(ace->e_flags &
+			ACE4_VALID_FLAGS);
+		xattr_ace->e_mask = cpu_to_be32(ace->e_mask);
+		if (richace_is_unix_id(ace)) {
+			xattr_ace->e_id = cpu_to_be32(ace->u.e_id);
+			memset(xattr_ace->e_who, 0, 4);
+			xattr_ace = (void *)xattr_ace->e_who + 4;
+		} else {
+			int sz = ALIGN(strlen(ace->u.e_who) + 1, 4);
+
+			xattr_ace->e_id = cpu_to_be32(-1);
+			memset(xattr_ace->e_who + sz - 4, 0, 4);
+			strcpy(xattr_ace->e_who, ace->u.e_who);
+			xattr_ace = (void *)xattr_ace->e_who + sz;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(richacl_to_xattr);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
new file mode 100644
index 0000000..a2b4bd0
--- /dev/null
+++ b/include/linux/richacl.h
@@ -0,0 +1,208 @@
+#ifndef __RICHACL_H
+#define __RICHACL_H
+#include <linux/slab.h>
+
+struct richace {
+	unsigned short	e_type;
+	unsigned short	e_flags;
+	unsigned int	e_mask;
+	union {
+		unsigned int	e_id;
+		const char	*e_who;
+	} u;
+};
+
+struct richacl {
+	atomic_t	a_refcount;
+	unsigned int	a_owner_mask;
+	unsigned int	a_group_mask;
+	unsigned int	a_other_mask;
+	unsigned short	a_count;
+	unsigned short	a_flags;
+	struct richace	a_entries[0];
+};
+
+#define richacl_for_each_entry(_ace, _acl) \
+	for (_ace = _acl->a_entries; \
+	     _ace != _acl->a_entries + _acl->a_count; \
+	     _ace++)
+
+#define richacl_for_each_entry_reverse(_ace, _acl) \
+	for (_ace = _acl->a_entries + _acl->a_count - 1; \
+	     _ace != _acl->a_entries - 1; \
+	     _ace--)
+
+/* a_flags values */
+#define ACL4_WRITE_THROUGH		0x40
+
+#define ACL4_VALID_FLAGS \
+	ACL4_WRITE_THROUGH
+
+/* e_type values */
+#define ACE4_ACCESS_ALLOWED_ACE_TYPE	0x0000
+#define ACE4_ACCESS_DENIED_ACE_TYPE	0x0001
+/*#define ACE4_SYSTEM_AUDIT_ACE_TYPE	0x0002*/
+/*#define ACE4_SYSTEM_ALARM_ACE_TYPE	0x0003*/
+
+/* e_flags bitflags */
+#define ACE4_FILE_INHERIT_ACE		0x0001
+#define ACE4_DIRECTORY_INHERIT_ACE	0x0002
+#define ACE4_NO_PROPAGATE_INHERIT_ACE	0x0004
+#define ACE4_INHERIT_ONLY_ACE		0x0008
+/*#define ACE4_SUCCESSFUL_ACCESS_ACE_FLAG	0x0010*/
+/*#define ACE4_FAILED_ACCESS_ACE_FLAG	0x0020*/
+#define ACE4_IDENTIFIER_GROUP		0x0040
+/* in-memory representation only */
+#define ACE4_SPECIAL_WHO		0x4000
+
+#define ACE4_VALID_FLAGS ( \
+	ACE4_FILE_INHERIT_ACE | \
+	ACE4_DIRECTORY_INHERIT_ACE | \
+	ACE4_NO_PROPAGATE_INHERIT_ACE | \
+	ACE4_INHERIT_ONLY_ACE | \
+	ACE4_IDENTIFIER_GROUP)
+
+/* e_mask bitflags */
+#define ACE4_READ_DATA			0x00000001
+#define ACE4_LIST_DIRECTORY		0x00000001
+#define ACE4_WRITE_DATA			0x00000002
+#define ACE4_ADD_FILE			0x00000002
+#define ACE4_APPEND_DATA		0x00000004
+#define ACE4_ADD_SUBDIRECTORY		0x00000004
+#define ACE4_READ_NAMED_ATTRS		0x00000008
+#define ACE4_WRITE_NAMED_ATTRS		0x00000010
+#define ACE4_EXECUTE			0x00000020
+#define ACE4_DELETE_CHILD		0x00000040
+#define ACE4_READ_ATTRIBUTES		0x00000080
+#define ACE4_WRITE_ATTRIBUTES		0x00000100
+#define ACE4_DELETE			0x00010000
+#define ACE4_READ_ACL			0x00020000
+#define ACE4_WRITE_ACL			0x00040000
+#define ACE4_WRITE_OWNER		0x00080000
+#define ACE4_SYNCHRONIZE		0x00100000
+
+#define ACE4_VALID_MASK ( \
+	ACE4_READ_DATA | ACE4_LIST_DIRECTORY | \
+	ACE4_WRITE_DATA | ACE4_ADD_FILE | \
+	ACE4_APPEND_DATA | ACE4_ADD_SUBDIRECTORY | \
+	ACE4_READ_NAMED_ATTRS | \
+	ACE4_WRITE_NAMED_ATTRS | \
+	ACE4_EXECUTE | \
+	ACE4_DELETE_CHILD | \
+	ACE4_READ_ATTRIBUTES | \
+	ACE4_WRITE_ATTRIBUTES | \
+	ACE4_DELETE | \
+	ACE4_READ_ACL | \
+	ACE4_WRITE_ACL | \
+	ACE4_WRITE_OWNER | \
+	ACE4_SYNCHRONIZE)
+
+#define ACE4_POSIX_ALWAYS_ALLOWED ( \
+	ACE4_SYNCHRONIZE | \
+	ACE4_READ_ATTRIBUTES | \
+	ACE4_READ_ACL)
+/*
+ * Duplicate an RICHACL handle.
+ */
+static inline struct richacl *
+richacl_get(struct richacl *acl)
+{
+	if (acl)
+		atomic_inc(&acl->a_refcount);
+	return acl;
+}
+
+/*
+ * Free an RICHACL handle
+ */
+static inline void
+richacl_put(struct richacl *acl)
+{
+	if (acl && atomic_dec_and_test(&acl->a_refcount))
+		kfree(acl);
+}
+
+/* Special e_who identifiers: we use these pointer values in comparisons
+   instead of strcmp for efficiency. */
+
+extern const char richace_owner_who[];
+extern const char richace_group_who[];
+extern const char richace_everyone_who[];
+
+static inline int
+richace_is_owner(const struct richace *ace)
+{
+	return (ace->e_flags & ACE4_SPECIAL_WHO) &&
+	       ace->u.e_who == richace_owner_who;
+}
+
+static inline int
+richace_is_group(const struct richace *ace)
+{
+	return (ace->e_flags & ACE4_SPECIAL_WHO) &&
+	       ace->u.e_who == richace_group_who;
+}
+
+static inline int
+richace_is_everyone(const struct richace *ace)
+{
+	return (ace->e_flags & ACE4_SPECIAL_WHO) &&
+	       ace->u.e_who == richace_everyone_who;
+}
+
+static inline int
+richace_is_unix_id(const struct richace *ace)
+{
+	return !(ace->e_flags & ACE4_SPECIAL_WHO);
+}
+
+static inline int
+richace_is_inherit_only(const struct richace *ace)
+{
+	return ace->e_flags & ACE4_INHERIT_ONLY_ACE;
+}
+
+static inline int
+richace_is_inheritable(const struct richace *ace)
+{
+	return ace->e_flags & (ACE4_FILE_INHERIT_ACE |
+			       ACE4_DIRECTORY_INHERIT_ACE);
+}
+
+static inline void
+richace_clear_inheritance_flags(struct richace *ace)
+{
+	ace->e_flags &= ~(ACE4_FILE_INHERIT_ACE |
+			  ACE4_DIRECTORY_INHERIT_ACE |
+			  ACE4_NO_PROPAGATE_INHERIT_ACE |
+			  ACE4_INHERIT_ONLY_ACE);
+}
+
+static inline int
+richace_is_allow(const struct richace *ace)
+{
+	return ace->e_type == ACE4_ACCESS_ALLOWED_ACE_TYPE;
+}
+
+static inline int
+richace_is_deny(const struct richace *ace)
+{
+	return ace->e_type == ACE4_ACCESS_DENIED_ACE_TYPE;
+}
+
+extern struct richacl *richacl_alloc(int count);
+extern struct richacl *richacl_clone(const struct richacl *acl);
+
+extern unsigned int richacl_want_to_mask(int want);
+extern int richacl_permission(struct inode *,
+			const struct richacl *, unsigned int);
+extern int richacl_generic_permission(struct inode *, unsigned int);
+extern int richace_is_same_who(const struct richace *, const struct richace *);
+extern int richace_set_who(struct richace *ace, const char *who);
+extern struct richacl *richacl_inherit(const struct richacl *, mode_t);
+extern int richacl_masks_to_mode(const struct richacl *);
+extern struct richacl *richacl_chmod(struct richacl *, mode_t);
+extern int richacl_apply_masks(struct richacl **acl);
+extern int richacl_write_through(struct richacl **acl);
+
+#endif /* __RICHACL_H */
diff --git a/include/linux/richacl_xattr.h b/include/linux/richacl_xattr.h
new file mode 100644
index 0000000..5a75284
--- /dev/null
+++ b/include/linux/richacl_xattr.h
@@ -0,0 +1,32 @@
+#ifndef __RICHACL_XATTR_H
+#define __RICHACL_XATTR_H
+
+#include <linux/richacl.h>
+
+#define RICHACL_XATTR "system.richacl"
+
+struct richace_xattr {
+	__be16		e_type;
+	__be16		e_flags;
+	__be32		e_mask;
+	__be32		e_id;
+	char		e_who[0];
+};
+
+struct richacl_xattr {
+	unsigned char	a_version;
+	unsigned char	a_flags;
+	__be16		a_count;
+	__be32		a_owner_mask;
+	__be32		a_group_mask;
+	__be32		a_other_mask;
+};
+
+#define ACL4_XATTR_VERSION	0
+#define ACL4_XATTR_MAX_COUNT	1024
+
+extern struct richacl *richacl_from_xattr(const void *, size_t);
+extern size_t richacl_xattr_size(const struct richacl *acl);
+extern void richacl_to_xattr(const struct richacl *, void *);
+
+#endif /* __RICHACL_XATTR_H */
-- 
1.7.0.rc0.48.gdace5

