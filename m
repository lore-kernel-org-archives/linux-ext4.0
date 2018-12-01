Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:32970 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbeLALvU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 06:51:20 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 5/9] lib/ext2fs: Support encoding when calculating dx hashes
Date: Fri, 30 Nov 2018 19:39:06 -0500
Message-Id: <20181201003910.18982-6-krisman@collabora.com>
In-Reply-To: <20181201003910.18982-1-krisman@collabora.com>
References: <20181201003910.18982-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

fsck must be aware of the superblock encoding and the casefold directory
setting, such that it is able to correctly calculate the dentry hashes.

Changes since v3:
  - Handle case where filename is too large

Changes since V2:
  - Don't modify dirhash symbol

Changes since V1:
  - Abort if encoding is invalid.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 e2fsck/Makefile.in     |  7 +++---
 e2fsck/dx_dirinfo.c    |  4 ++-
 e2fsck/e2fsck.h        |  4 ++-
 e2fsck/pass1.c         |  3 ++-
 e2fsck/pass2.c         | 11 ++++++---
 e2fsck/rehash.c        | 20 +++++++++------
 e2fsck/unix.c          | 10 ++++++++
 lib/ext2fs/Makefile.in |  3 ++-
 lib/ext2fs/dirhash.c   | 55 ++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h    |  8 ++++++
 10 files changed, 107 insertions(+), 18 deletions(-)

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 676ab7ddcc1d..9799274fa74e 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -293,7 +293,8 @@ pass1.o: $(srcdir)/pass1.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/bitops.h $(top_srcdir)/lib/support/profile.h \
  $(top_builddir)/lib/support/prof_err.h $(top_srcdir)/lib/support/quotaio.h \
  $(top_srcdir)/lib/support/dqblk_v2.h \
- $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/problem.h
+ $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/problem.h \
+ $(top_srcdir)/lib/ext2fs/nls.h
 pass1b.o: $(srcdir)/pass1b.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
@@ -317,7 +318,7 @@ pass2.o: $(srcdir)/pass2.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/support/prof_err.h $(top_srcdir)/lib/support/quotaio.h \
  $(top_srcdir)/lib/support/dqblk_v2.h \
  $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/problem.h \
- $(top_srcdir)/lib/support/dict.h
+ $(top_srcdir)/lib/support/dict.h $(top_srcdir)/lib/ext2fs/nls.h
 pass3.o: $(srcdir)/pass3.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/e2fsck.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
@@ -416,7 +417,7 @@ unix.o: $(srcdir)/unix.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/support/plausible.h \
  $(srcdir)/e2fsck.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
  $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
- $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h  $(top_srcdir)/lib/ext2fs/nls.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/hashmap.h \
  $(top_srcdir)/lib/ext2fs/bitops.h $(top_srcdir)/lib/support/profile.h \
  $(top_builddir)/lib/support/prof_err.h $(top_srcdir)/lib/support/quotaio.h \
diff --git a/e2fsck/dx_dirinfo.c b/e2fsck/dx_dirinfo.c
index c7b605685339..c0b0e9a41235 100644
--- a/e2fsck/dx_dirinfo.c
+++ b/e2fsck/dx_dirinfo.c
@@ -13,7 +13,8 @@
  * entry.  During pass1, the passed-in parent is 0; it will get filled
  * in during pass2.
  */
-void e2fsck_add_dx_dir(e2fsck_t ctx, ext2_ino_t ino, int num_blocks)
+void e2fsck_add_dx_dir(e2fsck_t ctx, ext2_ino_t ino, struct ext2_inode *inode,
+		       int num_blocks)
 {
 	struct dx_dir_info *dir;
 	int		i, j;
@@ -72,6 +73,7 @@ void e2fsck_add_dx_dir(e2fsck_t ctx, ext2_ino_t ino, int num_blocks)
 	dir->ino = ino;
 	dir->numblocks = num_blocks;
 	dir->hashversion = 0;
+	dir->casefolded_hash = inode->i_flags & EXT4_CASEFOLD_FL;
 	dir->dx_block = e2fsck_allocate_memory(ctx, num_blocks
 				       * sizeof (struct dx_dirblock_info),
 				       "dx_block info array");
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index cd5cba2f6031..1c7a67cba1ce 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -109,6 +109,7 @@ struct dx_dir_info {
 	int			hashversion;
 	short			depth;		/* depth of tree */
 	struct dx_dirblock_info	*dx_block; 	/* Array of size numblocks */
+	int			casefolded_hash;
 };
 
 #define DX_DIRBLOCK_ROOT	1
@@ -471,7 +472,8 @@ extern int e2fsck_dir_info_get_dotdot(e2fsck_t ctx, ext2_ino_t ino,
 				      ext2_ino_t *dotdot);
 
 /* dx_dirinfo.c */
-extern void e2fsck_add_dx_dir(e2fsck_t ctx, ext2_ino_t ino, int num_blocks);
+extern void e2fsck_add_dx_dir(e2fsck_t ctx, ext2_ino_t ino,
+			      struct ext2_inode *inode, int num_blocks);
 extern struct dx_dir_info *e2fsck_get_dx_dir_info(e2fsck_t ctx, ext2_ino_t ino);
 extern void e2fsck_free_dx_dir_info(e2fsck_t ctx);
 extern int e2fsck_get_num_dx_dirinfo(e2fsck_t ctx);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8abf0c33a1d3..16ebec18db6f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -48,6 +48,7 @@
 
 #include "e2fsck.h"
 #include <ext2fs/ext2_ext_attr.h>
+#include <e2p/e2p.h>
 
 #include "problem.h"
 
@@ -3381,7 +3382,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			inode->i_flags &= ~EXT2_INDEX_FL;
 			dirty_inode++;
 		} else {
-			e2fsck_add_dx_dir(ctx, ino, pb.last_block+1);
+			e2fsck_add_dx_dir(ctx, ino, inode, pb.last_block+1);
 		}
 	}
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index b92eec1e149f..a7d9c47dbe8e 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -933,6 +933,7 @@ static int check_dir_block(ext2_filsys fs,
 	int	filetype = 0;
 	int	encrypted = 0;
 	size_t	max_block_size;
+	int	hash_flags = 0;
 
 	cd = (struct check_dir_struct *) priv_data;
 	ibuf = buf = cd->buf;
@@ -1426,9 +1427,13 @@ skip_checksum:
 			dir_modified++;
 
 		if (dx_db) {
-			ext2fs_dirhash(dx_dir->hashversion, dirent->name,
-				       ext2fs_dirent_name_len(dirent),
-				       fs->super->s_hash_seed, &hash, 0);
+			if (dx_dir->casefolded_hash)
+				hash_flags = EXT4_CASEFOLD_FL;
+
+			ext2fs_dirhash2(dx_dir->hashversion, dirent->name,
+					ext2fs_dirent_name_len(dirent),
+					fs->encoding, hash_flags,
+					fs->super->s_hash_seed, &hash, 0);
 			if (hash < dx_db->min_hash)
 				dx_db->min_hash = hash;
 			if (hash > dx_db->max_hash)
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 7c4ab0836482..a5fc1be1a210 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -113,7 +113,7 @@ static int fill_dir_block(ext2_filsys fs,
 	struct ext2_dir_entry 	*dirent;
 	char			*dir;
 	unsigned int		offset, dir_offset, rec_len, name_len;
-	int			hash_alg;
+	int			hash_alg, hash_flags;
 
 	if (blockcnt < 0)
 		return 0;
@@ -139,6 +139,7 @@ static int fill_dir_block(ext2_filsys fs,
 		if (fd->err)
 			return BLOCK_ABORT;
 	}
+	hash_flags = fd->inode->i_flags & EXT4_CASEFOLD_FL;
 	hash_alg = fs->super->s_def_hash_version;
 	if ((hash_alg <= EXT2_HASH_TEA) &&
 	    (fs->super->s_flags & EXT2_FLAGS_UNSIGNED_HASH))
@@ -184,10 +185,11 @@ static int fill_dir_block(ext2_filsys fs,
 		if (fd->compress)
 			ent->hash = ent->minor_hash = 0;
 		else {
-			fd->err = ext2fs_dirhash(hash_alg, dirent->name,
-						 name_len,
-						 fs->super->s_hash_seed,
-						 &ent->hash, &ent->minor_hash);
+			fd->err = ext2fs_dirhash2(hash_alg,
+						  dirent->name, name_len,
+						  fs->encoding, hash_flags,
+						  fs->super->s_hash_seed,
+						  &ent->hash, &ent->minor_hash);
 			if (fd->err)
 				return BLOCK_ABORT;
 		}
@@ -371,6 +373,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	char			new_name[256];
 	unsigned int		new_len;
 	int			hash_alg;
+	int hash_flags = fd->inode->i_flags & EXT4_CASEFOLD_FL;
 
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
@@ -415,9 +418,10 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 		if (fix_problem(ctx, PR_2_NON_UNIQUE_FILE, &pctx)) {
 			memcpy(ent->dir->name, new_name, new_len);
 			ext2fs_dirent_set_name_len(ent->dir, new_len);
-			ext2fs_dirhash(hash_alg, new_name, new_len,
-				       fs->super->s_hash_seed,
-				       &ent->hash, &ent->minor_hash);
+			ext2fs_dirhash2(hash_alg, new_name, new_len,
+					fs->encoding, hash_flags,
+					fs->super->s_hash_seed,
+					&ent->hash, &ent->minor_hash);
 			fixed++;
 		}
 	}
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 2df22b17146f..5b3552ece6b1 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -55,6 +55,7 @@ extern int optind;
 #include "problem.h"
 #include "jfs_user.h"
 #include "../version.h"
+#include <ext2fs/nls.h>
 
 /* Command line options */
 static int cflag;		/* check disk */
@@ -1784,6 +1785,15 @@ print_unsupp_features:
 		goto get_newer;
 	}
 
+	if (ext2fs_has_feature_fname_encoding(sb)) {
+		fs->encoding = nls_load_table(sb->s_encoding);
+		if (!fs->encoding) {
+			log_err(ctx, _("%s has unsupported encoding: %0x\n"),
+				ctx->filesystem_name, sb->s_encoding);
+			goto get_newer;
+		}
+	}
+
 	/*
 	 * If the user specified a specific superblock, presumably the
 	 * master superblock has been trashed.  So we mark the
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index a2f07403c9ae..b756bbdf35a5 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -779,7 +779,8 @@ dirhash.o: $(srcdir)/dirhash.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
- $(srcdir)/ext2_ext_attr.h $(srcdir)/hashmap.h $(srcdir)/bitops.h
+ $(srcdir)/ext2_ext_attr.h $(srcdir)/hashmap.h $(srcdir)/bitops.h \
+ $(srcdir)/nls.h
 dir_iterate.o: $(srcdir)/dir_iterate.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index 4ba3f35c091f..0caf5d4ed6e7 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -14,9 +14,11 @@
 #include "config.h"
 #include <stdio.h>
 #include <string.h>
+#include <limits.h>
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "nls.h"
 
 /*
  * Keyed 32-bit hash function using TEA in a Davis-Meyer function
@@ -184,6 +186,11 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
  * A particular hash version specifies whether or not the seed is
  * represented, and whether or not the returned hash is 32 bits or 64
  * bits.  32 bit hashes will return 0 for the minor hash.
+ *
+ * This function doesn't do any normalization or casefolding of the
+ * input string.  To take charset encoding into account, use
+ * ext2fs_dirhash2.
+ *
  */
 errcode_t ext2fs_dirhash(int version, const char *name, int len,
 			 const __u32 *seed,
@@ -257,3 +264,51 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 		*ret_minor_hash = minor_hash;
 	return 0;
 }
+
+/*
+ * Returns the hash of a filename considering normalization and
+ * casefolding.  This is a wrapper around ext2fs_dirhash with string
+ * encoding support based on the nls_table and the flags. Check
+ * ext2fs_dirhash for documentation on the input and output parameters.
+ */
+errcode_t ext2fs_dirhash2(int version, const char *name, int len,
+			  const struct nls_table *charset, int hash_flags,
+			  const __u32 *seed,
+			  ext2_dirhash_t *ret_hash,
+			  ext2_dirhash_t *ret_minor_hash)
+{
+	errcode_t r;
+	int dlen;
+	unsigned char *buff;
+
+	if (len && charset) {
+		buff = calloc(sizeof (char), PATH_MAX);
+		if (!buff)
+			return -ENOMEM;
+
+		if (hash_flags & EXT4_CASEFOLD_FL)
+			dlen = charset->ops->casefold(charset, name, len, buff,
+						  PATH_MAX);
+		else
+			dlen = charset->ops->normalize(charset, name, len, buff,
+						  PATH_MAX);
+
+		if (dlen < 0) {
+			free(buff);
+			if (dlen == -EINVAL)
+				goto opaque_seq;
+
+			return dlen;
+		}
+
+		r = ext2fs_dirhash(version, buff, dlen, seed, ret_hash,
+				   ret_minor_hash);
+
+		free(buff);
+		return r;
+	}
+
+opaque_seq:
+	return ext2fs_dirhash(version, name, len, seed, ret_hash,
+			      ret_minor_hash);
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 64c5b8758a40..f7760e579508 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -307,6 +307,8 @@ struct struct_ext2_filsys {
 
 	/* hashmap for SHA of data blocks */
 	struct ext2fs_hashmap* block_sha_map;
+
+	const struct nls_table *encoding;
 };
 
 #if EXT2_FLAT_INCLUDES
@@ -1174,6 +1176,12 @@ extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
 				ext2_dirhash_t *ret_hash,
 				ext2_dirhash_t *ret_minor_hash);
 
+extern errcode_t ext2fs_dirhash2(int version, const char *name, int len,
+				 const struct nls_table *charset,
+				 int hash_flags,
+				 const __u32 *seed,
+				 ext2_dirhash_t *ret_hash,
+				 ext2_dirhash_t *ret_minor_hash);
 
 /* dir_iterate.c */
 extern errcode_t ext2fs_get_rec_len(ext2_filsys fs,
-- 
2.20.0.rc1
