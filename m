Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4366CC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0712220989
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 20:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfCRU2e (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 16:28:34 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33086 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727737AbfCRU2d (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Mar 2019 16:28:33 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 45EB828119F
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, jlayton@kernel.org, bfields@fieldses.org,
        paulus@samba.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v6 09/11] ext4: Support encoding-aware file name lookups
Date:   Mon, 18 Mar 2019 16:27:43 -0400
Message-Id: <20190318202745.5200-10-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190318202745.5200-1-krisman@collabora.com>
References: <20190318202745.5200-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This patch implements the actual support for encoding-aware file name
lookups in ext4, based on the feature bit and the encoding stored in the
superblock.

A filesystem that has the fname_encoding feature set is able to find
files even if the name used by userspace is not a byte per byte match,
but is an equivalent unicode string.  This operation will be called and
inexact-match name search.

* dcache handling:

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

* on-disk data:

Despite using a specific version of the name as the internal
representation within the dcache, the name stored and fetch from the
disk is a byte-per-byte match with what the user requested, making this
implementation Name-preserving. i.e. no actual information is lost when
writing to the storage.

DX is supported by modifying the hashes to make them encoding-aware.
The new disk hashes are also calculated as the hash of the normalized
string, instead of the string directly.  This allows us to efficiently
search for file names in the htree without requiring the user to provide
the exact name.

* Dealing with invalid sequences:

By default, when a invalid UTF-8 sequence is identified, ext4 will treat
it as an opaque byte sequence, ignoring the encoding and reverting to
the old behavior for that unique file.  This means that inexact-match
lookups and (future) casefold will not work for that file only.  An
optional bit can be set in the superblock telling the filesystem code
and userspace tools to enforce the encoding.  When that flag is set, any
attempt to create a file name using an invalid UTF-8 sequence will fail.

* Normalization algorithm:

The UTF-8 algorithm used to lookup and compare strings in ext4 is
implemented by fs/unicode, and is based on a previous developed by SGI.
It implements the Canonical decomposition (NFD) algorithm described by
the Unicode specification 11.0, or higher, combined with the elimination
of ignorable code points (NFDi) as documented in fs/unicode/utf8_norm.c.

NFD seems to be the best normalization method because:

  - It has a lower cost than NFC/NFKC (which requires
    decomposing to NFD as an intermediary step)
  - It doesn't eliminate important semantic meaning like NFKD.

But:

  - It ignores valid equivalent sequences in some languages, which
  would be invalid on anothers: the ff ligature, in o_ff_i_c_e, and the
  usual spelling o_f_f_i_c_e, for instance, will no longer match.  On
  the other hand, the ash grapheme (formed by a ligature of AE )
  can be represented as a different letter than A plus E, which is
  correct in Danish, Norwegian, Icelandic, and Faroese.

  - This implementation is not linguistic accurate, because different
    languages have conflicting rules, which would require the
    specialization of the filesystem to a given locale, which brings all
    sorts of problems for removable media and for users who use more
    than one language.

Changes since v4:
  - Migrate NFKD -> NFD

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
 fs/ext4/dir.c    |  40 +++++++++++++++++++
 fs/ext4/ext4.h   |  12 +++++-
 fs/ext4/hash.c   |  35 ++++++++++++++++-
 fs/ext4/ialloc.c |   2 +-
 fs/ext4/inline.c |   2 +-
 fs/ext4/namei.c  | 100 +++++++++++++++++++++++++++++++++++++++++------
 fs/ext4/super.c  |   6 +++
 7 files changed, 181 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 0ccd51f72048..ab1bc1c43063 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -26,6 +26,7 @@
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
 #include <linux/iversion.h>
+#include <linux/unicode.h>
 #include "ext4.h"
 #include "xattr.h"
 
@@ -660,3 +661,42 @@ const struct file_operations ext4_dir_operations = {
 	.open		= ext4_dir_open,
 	.release	= ext4_release_dir,
 };
+
+#ifdef CONFIG_UNICODE
+static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
+			  const char *str, const struct qstr *name)
+{
+	struct qstr qstr = {.name = str, .len = len };
+
+	return ext4_encoding_cmp(dentry->d_parent->d_inode, name, &qstr);
+}
+
+static int ext4_d_hash(const struct dentry *dentry, struct qstr *str)
+{
+	const struct ext4_sb_info *sbi = EXT4_SB(dentry->d_sb);
+	const struct unicode_map *um = sbi->s_encoding;
+	unsigned char *norm;
+	int len, ret = 0;
+
+	norm = kmalloc(PATH_MAX, GFP_ATOMIC);
+	if (!norm)
+		return -ENOMEM;
+
+	len = utf8_normalize(um, str, norm, PATH_MAX);
+
+	if (len < 0) {
+		if (ext4_has_strict_mode(sbi))
+			ret = -EINVAL;
+		goto out;
+	}
+	str->hash = full_name_hash(dentry, norm, len);
+out:
+	kfree(norm);
+	return ret;
+}
+
+const struct dentry_operations ext4_dentry_ops = {
+	.d_hash = ext4_d_hash,
+	.d_compare = ext4_d_compare,
+};
+#endif
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2039270be616..18035350b28f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2396,8 +2396,8 @@ extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
 
 /* hash.c */
-extern int ext4fs_dirhash(const char *name, int len, struct
-			  dx_hash_info *hinfo);
+extern int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
+			  struct dx_hash_info *hinfo);
 
 /* ialloc.c */
 extern struct inode *__ext4_new_inode(handle_t *, struct inode *, umode_t,
@@ -2993,6 +2993,10 @@ static inline void ext4_unlock_group(struct super_block *sb,
 /* dir.c */
 extern const struct file_operations ext4_dir_operations;
 
+#ifdef CONFIG_UNICODE
+extern const struct dentry_operations ext4_dentry_ops;
+#endif
+
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
 extern const struct file_operations ext4_file_operations;
@@ -3085,6 +3089,10 @@ extern void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
 extern int ext4_handle_dirty_dirent_node(handle_t *handle,
 					 struct inode *inode,
 					 struct buffer_head *bh);
+extern int ext4_encoding_cmp(const struct inode *parent,
+			     const struct qstr *name,
+			     const struct qstr *entry);
+
 #define S_SHIFT 12
 static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
 	[S_IFREG >> S_SHIFT]	= EXT4_FT_REG_FILE,
diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 46b24da33a28..5a33c72efc56 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/unicode.h>
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
@@ -268,3 +270,34 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 	hinfo->minor_hash = minor_hash;
 	return 0;
 }
+
+int ext4fs_dirhash(const struct inode *dir, const char *name, int len,
+		   struct dx_hash_info *hinfo)
+{
+#ifdef CONFIG_UNICODE
+	const struct unicode_map *um = EXT4_SB(dir->i_sb)->s_encoding;
+	int r, dlen;
+	unsigned char *buff;
+	struct qstr qstr = {.name = name, .len = len };
+
+	if (len && um) {
+		buff = kzalloc(sizeof(char) * PATH_MAX, GFP_KERNEL);
+		if (!buff)
+			return -1;
+
+		dlen = utf8_normalize(um, &qstr, buff, PATH_MAX);
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
index f3e17a8c84b4..764ff4c56233 100644
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
index 56f6e1782d5f..f73bc3925282 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1407,7 +1407,7 @@ int htree_inlinedir_to_tree(struct file *dir_file,
 			}
 		}
 
-		ext4fs_dirhash(de->name, de->name_len, hinfo);
+		ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
 		     (hinfo->minor_hash < start_minor_hash)))
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 980166a8122a..0caaa210be8c 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -35,6 +35,7 @@
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
 #include <linux/iversion.h>
+#include <linux/unicode.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -629,7 +630,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				}
 				if (!fscrypt_has_encryption_key(dir)) {
 					/* Directory is not encrypted */
-					ext4fs_dirhash(de->name,
+					ext4fs_dirhash(dir, de->name,
 						de->name_len, &h);
 					printk("%*.s:(U)%x.%u ", len,
 					       name, h.hash,
@@ -662,8 +663,8 @@ static struct stats dx_show_leaf(struct inode *dir,
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
@@ -673,7 +674,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 #else
 				int len = de->name_len;
 				char *name = de->name;
-				ext4fs_dirhash(de->name, de->name_len, &h);
+				ext4fs_dirhash(dir, de->name, de->name_len, &h);
 				printk("%*.s:%x.%u ", len, name, h.hash,
 				       (unsigned) ((char *) de - base));
 #endif
@@ -762,7 +763,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 	if (fname && fname_name(fname))
-		ext4fs_dirhash(fname_name(fname), fname_len(fname), hinfo);
+		ext4fs_dirhash(dir, fname_name(fname), fname_len(fname), hinfo);
 	hash = hinfo->hash;
 
 	if (root->info.unused_flags & 1) {
@@ -1008,7 +1009,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			/* silently ignore the rest of the block */
 			break;
 		}
-		ext4fs_dirhash(de->name, de->name_len, hinfo);
+		ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
 		     (hinfo->minor_hash < start_minor_hash)))
@@ -1197,7 +1198,7 @@ static int dx_make_map(struct inode *dir, struct ext4_dir_entry_2 *de,
 
 	while ((char *) de < base + blocksize) {
 		if (de->name_len && de->inode) {
-			ext4fs_dirhash(de->name, de->name_len, &h);
+			ext4fs_dirhash(dir, de->name, de->name_len, &h);
 			map_tail--;
 			map_tail->hash = h.hash;
 			map_tail->offs = ((char *) de - base)>>2;
@@ -1252,15 +1253,45 @@ static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
 	dx_set_count(entries, count + 1);
 }
 
+#ifdef CONFIG_UNICODE
+int ext4_encoding_cmp(const struct inode *parent, const struct qstr *name,
+		      const struct qstr *entry)
+{
+	const struct ext4_sb_info *sbi = EXT4_SB(parent->i_sb);
+	const struct unicode_map *um = sbi->s_encoding;
+	int ret;
+
+	ret = utf8_strncmp(um, name, entry);
+	if (ret < 0) {
+		/* Handle invalid character sequence as either an error
+		 * or as an opaque byte sequence.
+		 */
+		if (ext4_has_strict_mode(sbi))
+			return -EINVAL;
+
+		if (name->len != entry->len)
+			return 1;
+
+		return !!memcmp(name->name, entry->name, name->len);
+	}
+
+	return ret;
+}
+#endif
+
 /*
  * Test whether a directory entry matches the filename being searched for.
  *
  * Return: %true if the directory entry matches, otherwise %false.
  */
-static inline bool ext4_match(const struct ext4_filename *fname,
+static inline bool ext4_match(const struct inode *parent,
+			      const struct ext4_filename *fname,
 			      const struct ext4_dir_entry_2 *de)
 {
 	struct fscrypt_name f;
+#ifdef CONFIG_UNICODE
+	const struct qstr entry = {.name = de->name, .len = de->name_len};
+#endif
 
 	if (!de->inode)
 		return false;
@@ -1270,6 +1301,12 @@ static inline bool ext4_match(const struct ext4_filename *fname,
 #ifdef CONFIG_FS_ENCRYPTION
 	f.crypto_buf = fname->crypto_buf;
 #endif
+
+#ifdef CONFIG_UNICODE
+	if (EXT4_SB(parent->i_sb)->s_encoding)
+		return !ext4_encoding_cmp(parent, fname->usr_fname, &entry);
+#endif
+
 	return fscrypt_match_name(&f, de->name, de->name_len);
 }
 
@@ -1290,7 +1327,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 		if ((char *) de + de->name_len <= dlimit &&
-		    ext4_match(fname, de)) {
+		    ext4_match(dir, fname, de)) {
 			/* found a match - just to be sure, do
 			 * a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
@@ -1588,6 +1625,17 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 			return ERR_PTR(-EPERM);
 		}
 	}
+
+#ifdef CONFIG_UNICODE
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
 
@@ -1798,7 +1846,7 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 buf, buf_size, offset))
 			return -EFSCORRUPTED;
-		if (ext4_match(fname, de))
+		if (ext4_match(dir, fname, de))
 			return -EEXIST;
 		nlen = EXT4_DIR_REC_LEN(de->name_len);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
@@ -1983,7 +2031,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	if (fname->hinfo.hash_version <= DX_HASH_TEA)
 		fname->hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	fname->hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
-	ext4fs_dirhash(fname_name(fname), fname_len(fname), &fname->hinfo);
+	ext4fs_dirhash(dir, fname_name(fname), fname_len(fname), &fname->hinfo);
 
 	memset(frames, 0, sizeof(frames));
 	frame = frames;
@@ -2036,6 +2084,7 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	struct ext4_dir_entry_2 *de;
 	struct ext4_dir_entry_tail *t;
 	struct super_block *sb;
+	struct ext4_sb_info *sbi;
 	struct ext4_filename fname;
 	int	retval;
 	int	dx_fallback=0;
@@ -2047,10 +2096,17 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	sb = dir->i_sb;
+	sbi = EXT4_SB(sb);
 	blocksize = sb->s_blocksize;
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+#ifdef CONFIG_UNICODE
+	if (sbi->s_encoding_flags & EXT4_ENC_STRICT_MODE_FL &&
+	    utf8_validate(sbi->s_encoding, &dentry->d_name))
+		return -EINVAL;
+#endif
+
 	retval = ext4_fname_setup_filename(dir, &dentry->d_name, 0, &fname);
 	if (retval)
 		return retval;
@@ -2975,6 +3031,17 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	ext4_update_dx_flag(dir);
 	ext4_mark_inode_dirty(handle, dir);
 
+#ifdef CONFIG_UNICODE
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
@@ -3044,6 +3111,17 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	inode->i_ctime = current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 
+#ifdef CONFIG_UNICODE
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
index f9a194c086e4..29f06f4fb0c7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4443,6 +4443,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		iput(root);
 		goto failed_mount4;
 	}
+
+#ifdef CONFIG_UNICODE
+	if (sbi->s_encoding)
+		sb->s_d_op = &ext4_dentry_ops;
+#endif
+
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		ext4_msg(sb, KERN_ERR, "get root dentry failed");
-- 
2.20.1

