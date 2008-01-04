From: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] [Coding Style]: misc fixes for fs/ext{3,4}/acl.{c,h} from checkpatch.pl
Date: Fri,  4 Jan 2008 14:21:32 +0100
Message-ID: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mathieu Segaud <mathieu.segaud@regala.cx>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bde.crans.org ([138.231.137.76]:48605 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYADNaT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2008 08:30:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 fs/ext3/acl.c |  194 ++++++++++++++++++++++++++++----------------------------
 fs/ext3/acl.h |    6 +-
 fs/ext4/acl.c |  190 ++++++++++++++++++++++++++++----------------------------
 fs/ext4/acl.h |    6 +-
 4 files changed, 198 insertions(+), 198 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index d34e996..8de0050 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -40,34 +40,34 @@ ext3_acl_from_disk(const void *value, size_t size)
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
-	for (n=0; n < count; n++) {
+	for (n = 0; n < count; n++) {
 		ext3_acl_entry *entry =
 			(ext3_acl_entry *)value;
 		if ((char *)value + sizeof(ext3_acl_entry_short) > end)
 			goto fail;
 		acl->a_entries[n].e_tag  = le16_to_cpu(entry->e_tag);
 		acl->a_entries[n].e_perm = le16_to_cpu(entry->e_perm);
-		switch(acl->a_entries[n].e_tag) {
-			case ACL_USER_OBJ:
-			case ACL_GROUP_OBJ:
-			case ACL_MASK:
-			case ACL_OTHER:
-				value = (char *)value +
-					sizeof(ext3_acl_entry_short);
-				acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
-				break;
-
-			case ACL_USER:
-			case ACL_GROUP:
-				value = (char *)value + sizeof(ext3_acl_entry);
-				if ((char *)value > end)
-					goto fail;
-				acl->a_entries[n].e_id =
-					le32_to_cpu(entry->e_id);
-				break;
-
-			default:
+		switch (acl->a_entries[n].e_tag) {
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			value = (char *)value +
+				sizeof(ext3_acl_entry_short);
+			acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
+			break;
+
+		case ACL_USER:
+		case ACL_GROUP:
+			value = (char *)value + sizeof(ext3_acl_entry);
+			if ((char *)value > end)
 				goto fail;
+			acl->a_entries[n].e_id =
+				le32_to_cpu(entry->e_id);
+			break;
+
+		default:
+			goto fail;
 		}
 	}
 	if (value != end)
@@ -96,27 +96,27 @@ ext3_acl_to_disk(const struct posix_acl *acl, size_t *size)
 		return ERR_PTR(-ENOMEM);
 	ext_acl->a_version = cpu_to_le32(EXT3_ACL_VERSION);
 	e = (char *)ext_acl + sizeof(ext3_acl_header);
-	for (n=0; n < acl->a_count; n++) {
+	for (n = 0; n < acl->a_count; n++) {
 		ext3_acl_entry *entry = (ext3_acl_entry *)e;
 		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
 		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		switch(acl->a_entries[n].e_tag) {
-			case ACL_USER:
-			case ACL_GROUP:
-				entry->e_id =
-					cpu_to_le32(acl->a_entries[n].e_id);
-				e += sizeof(ext3_acl_entry);
-				break;
-
-			case ACL_USER_OBJ:
-			case ACL_GROUP_OBJ:
-			case ACL_MASK:
-			case ACL_OTHER:
-				e += sizeof(ext3_acl_entry_short);
-				break;
-
-			default:
-				goto fail;
+		switch (acl->a_entries[n].e_tag) {
+		case ACL_USER:
+		case ACL_GROUP:
+			entry->e_id =
+				cpu_to_le32(acl->a_entries[n].e_id);
+			e += sizeof(ext3_acl_entry);
+			break;
+
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			e += sizeof(ext3_acl_entry_short);
+			break;
+
+		default:
+			goto fail;
 		}
 	}
 	return (char *)ext_acl;
@@ -141,7 +141,7 @@ ext3_iget_acl(struct inode *inode, struct posix_acl **i_acl)
 
 static inline void
 ext3_iset_acl(struct inode *inode, struct posix_acl **i_acl,
-                  struct posix_acl *acl)
+				struct posix_acl *acl)
 {
 	spin_lock(&inode->i_lock);
 	if (*i_acl != EXT3_ACL_NOT_CACHED)
@@ -167,23 +167,23 @@ ext3_get_acl(struct inode *inode, int type)
 	if (!test_opt(inode->i_sb, POSIX_ACL))
 		return NULL;
 
-	switch(type) {
-		case ACL_TYPE_ACCESS:
-			acl = ext3_iget_acl(inode, &ei->i_acl);
-			if (acl != EXT3_ACL_NOT_CACHED)
-				return acl;
-			name_index = EXT3_XATTR_INDEX_POSIX_ACL_ACCESS;
-			break;
-
-		case ACL_TYPE_DEFAULT:
-			acl = ext3_iget_acl(inode, &ei->i_default_acl);
-			if (acl != EXT3_ACL_NOT_CACHED)
-				return acl;
-			name_index = EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT;
-			break;
-
-		default:
-			return ERR_PTR(-EINVAL);
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		acl = ext3_iget_acl(inode, &ei->i_acl);
+		if (acl != EXT3_ACL_NOT_CACHED)
+			return acl;
+		name_index = EXT3_XATTR_INDEX_POSIX_ACL_ACCESS;
+		break;
+
+	case ACL_TYPE_DEFAULT:
+		acl = ext3_iget_acl(inode, &ei->i_default_acl);
+		if (acl != EXT3_ACL_NOT_CACHED)
+			return acl;
+		name_index = EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		break;
+
+	default:
+		return ERR_PTR(-EINVAL);
 	}
 	retval = ext3_xattr_get(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
@@ -201,14 +201,14 @@ ext3_get_acl(struct inode *inode, int type)
 	kfree(value);
 
 	if (!IS_ERR(acl)) {
-		switch(type) {
-			case ACL_TYPE_ACCESS:
-				ext3_iset_acl(inode, &ei->i_acl, acl);
-				break;
-
-			case ACL_TYPE_DEFAULT:
-				ext3_iset_acl(inode, &ei->i_default_acl, acl);
-				break;
+		switch (type) {
+		case ACL_TYPE_ACCESS:
+			ext3_iset_acl(inode, &ei->i_acl, acl);
+			break;
+
+		case ACL_TYPE_DEFAULT:
+			ext3_iset_acl(inode, &ei->i_default_acl, acl);
+			break;
 		}
 	}
 	return acl;
@@ -232,31 +232,31 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
-	switch(type) {
-		case ACL_TYPE_ACCESS:
-			name_index = EXT3_XATTR_INDEX_POSIX_ACL_ACCESS;
-			if (acl) {
-				mode_t mode = inode->i_mode;
-				error = posix_acl_equiv_mode(acl, &mode);
-				if (error < 0)
-					return error;
-				else {
-					inode->i_mode = mode;
-					ext3_mark_inode_dirty(handle, inode);
-					if (error == 0)
-						acl = NULL;
-				}
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = EXT3_XATTR_INDEX_POSIX_ACL_ACCESS;
+		if (acl) {
+			mode_t mode = inode->i_mode;
+			error = posix_acl_equiv_mode(acl, &mode);
+			if (error < 0)
+				return error;
+			else {
+				inode->i_mode = mode;
+				ext3_mark_inode_dirty(handle, inode);
+				if (error == 0)
+					acl = NULL;
 			}
-			break;
+		}
+		break;
 
-		case ACL_TYPE_DEFAULT:
-			name_index = EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT;
-			if (!S_ISDIR(inode->i_mode))
-				return acl ? -EACCES : 0;
-			break;
+	case ACL_TYPE_DEFAULT:
+		name_index = EXT3_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		break;
 
-		default:
-			return -EINVAL;
+	default:
+		return -EINVAL;
 	}
 	if (acl) {
 		value = ext3_acl_to_disk(acl, &size);
@@ -269,14 +269,14 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 
 	kfree(value);
 	if (!error) {
-		switch(type) {
-			case ACL_TYPE_ACCESS:
-				ext3_iset_acl(inode, &ei->i_acl, acl);
-				break;
-
-			case ACL_TYPE_DEFAULT:
-				ext3_iset_acl(inode, &ei->i_default_acl, acl);
-				break;
+		switch (type) {
+		case ACL_TYPE_ACCESS:
+			ext3_iset_acl(inode, &ei->i_acl, acl);
+			break;
+
+		case ACL_TYPE_DEFAULT:
+			ext3_iset_acl(inode, &ei->i_default_acl, acl);
+			break;
 		}
 	}
 	return error;
@@ -375,7 +375,7 @@ int
 ext3_acl_chmod(struct inode *inode)
 {
 	struct posix_acl *acl, *clone;
-        int error;
+	int error;
 
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
@@ -393,7 +393,7 @@ ext3_acl_chmod(struct inode *inode)
 		handle_t *handle;
 		int retries = 0;
 
-	retry:
+retry:
 		handle = ext3_journal_start(inode,
 				EXT3_DATA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
diff --git a/fs/ext3/acl.h b/fs/ext3/acl.h
index 0d1e627..ee85815 100644
--- a/fs/ext3/acl.h
+++ b/fs/ext3/acl.h
@@ -58,9 +58,9 @@ static inline int ext3_acl_count(size_t size)
 #define EXT3_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext3_permission (struct inode *, int, struct nameidata *);
-extern int ext3_acl_chmod (struct inode *);
-extern int ext3_init_acl (handle_t *, struct inode *, struct inode *);
+extern int ext3_permission(struct inode *, int, struct nameidata *);
+extern int ext3_acl_chmod(struct inode *);
+extern int ext3_init_acl(handle_t *, struct inode *, struct inode *);
 
 #else  /* CONFIG_EXT3_FS_POSIX_ACL */
 #include <linux/sched.h>
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index a8bae8c..f9f8d1e 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -40,34 +40,34 @@ ext4_acl_from_disk(const void *value, size_t size)
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
-	for (n=0; n < count; n++) {
+	for (n = 0; n < count; n++) {
 		ext4_acl_entry *entry =
 			(ext4_acl_entry *)value;
 		if ((char *)value + sizeof(ext4_acl_entry_short) > end)
 			goto fail;
 		acl->a_entries[n].e_tag  = le16_to_cpu(entry->e_tag);
 		acl->a_entries[n].e_perm = le16_to_cpu(entry->e_perm);
-		switch(acl->a_entries[n].e_tag) {
-			case ACL_USER_OBJ:
-			case ACL_GROUP_OBJ:
-			case ACL_MASK:
-			case ACL_OTHER:
-				value = (char *)value +
-					sizeof(ext4_acl_entry_short);
-				acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
-				break;
-
-			case ACL_USER:
-			case ACL_GROUP:
-				value = (char *)value + sizeof(ext4_acl_entry);
-				if ((char *)value > end)
-					goto fail;
-				acl->a_entries[n].e_id =
-					le32_to_cpu(entry->e_id);
-				break;
-
-			default:
+		switch (acl->a_entries[n].e_tag) {
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			value = (char *)value +
+				sizeof(ext4_acl_entry_short);
+			acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
+			break;
+
+		case ACL_USER:
+		case ACL_GROUP:
+			value = (char *)value + sizeof(ext4_acl_entry);
+			if ((char *)value > end)
 				goto fail;
+			acl->a_entries[n].e_id =
+				le32_to_cpu(entry->e_id);
+			break;
+
+		default:
+			goto fail;
 		}
 	}
 	if (value != end)
@@ -96,27 +96,27 @@ ext4_acl_to_disk(const struct posix_acl *acl, size_t *size)
 		return ERR_PTR(-ENOMEM);
 	ext_acl->a_version = cpu_to_le32(EXT4_ACL_VERSION);
 	e = (char *)ext_acl + sizeof(ext4_acl_header);
-	for (n=0; n < acl->a_count; n++) {
+	for (n = 0; n < acl->a_count; n++) {
 		ext4_acl_entry *entry = (ext4_acl_entry *)e;
 		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
 		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		switch(acl->a_entries[n].e_tag) {
-			case ACL_USER:
-			case ACL_GROUP:
-				entry->e_id =
-					cpu_to_le32(acl->a_entries[n].e_id);
-				e += sizeof(ext4_acl_entry);
-				break;
-
-			case ACL_USER_OBJ:
-			case ACL_GROUP_OBJ:
-			case ACL_MASK:
-			case ACL_OTHER:
-				e += sizeof(ext4_acl_entry_short);
-				break;
-
-			default:
-				goto fail;
+		switch (acl->a_entries[n].e_tag) {
+		case ACL_USER:
+		case ACL_GROUP:
+			entry->e_id =
+				cpu_to_le32(acl->a_entries[n].e_id);
+			e += sizeof(ext4_acl_entry);
+			break;
+
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			e += sizeof(ext4_acl_entry_short);
+			break;
+
+		default:
+			goto fail;
 		}
 	}
 	return (char *)ext_acl;
@@ -167,23 +167,23 @@ ext4_get_acl(struct inode *inode, int type)
 	if (!test_opt(inode->i_sb, POSIX_ACL))
 		return NULL;
 
-	switch(type) {
-		case ACL_TYPE_ACCESS:
-			acl = ext4_iget_acl(inode, &ei->i_acl);
-			if (acl != EXT4_ACL_NOT_CACHED)
-				return acl;
-			name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
-			break;
-
-		case ACL_TYPE_DEFAULT:
-			acl = ext4_iget_acl(inode, &ei->i_default_acl);
-			if (acl != EXT4_ACL_NOT_CACHED)
-				return acl;
-			name_index = EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT;
-			break;
-
-		default:
-			return ERR_PTR(-EINVAL);
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		acl = ext4_iget_acl(inode, &ei->i_acl);
+		if (acl != EXT4_ACL_NOT_CACHED)
+			return acl;
+		name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
+		break;
+
+	case ACL_TYPE_DEFAULT:
+		acl = ext4_iget_acl(inode, &ei->i_default_acl);
+		if (acl != EXT4_ACL_NOT_CACHED)
+			return acl;
+		name_index = EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		break;
+
+	default:
+		return ERR_PTR(-EINVAL);
 	}
 	retval = ext4_xattr_get(inode, name_index, "", NULL, 0);
 	if (retval > 0) {
@@ -201,14 +201,14 @@ ext4_get_acl(struct inode *inode, int type)
 	kfree(value);
 
 	if (!IS_ERR(acl)) {
-		switch(type) {
-			case ACL_TYPE_ACCESS:
-				ext4_iset_acl(inode, &ei->i_acl, acl);
-				break;
-
-			case ACL_TYPE_DEFAULT:
-				ext4_iset_acl(inode, &ei->i_default_acl, acl);
-				break;
+		switch (type) {
+		case ACL_TYPE_ACCESS:
+			ext4_iset_acl(inode, &ei->i_acl, acl);
+			break;
+
+		case ACL_TYPE_DEFAULT:
+			ext4_iset_acl(inode, &ei->i_default_acl, acl);
+			break;
 		}
 	}
 	return acl;
@@ -232,31 +232,31 @@ ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
 
-	switch(type) {
-		case ACL_TYPE_ACCESS:
-			name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
-			if (acl) {
-				mode_t mode = inode->i_mode;
-				error = posix_acl_equiv_mode(acl, &mode);
-				if (error < 0)
-					return error;
-				else {
-					inode->i_mode = mode;
-					ext4_mark_inode_dirty(handle, inode);
-					if (error == 0)
-						acl = NULL;
-				}
+	switch (type) {
+	case ACL_TYPE_ACCESS:
+		name_index = EXT4_XATTR_INDEX_POSIX_ACL_ACCESS;
+		if (acl) {
+			mode_t mode = inode->i_mode;
+			error = posix_acl_equiv_mode(acl, &mode);
+			if (error < 0)
+				return error;
+			else {
+				inode->i_mode = mode;
+				ext4_mark_inode_dirty(handle, inode);
+				if (error == 0)
+					acl = NULL;
 			}
-			break;
+		}
+		break;
 
-		case ACL_TYPE_DEFAULT:
-			name_index = EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT;
-			if (!S_ISDIR(inode->i_mode))
-				return acl ? -EACCES : 0;
-			break;
+	case ACL_TYPE_DEFAULT:
+		name_index = EXT4_XATTR_INDEX_POSIX_ACL_DEFAULT;
+		if (!S_ISDIR(inode->i_mode))
+			return acl ? -EACCES : 0;
+		break;
 
-		default:
-			return -EINVAL;
+	default:
+		return -EINVAL;
 	}
 	if (acl) {
 		value = ext4_acl_to_disk(acl, &size);
@@ -269,14 +269,14 @@ ext4_set_acl(handle_t *handle, struct inode *inode, int type,
 
 	kfree(value);
 	if (!error) {
-		switch(type) {
-			case ACL_TYPE_ACCESS:
-				ext4_iset_acl(inode, &ei->i_acl, acl);
-				break;
-
-			case ACL_TYPE_DEFAULT:
-				ext4_iset_acl(inode, &ei->i_default_acl, acl);
-				break;
+		switch (type) {
+		case ACL_TYPE_ACCESS:
+			ext4_iset_acl(inode, &ei->i_acl, acl);
+			break;
+
+		case ACL_TYPE_DEFAULT:
+			ext4_iset_acl(inode, &ei->i_default_acl, acl);
+			break;
 		}
 	}
 	return error;
@@ -393,7 +393,7 @@ ext4_acl_chmod(struct inode *inode)
 		handle_t *handle;
 		int retries = 0;
 
-	retry:
+retry:
 		handle = ext4_journal_start(inode,
 				EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
 		if (IS_ERR(handle)) {
diff --git a/fs/ext4/acl.h b/fs/ext4/acl.h
index 26a5c1a..7eac965 100644
--- a/fs/ext4/acl.h
+++ b/fs/ext4/acl.h
@@ -58,9 +58,9 @@ static inline int ext4_acl_count(size_t size)
 #define EXT4_ACL_NOT_CACHED ((void *)-1)
 
 /* acl.c */
-extern int ext4_permission (struct inode *, int, struct nameidata *);
-extern int ext4_acl_chmod (struct inode *);
-extern int ext4_init_acl (handle_t *, struct inode *, struct inode *);
+extern int ext4_permission(struct inode *, int, struct nameidata *);
+extern int ext4_acl_chmod(struct inode *);
+extern int ext4_init_acl(handle_t *, struct inode *, struct inode *);
 
 #else  /* CONFIG_EXT4DEV_FS_POSIX_ACL */
 #include <linux/sched.h>
-- 
1.5.3.7
