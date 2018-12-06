Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56166 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbeLFXKb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 18:10:31 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, kernel@collabora.com,
        linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 22/23] ext4: Implement EXT4_CASEFOLD_FL flag
Date: Thu,  6 Dec 2018 18:09:02 -0500
Message-Id: <20181206230903.30011-23-krisman@collabora.com>
In-Reply-To: <20181206230903.30011-1-krisman@collabora.com>
References: <20181206230903.30011-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Casefold is a flag applied to directories and inherited by its children
which states that the directory requires case-insensitive searches.
This flag can only be enabled on empty directories for filesystems that
support the encoding feature, thus preventing collision of file names
that only differ by case.

Enconding-awareness is also required because we consider the casefold
operation not be defined for opaque byte sequences.

Changes since v2:
  - Rename sbi->encoding -> sbi->s_encoding.

Changes since v1:
  - Moved the CASEFOLD_FL to prevent collision with reserved verity flag.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/dir.c      | 30 ++++++++++++++++++++++--------
 fs/ext4/ext4.h     |  7 ++++---
 fs/ext4/hash.c     |  6 +++++-
 fs/ext4/inode.c    |  4 +++-
 fs/ext4/ioctl.c    | 18 ++++++++++++++++++
 fs/ext4/namei.c    | 13 ++++++++++---
 include/linux/fs.h |  2 ++
 7 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index efb75c204551..43b91747f7e7 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -670,6 +670,10 @@ static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
 {
 	struct nls_table *charset = EXT4_SB(dentry->d_sb)->s_encoding;
 
+	if (IS_CASEFOLDED(dentry->d_parent->d_inode))
+		return nls_strncasecmp(charset, str, len, name->name,
+				       name->len);
+
 	return nls_strncmp(charset, str, len, name->name, name->len);
 }
 
@@ -679,16 +683,26 @@ static int ext4_d_hash(const struct dentry *dentry, struct qstr *q)
 	unsigned char *norm;
 	int len, ret = 0;
 
-	/* If normalization is TYPE_PLAIN, we can just reuse the vfs
-	 * hash. */
-	if (IS_NORMALIZATION_TYPE_ALL_PLAIN(charset))
-	    return 0;
+	if (!IS_CASEFOLDED(dentry->d_inode)) {
 
-	norm = kmalloc(PATH_MAX, GFP_ATOMIC);
-	if (!norm)
-		return -ENOMEM;
+		/* If normalization is TYPE_PLAIN, we can just reuse the
+		 * VFS hash.
+		 */
+		if (IS_NORMALIZATION_TYPE_ALL_PLAIN(charset))
+			return 0;
 
-	len = nls_normalize(charset, q->name, q->len, norm, PATH_MAX);
+		norm = kmalloc(PATH_MAX, GFP_ATOMIC);
+		if (!norm)
+			return -ENOMEM;
+
+		len = nls_normalize(charset, q->name, q->len, norm, PATH_MAX);
+	} else {
+		norm = kmalloc(PATH_MAX, GFP_ATOMIC);
+		if (!norm)
+			return -ENOMEM;
+
+		len = nls_casefold(charset, q->name, q->len, norm, PATH_MAX);
+	}
 
 	if (len < 0) {
 		ret = -EINVAL;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e84a6605a19a..d21ed5e88302 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -400,10 +400,11 @@ struct flex_groups {
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
 #define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
+#define EXT4_CASEFOLD_FL		0x40000000 /* Casefolded file */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x304BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x204BC0FF /* User modifiable flags */
+#define EXT4_FL_USER_VISIBLE		0x704BDFFF /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x604BC0FF /* User modifiable flags */
 
 /* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
 #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
@@ -418,7 +419,7 @@ struct flex_groups {
 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
 			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
-			   EXT4_PROJINHERIT_FL)
+			   EXT4_PROJINHERIT_FL | EXT4_CASEFOLD_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 8ec9c7145987..78cb97664a33 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -282,7 +282,11 @@ int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 		if (!buff)
 			return -1;
 
-		dlen = nls_normalize(charset, name, len, buff, PATH_MAX);
+		if (!IS_CASEFOLDED(dir))
+			dlen = nls_normalize(charset, name, len, buff,
+					     PATH_MAX);
+		else
+			dlen = nls_casefold(charset, name, len, buff, PATH_MAX);
 
 		if (dlen < 0) {
 			kfree(buff);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 22a9d8159720..9908d7d98b6e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4745,9 +4745,11 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_DAX;
 	if (flags & EXT4_ENCRYPT_FL)
 		new_fl |= S_ENCRYPTED;
+	if (flags & EXT4_CASEFOLD_FL)
+		new_fl |= S_CASEFOLD;
 	inode_set_flags(inode, new_fl,
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX|
-			S_ENCRYPTED);
+			S_ENCRYPTED|S_CASEFOLD);
 }
 
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0edee31913d1..ef4ffe681836 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -231,6 +231,7 @@ static int ext4_ioctl_setflags(struct inode *inode,
 	struct ext4_iloc iloc;
 	unsigned int oldflags, mask, i;
 	unsigned int jflag;
+	struct super_block *sb = inode->i_sb;
 
 	/* Is it quota file? Do not allow user to mess with it */
 	if (ext4_is_quota_file(inode))
@@ -275,6 +276,23 @@ static int ext4_ioctl_setflags(struct inode *inode,
 			goto flags_out;
 	}
 
+	if ((flags ^ oldflags) & EXT4_CASEFOLD_FL) {
+		if (!ext4_has_feature_fname_encoding(sb)) {
+			err = -EOPNOTSUPP;
+			goto flags_out;
+		}
+
+		if (!S_ISDIR(inode->i_mode)) {
+			err = -ENOTDIR;
+			goto flags_out;
+		}
+
+		if (!ext4_empty_dir(inode)) {
+			err = -ENOTEMPTY;
+			goto flags_out;
+		}
+	}
+
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 23e0e911b3fe..a21f0d7227db 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1278,9 +1278,16 @@ static inline bool ext4_match(const struct inode *parent,
 
 #ifdef CONFIG_NLS
 	if (sbi->s_encoding) {
-		return !nls_strncmp(sbi->s_encoding,
-				    de->name, de->name_len,
-				    f.disk_name.name, f.disk_name.len);
+		if (!IS_CASEFOLDED(parent))
+			return !nls_strncmp(sbi->s_encoding,
+					    de->name, de->name_len,
+					    fname->disk_name.name,
+					    fname->disk_name.len);
+		else
+			return !nls_strncasecmp(sbi->s_encoding,
+						de->name, de->name_len,
+						fname->disk_name.name,
+						fname->disk_name.len);
 	}
 #endif
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c95c0807471f..69abaca207c0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1947,6 +1947,7 @@ struct super_operations {
 #define S_DAX		0	/* Make all the DAX code disappear */
 #endif
 #define S_ENCRYPTED	16384	/* Encrypted file (using fs/crypto/) */
+#define S_CASEFOLD	32768	/* Casefolded file */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1987,6 +1988,7 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 #define IS_DAX(inode)		((inode)->i_flags & S_DAX)
 #define IS_ENCRYPTED(inode)	((inode)->i_flags & S_ENCRYPTED)
+#define IS_CASEFOLDED(inode)	((inode)->i_flags & S_CASEFOLD)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
-- 
2.20.0.rc2
