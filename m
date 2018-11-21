Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46008 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbeKUKeW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 05:34:22 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v2 6/8] debugfs/htree: Support encoding when printing the file hash
Date: Tue, 20 Nov 2018 19:02:04 -0500
Message-Id: <20181121000206.15496-7-krisman@collabora.com>
In-Reply-To: <20181121000206.15496-1-krisman@collabora.com>
References: <20181121000206.15496-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Implement two parameters -e and -c, to specify encoding and casefold
when printing the hash of a given file.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 debugfs/htree.c        | 24 +++++++++++++++++++-----
 lib/ext2fs/Makefile.in |  2 +-
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 51ae3fa94cc8..afa297e65a85 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -27,6 +27,8 @@ extern char *optarg;
 #include "uuid/uuid.h"
 #include "e2p/e2p.h"
 
+#include "ext2fs/nls.h"
+
 static FILE *pager;
 
 static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
@@ -44,6 +46,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	ext2_dirhash_t 	hash, minor_hash;
 	unsigned int	rec_len;
 	int		hash_alg;
+	int		hash_flags = inode->i_flags & EXT4_CASEFOLD_FL;
 	int		csum_size = 0;
 
 	if (ext2fs_has_feature_metadata_csum(fs->super))
@@ -89,8 +92,8 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 		}
 		strncpy(name, dirent->name, thislen);
 		name[thislen] = '\0';
-		errcode = ext2fs_dirhash(NULL, hash_alg, 0, name,
-					 thislen, fs->super->s_hash_seed,
+		errcode = ext2fs_dirhash(fs->encoding, hash_alg, hash_flags,
+					 name, thislen, fs->super->s_hash_seed,
 					 &hash, &minor_hash);
 		if (errcode)
 			com_err("htree_dump_leaf_node", errcode,
@@ -306,11 +309,12 @@ errout:
 void do_dx_hash(int argc, char *argv[], int sci_idx EXT2FS_ATTR((unused)),
 		void *infop EXT2FS_ATTR((unused)))
 {
-	ext2_dirhash_t hash, minor_hash;
+	ext2_dirhash_t hash, minor_hash, hash_flags;
 	errcode_t	err;
 	int		c;
 	int		hash_version = 0;
 	__u32		hash_seed[4];
+	const struct nls_table *encoding;
 
 	hash_seed[0] = hash_seed[1] = hash_seed[2] = hash_seed[3] = 0;
 
@@ -329,6 +333,15 @@ void do_dx_hash(int argc, char *argv[], int sci_idx EXT2FS_ATTR((unused)),
 				return;
 			}
 			break;
+		case 'c':
+			hash_flags = EXT4_CASEFOLD_FL;
+			break;
+		case 'e':
+			encoding = nls_load_table(optarg);
+			if (!encoding)
+				fprintf(stderr, "Invalid encoding: %s\n",
+					optarg);
+				return;
 		default:
 			goto print_usage;
 		}
@@ -336,10 +349,11 @@ void do_dx_hash(int argc, char *argv[], int sci_idx EXT2FS_ATTR((unused)),
 	if (optind != argc-1) {
 	print_usage:
 		com_err(argv[0], 0, "usage: dx_hash [-h hash_alg] "
-			"[-s hash_seed] filename");
+			"[-s hash_seed] [-c] [-e encoding] filename");
 		return;
 	}
-	err = ext2fs_dirhash(NULL, hash_version, 0, argv[optind],
+
+	err = ext2fs_dirhash(encoding, hash_version, hash_flags, argv[optind],
 			     strlen(argv[optind]), hash_seed, &hash,
 			     &minor_hash);
 	if (err) {
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index b756bbdf35a5..78c54d1a09de 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -1299,7 +1299,7 @@ htree.o: $(top_srcdir)/debugfs/htree.c $(top_builddir)/lib/config.h \
  $(srcdir)/hashmap.h $(srcdir)/bitops.h \
  $(top_srcdir)/debugfs/../misc/create_inode.h $(top_srcdir)/lib/e2p/e2p.h \
  $(top_srcdir)/lib/support/quotaio.h $(top_srcdir)/lib/support/dqblk_v2.h \
- $(top_srcdir)/lib/support/quotaio_tree.h
+ $(top_srcdir)/lib/support/quotaio_tree.h $(srcdir)/nls.h
 unused.o: $(top_srcdir)/debugfs/unused.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/debugfs/debugfs.h \
  $(top_srcdir)/lib/ss/ss.h $(top_builddir)/lib/ss/ss_err.h \
-- 
2.19.1
