From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 1/3] libquota: cleanup libquota code
Date: Thu,  3 Nov 2011 17:18:31 -0700
Message-ID: <1320365913-25857-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: adilger@dilger.ca, tytso.mit.edu@google.com, niu@whamcloud.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1KDASr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2011 20:18:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch cleans up the quota code as suggested in previous reviews. This
includes
* remove BUG_ON()s and 'exit()' calls from library code
* remove calls to malloc/free and instead use ext2fs_get/free_mem functions.
* lib/quota/common.c file in not needed anymore and is removed.
* rename exported functions to start with quota_
  (ex: init_quota_context --> quota_init_context)
* better error handling in quota library

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 e2fsck/quota.c           |    3 +-
 e2fsck/unix.c            |    6 +-
 lib/quota/Makefile.in    |    7 +--
 lib/quota/common.c       |   63 ----------------------
 lib/quota/common.h       |   28 ----------
 lib/quota/mkquota.c      |   81 +++++++++++++++++-----------
 lib/quota/mkquota.h      |   34 +++++++-----
 lib/quota/quotaio.c      |   71 +++++++++++++++++++------
 lib/quota/quotaio.h      |   14 +++--
 lib/quota/quotaio_tree.c |  133 ++++++++++++++++++++++++++++++++++------------
 lib/quota/quotaio_v2.c   |   14 ++---
 misc/mke2fs.c            |   12 ++--
 misc/tune2fs.c           |   20 ++++----
 13 files changed, 256 insertions(+), 230 deletions(-)
 delete mode 100644 lib/quota/common.c

diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index 059b98d..53b695b 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -38,8 +38,7 @@ static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
 
 	ext2fs_write_new_inode(fs, to_ino, &inode);
 	/* unlink the old inode */
-	snprintf(qf_name, sizeof(qf_name), "aquota.%s",
-		 qtype ? "group" : "user");
+	quota_get_qf_name(qtype, QFMT_VFS_V1, qf_name);
 	ext2fs_unlink(fs, EXT2_ROOT_INO, qf_name, from_ino, 0);
 	ext2fs_inode_alloc_stats(fs, from_ino, -1);
 }
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 0edcfc8..d2a8c80 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1525,7 +1525,7 @@ print_unsupp_features:
 		else
 			qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
 
-		init_quota_context(&ctx->qctx, ctx->fs, qtype);
+		quota_init_context(&ctx->qctx, ctx->fs, qtype);
 	}
 
 	run_result = e2fsck_run(ctx);
@@ -1561,8 +1561,8 @@ print_unsupp_features:
 no_journal:
 
 	if (ctx->qctx) {
-		write_quota_inode(ctx->qctx, -1);
-		release_quota_context(&ctx->qctx);
+		quota_write_inode(ctx->qctx, -1);
+		quota_release_context(&ctx->qctx);
 	}
 
 	if (run_result == E2F_FLAG_RESTART) {
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index 75d9c64..5a12d4f 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -15,10 +15,9 @@ all::
 SMANPAGES=
 
 
-OBJS=		common.o mkquota.o quotaio.o quotaio_v2.o quotaio_tree.o dict.o
+OBJS=		mkquota.o quotaio.o quotaio_v2.o quotaio_tree.o dict.o
 
-SRCS=		$(srcdir)/common.c \
-		$(srcdir)/mkquota.c \
+SRCS=		$(srcdir)/mkquota.c \
 		$(srcdir)/quotaio.c \
 		$(srcdir)/quotaio_tree.c \
 		$(srcdir)/quotaio_v2.c \
@@ -125,8 +124,6 @@ $(OBJS):
 # Makefile dependencies follow.  This must be the last section in
 # the Makefile.in file
 #
-common.o: $(srcdir)/common.c $(top_builddir)/lib/config.h \
- $(top_builddir)/lib/dirpaths.h $(srcdir)/common.h
 mkquota.o: $(srcdir)/mkquota.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
diff --git a/lib/quota/common.c b/lib/quota/common.c
deleted file mode 100644
index 6fd34b9..0000000
--- a/lib/quota/common.c
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * Common things for all utilities
- *
- * Jan Kara <jack@suse.cz> - sponsored by SuSE CR
- *
- * Jani Jaakkola <jjaakkol@cs.helsinki.fi> - syslog support
- */
-
-#include "config.h"
-#include <stdio.h>
-#include <stdlib.h>
-#include <stdarg.h>
-#include <string.h>
-#include <syslog.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-
-#include "common.h"
-
-void *smalloc(size_t size)
-{
-	void *ret = malloc(size);
-
-	if (!ret) {
-		fputs("Not enough memory.\n", stderr);
-		exit(3);
-	}
-	return ret;
-}
-
-void *srealloc(void *ptr, size_t size)
-{
-	void *ret = realloc(ptr, size);
-
-	if (!ret) {
-		fputs("Not enough memory.\n", stderr);
-		exit(3);
-	}
-	return ret;
-}
-
-void sstrncpy(char *d, const char *s, size_t len)
-{
-	strncpy(d, s, len);
-	d[len - 1] = 0;
-}
-
-void sstrncat(char *d, const char *s, size_t len)
-{
-	strncat(d, s, len);
-	d[len - 1] = 0;
-}
-
-char *sstrdup(const char *s)
-{
-	char *r = strdup(s);
-
-	if (!r) {
-		puts("Not enough memory.");
-		exit(3);
-	}
-	return r;
-}
diff --git a/lib/quota/common.h b/lib/quota/common.h
index 7b88003..b5e8331 100644
--- a/lib/quota/common.h
+++ b/lib/quota/common.h
@@ -13,12 +13,6 @@
 # endif
 #endif
 
-#define log_fatal(exit_code, format, ...)	do { \
-		fprintf(stderr, "[FATAL] %s:%d:%s:: " format "\n", \
-			__FILE__, __LINE__, __func__, __VA_ARGS__); \
-		exit(exit_code); \
-	} while (0)
-
 #define log_err(format, ...)	fprintf(stderr, \
 				"[ERROR] %s:%d:%s:: " format "\n", \
 				__FILE__, __LINE__, __func__, __VA_ARGS__)
@@ -31,26 +25,4 @@
 # define log_debug(format, ...)
 #endif
 
-#define BUG_ON(x)		do { if ((x)) { \
-					fprintf(stderr, \
-						"BUG_ON: %s:%d:: ##x", \
-						__FILE__, __LINE__); \
-					exit(2); \
-				} } while (0)
-
-/* malloc() with error check */
-void *smalloc(size_t);
-
-/* realloc() with error check */
-void *srealloc(void *, size_t);
-
-/* Safe strncpy - always finishes string */
-void sstrncpy(char *, const char *, size_t);
-
-/* Safe strncat - always finishes string */
-void sstrncat(char *, const char *, size_t);
-
-/* Safe version of strdup() */
-char *sstrdup(const char *s);
-
 #endif /* __QUOTA_COMMON_H__ */
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 5440003..3921da9 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -49,7 +49,7 @@ static void print_inode(struct ext2_inode *inode)
 	return;
 }
 
-int is_quota_on(ext2_filsys fs, int type)
+int quota_is_on(ext2_filsys fs, int type)
 {
 	char tmp[1024];
 	qid_t id = (type == USRQUOTA) ? getuid() : getgid();
@@ -65,7 +65,7 @@ int is_quota_on(ext2_filsys fs, int type)
  * Returns 0 if not able to find the quota file, otherwise returns its
  * inode number.
  */
-int quota_file_exists(ext2_filsys fs, int qtype)
+int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
 {
 	char qf_name[256];
 	errcode_t ret;
@@ -74,7 +74,7 @@ int quota_file_exists(ext2_filsys fs, int qtype)
 	if (qtype >= MAXQUOTAS)
 		return -EINVAL;
 
-	snprintf(qf_name, sizeof(qf_name), "aquota.%s", type2name(qtype));
+	quota_get_qf_name(qtype, fmt, qf_name);
 
 	ret = ext2fs_lookup(fs, EXT2_ROOT_INO, qf_name, strlen(qf_name), 0,
 			    &ino);
@@ -87,7 +87,7 @@ int quota_file_exists(ext2_filsys fs, int qtype)
 /*
  * Set the value for reserved quota inode number field in superblock.
  */
-void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
 {
 	ext2_ino_t *inump;
 
@@ -100,17 +100,17 @@ void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
 	ext2fs_mark_super_dirty(fs);
 }
 
-errcode_t remove_quota_inode(ext2_filsys fs, int qtype)
+errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
 {
 	ext2_ino_t qf_ino;
 
 	ext2fs_read_bitmaps(fs);
 	qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
 		fs->super->s_grp_quota_inum;
-	set_sb_quota_inum(fs, 0, qtype);
+	quota_set_sb_inum(fs, 0, qtype);
 	/* Truncate the inode only if its a reserved one. */
 	if (qf_ino < EXT2_FIRST_INODE(fs->super))
-		truncate_quota_inode(fs, qf_ino);
+		quota_inode_truncate(fs, qf_ino);
 
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_write_bitmaps(fs);
@@ -132,7 +132,7 @@ static void write_dquots(dict_t *dict, struct quota_handle *qh)
 	}
 }
 
-errcode_t write_quota_inode(quota_ctx_t qctx, int qtype)
+errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 {
 	int		retval = 0, i;
 	dict_t		*dict;
@@ -144,7 +144,12 @@ errcode_t write_quota_inode(quota_ctx_t qctx, int qtype)
 		return 0;
 
 	fs = qctx->fs;
-	h = smalloc(sizeof(struct quota_handle));
+	retval = ext2fs_get_mem(sizeof(struct quota_handle), &h);
+	if (retval) {
+		log_err("Unable to allocate quota handle", "");
+		goto out;
+	}
+
 	ext2fs_read_bitmaps(fs);
 
 	for (i = 0; i < MAXQUOTAS; i++) {
@@ -155,32 +160,34 @@ errcode_t write_quota_inode(quota_ctx_t qctx, int qtype)
 		if (!dict)
 			continue;
 
-		retval = new_io(h, fs, i, fmt);
+		retval = quota_file_create(h, fs, i, fmt);
 		if (retval < 0) {
 			log_err("Cannot initialize io on quotafile", "");
 			continue;
 		}
 
 		write_dquots(dict, h);
-		retval = end_io(h);
+		retval = quota_file_close(h);
 		if (retval < 0) {
 			log_err("Cannot finish IO on new quotafile: %s",
 				strerror(errno));
 			if (h->qh_qf.e2_file)
 				ext2fs_file_close(h->qh_qf.e2_file);
-			truncate_quota_inode(fs, h->qh_qf.ino);
+			quota_inode_truncate(fs, h->qh_qf.ino);
 			continue;
 		}
 
 		/* Set quota inode numbers in superblock. */
-		set_sb_quota_inum(fs, h->qh_qf.ino, i);
+		quota_set_sb_inum(fs, h->qh_qf.ino, i);
 		ext2fs_mark_super_dirty(fs);
 		ext2fs_mark_bb_dirty(fs);
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	}
 
 	ext2fs_write_bitmaps(fs);
-	free(h);
+out:
+	if (h)
+		ext2fs_free_mem(&h);
 	return retval;
 }
 
@@ -198,17 +205,11 @@ static int dict_uint_cmp(const void *a, const void *b)
 	return c - d;
 }
 
-static qid_t get_qid(struct ext2_inode *inode, int qtype)
+static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
 {
-	switch (qtype) {
-	case USRQUOTA:
+	if (qtype == USRQUOTA)
 		return inode_uid(*inode);
-	case GRPQUOTA:
-		return inode_gid(*inode);
-	default:
-		log_err("Invalid quota type: %d", qtype);
-		BUG_ON(1);
-	}
+	return inode_gid(*inode);
 }
 
 static void quota_dnode_free(dnode_t *node,
@@ -216,25 +217,34 @@ static void quota_dnode_free(dnode_t *node,
 {
 	void *ptr = node ? dnode_get(node) : 0;
 
-	free(ptr);
+	ext2fs_free_mem(&ptr);
 	free(node);
 }
 
 /*
- * Called in Pass #1 to set up the quota tracking data structures.
+ * Set up the quota tracking data structures.
  */
-void init_quota_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 {
-	int	i;
+	int	i, err = 0;
 	dict_t	*dict;
 	quota_ctx_t ctx;
 
-	ctx = (quota_ctx_t)smalloc(sizeof(struct quota_ctx));
+	err = ext2fs_get_mem(sizeof(struct quota_ctx), &ctx);
+	if (err) {
+		log_err("Failed to allocate quota context", "");
+		return err;
+	}
+
 	memset(ctx, 0, sizeof(struct quota_ctx));
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if ((qtype != -1) && (i != qtype))
 			continue;
-		dict = (dict_t *)smalloc(sizeof(dict_t));
+		err = ext2fs_get_mem(sizeof(dict_t), &dict);
+		if (err) {
+			log_err("Failed to allocate dictionary", "");
+			return err;
+		}
 		ctx->quota_dict[i] = dict;
 		dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
 		dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
@@ -242,9 +252,10 @@ void init_quota_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 
 	ctx->fs = fs;
 	*qctx = ctx;
+	return 0;
 }
 
-void release_quota_context(quota_ctx_t *qctx)
+void quota_release_context(quota_ctx_t *qctx)
 {
 	dict_t	*dict;
 	int	i;
@@ -275,7 +286,10 @@ static struct dquot *get_dq(dict_t *dict, __u32 key)
 	if (n)
 		dq = dnode_get(n);
 	else {
-		dq = smalloc(sizeof(struct dquot));
+		if (ext2fs_get_mem(sizeof(struct dquot), &dq)) {
+			log_err("Unable to allocate dquot", "");
+			return NULL;
+		}
 		memset(dq, 0, sizeof(struct dquot));
 		dict_alloc_insert(dict, UINT_TO_VOIDPTR(key), dq);
 	}
@@ -303,7 +317,8 @@ void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		dict = qctx->quota_dict[i];
 		if (dict) {
 			dq = get_dq(dict, get_qid(inode, i));
-			dq->dq_dqb.dqb_curspace += space;
+			if (dq)
+				dq->dq_dqb.dqb_curspace += space;
 		}
 	}
 }
@@ -358,7 +373,7 @@ void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
 	}
 }
 
-errcode_t compute_quota(quota_ctx_t qctx, int qtype)
+errcode_t quota_compute_usage(quota_ctx_t qctx)
 {
 	ext2_filsys fs;
 	ext2_ino_t ino;
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index e3ec8c2..8d0a8ce 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -10,15 +10,15 @@
  * {
  *	quota_ctx_t qctx;
  *
- *	init_quota_context(&qctx, fs, -1);
+ *	quota_init_context(&qctx, fs, -1);
  *	{
- *		compute_quota(qctx, -1);
+ *		quota_compute_usage(qctx, -1);
  *		AND/OR
  *		quota_data_add/quota_data_sub/quota_data_inodes();
  *	}
- *	write_quota_inode(qctx, USRQUOTA);
- *	write_quota_inode(qctx, GRPQUOTA);
- *	release_quota_context(&qctx);
+ *	quota_write_inode(qctx, USRQUOTA);
+ *	quota_write_inode(qctx, GRPQUOTA);
+ *	quota_release_context(&qctx);
  * }
  *
  * This initial version does not support reading the quota files. This support
@@ -42,20 +42,26 @@ struct quota_ctx {
 	dict_t		*quota_dict[MAXQUOTAS];
 };
 
-void init_quota_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
+/* In mkquota.c */
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
 void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		int adjust);
 void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		qsize_t space);
 void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		qsize_t space);
-errcode_t write_quota_inode(quota_ctx_t qctx, int qtype);
-errcode_t compute_quota(quota_ctx_t qctx, int qtype);
-void release_quota_context(quota_ctx_t *qctx);
-
-errcode_t remove_quota_inode(ext2_filsys fs, int qtype);
-int is_quota_on(ext2_filsys fs, int type);
-int quota_file_exists(ext2_filsys fs, int qtype);
-void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
+errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
+errcode_t quota_compute_usage(quota_ctx_t qctx);
+void quota_release_context(quota_ctx_t *qctx);
+
+errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
+int quota_is_on(ext2_filsys fs, int type);
+int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
+
+/* In quotaio.c */
+const char *quota_get_qf_name(int type, int fmt, char *buf);
+const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+			      char *path_buf, size_t path_buf_size);
 
 #endif  /* __QUOTA_QUOTAIO_H__ */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 8430db1..4af0184 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -49,6 +49,36 @@ const char *type2name(int type)
 	return extensions[type];
 }
 
+/**
+ * Creates a quota file name for given type and format.
+ */
+const char *quota_get_qf_name(int type, int fmt, char *buf)
+{
+	if (!buf)
+		return NULL;
+	snprintf(buf, PATH_MAX, "%s.%s",
+		 basenames[fmt], extensions[type]);
+
+	return buf;
+}
+
+const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+			      char *path_buf, size_t path_buf_size)
+{
+	struct stat	qf_stat;
+	char qf_name[PATH_MAX] = {0};
+
+	if (!mntpt || !path_buf || !path_buf_size)
+		return NULL;
+
+	strncpy(path_buf, mntpt, path_buf_size);
+	strncat(path_buf, "/", 1);
+	strncat(path_buf, quota_get_qf_name(qtype, fmt, qf_name),
+		path_buf_size - strlen(path_buf));
+
+	return path_buf;
+}
+
 /*
  * Set grace time if needed
  */
@@ -102,12 +132,14 @@ static int compute_num_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 	return 0;
 }
 
-void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino)
+errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
+	errcode_t err;
+	int i;
 
-	if (ext2fs_read_inode(fs, ino, &inode))
-		return;
+	if ((err = ext2fs_read_inode(fs, ino, &inode)))
+		return err;
 
 	inode.i_dtime = fs->now ? fs->now : time(0);
 	if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
@@ -117,7 +149,8 @@ void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino)
 			      release_blocks_proc, NULL);
 
 	memset(&inode, 0, sizeof(struct ext2_inode));
-	ext2fs_write_inode(fs, ino, &inode);
+	err = ext2fs_write_inode(fs, ino, &inode);
+	return err;
 }
 
 static ext2_off64_t compute_inode_size(ext2_filsys fs, ext2_ino_t ino)
@@ -183,15 +216,14 @@ static unsigned int quota_read_nomount(struct quota_file *qf,
 /*
  * Detect quota format and initialize quota IO
  */
-struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int type,
-			     int fmt, int flags)
+errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
+			  int type, int fmt, int flags)
 {
 	log_err("Not Implemented.", "");
-	BUG_ON(1);
-	return NULL;
+	return -1;
 }
 
-static errcode_t init_new_quota_inode(ext2_filsys fs, ext2_ino_t ino)
+static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
 	errcode_t err = 0;
@@ -203,7 +235,7 @@ static errcode_t init_new_quota_inode(ext2_filsys fs, ext2_ino_t ino)
 	}
 
 	if (EXT2_I_SIZE(&inode))
-		truncate_quota_inode(fs, ino);
+		quota_inode_truncate(fs, ino);
 
 	memset(&inode, 0, sizeof(struct ext2_inode));
 	ext2fs_iblk_set(fs, &inode, 0);
@@ -227,7 +259,7 @@ static errcode_t init_new_quota_inode(ext2_filsys fs, ext2_ino_t ino)
 /*
  * Create new quotafile of specified format on given filesystem
  */
-int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
+errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
 {
 	ext2_file_t e2_file;
 	int err;
@@ -242,12 +274,13 @@ int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
 	else if (type == GRPQUOTA)
 		qf_inum = EXT4_GRP_QUOTA_INO;
 	else
-		BUG_ON(1);
+		return -1;
+
 	err = ext2fs_read_bitmaps(fs);
 	if (err)
 		goto out_err;
 
-	err = init_new_quota_inode(fs, qf_inum);
+	err = quota_inode_init_new(fs, qf_inum);
 	if (err) {
 		log_err("init_new_quota_inode failed", "");
 		goto out_err;
@@ -283,7 +316,7 @@ out_err1:
 out_err:
 
 	if (qf_inum)
-		truncate_quota_inode(fs, qf_inum);
+		quota_inode_truncate(fs, qf_inum);
 
 	return -1;
 }
@@ -291,7 +324,7 @@ out_err:
 /*
  * Close quotafile and release handle
  */
-int end_io(struct quota_handle *h)
+errcode_t quota_file_close(struct quota_handle *h)
 {
 	if (h->qh_io_flags & IOFL_INFODIRTY) {
 		if (h->qh_ops->write_info && h->qh_ops->write_info(h) < 0)
@@ -316,9 +349,13 @@ int end_io(struct quota_handle *h)
  */
 struct dquot *get_empty_dquot(void)
 {
-	struct dquot *dquot = smalloc(sizeof(struct dquot));
+	struct dquot *dquot;
+
+	if (ext2fs_get_memzero(sizeof(struct dquot), &dquot)) {
+		log_err("Failed to allocate dquot", "");
+		return NULL;
+	}
 
-	memset(dquot, 0, sizeof(*dquot));
 	dquot->dq_id = -1;
 	return dquot;
 }
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 282b543..fa71762 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -136,20 +136,22 @@ static inline void mark_quotafile_info_dirty(struct quota_handle *h)
 #define QIO_ENABLED(h)	((h)->qh_io_flags & IOFL_QUOTAON)
 #define QIO_RO(h)	((h)->qh_io_flags & IOFL_RO)
 
-/* Check quota format used on specified medium and initialize it */
-struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int type,
-			     int fmt, int flags);
+/* Open existing quotafile of given type (and verify its format) on given
+ * filesystem. */
+errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
+			  int type, int fmt, int flags);
 
 /* Create new quotafile of specified format on given filesystem */
-int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt);
+errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
+			    int type, int fmt);
 
 /* Close quotafile */
-int end_io(struct quota_handle *h);
+errcode_t quota_file_close(struct quota_handle *h);
 
 /* Get empty quota structure */
 struct dquot *get_empty_dquot(void);
 
-void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino);
+errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
 
 const char *type2name(int type);
 
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index 0890ca3..b8583b9 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -18,8 +18,18 @@
 
 typedef char *dqbuf_t;
 
-#define getdqbuf()		smalloc(QT_BLKSIZE)
-#define freedqbuf(buf)		free(buf)
+#define freedqbuf(buf)		ext2fs_free_mem(&buf)
+
+static inline dqbuf_t getdqbuf(void)
+{
+	dqbuf_t buf;
+	if (ext2fs_get_memzero(QT_BLKSIZE, &buf)) {
+		log_err("Failed to allocate dqbuf", "");
+		return NULL;
+	}
+
+	return buf;
+}
 
 /* Is given dquot empty? */
 int qtree_entry_unused(struct qtree_mem_dqinfo *info, char *disk)
@@ -51,7 +61,7 @@ static void read_blk(struct quota_handle *h, uint blk, dqbuf_t buf)
 	err = h->e2fs_read(&h->qh_qf, blk << QT_BLKSIZE_BITS, buf,
 			QT_BLKSIZE);
 	if (err < 0)
-		log_fatal(2, "Cannot read block %u: %s", blk, strerror(errno));
+		log_err("Cannot read block %u: %s", blk, strerror(errno));
 	else if (err != QT_BLKSIZE)
 		memset(buf + err, 0, QT_BLKSIZE - err);
 }
@@ -64,8 +74,7 @@ static int write_blk(struct quota_handle *h, uint blk, dqbuf_t buf)
 	err = h->e2fs_write(&h->qh_qf, blk << QT_BLKSIZE_BITS, buf,
 			QT_BLKSIZE);
 	if (err < 0 && errno != ENOSPC)
-		log_fatal(2, "Cannot write block (%u): %s",
-			  blk, strerror(errno));
+		log_err("Cannot write block (%u): %s", blk, strerror(errno));
 	if (err != QT_BLKSIZE)
 		return -ENOSPC;
 	return 0;
@@ -79,6 +88,9 @@ static int get_free_dqblk(struct quota_handle *h)
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
 	int blk;
 
+	if (!buf)
+		return -ENOMEM;
+
 	if (info->dqi_free_blk) {
 		blk = info->dqi_free_blk;
 		read_blk(h, blk, buf);
@@ -122,6 +134,9 @@ static void remove_free_dqentry(struct quota_handle *h, dqbuf_t buf, uint blk)
 
 		ext2fs_le32_to_cpu(dh->dqdh_prev_free);
 
+	if (!tmpbuf)
+		return;
+
 	if (nextblk) {
 		read_blk(h, nextblk, tmpbuf);
 		((struct qt_disk_dqdbheader *)tmpbuf)->dqdh_prev_free =
@@ -150,6 +165,9 @@ static void insert_free_dqentry(struct quota_handle *h, dqbuf_t buf, uint blk)
 	struct qt_disk_dqdbheader *dh = (struct qt_disk_dqdbheader *)buf;
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
 
+	if (!tmpbuf)
+		return;
+
 	dh->dqdh_next_free = ext2fs_cpu_to_le32(info->dqi_free_entry);
 	dh->dqdh_prev_free = ext2fs_cpu_to_le32(0);
 	write_blk(h, blk, buf);
@@ -176,6 +194,11 @@ static uint find_free_dqentry(struct quota_handle *h, struct dquot *dquot,
 
 	*err = 0;
 	buf = getdqbuf();
+	if (!buf) {
+		*err = -ENOMEM;
+		return 0;
+	}
+
 	dh = (struct qt_disk_dqdbheader *)buf;
 	if (info->dqi_free_entry) {
 		blk = info->dqi_free_entry;
@@ -207,8 +230,8 @@ static uint find_free_dqentry(struct quota_handle *h, struct dquot *dquot,
 		ddquot += info->dqi_entry_size;
 
 	if (i == qtree_dqstr_in_blk(info))
-		log_fatal(2, "find_free_dqentry(): Data block full but it "
-			     "shouldn't.", "");
+		log_err("find_free_dqentry(): Data block full but it "
+			"shouldn't.", "");
 
 	write_blk(h, blk, buf);
 	dquot->dq_dqb.u.v2_mdqb.dqb_off =
@@ -230,6 +253,9 @@ static int do_insert_tree(struct quota_handle *h, struct dquot *dquot,
 
 	log_debug("inserting in tree: treeblk=%u, depth=%d", *treeblk, depth);
 	buf = getdqbuf();
+	if (!buf)
+		return -ENOMEM;
+
 	if (!*treeblk) {
 		ret = get_free_dqblk(h);
 		if (ret < 0)
@@ -247,9 +273,9 @@ static int do_insert_tree(struct quota_handle *h, struct dquot *dquot,
 		newson = 1;
 	if (depth == QT_TREEDEPTH - 1) {
 		if (newblk)
-			log_fatal(2, "Inserting already present quota entry "
-				     "(block %u).",
-				  ref[get_index(dquot->dq_id, depth)]);
+			log_err("Inserting already present quota entry "
+				"(block %u).",
+				ref[get_index(dquot->dq_id, depth)]);
 		newblk = find_free_dqentry(h, dquot, &ret);
 	} else {
 		ret = do_insert_tree(h, dquot, &newblk, depth + 1);
@@ -274,21 +300,28 @@ static void dq_insert_tree(struct quota_handle *h, struct dquot *dquot)
 	uint tmp = QT_TREEOFF;
 
 	if (do_insert_tree(h, dquot, &tmp, 0) < 0)
-		log_fatal(2, "Cannot write quota (id %u): %s",
-			  (uint) dquot->dq_id, strerror(errno));
+		log_err("Cannot write quota (id %u): %s",
+			(uint) dquot->dq_id, strerror(errno));
 }
 
 /* Write dquot to file */
 void qtree_write_dquot(struct dquot *dquot)
 {
 	ssize_t ret;
+	char *ddquot;
 	struct quota_handle *h = dquot->dq_h;
 	struct qtree_mem_dqinfo *info =
 			&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree;
 	log_debug("writing ddquot 1: off=%llu, info->dqi_entry_size=%u",
 			dquot->dq_dqb.u.v2_mdqb.dqb_off,
 			info->dqi_entry_size);
-	char *ddquot = (char *)smalloc(info->dqi_entry_size);
+	ret = ext2fs_get_mem(info->dqi_entry_size, &ddquot);
+	if (ret) {
+		errno = ENOMEM;
+		log_err("Quota write failed (id %u): %s",
+			(uint)dquot->dq_id, strerror(errno));
+		return;
+	}
 
 	if (!dquot->dq_dqb.u.v2_mdqb.dqb_off)
 		dq_insert_tree(dquot->dq_h, dquot);
@@ -302,9 +335,10 @@ void qtree_write_dquot(struct dquot *dquot)
 	if (ret != info->dqi_entry_size) {
 		if (ret > 0)
 			errno = ENOSPC;
-		log_fatal(2, "Quota write failed (id %u): %s",
-			  (uint)dquot->dq_id, strerror(errno));
+		log_err("Quota write failed (id %u): %s",
+			(uint)dquot->dq_id, strerror(errno));
 	}
+	ext2fs_free_mem(&ddquot);
 }
 
 /* Free dquot entry in data block */
@@ -314,9 +348,12 @@ static void free_dqentry(struct quota_handle *h, struct dquot *dquot, uint blk)
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
 	dqbuf_t buf = getdqbuf();
 
+	if (!buf)
+		return;
+
 	if (dquot->dq_dqb.u.v2_mdqb.dqb_off >> QT_BLKSIZE_BITS != blk)
-		log_fatal(2, "Quota structure has offset to other block (%u) "
-			     "than it should (%u).", blk,
+		log_err("Quota structure has offset to other block (%u) "
+			"than it should (%u).", blk,
 			  (uint) (dquot->dq_dqb.u.v2_mdqb.dqb_off >>
 				  QT_BLKSIZE_BITS));
 
@@ -353,6 +390,9 @@ static void remove_tree(struct quota_handle *h, struct dquot *dquot,
 	uint newblk;
 	u_int32_t *ref = (u_int32_t *) buf;
 
+	if (!buf)
+		return;
+
 	read_blk(h, *blk, buf);
 	newblk = ext2fs_le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
 	if (depth == QT_TREEDEPTH - 1) {
@@ -400,6 +440,9 @@ static ext2_loff_t find_block_dqentry(struct quota_handle *h,
 	int i;
 	char *ddquot = buf + sizeof(struct qt_disk_dqdbheader);
 
+	if (!buf)
+		return -ENOMEM;
+
 	read_blk(h, blk, buf);
 	for (i = 0;
 	     i < qtree_dqstr_in_blk(info) && !info->dqi_ops->is_id(ddquot, dquot);
@@ -407,8 +450,8 @@ static ext2_loff_t find_block_dqentry(struct quota_handle *h,
 		ddquot += info->dqi_entry_size;
 
 	if (i == qtree_dqstr_in_blk(info))
-		log_fatal(2, "Quota for id %u referenced but not present.",
-			  dquot->dq_id);
+		log_err("Quota for id %u referenced but not present.",
+			dquot->dq_id);
 	freedqbuf(buf);
 	return (blk << QT_BLKSIZE_BITS) + sizeof(struct qt_disk_dqdbheader) +
 		i * info->dqi_entry_size;
@@ -423,6 +466,9 @@ static ext2_loff_t find_tree_dqentry(struct quota_handle *h,
 	ext2_loff_t ret = 0;
 	u_int32_t *ref = (u_int32_t *) buf;
 
+	if (!buf)
+		return -ENOMEM;
+
 	read_blk(h, blk, buf);
 	ret = 0;
 	blk = ext2fs_le32_to_cpu(ref[get_index(dquot->dq_id, depth)]);
@@ -445,17 +491,23 @@ static inline ext2_loff_t find_dqentry(struct quota_handle *h,
 }
 
 /*
- *  Read dquot (either from disk or from kernel)
- *  User can use errno to detect errstr when NULL is returned
+ *  Read dquot from disk.
  */
 struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id)
 {
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
 	ext2_loff_t offset;
 	ssize_t ret;
-	char *ddquot = smalloc(info->dqi_entry_size);
+	char *ddquot;
 	struct dquot *dquot = get_empty_dquot();
 
+	if (!dquot)
+		return NULL;
+	if (ext2fs_get_mem(info->dqi_entry_size, &ddquot)) {
+		ext2fs_free_mem(&dquot);
+		return NULL;
+	}
+
 	dquot->dq_id = id;
 	dquot->dq_h = h;
 	dquot->dq_dqb.u.v2_mdqb.dqb_off = 0;
@@ -469,17 +521,17 @@ struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id)
 		if (ret != info->dqi_entry_size) {
 			if (ret > 0)
 				errno = EIO;
-			log_fatal(2,
-				"Cannot read quota structure for id %u: %s",
+			log_err("Cannot read quota structure for id %u: %s",
 				dquot->dq_id, strerror(errno));
 		}
 		info->dqi_ops->disk2mem_dqblk(dquot, ddquot);
 	}
+	ext2fs_free_mem(&ddquot);
 	return dquot;
 }
 
 /*
- *	Scan all dquots in file and call callback on each
+ * Scan all dquots in file and call callback on each
  */
 #define set_bit(bmp, ind) ((bmp)[(ind) >> 3] |= (1 << ((ind) & 7)))
 #define get_bit(bmp, ind) ((bmp)[(ind) >> 3] & (1 << ((ind) & 7)))
@@ -494,6 +546,9 @@ static int report_block(struct dquot *dquot, uint blk, char *bitmap,
 	char *ddata;
 	int entries, i;
 
+	if (!buf)
+		return 0;
+
 	set_bit(bitmap, blk);
 	read_blk(dquot->dq_h, blk, buf);
 	dh = (struct qt_disk_dqdbheader *)buf;
@@ -513,12 +568,12 @@ static int report_block(struct dquot *dquot, uint blk, char *bitmap,
 static void check_reference(struct quota_handle *h, uint blk)
 {
 	if (blk >= h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks)
-		log_fatal(2, "Illegal reference (%u >= %u) in %s quota file. "
-			     "Quota file is probably corrupted.\n"
-			     "Please run e2fsck (8) to fix it.",
-			  blk,
-			  h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
-			  type2name(h->qh_type));
+		log_err("Illegal reference (%u >= %u) in %s quota file. "
+			"Quota file is probably corrupted.\n"
+			"Please run e2fsck (8) to fix it.",
+			blk,
+			h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
+			type2name(h->qh_type));
 }
 
 static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
@@ -528,6 +583,9 @@ static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
 	dqbuf_t buf = getdqbuf();
 	u_int32_t *ref = (u_int32_t *) buf;
 
+	if (!buf)
+		return 0;
+
 	read_blk(dquot->dq_h, blk, buf);
 	if (depth == QT_TREEDEPTH - 1) {
 		for (i = 0; i < QT_BLKSIZE >> 2; i++) {
@@ -568,13 +626,18 @@ int qtree_scan_dquots(struct quota_handle *h,
 	struct qtree_mem_dqinfo *info = &v2info->dqi_qtree;
 	struct dquot *dquot = get_empty_dquot();
 
+	if (!dquot)
+		return -1;
+
 	dquot->dq_h = h;
-	bitmap = smalloc((info->dqi_blocks + 7) >> 3);
-	memset(bitmap, 0, (info->dqi_blocks + 7) >> 3);
+	if (ext2fs_get_memzero((info->dqi_blocks + 7) >> 3, &bitmap)) {
+		ext2fs_free_mem(&dquot);
+		return -1;
+	}
 	v2info->dqi_used_entries = report_tree(dquot, QT_TREEOFF, 0, bitmap,
 					       process_dquot);
 	v2info->dqi_data_blocks = find_set_bits(bitmap, info->dqi_blocks);
-	free(bitmap);
-	free(dquot);
+	ext2fs_free_mem(&bitmap);
+	ext2fs_free_mem(&dquot);
 	return 0;
 }
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
index 7c9e4f7..6b5078b 100644
--- a/lib/quota/quotaio_v2.c
+++ b/lib/quota/quotaio_v2.c
@@ -197,8 +197,8 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 
 	if (ext2fs_le32_to_cpu(dqh.dqh_magic) != file_magics[type]) {
 		if (ext2fs_be32_to_cpu(dqh.dqh_magic) == file_magics[type])
-			log_fatal(3, "Your quota file is stored in wrong "
-				  "endianity.", "");
+			log_err("Your quota file is stored in wrong "
+				"endianity.", "");
 		return 0;
 	}
 	if (ext2fs_le32_to_cpu(dqh.dqh_version) > known_versions[type])
@@ -214,7 +214,6 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 static int v2_init_io(struct quota_handle *h)
 {
 	log_err("Not Implemented.", "");
-	BUG_ON(1);
 	return 0;
 }
 
@@ -228,7 +227,8 @@ static int v2_new_io(struct quota_handle *h)
 	struct v2_disk_dqinfo ddqinfo;
 	int version = 1;
 
-	BUG_ON(h->qh_fmt != QFMT_VFS_V1);
+	if (h->qh_fmt != QFMT_VFS_V1)
+		return -1;
 
 	/* Write basic quota header */
 	ddqheader.dqh_magic = ext2fs_cpu_to_le32(file_magics[h->qh_type]);
@@ -272,8 +272,7 @@ static int v2_write_info(struct quota_handle *h)
 }
 
 /*
- * Read dquot (either from disk or from kernel)
- * User can use errno to detect errstr when NULL is returned
+ * Read dquot from disk
  */
 static struct dquot *v2_read_dquot(struct quota_handle *h, qid_t id)
 {
@@ -310,6 +309,5 @@ static int v2_scan_dquots(struct quota_handle *h,
 static int v2_report(struct quota_handle *h, int verbose)
 {
 	log_err("Not Implemented.", "");
-	BUG_ON(1);
-	return 0;
+	return -1;
 }
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a07e866..04b0189 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2181,13 +2181,13 @@ static int create_quota_inodes(ext2_filsys fs)
 {
 	quota_ctx_t qctx;
 
-	init_quota_context(&qctx, fs, -1);
-	compute_quota(qctx, -1);
-	write_quota_inode(qctx, USRQUOTA);
-	write_quota_inode(qctx, GRPQUOTA);
-	release_quota_context(&qctx);
+	quota_init_context(&qctx, fs, -1);
+	quota_compute_usage(qctx);
+	quota_write_inode(qctx, USRQUOTA);
+	quota_write_inode(qctx, GRPQUOTA);
+	quota_release_context(&qctx);
 
-	return;
+	return 0;
 }
 
 int main (int argc, char *argv[])
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ccb27a8..112b258 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -707,27 +707,27 @@ void handle_quota_options(ext2_filsys fs)
 		/* Nothing to do. */
 		return;
 
-	init_quota_context(&qctx, fs, -1);
+	quota_init_context(&qctx, fs, -1);
 
 	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, USRQUOTA)) > 0)
-			set_sb_quota_inum(fs, qf_ino, USRQUOTA);
+		if ((qf_ino = quota_file_exists(fs, USRQUOTA, QFMT_VFS_V1)) > 0)
+			quota_set_sb_inum(fs, qf_ino, USRQUOTA);
 		else
-			write_quota_inode(qctx, USRQUOTA);
+			quota_write_inode(qctx, USRQUOTA);
 	} else if (usrquota == QOPT_DISABLE) {
-		remove_quota_inode(fs, USRQUOTA);
+		quota_remove_inode(fs, USRQUOTA);
 	}
 
 	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, GRPQUOTA)) > 0)
-			set_sb_quota_inum(fs, qf_ino, GRPQUOTA);
+		if ((qf_ino = quota_file_exists(fs, GRPQUOTA, QFMT_VFS_V1)) > 0)
+			quota_set_sb_inum(fs, qf_ino, GRPQUOTA);
 		else
-			write_quota_inode(qctx, GRPQUOTA);
+			quota_write_inode(qctx, GRPQUOTA);
 	} else if (grpquota == QOPT_DISABLE) {
-		remove_quota_inode(fs, GRPQUOTA);
+		quota_remove_inode(fs, GRPQUOTA);
 	}
 
-	release_quota_context(&qctx);
+	quota_release_context(&qctx);
 
 	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
 		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
-- 
1.7.3.1

