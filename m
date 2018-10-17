Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50190 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbeJREyS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 00:54:18 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 21/23] ext4: Support encoding-aware file name lookups
Date: Wed, 17 Oct 2018 16:55:22 -0400
Message-Id: <20181017205524.23360-22-krisman@collabora.co.uk>
In-Reply-To: <20181017205524.23360-1-krisman@collabora.co.uk>
References: <20181017205524.23360-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch implements the actual support for encoding-aware file name
lookups in ext4, based on the feature bit and the encoding stored in the
superblock.

A filesystem that has the encoding feature set is able to find files
even if the name used by userspace is not exactly the same, but if it is
an equivalent string.  This operation will be called and inexact-match
name search.

Ext4 only stores the first equivalent name dentry used in the
dcache. This is done to prevent unintentional duplication of dentries in
the dcache, while also allowing the VFS code to quickly find the right
entry in the cache despite what equivalent string was used without
resorting to ->lookup().

d_hash() is implemented as the hash of the normalized string, such that
we always have a well-known bucket for all the equivalencies of the same
string. d_compare uses the nls_strncmp() infrastructure, which should
handle the comparison of equivalent names as well.  If the filesystem's
normalization type is PLAIN, though, we can just reuse the VFS hash.

For now, negative lookups are not inserted in the dcache, since they
would need to be invalidated anyway, because we can't trust missing file
dentries.  This is bad for performance but requires some leveraging of
the vfs layer to fix.  We can live without that for now, and so does
everyone else.

DX is supported by modifying the hashes to make them encoding-aware.
The new disk hashes are also calculated as the hash of the normalized
string, instead of the string directly.  This allows us to efficiently
search for file names in the htree without requiring the user to provide
the exact name.

Changes since v2:
  - Don't use d_add_ci.
  - Squash the dcache hooks into this patch.
  - Rename sbi->encoding -> sbi->s_encoding.

Changes since v1:
  - Support normalized htree hashes.
  - Guard code with CONFIG_NLS.
  - Use qstr->len instead of strlen in dcache hookups.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/dir.c    | 45 ++++++++++++++++++++++++++++
 fs/ext4/ext4.h   | 12 ++++++--
 fs/ext4/hash.c   | 34 ++++++++++++++++++++-
 fs/ext4/ialloc.c |  2 +-
 fs/ext4/inline.c |  2 +-
 fs/ext4/namei.c  | 78 +++++++++++++++++++++++++++++++++++++++++-------
 fs/ext4/super.c  |  6 ++++
 7 files changed, 163 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index f93f9881ec18..efb75c204551 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -26,6 +26,7 @@
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
 #include <linux/iversion.h>
+#include <linux/nls.h>
 #include "ext4.h"
 #include "xattr.h"
 
@@ -662,3 +663,47 @@ const struct file_operations ext4_dir_operations = {
 	.open		= ext4_dir_open,
 	.release	= ext4_release_dir,
 };
+
+#ifdef CONFIG_NLS
+static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
+			  const char *str, const struct qstr *name)
+{
+	struct nls_table *charset = EXT4_SB(dentry->d_sb)->s_encoding;
+
+	return nls_strncmp(charset, str, len, name->name, name->len);
+}
+
+static int ext4_d_hash(const struct dentry *dentry, struct qstr *q)
+{
+	const struct nls_table *charset = EXT4_SB(dentry->d_sb)->s_encoding;
+	unsigned char *norm;
+	int len, ret = 0;
+
+	/* If normalization is TYPE_PLAIN, we can just reuse the vfs
+	 * hash. */
+	if (IS_NORMALIZATION_TYPE_ALL_PLAIN(charset))
+	    return 0;
+
+	norm = kmalloc(PATH_MAX, GFP_ATOMIC);
+	if (!norm)
+		return -ENOMEM;
+
+	len = nls_normalize(charset, q->name, q->len, norm, PATH_MAX);
+
+	if (len < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	q->hash = full_name_hash(dentry, norm, len);
+
+out:
+	kfree (norm);
+	return ret;
+}
+
+const struct dentry_operations ext4_dentry_ops = {
+	.d_hash = ext4_d_hash,
+	.d_compare = ext4_d_compare,
+};
+#endif
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9fa952c6ba4d..03f86c8d07e0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1347,6 +1347,11 @@ struct ext4_super_block {
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 3
 
+/*
+ * Flags for ext4_sb_info.s_encoding_flags.  Be careful when modifying
+ * these, as they must match their NLS counterpart. */
+#define EXT4_ENC_STRICT_MODE_FL	0x0001
+
 /*
  * fourth extended-fs super-block data in memory
  */
@@ -2393,8 +2398,8 @@ extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
 
 /* hash.c */
-extern int ext4fs_dirhash(const char *name, int len, struct
-			  dx_hash_info *hinfo);
+extern int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
+			  struct dx_hash_info *hinfo);
 
 /* ialloc.c */
 extern struct inode *__ext4_new_inode(handle_t *, struct inode *, umode_t,
@@ -2977,6 +2982,9 @@ static inline void ext4_unlock_group(struct super_block *sb,
 
 /* dir.c */
 extern const struct file_operations ext4_dir_operations;
+#ifdef CONFIG_NLS
+extern const struct dentry_operations ext4_dentry_ops;
+#endif
 
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index e22dcfab308b..8ec9c7145987 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/nls.h>
 #include <linux/compiler.h>
 #include <linux/bitops.h>
 #include "ext4.h"
@@ -196,7 +197,8 @@ static void str2hashbuf_unsigned(const char *msg, int len, __u32 *buf, int num)
  * represented, and whether or not the returned hash is 32 bits or 64
  * bits.  32 bit hashes will return 0 for the minor hash.
  */
-int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
+static int __ext4fs_dirhash(const char *name, int len,
+			    struct dx_hash_info *hinfo)
 {
 	__u32	hash;
 	__u32	minor_hash = 0;
@@ -266,3 +268,33 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 	hinfo->minor_hash = minor_hash;
 	return 0;
 }
+
+int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
+		   struct dx_hash_info *hinfo)
+{
+#ifdef CONFIG_NLS
+	const struct nls_table *charset = EXT4_SB(dir->i_sb)->s_encoding;
+	int r, dlen;
+	unsigned char *buff;
+
+	if (len && charset) {
+		buff = kzalloc(sizeof (char) * PATH_MAX, GFP_KERNEL);
+		if (!buff)
+			return -1;
+
+		dlen = nls_normalize(charset, name, len, buff, PATH_MAX);
+
+		if (dlen < 0) {
+			kfree(buff);
+			goto opaque_seq;
+		}
+
+		r = __ext4fs_dirhash(buff, dlen, hinfo);
+
+		kfree(buff);
+		return r;
+	}
+opaque_seq:
+#endif
+	return __ext4fs_dirhash(name, len, hinfo);
+}
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2addcb8730e1..5a8265540343 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -455,7 +455,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 		if (qstr) {
 			hinfo.hash_version = DX_HASH_HALF_MD4;
 			hinfo.seed = sbi->s_hash_seed;
-			ext4fs_dirhash(qstr->name, qstr->len, &hinfo);
+			ext4fs_dirhash(parent, qstr->name, qstr->len, &hinfo);
 			grp = hinfo.hash;
 		} else
 			grp = prandom_u32();
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 9c4bac18cc6c..10b9d3dcec4e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1404,7 +1404,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 			}
 		}
 
-		ext4fs_dirhash(de->name, de->name_len, hinfo);
+		ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
 		     (hinfo->minor_hash < start_minor_hash)))
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 67a38532032a..5c6f78c0a6f9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
 #include <linux/iversion.h>
+#include <linux/nls.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -628,7 +629,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				}
 				if (!fscrypt_has_encryption_key(dir)) {
 					/* Directory is not encrypted */
-					ext4fs_dirhash(de->name,
+					ext4fs_dirhash(dir, de->name,
 						de->name_len, &h);
 					printk("%*.s:(U)%x.%u ", len,
 					       name, h.hash,
@@ -661,8 +662,8 @@ static struct stats dx_show_leaf(struct inode *dir,
 						name = fname_crypto_str.name;
 						len = fname_crypto_str.len;
 					}
-					ext4fs_dirhash(de->name, de->name_len,
-						       &h);
+					ext4fs_dirhash(dir, de->name,
+						       de->name_len, &h);
 					printk("%*.s:(E)%x.%u ", len, name,
 					       h.hash, (unsigned) ((char *) de
 								   - base));
@@ -672,7 +673,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 #else
 				int len = de->name_len;
 				char *name = de->name;
-				ext4fs_dirhash(de->name, de->name_len, &h);
+				ext4fs_dirhash(dir, de->name, de->name_len, &h);
 				printk("%*.s:%x.%u ", len, name, h.hash,
 				       (unsigned) ((char *) de - base));
 #endif
@@ -761,7 +762,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 	if (fname && fname_name(fname))
-		ext4fs_dirhash(fname_name(fname), fname_len(fname), hinfo);
+		ext4fs_dirhash(dir, fname_name(fname), fname_len(fname), hinfo);
 	hash = hinfo->hash;
 
 	if (root->info.unused_flags & 1) {
@@ -1007,7 +1008,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			/* silently ignore the rest of the block */
 			break;
 		}
-		ext4fs_dirhash(de->name, de->name_len, hinfo);
+		ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
 		     (hinfo->minor_hash < start_minor_hash)))
@@ -1196,7 +1197,7 @@ static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
 
 	while ((char *) de < base + blocksize) {
 		if (de->name_len && de->inode) {
-			ext4fs_dirhash(de->name, de->name_len, &h);
+			ext4fs_dirhash(dir, de->name, de->name_len, &h);
 			map_tail--;
 			map_tail->hash = h.hash;
 			map_tail->offs = ((char *) de - base)>>2;
@@ -1256,10 +1257,14 @@ static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
  *
  * Return: %true if the directory entry matches, otherwise %false.
  */
-static inline bool ext4_match(const struct ext4_filename *fname,
+static inline bool ext4_match(const struct inode *parent,
+			      const struct ext4_filename *fname,
 			      const struct ext4_dir_entry_2 *de)
 {
 	struct fscrypt_name f;
+#ifdef CONFIG_NLS
+	const struct ext4_sb_info *sbi = EXT4_SB(parent->i_sb);
+#endif
 
 	if (!de->inode)
 		return false;
@@ -1269,6 +1274,15 @@ static inline bool ext4_match(const struct ext4_filename *fname,
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	f.crypto_buf = fname->crypto_buf;
 #endif
+
+#ifdef CONFIG_NLS
+	if (sbi->s_encoding) {
+		return !nls_strncmp(sbi->s_encoding,
+				    de->name, de->name_len,
+				    f.disk_name.name, f.disk_name.len);
+	}
+#endif
+
 	return fscrypt_match_name(&f, de->name, de->name_len);
 }
 
@@ -1289,7 +1303,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 		if ((char *) de + de->name_len <= dlimit &&
-		    ext4_match(fname, de)) {
+		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
@@ -1587,6 +1601,17 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 			return ERR_PTR(-EPERM);
 		}
 	}
+
+#ifdef CONFIG_NLS
+	if (EXT4_SB(dir->i_sb)->s_encoding && !inode) {
+		/* Eventually we want to call d_add_ci(dentry, NULL)
+		 * for negative dentries in the encoding case as
+		 * well.  For now, prevent the negative dentry
+		 * from being cached.
+		 */
+		return NULL;
+	}
+#endif
 	return d_splice_alias(inode, dentry);
 }
 
@@ -1797,7 +1822,7 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 buf, buf_size, offset))
 			return -EFSCORRUPTED;
-		if (ext4_match(fname, de))
+		if (ext4_match(dir, fname, de))
 			return -EEXIST;
 		nlen = EXT4_DIR_REC_LEN(de->name_len);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
@@ -1982,7 +2007,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	if (fname->hinfo.hash_version <= DX_HASH_TEA)
 		fname->hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	fname->hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
-	ext4fs_dirhash(fname_name(fname), fname_len(fname), &fname->hinfo);
+	ext4fs_dirhash(dir, fname_name(fname), fname_len(fname), &fname->hinfo);
 
 	memset(frames, 0, sizeof(frames));
 	frame = frames;
@@ -2035,6 +2060,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	struct ext4_dir_entry_2 *de;
 	struct ext4_dir_entry_tail *t;
 	struct super_block *sb;
+	struct ext4_sb_info *sbi;
 	struct ext4_filename fname;
 	int	retval;
 	int	dx_fallback=0;
@@ -2046,10 +2072,18 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	sb = dir->i_sb;
+	sbi = EXT4_SB(sb);
 	blocksize = sb->s_blocksize;
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+#ifdef CONFIG_NLS
+	if (sbi->s_encoding_flags & EXT4_ENC_STRICT_MODE_FL &&
+	    nls_validate(sbi->s_encoding, dentry->d_name.name,
+			 dentry->d_name.len))
+		return -EINVAL;
+#endif
+
 	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
 	if (retval)
 		return retval;
@@ -2972,6 +3006,17 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
 
+#ifdef CONFIG_NLS
+	/* VFS negative dentries are incompatible with Encoding and
+	 * Case-insensitiveness. Eventually we'll want avoid
+	 * invalidating the dentries here, alongside with returning the
+	 * negative dentries at ext4_lookup(), when it is better
+	 * supported by the VFS for the CI case.
+	 */
+	if (EXT4_SB(dir->i_sb)->s_encoding)
+		d_invalidate(dentry);
+#endif
+
 end_rmdir:
 	brelse(bh);
 	if (handle)
@@ -3041,6 +3086,17 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	inode->i_ctime = current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 
+#ifdef CONFIG_NLS
+	/* VFS negative dentries are incompatible with Encoding and
+	 * Case-insensitiveness. Eventually we'll want avoid
+	 * invalidating the dentries here, alongside with returning the
+	 * negative dentries at ext4_lookup(), when it is  better
+	 * supported by the VFS for the CI case.
+	 */
+	if (EXT4_SB(dir->i_sb)->s_encoding)
+		d_invalidate(dentry);
+#endif
+
 end_unlink:
 	brelse(bh);
 	if (handle)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a09a72e7ee58..7fb00468e8fd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4406,6 +4406,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		iput(root);
 		goto failed_mount4;
 	}
+
+#ifdef CONFIG_NLS
+	if (sbi->s_encoding)
+		sb->s_d_op = &ext4_dentry_ops;
+#endif
+
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		ext4_msg(sb, KERN_ERR, "get root dentry failed");
-- 
2.19.1
