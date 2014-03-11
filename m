From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/49] misc: cppcheck cleanups
Date: Mon, 10 Mar 2014 23:55:40 -0700
Message-ID: <20140311065540.30585.97622.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21442 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaCKGzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:44 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix a number of things that cppcheck complains about.  Most of these
are minor resource leaks and forgotten declarations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c      |    2 +-
 debugfs/debugfs.h      |    4 ++++
 e2fsck/pass1.c         |    2 +-
 e2fsck/pass2.c         |    2 +-
 e2fsck/region.c        |    2 ++
 lib/ext2fs/expanddir.c |    1 +
 lib/ext2fs/ext2fs.h    |   11 +++++++++++
 lib/ext2fs/ext2fsP.h   |    9 ---------
 lib/ext2fs/mkdir.c     |    1 +
 lib/ext2fs/punch.c     |    1 +
 util/subst.c           |    2 ++
 11 files changed, 25 insertions(+), 12 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index a5cd007..a10446d 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -666,7 +666,7 @@ static void dump_inline_data(FILE *out, const char *prefix, ext2_ino_t inode_num
 
 	retval = ext2fs_inline_data_size(current_fs, inode_num, &size);
 	if (!retval)
-		fprintf(out, "%sSize of inline data: %d", prefix, size);
+		fprintf(out, "%sSize of inline data: %zu", prefix, size);
 }
 
 void internal_dump_inode(FILE *out, const char *prefix,
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 3c27f82..0164ca5 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -177,6 +177,10 @@ extern time_t string_to_time(const char *arg);
 
 /* xattrs.c */
 void dump_inode_attributes(FILE *out, ext2_ino_t ino);
+void do_get_xattr(int argc, char **argv);
+void do_set_xattr(int argc, char **argv);
+void do_rm_xattr(int argc, char **argv);
+void do_list_xattr(int argc, char **argv);
 
 /* zap.c */
 extern void do_zap_block(int argc, char **argv);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 641b3fb..eb9497c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -446,7 +446,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
 			 EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 	if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL)) {
-		unsigned int size;
+		size_t size;
 
 		if (ext2fs_inline_data_size(ctx->fs, pctx->ino, &size))
 			return;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 586f3a8..5488c73 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -770,7 +770,7 @@ static int check_dir_block(ext2_filsys fs,
 	int	dx_csum_size = 0, de_csum_size = 0;
 	int	failed_csum = 0;
 	int	is_leaf = 1;
-	int	inline_data_size = 0;
+	size_t	inline_data_size = 0;
 	int	filetype = 0;
 
 	cd = (struct check_dir_struct *) priv_data;
diff --git a/e2fsck/region.c b/e2fsck/region.c
index 4b669f0..aaaaa19 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -203,6 +203,8 @@ int main(int argc, char **argv)
 			break;
 		}
 	}
+	if (r)
+		region_free(r);
 }
 
 #endif /* TEST_PROGRAM */
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 7cff343..d0f7287 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -18,6 +18,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 struct expand_dir_struct {
 	int		done;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 3756e8b..599c972 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1386,6 +1386,17 @@ errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *);
 extern errcode_t ext2fs_get_memalign(unsigned long size,
 				     unsigned long align, void *ptr);
 
+/* inline_data.c */
+extern errcode_t ext2fs_inline_data_init(ext2_filsys fs, ext2_ino_t ino);
+extern errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino,
+					 size_t *size);
+extern errcode_t ext2fs_inline_data_get(ext2_filsys fs, ext2_ino_t ino,
+					struct ext2_inode *inode,
+					void *buf, size_t *size);
+extern errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
+					struct ext2_inode *inode,
+					void *buf, size_t size);
+
 /* inode.c */
 extern errcode_t ext2fs_create_inode_cache(ext2_filsys fs,
 					   unsigned int cache_size);
diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index 20257e2..f8c61e6 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -88,20 +88,11 @@ extern int ext2fs_process_dir_block(ext2_filsys  	fs,
 				    int			ref_offset,
 				    void		*priv_data);
 
-extern errcode_t ext2fs_inline_data_init(ext2_filsys fs, ext2_ino_t ino);
-extern errcode_t ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino,
-					 size_t *size);
 extern errcode_t ext2fs_inline_data_ea_remove(ext2_filsys fs, ext2_ino_t ino);
 extern errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino);
 extern int ext2fs_inline_data_dir_iterate(ext2_filsys fs,
 					  ext2_ino_t ino,
 					  void *priv_data);
-extern errcode_t ext2fs_inline_data_get(ext2_filsys fs, ext2_ino_t ino,
-					struct ext2_inode *inode,
-					void *buf, size_t *size);
-extern errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
-					struct ext2_inode *inode,
-					void *buf, size_t size);
 
 /* Generic numeric progress meter */
 
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 06c2c7e..c4c7967 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -26,6 +26,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 #ifndef EXT2_FT_DIR
 #define EXT2_FT_DIR		2
diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 95e19d9..532c4b8 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -19,6 +19,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 #undef PUNCH_DEBUG
 
diff --git a/util/subst.c b/util/subst.c
index 6a5eab1..2ea16d9 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -426,6 +426,8 @@ int main(int argc, char **argv)
 	}
 	if (old)
 		fclose(old);
+	if (newfn)
+		free(newfn);
 	return (0);
 }
 

