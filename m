Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46004 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbeKUKeT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 05:34:19 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v2 5/8] lib/ext2fs: Support encoding when calculating dx hashes
Date: Tue, 20 Nov 2018 19:02:03 -0500
Message-Id: <20181121000206.15496-6-krisman@collabora.com>
In-Reply-To: <20181121000206.15496-1-krisman@collabora.com>
References: <20181121000206.15496-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

fsck must be aware of the superblock encoding and the casefold directory
setting, such that it is able to correctly calculate the dentry hashes.

Changes since V1:
  - Abort if encoding is invalid.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 debugfs/htree.c        |  7 +++---
 e2fsck/Makefile.in     |  3 ++-
 e2fsck/dx_dirinfo.c    |  4 +++-
 e2fsck/e2fsck.h        |  4 +++-
 e2fsck/pass1.c         |  3 ++-
 e2fsck/pass2.c         |  7 +++++-
 e2fsck/rehash.c        | 12 +++++++----
 e2fsck/unix.c          | 18 ++++++++++++++++
 lib/ext2fs/Makefile.in |  3 ++-
 lib/ext2fs/dirhash.c   | 49 ++++++++++++++++++++++++++++++++++++++----
 lib/ext2fs/ext2fs.h    |  5 ++++-
 11 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 0c6a3852393e..51ae3fa94cc8 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -89,7 +89,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 		}
 		strncpy(name, dirent->name, thislen);
 		name[thislen] = '\0';
-		errcode = ext2fs_dirhash(hash_alg, name,
+		errcode = ext2fs_dirhash(NULL, hash_alg, 0, name,
 					 thislen, fs->super->s_hash_seed,
 					 &hash, &minor_hash);
 		if (errcode)
@@ -339,8 +339,9 @@ void do_dx_hash(int argc, char *argv[], int sci_idx EXT2FS_ATTR((unused)),
 			"[-s hash_seed] filename");
 		return;
 	}
-	err = ext2fs_dirhash(hash_version, argv[optind], strlen(argv[optind]),
-			     hash_seed, &hash, &minor_hash);
+	err = ext2fs_dirhash(NULL, hash_version, 0, argv[optind],
+			     strlen(argv[optind]), hash_seed, &hash,
+			     &minor_hash);
 	if (err) {
 		com_err(argv[0], err, "while calculating hash");
 		return;
diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 676ab7ddcc1d..737bf26e65ba 100644
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
index b92eec1e149f..c1c2c6160512 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -933,6 +933,7 @@ static int check_dir_block(ext2_filsys fs,
 	int	filetype = 0;
 	int	encrypted = 0;
 	size_t	max_block_size;
+	int	hash_flags = 0;
 
 	cd = (struct check_dir_struct *) priv_data;
 	ibuf = buf = cd->buf;
@@ -1426,7 +1427,11 @@ skip_checksum:
 			dir_modified++;
 
 		if (dx_db) {
-			ext2fs_dirhash(dx_dir->hashversion, dirent->name,
+			if (dx_dir->casefolded_hash)
+				hash_flags = EXT4_CASEFOLD_FL;
+
+			ext2fs_dirhash(fs->encoding, dx_dir->hashversion,
+				       hash_flags, dirent->name,
 				       ext2fs_dirent_name_len(dirent),
 				       fs->super->s_hash_seed, &hash, 0);
 			if (hash < dx_db->min_hash)
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 7c4ab0836482..25e947615778 100644
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
@@ -184,8 +185,9 @@ static int fill_dir_block(ext2_filsys fs,
 		if (fd->compress)
 			ent->hash = ent->minor_hash = 0;
 		else {
-			fd->err = ext2fs_dirhash(hash_alg, dirent->name,
-						 name_len,
+			fd->err = ext2fs_dirhash(fs->encoding, hash_alg,
+						 hash_flags,
+						 dirent->name, name_len,
 						 fs->super->s_hash_seed,
 						 &ent->hash, &ent->minor_hash);
 			if (fd->err)
@@ -371,6 +373,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	char			new_name[256];
 	unsigned int		new_len;
 	int			hash_alg;
+	int hash_flags = fd->inode->i_flags & EXT4_CASEFOLD_FL;
 
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
@@ -415,7 +418,8 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 		if (fix_problem(ctx, PR_2_NON_UNIQUE_FILE, &pctx)) {
 			memcpy(ent->dir->name, new_name, new_len);
 			ext2fs_dirent_set_name_len(ent->dir, new_len);
-			ext2fs_dirhash(hash_alg, new_name, new_len,
+			ext2fs_dirhash(fs->encoding, hash_alg, hash_flags,
+				       new_name, new_len,
 				       fs->super->s_hash_seed,
 				       &ent->hash, &ent->minor_hash);
 			fixed++;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 2df22b17146f..bb610af0956f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -55,6 +55,7 @@ extern int optind;
 #include "problem.h"
 #include "jfs_user.h"
 #include "../version.h"
+#include <ext2fs/nls.h>
 
 /* Command line options */
 static int cflag;		/* check disk */
@@ -1381,6 +1382,7 @@ int main (int argc, char *argv[])
 	int old_bitmaps;
 	__u32 features[3];
 	char *cp;
+	const char *encoding_name;
 	enum quota_type qtype;
 
 	clear_problem_context(&pctx);
@@ -1784,6 +1786,22 @@ print_unsupp_features:
 		goto get_newer;
 	}
 
+	if (ext2fs_has_feature_fname_encoding(sb)) {
+		encoding_name = e2p_encoding2str(sb->s_encoding);
+		if (!encoding_name) {
+			log_err(ctx, _("%s has unknown encoding: 0x%X\n"),
+				ctx->filesystem_name, sb->s_encoding);
+			goto get_newer;
+		}
+
+		fs->encoding = nls_load_table(encoding_name);
+		if (!fs->encoding) {
+			log_err(ctx, _("%s has unsupported encoding: %s\n"),
+				ctx->filesystem_name, encoding_name);
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
index 4ba3f35c091f..2198a6fd4d2a 100644
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
@@ -185,10 +187,10 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
  * represented, and whether or not the returned hash is 32 bits or 64
  * bits.  32 bit hashes will return 0 for the minor hash.
  */
-errcode_t ext2fs_dirhash(int version, const char *name, int len,
-			 const __u32 *seed,
-			 ext2_dirhash_t *ret_hash,
-			 ext2_dirhash_t *ret_minor_hash)
+errcode_t _ext2fs_dirhash(int version, const char *name, int len,
+			  const __u32 *seed,
+			  ext2_dirhash_t *ret_hash,
+			  ext2_dirhash_t *ret_minor_hash)
 {
 	__u32	hash;
 	__u32	minor_hash = 0;
@@ -257,3 +259,42 @@ errcode_t ext2fs_dirhash(int version, const char *name, int len,
 		*ret_minor_hash = minor_hash;
 	return 0;
 }
+
+errcode_t ext2fs_dirhash(const struct nls_table *charset, int version,
+			 int hash_flags, const char *name, int len,
+			 const __u32 *seed,
+			 ext2_dirhash_t *ret_hash,
+			 ext2_dirhash_t *ret_minor_hash)
+{
+	errcode_t r;
+	int dlen;
+	unsigned char *buff;
+
+	if (len && charset) {
+		buff = calloc(sizeof (char), PATH_MAX);
+		if (!buff)
+			return -1;
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
+			goto opaque_seq;
+		}
+
+		r = _ext2fs_dirhash(version, buff, dlen, seed, ret_hash,
+				    ret_minor_hash);
+
+		free(buff);
+		return r;
+	}
+
+opaque_seq:
+	return _ext2fs_dirhash(version, name, len, seed, ret_hash,
+			       ret_minor_hash);
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 64c5b8758a40..e50d8a066ef3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -307,6 +307,8 @@ struct struct_ext2_filsys {
 
 	/* hashmap for SHA of data blocks */
 	struct ext2fs_hashmap* block_sha_map;
+
+	const struct nls_table *encoding;
 };
 
 #if EXT2_FLAT_INCLUDES
@@ -1169,7 +1171,8 @@ extern errcode_t ext2fs_write_dir_block4(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags, ext2_ino_t ino);
 
 /* dirhash.c */
-extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
+extern errcode_t ext2fs_dirhash(const struct nls_table *charset, int version,
+				int hash_flags, const char *name, int len,
 				const __u32 *seed,
 				ext2_dirhash_t *ret_hash,
 				ext2_dirhash_t *ret_minor_hash);
-- 
2.19.1
