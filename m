From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 27/32] fuse2fs: translate ACL structures
Date: Sat, 01 Mar 2014 23:19:32 -0800
Message-ID: <20140302071932.28217.65884.stgit@birch.djwong.org>
References: <20140302071639.28217.57302.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44430 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaCBHTh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 02:19:37 -0500
In-Reply-To: <20140302071639.28217.57302.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Translate "native" ACL structures into ext4 ACL structures when
reading or writing the ACL EAs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure      |    3 +
 configure.in   |    7 +-
 misc/fuse2fs.c |  260 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 263 insertions(+), 7 deletions(-)


diff --git a/configure b/configure
index ce6a4ef..6cf6380 100755
--- a/configure
+++ b/configure
@@ -11228,6 +11228,7 @@ else
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#define _FILE_OFFSET_BITS	64
+#define FUSE_USE_VERSION 29
 "
 if eval test \"x\$"$as_ac_Header"\" = x"yes"; then :
   cat >>confdefs.h <<_ACEOF
@@ -11246,6 +11247,7 @@ done
 
 	cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
+#define FUSE_USE_VERSION 29
 #ifdef __linux__
 #include <linux/fs.h>
 #include <linux/falloc.h>
@@ -11365,6 +11367,7 @@ else
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "#define _FILE_OFFSET_BITS	64
+#define FUSE_USE_VERSION 29
 #ifdef __linux__
 # include <linux/fs.h>
 # include <linux/falloc.h>
diff --git a/configure.in b/configure.in
index 2c455af..2ceca2d 100644
--- a/configure.in
+++ b/configure.in
@@ -1177,10 +1177,12 @@ then
 else
 	AC_CHECK_HEADERS([pthread.h fuse.h], [],
 [AC_MSG_FAILURE([Cannot find fuse2fs headers.])],
-[#define _FILE_OFFSET_BITS	64])
+[#define _FILE_OFFSET_BITS	64
+#define FUSE_USE_VERSION 29])
 
 	AC_PREPROC_IFELSE(
-[AC_LANG_PROGRAM([[#ifdef __linux__
+[AC_LANG_PROGRAM([[#define FUSE_USE_VERSION 29
+#ifdef __linux__
 #include <linux/fs.h>
 #include <linux/falloc.h>
 #include <linux/xattr.h>
@@ -1195,6 +1197,7 @@ fi
 ,
 AC_CHECK_HEADERS([pthread.h fuse.h], [], [FUSE_CMT="#"],
 [#define _FILE_OFFSET_BITS	64
+#define FUSE_USE_VERSION 29
 #ifdef __linux__
 # include <linux/fs.h>
 # include <linux/falloc.h>
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 8dc3c4e..a790d85 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -17,9 +17,13 @@
 # include <linux/falloc.h>
 # include <linux/xattr.h>
 # define FUSE_PLATFORM_OPTS	",nonempty,big_writes"
+# define TRANSLATE_LINUX_ACLS
 #else
 # define FUSE_PLATFORM_OPTS	""
 #endif
+#ifdef TRANSLATE_LINUX_ACLS
+# include <sys/acl.h>
+#endif
 #include <sys/ioctl.h>
 #include <unistd.h>
 #include <fuse.h>
@@ -59,6 +63,199 @@ static ext2_filsys global_fs; /* Try not to use this directly */
 # define FL_PUNCH_HOLE_FLAG (0)
 #endif
 
+/* ACL translation stuff */
+#ifdef TRANSLATE_LINUX_ACLS
+/*
+ * Copied from acl_ea.h in libacl source; ACLs have to be sent to and from fuse
+ * in this format... at least on Linux.
+ */
+#define ACL_EA_ACCESS		"system.posix_acl_access"
+#define ACL_EA_DEFAULT		"system.posix_acl_default"
+
+#define ACL_EA_VERSION		0x0002
+
+typedef struct {
+	u_int16_t	e_tag;
+	u_int16_t	e_perm;
+	u_int32_t	e_id;
+} acl_ea_entry;
+
+typedef struct {
+	u_int32_t	a_version;
+	acl_ea_entry	a_entries[0];
+} acl_ea_header;
+
+static inline size_t acl_ea_size(int count)
+{
+	return sizeof(acl_ea_header) + count * sizeof(acl_ea_entry);
+}
+
+static inline int acl_ea_count(size_t size)
+{
+	if (size < sizeof(acl_ea_header))
+		return -1;
+	size -= sizeof(acl_ea_header);
+	if (size % sizeof(acl_ea_entry))
+		return -1;
+	return size / sizeof(acl_ea_entry);
+}
+
+/*
+ * ext4 ACL structures, copied from fs/ext4/acl.h.
+ */
+#define EXT4_ACL_VERSION	0x0001
+
+typedef struct {
+	__u16		e_tag;
+	__u16		e_perm;
+	__u32		e_id;
+} ext4_acl_entry;
+
+typedef struct {
+	__u16		e_tag;
+	__u16		e_perm;
+} ext4_acl_entry_short;
+
+typedef struct {
+	__u32		a_version;
+} ext4_acl_header;
+
+static inline size_t ext4_acl_size(int count)
+{
+	if (count <= 4) {
+		return sizeof(ext4_acl_header) +
+		       count * sizeof(ext4_acl_entry_short);
+	} else {
+		return sizeof(ext4_acl_header) +
+		       4 * sizeof(ext4_acl_entry_short) +
+		       (count - 4) * sizeof(ext4_acl_entry);
+	}
+}
+
+static inline int ext4_acl_count(size_t size)
+{
+	ssize_t s;
+	size -= sizeof(ext4_acl_header);
+	s = size - 4 * sizeof(ext4_acl_entry_short);
+	if (s < 0) {
+		if (size % sizeof(ext4_acl_entry_short))
+			return -1;
+		return size / sizeof(ext4_acl_entry_short);
+	} else {
+		if (s % sizeof(ext4_acl_entry))
+			return -1;
+		return s / sizeof(ext4_acl_entry) + 4;
+	}
+}
+
+static errcode_t fuse_to_ext4_acl(acl_ea_header *facl, size_t facl_sz,
+				  ext4_acl_header **eacl, size_t *eacl_sz)
+{
+	int i, facl_count;
+	ext4_acl_header *h;
+	size_t h_sz;
+	ext4_acl_entry *e;
+	acl_ea_entry *a;
+	void *hptr;
+	errcode_t err;
+
+	facl_count = acl_ea_count(facl_sz);
+	h_sz = ext4_acl_size(facl_count);
+	if (h_sz < 0 || facl_count < 0 || facl->a_version != ACL_EA_VERSION)
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	err = ext2fs_get_mem(h_sz, &h);
+	if (err)
+		return err;
+
+	h->a_version = ext2fs_cpu_to_le32(EXT4_ACL_VERSION);
+	hptr = h + 1;
+	for (i = 0, a = facl->a_entries; i < facl_count; i++, a++) {
+		e = hptr;
+		e->e_tag = ext2fs_cpu_to_le16(a->e_tag);
+		e->e_perm = ext2fs_cpu_to_le16(a->e_perm);
+
+		switch (a->e_tag) {
+		case ACL_USER:
+		case ACL_GROUP:
+			e->e_id = ext2fs_cpu_to_le32(a->e_id);
+			hptr += sizeof(ext4_acl_entry);
+			break;
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			hptr += sizeof(ext4_acl_entry_short);
+			break;
+		default:
+			err = EXT2_ET_INVALID_ARGUMENT;
+			goto out;
+		}
+	}
+
+	*eacl = h;
+	*eacl_sz = h_sz;
+	return err;
+out:
+	ext2fs_free_mem(&h);
+	return err;
+}
+
+static errcode_t ext4_to_fuse_acl(acl_ea_header **facl, size_t *facl_sz,
+				  ext4_acl_header *eacl, size_t eacl_sz)
+{
+	int i, eacl_count;
+	acl_ea_header *f;
+	ext4_acl_entry *e;
+	acl_ea_entry *a;
+	size_t f_sz;
+	void *hptr;
+	errcode_t err;
+
+	eacl_count = ext4_acl_count(eacl_sz);
+	f_sz = acl_ea_size(eacl_count);
+	if (f_sz < 0 || eacl_count < 0 ||
+	    eacl->a_version != ext2fs_cpu_to_le32(EXT4_ACL_VERSION))
+		return EXT2_ET_INVALID_ARGUMENT;
+
+	err = ext2fs_get_mem(f_sz, &f);
+	if (err)
+		return err;
+
+	f->a_version = ACL_EA_VERSION;
+	hptr = eacl + 1;
+	for (i = 0, a = f->a_entries; i < eacl_count; i++, a++) {
+		e = hptr;
+		a->e_tag = ext2fs_le16_to_cpu(e->e_tag);
+		a->e_perm = ext2fs_le16_to_cpu(e->e_perm);
+
+		switch (a->e_tag) {
+		case ACL_USER:
+		case ACL_GROUP:
+			a->e_id = ext2fs_le32_to_cpu(e->e_id);
+			hptr += sizeof(ext4_acl_entry);
+			break;
+		case ACL_USER_OBJ:
+		case ACL_GROUP_OBJ:
+		case ACL_MASK:
+		case ACL_OTHER:
+			hptr += sizeof(ext4_acl_entry_short);
+			break;
+		default:
+			err = EXT2_ET_INVALID_ARGUMENT;
+			goto out;
+		}
+	}
+
+	*facl = f;
+	*facl_sz = f_sz;
+	return err;
+out:
+	ext2fs_free_mem(&f);
+	return err;
+}
+#endif /* TRANSLATE_LINUX_ACLS */
+
 /*
  * ext2_file_t contains a struct inode, so we can't leave files open.
  * Use this as a proxy instead.
@@ -2100,6 +2297,30 @@ static int op_statfs(const char *path, struct statvfs *buf)
 	return 0;
 }
 
+typedef errcode_t (*xattr_xlate_get)(void **cooked_buf, size_t *cooked_sz,
+				     const void *raw_buf, size_t raw_sz);
+typedef errcode_t (*xattr_xlate_set)(const void *cooked_buf, size_t cooked_sz,
+				     void **raw_buf, size_t *raw_sz);
+struct xattr_translate {
+	const char *prefix;
+	xattr_xlate_get get;
+	xattr_xlate_set set;
+};
+
+#define XATTR_TRANSLATOR(p, g, s) \
+	{.prefix = (p), \
+	 .get = (xattr_xlate_get)(g), \
+	 .set = (xattr_xlate_set)(s)}
+
+static struct xattr_translate xattr_translators[] = {
+#ifdef TRANSLATE_LINUX_ACLS
+	XATTR_TRANSLATOR(ACL_EA_ACCESS, ext4_to_fuse_acl, fuse_to_ext4_acl),
+	XATTR_TRANSLATOR(ACL_EA_DEFAULT, ext4_to_fuse_acl, fuse_to_ext4_acl),
+#endif
+	XATTR_TRANSLATOR(NULL, NULL, NULL),
+};
+#undef XATTR_TRANSLATOR
+
 static int op_getxattr(const char *path, const char *key, char *value,
 		       size_t len)
 {
@@ -2107,8 +2328,9 @@ static int op_getxattr(const char *path, const char *key, char *value,
 	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
 	ext2_filsys fs;
 	struct ext2_xattr_handle *h;
-	void *ptr;
-	size_t plen;
+	struct xattr_translate *xt;
+	void *ptr, *cptr;
+	size_t plen, clen;
 	ext2_ino_t ino;
 	errcode_t err;
 	int ret = 0;
@@ -2151,6 +2373,17 @@ static int op_getxattr(const char *path, const char *key, char *value,
 		goto out2;
 	}
 
+	for (xt = xattr_translators; xt->prefix != NULL; xt++) {
+		if (strncmp(key, xt->prefix, strlen(xt->prefix)) == 0) {
+			err = xt->get(&cptr, &clen, ptr, plen);
+			if (err)
+				goto out3;
+			ext2fs_free_mem(&ptr);
+			ptr = cptr;
+			plen = clen;
+		}
+	}
+
 	if (!len) {
 		ret = plen;
 	} else if (len < plen) {
@@ -2160,6 +2393,7 @@ static int op_getxattr(const char *path, const char *key, char *value,
 		ret = plen;
 	}
 
+out3:
 	ext2fs_free_mem(&ptr);
 out2:
 	err = ext2fs_xattrs_close(&h);
@@ -2274,6 +2508,9 @@ static int op_setxattr(const char *path, const char *key, const char *value,
 	struct fuse2fs *ff = (struct fuse2fs *)ctxt->private_data;
 	ext2_filsys fs;
 	struct ext2_xattr_handle *h;
+	struct xattr_translate *xt;
+	void *cvalue;
+	size_t clen;
 	ext2_ino_t ino;
 	errcode_t err;
 	int ret = 0;
@@ -2313,19 +2550,32 @@ static int op_setxattr(const char *path, const char *key, const char *value,
 		goto out2;
 	}
 
-	err = ext2fs_xattr_set(h, key, value, len);
+	cvalue = (void *)value;
+	clen = len;
+	for (xt = xattr_translators; xt->prefix != NULL; xt++) {
+		if (strncmp(key, xt->prefix, strlen(xt->prefix)) == 0) {
+			err = xt->set(value, len, &cvalue, &clen);
+			if (err)
+				goto out3;
+		}
+	}
+
+	err = ext2fs_xattr_set(h, key, cvalue, clen);
 	if (err) {
 		ret = translate_error(fs, ino, err);
-		goto out2;
+		goto out3;
 	}
 
 	err = ext2fs_xattrs_write(h);
 	if (err) {
 		ret = translate_error(fs, ino, err);
-		goto out2;
+		goto out3;
 	}
 
 	ret = update_ctime(fs, ino, NULL);
+out3:
+	if (cvalue != value)
+		ext2fs_free_mem(&cvalue);
 out2:
 	err = ext2fs_xattrs_close(&h);
 	if (!ret && err)

