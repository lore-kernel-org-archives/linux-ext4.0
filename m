From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2] e2fsprogs: clean up codes for adding new quota type
Date: Fri, 17 Jan 2014 16:06:39 +0800
Message-ID: <CAPTn0cBVcGo4J=wy3zUP-3eh1WeZqVz=sC4PW0OUQEGxvMdYbA@mail.gmail.com>
References: <CAPTn0cBB=aEunH9sK+DTC=_WsmnaQSdu=ajU0JsXvgfB2fAMew@mail.gmail.com>
	<5FD9AE93-B8AE-4221-AA43-EFCF6BFB5896@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>, Shuichi Ihara <sihara@ddn.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:49817 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQINC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jan 2014 03:13:02 -0500
Received: by mail-ig0-f178.google.com with SMTP id uq10so943115igb.5
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jan 2014 00:13:01 -0800 (PST)
In-Reply-To: <5FD9AE93-B8AE-4221-AA43-EFCF6BFB5896@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas, I've updated the patch which should have fixed most of the
problems you pointed out. And I'd like to add a sanity test suit to
check that MAXQUOTAS is < 32 as you said. Where do you think is the
place I should add it? Thanks!

Changelog:
* V2:
  - Change type2* functions to quota_type2*
  - Use uncontinuous array of s_quota_inum
  - Add quota_type_t
  - Fix a problem of quota_write_inode() in the first patch
  - Rename USRQUOTA_BIT/GRPQUOTA_BIT/ALLQUOTA_BIT to QUOTA_*_BIT
  - Code style change

Signed-off-by: Li Xi <lixi <at> ddn.com>
--
Index: e2fsprogs.git/lib/e2p/ls.c
===================================================================
--- e2fsprogs.git.orig/lib/e2p/ls.c
+++ e2fsprogs.git/lib/e2p/ls.c
@@ -23,6 +23,7 @@
 #include <time.h>

 #include "e2p.h"
+#include "quota/quotaio.h"

 static void print_user (unsigned short uid, FILE *f)
 {
@@ -206,11 +207,25 @@ static const char *checksum_type(__u8 ty
     }
 }

+static const char const *quota_names[MAXQUOTAS] = {
+        [USRQUOTA] = "User",
+        [GRPQUOTA] = "Group",
+};
+
+/**
+ * Convert type of quota to written representation
+ */
+const char *quota_type2upper_name(quota_type_t type)
+{
+    return quota_names[type];
+}
+
 void list_super2(struct ext2_super_block * sb, FILE *f)
 {
     int inode_blocks_per_group;
     char buf[80], *str;
     time_t    tm;
+    quota_type_t type;

     inode_blocks_per_group = (((sb->s_inodes_per_group *
                     EXT2_INODE_SIZE(sb)) +
@@ -426,13 +441,12 @@ void list_super2(struct ext2_super_block
         fprintf(f, "MMP update interval:      %u\n",
             sb->s_mmp_update_interval);
     }
-    if (sb->s_usr_quota_inum)
-        fprintf(f, "User quota inode:         %u\n",
-            sb->s_usr_quota_inum);
-    if (sb->s_grp_quota_inum)
-        fprintf(f, "Group quota inode:        %u\n",
-            sb->s_grp_quota_inum);
-
+    for (type = 0; type < MAXQUOTAS; type++) {
+        if (sb->s_quota_inum[quota_type2offset(type)])
+            fprintf(f, "%s quota inode:         %u\n",
+                quota_type2upper_name(type),
+                sb->s_quota_inum[quota_type2offset(type)]);
+    }
     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
         fprintf(f, "Checksum type:            %s\n",
             checksum_type(sb->s_checksum_type));
Index: e2fsprogs.git/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.git.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs.git/lib/ext2fs/ext2_fs.h
@@ -666,8 +666,7 @@ struct ext2_super_block {
     __u8    s_last_error_func[32];    /* function where the error happened */
 #define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, s_mount_opts)
     __u8    s_mount_opts[64];
-    __u32    s_usr_quota_inum;    /* inode number of user quota file */
-    __u32    s_grp_quota_inum;    /* inode number of group quota file */
+    __u32    s_quota_inum[2];    /* inode numbers of quota files */
     __u32    s_overhead_blocks;    /* overhead blocks/clusters in fs */
     __u32   s_reserved[108];        /* Padding to the end of the block */
     __u32    s_checksum;        /* crc32c(superblock) */
Index: e2fsprogs.git/lib/quota/mkquota.c
===================================================================
--- e2fsprogs.git.orig/lib/quota/mkquota.c
+++ e2fsprogs.git/lib/quota/mkquota.c
@@ -51,7 +51,7 @@ static void print_inode(struct ext2_inod
  * Returns 0 if not able to find the quota file, otherwise returns its
  * inode number.
  */
-int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
+int quota_file_exists(ext2_filsys fs, quota_type_t qtype, int fmt)
 {
     char qf_name[256];
     errcode_t ret;
@@ -73,12 +73,11 @@ int quota_file_exists(ext2_filsys fs, in
 /*
  * Set the value for reserved quota inode number field in superblock.
  */
-void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, quota_type_t qtype)
 {
     ext2_ino_t *inump;

-    inump = (qtype == USRQUOTA) ? &fs->super->s_usr_quota_inum :
-        &fs->super->s_grp_quota_inum;
+    inump = &fs->super->s_quota_inum[quota_type2offset(qtype)];

     log_debug("setting quota ino in superblock: ino=%u, type=%d", ino,
          qtype);
@@ -86,13 +85,12 @@ void quota_set_sb_inum(ext2_filsys fs, e
     ext2fs_mark_super_dirty(fs);
 }

-errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
+errcode_t quota_remove_inode(ext2_filsys fs, quota_type_t qtype)
 {
     ext2_ino_t qf_ino;

     ext2fs_read_bitmaps(fs);
-    qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
-        fs->super->s_grp_quota_inum;
+    qf_ino = fs->super->s_quota_inum[quota_type2offset(qtype)];
     quota_set_sb_inum(fs, 0, qtype);
     /* Truncate the inode only if its a reserved one. */
     if (qf_ino < EXT2_FIRST_INODE(fs->super))
@@ -119,9 +117,10 @@ static void write_dquots(dict_t *dict, s
     }
 }

-errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
+errcode_t quota_write_inode(quota_ctx_t qctx, unsigned int qtype_bits)
 {
-    int        retval = 0, i;
+    int        retval = 0;
+    quota_type_t    i;
     dict_t        *dict;
     ext2_filsys    fs;
     struct quota_handle *h = NULL;
@@ -140,7 +139,7 @@ errcode_t quota_write_inode(quota_ctx_t
     ext2fs_read_bitmaps(fs);

     for (i = 0; i < MAXQUOTAS; i++) {
-        if ((qtype != -1) && (i != qtype))
+        if (((1 << i) & qtype_bits) == 0)
             continue;

         dict = qctx->quota_dict[i];
@@ -192,7 +191,7 @@ static int dict_uint_cmp(const void *a,
     return c - d;
 }

-static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
+static inline qid_t get_qid(struct ext2_inode *inode, quota_type_t qtype)
 {
     if (qtype == USRQUOTA)
         return inode_uid(*inode);
@@ -211,9 +210,11 @@ static void quota_dnode_free(dnode_t *no
 /*
  * Set up the quota tracking data structures.
  */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
+                 unsigned int qtype_bits)
 {
-    int    i, err = 0;
+    int        err = 0;
+    quota_type_t    i;
     dict_t    *dict;
     quota_ctx_t ctx;

@@ -225,7 +226,7 @@ errcode_t quota_init_context(quota_ctx_t

     memset(ctx, 0, sizeof(struct quota_ctx));
     for (i = 0; i < MAXQUOTAS; i++) {
-        if ((qtype != -1) && (i != qtype))
+        if (((1 << i) & qtype_bits) == 0)
             continue;
         err = ext2fs_get_mem(sizeof(dict_t), &dict);
         if (err) {
@@ -246,7 +247,7 @@ errcode_t quota_init_context(quota_ctx_t
 void quota_release_context(quota_ctx_t *qctx)
 {
     dict_t    *dict;
-    int    i;
+    quota_type_t    i;
     quota_ctx_t ctx;

     if (!qctx)
@@ -294,7 +295,7 @@ void quota_data_add(quota_ctx_t qctx, st
 {
     struct dquot    *dq;
     dict_t        *dict;
-    int        i;
+    quota_type_t    i;

     if (!qctx)
         return;
@@ -320,7 +321,7 @@ void quota_data_sub(quota_ctx_t qctx, st
 {
     struct dquot    *dq;
     dict_t        *dict;
-    int        i;
+    quota_type_t    i;

     if (!qctx)
         return;
@@ -345,7 +346,7 @@ void quota_data_inodes(quota_ctx_t qctx,
 {
     struct dquot    *dq;
     dict_t        *dict;
-    int        i;
+    quota_type_t    i;

     if (!qctx)
         return;
@@ -486,7 +487,8 @@ static errcode_t quota_write_all_dquots(
 /*
  * Updates the in-memory quota limits from the given quota inode.
  */
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
+                  quota_type_t type)
 {
     struct quota_handle *qh;
     errcode_t err;
@@ -525,7 +527,7 @@ out:
  * on disk and updates the limits in qctx->quota_dict. 'usage_inconsistent' is
  * set to 1 if the supplied and on-disk quota usage values are not identical.
  */
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+errcode_t quota_compare_and_update(quota_ctx_t qctx, quota_type_t qtype,
                    int *usage_inconsistent)
 {
     ext2_filsys fs = qctx->fs;
@@ -537,8 +539,7 @@ errcode_t quota_compare_and_update(quota
     if (!qctx->quota_dict[qtype])
         goto out;

-    qf_ino = qtype == USRQUOTA ? fs->super->s_usr_quota_inum :
-                     fs->super->s_grp_quota_inum;
+    qf_ino = fs->super->s_quota_inum[quota_type2offset(qtype)];
     err = quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
     if (err) {
         log_err("Open quota file failed");
Index: e2fsprogs.git/e2fsck/pass1.c
===================================================================
--- e2fsprogs.git.orig/e2fsck/pass1.c
+++ e2fsprogs.git/e2fsck/pass1.c
@@ -574,6 +574,28 @@ static errcode_t recheck_bad_inode_check
     return 0;
 }

+static int quota_inum_is_super(struct ext2_super_block *sb, ext2_ino_t ino)
+{
+    quota_type_t i;
+
+    for (i = 0; i < MAXQUOTAS; i++)
+        if (sb->s_quota_inum[quota_type2offset(i)] == ino)
+            return 1;
+
+    return 0;
+}
+
+static int quota_inum_is_reserved(ext2_ino_t ino)
+{
+    quota_type_t i;
+
+    for (i = 0; i < MAXQUOTAS; i++)
+        if (quota_type2ino(i) == ino)
+            return 1;
+
+    return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
     int    i;
@@ -970,13 +992,11 @@ void e2fsck_pass1(e2fsck_t ctx)
                 e2fsck_write_inode_full(ctx, ino, inode,
                             inode_size, "pass1");
             }
-        } else if ((ino == EXT4_USR_QUOTA_INO) ||
-               (ino == EXT4_GRP_QUOTA_INO)) {
+        } else if (quota_inum_is_reserved(ino)) {
             ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
             if ((fs->super->s_feature_ro_compat &
                     EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-                ((fs->super->s_usr_quota_inum == ino) ||
-                 (fs->super->s_grp_quota_inum == ino))) {
+                quota_inum_is_super(fs->super, ino)) {
                 if (!LINUX_S_ISREG(inode->i_mode) &&
                     fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
                             &pctx)) {
Index: e2fsprogs.git/e2fsck/quota.c
===================================================================
--- e2fsprogs.git.orig/e2fsck/quota.c
+++ e2fsprogs.git/e2fsck/quota.c
@@ -19,7 +19,7 @@
 #include "quota/quotaio.h"

 static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
-                 ext2_ino_t to_ino, int qtype)
+                 ext2_ino_t to_ino, quota_type_t qtype)
 {
     struct ext2_inode    inode;
     errcode_t        retval;
@@ -63,6 +63,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
     struct ext2_super_block *sb = ctx->fs->super;
     struct problem_context    pctx;
     ext2_filsys        fs = ctx->fs;
+    quota_type_t i;
+    ext2_ino_t quota_ino;

     clear_problem_context(&pctx);

@@ -70,22 +72,17 @@ void e2fsck_hide_quota(e2fsck_t ctx)
         !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
         return;

-    pctx.ino = sb->s_usr_quota_inum;
-    if (sb->s_usr_quota_inum &&
-        (sb->s_usr_quota_inum != EXT4_USR_QUOTA_INO) &&
-        fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
-        move_quota_inode(fs, sb->s_usr_quota_inum, EXT4_USR_QUOTA_INO,
-                 USRQUOTA);
-        sb->s_usr_quota_inum = EXT4_USR_QUOTA_INO;
-    }
-
-    pctx.ino = sb->s_grp_quota_inum;
-    if (sb->s_grp_quota_inum &&
-        (sb->s_grp_quota_inum != EXT4_GRP_QUOTA_INO) &&
-        fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
-        move_quota_inode(fs, sb->s_grp_quota_inum, EXT4_GRP_QUOTA_INO,
-                 GRPQUOTA);
-        sb->s_grp_quota_inum = EXT4_GRP_QUOTA_INO;
+    for (i = 0; i < MAXQUOTAS; i++) {
+        pctx.ino = sb->s_quota_inum[quota_type2offset(i)];
+        quota_ino = quota_type2ino(i);
+        if (sb->s_quota_inum[quota_type2offset(i)] &&
+            (sb->s_quota_inum[quota_type2offset(i)] != quota_ino) &&
+            fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
+            move_quota_inode(fs, sb->s_quota_inum[quota_type2offset(i)],
+                     quota_ino,
+                     i);
+            sb->s_quota_inum[quota_type2offset(i)] = quota_ino;
+        }
     }

     return;
Index: e2fsprogs.git/e2fsck/unix.c
===================================================================
--- e2fsprogs.git.orig/e2fsck/unix.c
+++ e2fsprogs.git/e2fsck/unix.c
@@ -1180,7 +1180,7 @@ int main (int argc, char *argv[])
     int old_bitmaps;
     __u32 features[3];
     char *cp;
-    int qtype = -99;  /* quota type */
+    unsigned int qtype_bits = 0;  /* quota type */

     clear_problem_context(&pctx);
     sigcatcher_setup();
@@ -1623,14 +1623,14 @@ print_unsupp_features:
         journal_size = -1;

     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
+        quota_type_t i;
         /* Quotas were enabled. Do quota accounting during fsck. */
-        if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
-            (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
-            qtype = -1;
-        else
-            qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
+        for (i = 0; i < MAXQUOTAS; i++) {
+            if (sb->s_quota_inum[quota_type2offset(i)])
+                qtype_bits |= 1 << i;
+        }

-        quota_init_context(&ctx->qctx, ctx->fs, qtype);
+        quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
     }

     run_result = e2fsck_run(ctx);
@@ -1667,9 +1667,10 @@ print_unsupp_features:
 no_journal:

     if (ctx->qctx) {
-        int i, needs_writeout;
+        int needs_writeout;
+        quota_type_t i;
         for (i = 0; i < MAXQUOTAS; i++) {
-            if (qtype != -1 && qtype != i)
+            if (((1 << i) & qtype_bits) == 0)
                 continue;
             needs_writeout = 0;
             pctx.num = i;
@@ -1677,7 +1678,7 @@ no_journal:
                               &needs_writeout);
             if ((retval || needs_writeout) &&
                 fix_problem(ctx, PR_6_UPDATE_QUOTAS, &pctx))
-                quota_write_inode(ctx->qctx, i);
+                quota_write_inode(ctx->qctx, 1 << i);
         }
         quota_release_context(&ctx->qctx);
     }
Index: e2fsprogs.git/lib/quota/mkquota.h
===================================================================
--- e2fsprogs.git.orig/lib/quota/mkquota.h
+++ e2fsprogs.git/lib/quota/mkquota.h
@@ -10,7 +10,7 @@
  * {
  *    quota_ctx_t qctx;
  *
- *    quota_init_context(&qctx, fs, -1);
+ *    quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
  *    {
  *        quota_compute_usage(qctx, -1);
  *        AND/OR
@@ -43,22 +43,24 @@ struct quota_ctx {
 };

 /* In mkquota.c */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
+        unsigned int qtype_bits);
 void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
ext2_ino_t ino,
         int adjust);
 void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
         qsize_t space);
 void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
         qsize_t space);
-errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
+errcode_t quota_write_inode(quota_ctx_t qctx, unsigned int qtype_bits);
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
+        quota_type_t type);
 errcode_t quota_compute_usage(quota_ctx_t qctx);
 void quota_release_context(quota_ctx_t *qctx);

-errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
-int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
-void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+errcode_t quota_remove_inode(ext2_filsys fs, quota_type_t qtype);
+int quota_file_exists(ext2_filsys fs, quota_type_t qtype, int fmt);
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, quota_type_t qtype);
+errcode_t quota_compare_and_update(quota_ctx_t qctx, quota_type_t qtype,
                    int *usage_inconsistent);

 #endif  /* __QUOTA_QUOTAIO_H__ */
Index: e2fsprogs.git/lib/quota/quotaio.c
===================================================================
--- e2fsprogs.git.orig/lib/quota/quotaio.c
+++ e2fsprogs.git/lib/quota/quotaio.c
@@ -37,15 +37,31 @@ struct disk_dqheader {
 /**
  * Convert type of quota to written representation
  */
-const char *type2name(int type)
+const char *quota_type2name(quota_type_t type)
 {
     return extensions[type];
 }

+ext2_ino_t quota_type2ino(quota_type_t qtype)
+{
+    switch (qtype) {
+    case USRQUOTA:
+        return EXT4_USR_QUOTA_INO;
+        break;
+    case GRPQUOTA:
+        return EXT4_GRP_QUOTA_INO;
+        break;
+    default:
+        return 0;
+        break;
+    }
+    return 0;
+}
+
 /**
  * Creates a quota file name for given type and format.
  */
-const char *quota_get_qf_name(int type, int fmt, char *buf)
+const char *quota_get_qf_name(quota_type_t type, int fmt, char *buf)
 {
     if (!buf)
         return NULL;
@@ -55,7 +71,7 @@ const char *quota_get_qf_name(int type,
     return buf;
 }

-const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+const char *quota_get_qf_path(const char *mntpt, quota_type_t qtype, int fmt,
                   char *path_buf, size_t path_buf_size)
 {
     char qf_name[QUOTA_NAME_LEN];
@@ -114,11 +130,16 @@ errcode_t quota_inode_truncate(ext2_fils
 {
     struct ext2_inode inode;
     errcode_t err;
+    quota_type_t i;

     if ((err = ext2fs_read_inode(fs, ino, &inode)))
         return err;

-    if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO)) {
+    for (i = 0; i < MAXQUOTAS; i++)
+        if (ino == quota_type2ino(i))
+            break;
+
+    if (i != MAXQUOTAS) {
         inode.i_dtime = fs->now ? fs->now : time(0);
         if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
             return 0;
@@ -198,7 +219,8 @@ static unsigned int quota_read_nomount(s
  * Detect quota format and initialize quota IO
  */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
-              ext2_ino_t qf_ino, int type, int fmt, int flags)
+              ext2_ino_t qf_ino, quota_type_t type, int fmt,
+              int flags)
 {
     ext2_file_t e2_file;
     errcode_t err;
@@ -280,7 +302,8 @@ static errcode_t quota_inode_init_new(ex
 /*
  * Create new quotafile of specified format on given filesystem
  */
-errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
int type, int fmt)
+errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
+                quota_type_t type, int fmt)
 {
     ext2_file_t e2_file;
     int err;
@@ -290,11 +313,8 @@ errcode_t quota_file_create(struct quota
         fmt = QFMT_VFS_V1;

     h->qh_qf.fs = fs;
-    if (type == USRQUOTA)
-        qf_inum = EXT4_USR_QUOTA_INO;
-    else if (type == GRPQUOTA)
-        qf_inum = EXT4_GRP_QUOTA_INO;
-    else
+    qf_inum = quota_type2ino(type);
+    if (qf_inum == 0)
         return -1;

     err = ext2fs_read_bitmaps(fs);
Index: e2fsprogs.git/lib/quota/quotaio.h
===================================================================
--- e2fsprogs.git.orig/lib/quota/quotaio.h
+++ e2fsprogs.git/lib/quota/quotaio.h
@@ -16,9 +16,15 @@

 typedef int64_t qsize_t;    /* Type in which we store size limitations */

-#define MAXQUOTAS 2
-#define USRQUOTA 0
-#define GRPQUOTA 1
+typedef enum {
+    USRQUOTA = 0,
+    GRPQUOTA = 1,
+    MAXQUOTAS
+} quota_type_t;
+
+#define QUOTA_USR_BIT (1 << USRQUOTA)
+#define QUOTA_GRP_BIT (1 << GRPQUOTA)
+#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT)

 /*
  * Definitions of magics and versions of current quota files
@@ -68,7 +74,7 @@ struct quota_file {

 /* Structure for one opened quota file */
 struct quota_handle {
-    int qh_type;        /* Type of quotafile */
+    quota_type_t qh_type;    /* Type of quotafile */
     int qh_fmt;        /* Quotafile format */
     int qh_io_flags;    /* IO flags for file */
     struct quota_file qh_qf;
@@ -135,12 +141,13 @@ extern struct quotafile_ops quotafile_op
 /* Open existing quotafile of given type (and verify its format) on given
  * filesystem. */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
-              ext2_ino_t qf_ino, int type, int fmt, int flags);
+              ext2_ino_t qf_ino, quota_type_t type, int fmt,
+              int flags);


 /* Create new quotafile of specified format on given filesystem */
 errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
-                int type, int fmt);
+                quota_type_t type, int fmt);

 /* Close quotafile */
 errcode_t quota_file_close(struct quota_handle *h);
@@ -150,7 +157,8 @@ struct dquot *get_empty_dquot(void);

 errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);

-const char *type2name(int type);
+const char *quota_type2name(quota_type_t type);
+ext2_ino_t quota_type2ino(quota_type_t qtype);

 void update_grace_times(struct dquot *q);

@@ -158,8 +166,26 @@ void update_grace_times(struct dquot *q)
    than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
 #define QUOTA_NAME_LEN 16

-const char *quota_get_qf_name(int type, int fmt, char *buf);
-const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+const char *quota_get_qf_name(quota_type_t type, int fmt, char *buf);
+const char *quota_get_qf_path(const char *mntpt, quota_type_t qtype, int fmt,
                   char *path_buf, size_t path_buf_size);

+static inline int quota_type2offset(quota_type_t qtype)
+{
+    switch (qtype) {
+        case USRQUOTA:
+            return 0;
+        case GRPQUOTA:
+            return 1;
+        /* Skip s_overhead_blocks like this */
+        /*
+        case PRJQUOTA:
+            return 3;
+        */
+        default:
+            return -1;
+    }
+    return -1;
+}
+
 #endif /* GUARD_QUOTAIO_H */
Index: e2fsprogs.git/misc/tune2fs.c
===================================================================
--- e2fsprogs.git.orig/misc/tune2fs.c
+++ e2fsprogs.git/misc/tune2fs.c
@@ -94,7 +94,7 @@ static int stride_set, stripe_width_set;
 static char *extended_cmd;
 static unsigned long new_inode_size;
 static char *ext_mount_opts;
-static int usrquota, grpquota;
+static int quota_enable[MAXQUOTAS];
 static int rewrite_checksums;

 int journal_size, journal_flags;
@@ -862,6 +862,7 @@ static int update_feature_set(ext2_filsy
     __u32        old_features[3];
     int        type_err;
     unsigned int    mask_err;
+    quota_type_t    i;

 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
                 ((&sb->s_feature_compat)[(type)] & (mask)))
@@ -1095,8 +1096,8 @@ mmp_error:
         if (!Q_flag) {
             Q_flag = 1;
             /* Enable both user quota and group quota by default */
-            usrquota = QOPT_ENABLE;
-            grpquota = QOPT_ENABLE;
+            for (i = 0; i < MAXQUOTAS; i++)
+                quota_enable[i] = QOPT_ENABLE;
         }
         sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
     }
@@ -1112,8 +1113,8 @@ mmp_error:
                 "arguments.\n"), stderr);
         Q_flag = 1;
         /* Disable both user quota and group quota by default */
-        usrquota = QOPT_DISABLE;
-        grpquota = QOPT_DISABLE;
+        for (i = 0; i < MAXQUOTAS; i++)
+            quota_enable[i] = QOPT_DISABLE;
     }

     if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
@@ -1222,47 +1223,54 @@ static void handle_quota_options(ext2_fi
 {
     quota_ctx_t qctx;
     ext2_ino_t qf_ino;
+    quota_type_t i;
+    int enable = 0;

-    if (!usrquota && !grpquota)
+    for (i = 0 ; i < MAXQUOTAS; i++)
+        if (quota_enable[i] != 0)
+            break;
+    if (i == MAXQUOTAS)
         /* Nothing to do. */
         return;

-    quota_init_context(&qctx, fs, -1);
-
-    if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
+    quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
+    for (i = 0 ; i < MAXQUOTAS; i++) {
+        if (quota_enable[i] == QOPT_ENABLE) {
+            enable = 1;
+            break;
+        }
+    }
+    if (enable)
         quota_compute_usage(qctx);

-    if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
-        if ((qf_ino = quota_file_exists(fs, USRQUOTA,
-                        QFMT_VFS_V1)) > 0)
-            quota_update_limits(qctx, qf_ino, USRQUOTA);
-        quota_write_inode(qctx, USRQUOTA);
-    } else if (usrquota == QOPT_DISABLE) {
-        quota_remove_inode(fs, USRQUOTA);
-    }
-
-    if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
-        if ((qf_ino = quota_file_exists(fs, GRPQUOTA,
-                        QFMT_VFS_V1)) > 0)
-            quota_update_limits(qctx, qf_ino, GRPQUOTA);
-        quota_write_inode(qctx, GRPQUOTA);
-    } else if (grpquota == QOPT_DISABLE) {
-        quota_remove_inode(fs, GRPQUOTA);
+    for (i = 0 ; i < MAXQUOTAS; i++) {
+        if (quota_enable[i] == QOPT_ENABLE &&
!fs->super->s_quota_inum[quota_type2offset(i)]) {
+            if ((qf_ino = quota_file_exists(fs, i,
+                            QFMT_VFS_V1)) > 0)
+                quota_update_limits(qctx, qf_ino, i);
+            quota_write_inode(qctx, 1 << i);
+        } else if (quota_enable[i] == QOPT_DISABLE) {
+            quota_remove_inode(fs, i);
+        }
     }

     quota_release_context(&qctx);

-    if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
+    if (enable) {
         fprintf(stderr, "%s", _("\nWarning: the quota feature is still "
                   "under development\n"
                   "See https://ext4.wiki.kernel.org/"
                   "index.php/Quota for more information\n\n"));
         fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
         ext2fs_mark_super_dirty(fs);
-    } else if (!fs->super->s_usr_quota_inum &&
-           !fs->super->s_grp_quota_inum) {
-        fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
-        ext2fs_mark_super_dirty(fs);
+    } else {
+        for (i = 0 ; i < MAXQUOTAS; i++)
+            if (fs->super->s_quota_inum[quota_type2offset(i)])
+                break;
+        if (i == MAXQUOTAS) {
+            fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
+            ext2fs_mark_super_dirty(fs);
+        }
     }

     return;
@@ -1291,13 +1299,13 @@ static void parse_quota_opts(const char
         }

         if (strcmp(token, "usrquota") == 0) {
-            usrquota = QOPT_ENABLE;
+            quota_enable[USRQUOTA] = QOPT_ENABLE;
         } else if (strcmp(token, "^usrquota") == 0) {
-            usrquota = QOPT_DISABLE;
+            quota_enable[USRQUOTA] = QOPT_DISABLE;
         } else if (strcmp(token, "grpquota") == 0) {
-            grpquota = QOPT_ENABLE;
+            quota_enable[GRPQUOTA] = QOPT_ENABLE;
         } else if (strcmp(token, "^grpquota") == 0) {
-            grpquota = QOPT_DISABLE;
+            quota_enable[GRPQUOTA] = QOPT_DISABLE;
         } else {
             fputs(_("\nBad quota options specified.\n\n"
                 "Following valid quota options are available "
Index: e2fsprogs.git/debugfs/set_fields.c
===================================================================
--- e2fsprogs.git.orig/debugfs/set_fields.c
+++ e2fsprogs.git/debugfs/set_fields.c
@@ -147,8 +147,8 @@ static struct field_set_info super_field
       NULL, 8, parse_uint },
     { "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint },
     { "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
-    { "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
-    { "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
+    { "quota_inum", &set_sb.s_quota_inum, NULL, 4, parse_uint, FLAG_ARRAY,
+      2 },
     { "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, parse_uint },
     { "checksum", &set_sb.s_checksum, NULL, 4, parse_uint },
     { "checksum_type", &set_sb.s_checksum_type, NULL, 1, parse_uint },
Index: e2fsprogs.git/lib/ext2fs/tst_super_size.c
===================================================================
--- e2fsprogs.git.orig/lib/ext2fs/tst_super_size.c
+++ e2fsprogs.git/lib/ext2fs/tst_super_size.c
@@ -132,8 +132,7 @@ int main(int argc, char **argv)
     check_field(s_last_error_block, 8);
     check_field(s_last_error_func, 32);
     check_field(s_mount_opts, 64);
-    check_field(s_usr_quota_inum, 4);
-    check_field(s_grp_quota_inum, 4);
+    check_field(s_quota_inum, 4 * 2);
     check_field(s_overhead_blocks, 4);
     check_field(s_reserved, 108 * 4);
     check_field(s_checksum, 4);
Index: e2fsprogs.git/lib/quota/quotaio_tree.c
===================================================================
--- e2fsprogs.git.orig/lib/quota/quotaio_tree.c
+++ e2fsprogs.git/lib/quota/quotaio_tree.c
@@ -586,7 +586,7 @@ static void check_reference(struct quota
             "Please run e2fsck (8) to fix it.",
             blk,
             h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
-            type2name(h->qh_type));
+            quota_type2name(h->qh_type));
 }

 static int report_tree(struct dquot *dquot, unsigned int blk, int depth,
Index: e2fsprogs.git/misc/mke2fs.c
===================================================================
--- e2fsprogs.git.orig/misc/mke2fs.c
+++ e2fsprogs.git/misc/mke2fs.c
@@ -95,7 +95,7 @@ int    journal_flags;
 static int    lazy_itable_init;
 static char    *bad_blocks_filename = NULL;
 static __u32    fs_stride;
-static int    quotatype = -1;  /* Initialize both user and group
quotas by default */
+static unsigned int quotatype_bits = QUOTA_ALL_BIT;  /* Initialize
both all quotas by default */
 static __u64    offset;

 static struct ext2_super_block fs_param;
@@ -916,9 +916,9 @@ static void parse_extended_opts(struct e
                 continue;
             }
             if (!strncmp(arg, "usr", 3)) {
-                quotatype = 0;
+                quotatype_bits = QUOTA_USR_BIT;
             } else if (!strncmp(arg, "grp", 3)) {
-                quotatype = 1;
+                quotatype_bits = QUOTA_GRP_BIT;
             } else {
                 fprintf(stderr,
                     _("Invalid quotatype parameter: %s\n"),
@@ -2444,7 +2444,7 @@ static int create_quota_inodes(ext2_fils

     quota_init_context(&qctx, fs, -1);
     quota_compute_usage(qctx);
-    quota_write_inode(qctx, quotatype);
+    quota_write_inode(qctx, quotatype_bits);
     quota_release_context(&qctx);

     return 0;

2014/1/17 Andreas Dilger <adilger@dilger.ca>:
> On Jan 15, 2014, at 8:29 PM, Li Xi <pkuelelixi@gmail.com> wrote:
>> Adding directory/project quota support to ext4 is widely discussed
>> these days. E2fsprogs has to be updated if we want that new feature.
>> As a preparation for it, this patch cleans up quota codes of e2fsprogs
>> so as to make it easier to add new quota type(s).
>>
>> Test suits are all passed when "make rpm". I am trying to avoid
>> breaking anything, so please let me know if there is any extra test
>> suits we have run to check its correctness. Thanks!
>>
>> Signed-off-by: Li Xi <lixi <at> ddn.com>
>> ---
>> Index: e2fsprogs.git/lib/e2p/ls.c
>> ===================================================================
>> --- e2fsprogs.git.orig/lib/e2p/ls.c
>> +++ e2fsprogs.git/lib/e2p/ls.c
>> @@ -206,11 +206,22 @@ static const char *checksum_type(__u8 ty
>>     }
>> }
>>
>> +static const char * const names[MAXQUOTAS] = {"User", "Group"};
>
> (style) no space after '*'
>
> It would probably be better to declare these one line per entry, like:
>
> static const char const *quota_names[MAXQUOTAS] = {
>         [USRQUOTA] = "User",
>         [GRPQUOTA] = "Group",
>         [PRJQUOTA] = "Project",
> };
>
>> +/**
>> + * Convert type of quota to written representation
>> + */
>> +const char *type2Name(int type)
>
> (style) no camel-case for function names
>
>> +{
>> +    return names[type];
>> +}
>> +
>> void list_super2(struct ext2_super_block * sb, FILE *f)
>> {
>>     int inode_blocks_per_group;
>>     char buf[80], *str;
>>     time_t    tm;
>> +    int type;
>>
>>     inode_blocks_per_group = (((sb->s_inodes_per_group *
>>                     EXT2_INODE_SIZE(sb)) +
>> @@ -426,13 +437,12 @@ void list_super2(struct ext2_super_block
>>         fprintf(f, "MMP update interval:      %u\n",
>>             sb->s_mmp_update_interval);
>>     }
>> -    if (sb->s_usr_quota_inum)
>> -        fprintf(f, "User quota inode:         %u\n",
>> -            sb->s_usr_quota_inum);
>> -    if (sb->s_grp_quota_inum)
>> -        fprintf(f, "Group quota inode:        %u\n",
>> -            sb->s_grp_quota_inum);
>> -
>> +    for (type = 0; type < MAXQUOTAS; type++) {
>> +        if (sb->s_quota_inum[type])
>> +            fprintf(f, "%s quota inode:         %u\n",
>> +                type2Name(type),
>> +                sb->s_quota_inum[type]);
>> +    }
>>     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
>>         fprintf(f, "Checksum type:            %s\n",
>>             checksum_type(sb->s_checksum_type));
>> Index: e2fsprogs.git/lib/ext2fs/ext2_fs.h
>> ===================================================================
>> --- e2fsprogs.git.orig/lib/ext2fs/ext2_fs.h
>> +++ e2fsprogs.git/lib/ext2fs/ext2_fs.h
>> @@ -18,6 +18,8 @@
>>
>> #include <ext2fs/ext2_types.h>        /* Changed from linux/types.h */
>>
>> +#define MAXQUOTAS 2
>> +
>> /*
>>  * The second extended filesystem constants/structures
>>  */
>> @@ -666,8 +668,7 @@ struct ext2_super_block {
>>     __u8    s_last_error_func[32];    /* function where the error happened */
>> #define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, s_mount_opts)
>>     __u8    s_mount_opts[64];
>> -    __u32    s_usr_quota_inum;    /* inode number of user quota file */
>> -    __u32    s_grp_quota_inum;    /* inode number of group quota file */
>> +    __u32    s_quota_inum[MAXQUOTAS];/* inode numbers of quota files */
>
> Unfortunately, this has the potential for a serious data corruption,
> since ext2_super_block is the on-disk superblock and not in-memory.
>
> If MAXQUOTAS is ever changed then this will overflow s_overhead_blocks
> on disk and change the size of the superblock, which will also break
> the superblock checksum.
>
> Unfortunately, I don't see an easy way to fix this without having some
> kind of indirection array or function that records the offsets of these
> fields in the superblock, because both s_{usr,grp}_quota_inum and s_overhead_blocks have been in use for long enough that it isn't easy
> to change them.  The benefit is that with an indirection array there is
> no need to reserve contiguous space for all future quota types.
>
>>     __u32    s_overhead_blocks;    /* overhead blocks/clusters in fs */
>>     __u32   s_reserved[108];        /* Padding to the end of the block */
>>     __u32    s_checksum;        /* crc32c(superblock) */
>> Index: e2fsprogs.git/lib/quota/mkquota.c
>> ===================================================================
>> --- e2fsprogs.git.orig/lib/quota/mkquota.c
>> +++ e2fsprogs.git/lib/quota/mkquota.c
>> @@ -77,8 +77,7 @@ void quota_set_sb_inum(ext2_filsys fs, e
>> {
>>     ext2_ino_t *inump;
>>
>> -    inump = (qtype == USRQUOTA) ? &fs->super->s_usr_quota_inum :
>> -        &fs->super->s_grp_quota_inum;
>> +    inump = &fs->super->s_quota_inum[qtype];
>
> This will need to be a helper function instead of an array dereference.
> The other alternative would be something like:
>
>         inump = &fs->super->s_quota_inum[ext2fs_quota_type_offset[qtype]];
>
> and then there is something like the following is done:
>
> int ext2fs_quota_type_offset[] = {
>         [USRQUOTA] = 0,
>         [GRPQUOTA] = 1,
>         [PRJQUOTA] = 3,
> };
>
>>
>>     log_debug("setting quota ino in superblock: ino=%u, type=%d", ino,
>>          qtype);
>> @@ -91,8 +90,7 @@ errcode_t quota_remove_inode(ext2_filsys
>>     ext2_ino_t qf_ino;
>>
>>     ext2fs_read_bitmaps(fs);
>> -    qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
>> -        fs->super->s_grp_quota_inum;
>> +    qf_ino = fs->super->s_quota_inum[qtype];
>>     quota_set_sb_inum(fs, 0, qtype);
>>     /* Truncate the inode only if its a reserved one. */
>>     if (qf_ino < EXT2_FIRST_INODE(fs->super))
>> @@ -211,7 +209,7 @@ static void quota_dnode_free(dnode_t *no
>> /*
>>  * Set up the quota tracking data structures.
>>  */
>> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
>> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype_bits)
>> {
>>     int    i, err = 0;
>>     dict_t    *dict;
>> @@ -225,7 +223,7 @@ errcode_t quota_init_context(quota_ctx_t
>>
>>     memset(ctx, 0, sizeof(struct quota_ctx));
>>     for (i = 0; i < MAXQUOTAS; i++) {
>> -        if ((qtype != -1) && (i != qtype))
>> +        if (((1 << i) & qtype_bits) == 0)
>>             continue;
>>         err = ext2fs_get_mem(sizeof(dict_t), &dict);
>>         if (err) {
>> @@ -537,8 +535,7 @@ errcode_t quota_compare_and_update(quota
>>     if (!qctx->quota_dict[qtype])
>>         goto out;
>>
>> -    qf_ino = qtype == USRQUOTA ? fs->super->s_usr_quota_inum :
>> -                     fs->super->s_grp_quota_inum;
>> +    qf_ino = fs->super->s_quota_inum[qtype];
>>     err = quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
>>     if (err) {
>>         log_err("Open quota file failed");
>> Index: e2fsprogs.git/e2fsck/pass1.c
>> ===================================================================
>> --- e2fsprogs.git.orig/e2fsck/pass1.c
>> +++ e2fsprogs.git/e2fsck/pass1.c
>> @@ -574,6 +574,24 @@ static errcode_t recheck_bad_inode_check
>>     return 0;
>> }
>>
>> +static int is_super_quota_inum(struct ext2_super_block *sb, ext2_ino_t ino)
>> +{
>> +    int i;
>
> (style) blank line after variable declaration
>
>> +    for (i = 0; i < MAXQUOTAS; i++)
>> +        if (sb->s_quota_inum[i] == ino)
>> +            return 1;
>
> (style) blank line before return
>
>> +    return 0;
>> +}
>> +
>> +static int is_quota_inum(ext2_ino_t ino)
>
> It might be better to name this "is_reserved_quota_inum()" to match
> the other function, or even better would be to put "quota" near the
> start so they are more easily found, like quota_inum_is_reserved()
> and quota_inum_is_super() or similar.
>
>> +{
>> +    int i;
>> +    for (i = 0; i < MAXQUOTAS; i++)
>> +        if (type2ino(i) == ino)
>> +            return 1;
>> +    return 0;
>> +}
>> +
>> void e2fsck_pass1(e2fsck_t ctx)
>> {
>>     int    i;
>> @@ -970,13 +988,11 @@ void e2fsck_pass1(e2fsck_t ctx)
>>                 e2fsck_write_inode_full(ctx, ino, inode,
>>                             inode_size, "pass1");
>>             }
>> -        } else if ((ino == EXT4_USR_QUOTA_INO) ||
>> -               (ino == EXT4_GRP_QUOTA_INO)) {
>> +        } else if (is_quota_inum(ino)) {
>>             ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
>>             if ((fs->super->s_feature_ro_compat &
>>                     EXT4_FEATURE_RO_COMPAT_QUOTA) &&
>> -                ((fs->super->s_usr_quota_inum == ino) ||
>> -                 (fs->super->s_grp_quota_inum == ino))) {
>> +                is_super_quota_inum(fs->super, ino)) {
>>                 if (!LINUX_S_ISREG(inode->i_mode) &&
>>                     fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
>>                             &pctx)) {
>> Index: e2fsprogs.git/e2fsck/quota.c
>> ===================================================================
>> --- e2fsprogs.git.orig/e2fsck/quota.c
>> +++ e2fsprogs.git/e2fsck/quota.c
>> @@ -63,6 +63,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
>>     struct ext2_super_block *sb = ctx->fs->super;
>>     struct problem_context    pctx;
>>     ext2_filsys        fs = ctx->fs;
>> +    int i;
>> +    ext2_ino_t quota_ino;
>>
>>     clear_problem_context(&pctx);
>>
>> @@ -70,22 +72,17 @@ void e2fsck_hide_quota(e2fsck_t ctx)
>>         !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
>>         return;
>>
>> -    pctx.ino = sb->s_usr_quota_inum;
>> -    if (sb->s_usr_quota_inum &&
>> -        (sb->s_usr_quota_inum != EXT4_USR_QUOTA_INO) &&
>> -        fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
>> -        move_quota_inode(fs, sb->s_usr_quota_inum, EXT4_USR_QUOTA_INO,
>> -                 USRQUOTA);
>> -        sb->s_usr_quota_inum = EXT4_USR_QUOTA_INO;
>> -    }
>> -
>> -    pctx.ino = sb->s_grp_quota_inum;
>> -    if (sb->s_grp_quota_inum &&
>> -        (sb->s_grp_quota_inum != EXT4_GRP_QUOTA_INO) &&
>> -        fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
>> -        move_quota_inode(fs, sb->s_grp_quota_inum, EXT4_GRP_QUOTA_INO,
>> -                 GRPQUOTA);
>> -        sb->s_grp_quota_inum = EXT4_GRP_QUOTA_INO;
>> +    for (i = 0; i < MAXQUOTAS; i++) {
>> +        pctx.ino = sb->s_quota_inum[i];
>> +        quota_ino = type2ino(i);
>> +        if (sb->s_quota_inum[i] &&
>> +            (sb->s_quota_inum[i] != quota_ino) &&
>
> This looks like it could benefit from using quota_inode_is_reserved()?
>
>> +            fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
>> +            move_quota_inode(fs, sb->s_quota_inum[i],
>> +                     quota_ino,
>> +                     i);
>> +            sb->s_quota_inum[i] = quota_ino;
>> +        }
>>     }
>>
>>     return;
>> Index: e2fsprogs.git/e2fsck/unix.c
>> ===================================================================
>> --- e2fsprogs.git.orig/e2fsck/unix.c
>> +++ e2fsprogs.git/e2fsck/unix.c
>> @@ -1180,7 +1180,7 @@ int main (int argc, char *argv[])
>>     int old_bitmaps;
>>     __u32 features[3];
>>     char *cp;
>> -    int qtype = -99;  /* quota type */
>> +    int qtype_bits = 0;  /* quota type */
>
> This should now be an unsigned int.
>
>>     clear_problem_context(&pctx);
>>     sigcatcher_setup();
>> @@ -1623,14 +1623,14 @@ print_unsupp_features:
>>         journal_size = -1;
>>
>>     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
>> +        int i;
>>         /* Quotas were enabled. Do quota accounting during fsck. */
>> -        if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
>> -            (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
>> -            qtype = -1;
>> -        else
>> -            qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
>> +        for (i = 0; i < MAXQUOTAS; i++) {
>> +            if (sb->s_quota_inum[i])
>> +                qtype_bits |= 1 << i;
>
> Should there be some kind of sanity check that MAXQUOTAS is < 32?
> I guess most compilers will complain about << 32 for an unsigned int,
> but it would be good to make sure.
>
>> +        }
>>
>> -        quota_init_context(&ctx->qctx, ctx->fs, qtype);
>> +        quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
>>     }
>>
>>     run_result = e2fsck_run(ctx);
>> @@ -1669,7 +1669,7 @@ no_journal:
>>     if (ctx->qctx) {
>>         int i, needs_writeout;
>>         for (i = 0; i < MAXQUOTAS; i++) {
>> -            if (qtype != -1 && qtype != i)
>> +            if (((1 << i) & qtype_bits) == 0)
>>                 continue;
>>             needs_writeout = 0;
>>             pctx.num = i;
>> Index: e2fsprogs.git/lib/quota/mkquota.h
>> ===================================================================
>> --- e2fsprogs.git.orig/lib/quota/mkquota.h
>> +++ e2fsprogs.git/lib/quota/mkquota.h
>> @@ -10,7 +10,7 @@
>>  * {
>>  *    quota_ctx_t qctx;
>>  *
>> - *    quota_init_context(&qctx, fs, -1);
>> + *    quota_init_context(&qctx, fs, ALLQUOTA_BIT);
>>  *    {
>>  *        quota_compute_usage(qctx, -1);
>>  *        AND/OR
>> @@ -43,7 +43,7 @@ struct quota_ctx {
>> };
>>
>> /* In mkquota.c */
>> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
>> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int
>> qtype_bits);
>> void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
>> ext2_ino_t ino,
>>         int adjust);
>> void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
>> Index: e2fsprogs.git/lib/quota/quotaio.c
>> ===================================================================
>> --- e2fsprogs.git.orig/lib/quota/quotaio.c
>> +++ e2fsprogs.git/lib/quota/quotaio.c
>> @@ -42,6 +42,22 @@ const char *type2name(int type)
>>     return extensions[type];
>> }
>>
>> +ext2_ino_t type2ino(int qtype)
>
> "type2ino()" is a very generic function name.  At least using
> quota_type2ino() would make it more clear that this relates to
> quota.  Secondly, "qtype" should be an enum that declares USRQUOTA
> and GRPQUOTA, and then uses this consistently throughout the code.
>
>> +{
>> +    switch (qtype) {
>> +    case USRQUOTA:
>> +        return EXT4_USR_QUOTA_INO;
>> +        break;
>> +    case GRPQUOTA:
>> +        return EXT4_GRP_QUOTA_INO;
>> +        break;
>> +    default:
>> +        return 0;
>> +        break;
>> +    }
>> +    return 0;
>> +}
>> +
>> /**
>>  * Creates a quota file name for given type and format.
>>  */
>> @@ -114,11 +130,16 @@ errcode_t quota_inode_truncate(ext2_fils
>> {
>>     struct ext2_inode inode;
>>     errcode_t err;
>> +    int i;
>>
>>     if ((err = ext2fs_read_inode(fs, ino, &inode)))
>>         return err;
>>
>> -    if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO)) {
>> +    for (i = 0; i < MAXQUOTAS; i++)
>> +        if (ino == type2ino(i))
>> +            break;
>> +
>> +    if (i != MAXQUOTAS) {
>>         inode.i_dtime = fs->now ? fs->now : time(0);
>>         if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
>>             return 0;
>> @@ -290,11 +311,8 @@ errcode_t quota_file_create(struct quota
>>         fmt = QFMT_VFS_V1;
>>
>>     h->qh_qf.fs = fs;
>> -    if (type == USRQUOTA)
>> -        qf_inum = EXT4_USR_QUOTA_INO;
>> -    else if (type == GRPQUOTA)
>> -        qf_inum = EXT4_GRP_QUOTA_INO;
>> -    else
>> +    qf_inum = type2ino(type);
>> +    if (qf_inum == 0)
>>         return -1;
>>
>>     err = ext2fs_read_bitmaps(fs);
>> Index: e2fsprogs.git/lib/quota/quotaio.h
>> ===================================================================
>> --- e2fsprogs.git.orig/lib/quota/quotaio.h
>> +++ e2fsprogs.git/lib/quota/quotaio.h
>> @@ -20,6 +20,10 @@ typedef int64_t qsize_t;    /* Type in whic
>> #define USRQUOTA 0
>> #define GRPQUOTA 1
>>
>> +#define USRQUOTA_BIT (1 << USRQUOTA)
>> +#define GRPQUOTA_BIT (1 << GRPQUOTA)
>> +#define ALLQUOTA_BIT (USRQUOTA_BIT | GRPQUOTA_BIT)
>
> It isn't the fault of this patch, but I'd really prefer to see
> all of these constants put "QUOTA" at the start, so they sort
> together, like QUOTA_USR{,_BIT}, QUOTA_GRP{,_BIT}, QUOTA_ALL_BIT.
>
> Is there some dependency on the upstream kernel or quota-tools
> package that would recommend against this change?
>
> It should definitely be in a separate patch from this one.
>
>> /*
>>  * Definitions of magics and versions of current quota files
>>  */
>> @@ -151,6 +155,7 @@ struct dquot *get_empty_dquot(void);
>> errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
>>
>> const char *type2name(int type);
>
> This existing type2name() function should also get a quota_ prefix.
>
>> +ext2_ino_t type2ino(int qtype);
>>
>> void update_grace_times(struct dquot *q);
>>
>> Index: e2fsprogs.git/misc/tune2fs.c
>> ===================================================================
>> --- e2fsprogs.git.orig/misc/tune2fs.c
>> +++ e2fsprogs.git/misc/tune2fs.c
>> @@ -94,7 +94,7 @@ static int stride_set, stripe_width_set;
>> static char *extended_cmd;
>> static unsigned long new_inode_size;
>> static char *ext_mount_opts;
>> -static int usrquota, grpquota;
>> +static int quota[MAXQUOTAS];
>
> It might be better to name this quota_enable[] or similar.
>
>> static int rewrite_checksums;
>>
>> int journal_size, journal_flags;
>> @@ -862,6 +862,7 @@ static int update_feature_set(ext2_filsy
>>     __u32        old_features[3];
>>     int        type_err;
>>     unsigned int    mask_err;
>> +    int        i;
>>
>> #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
>>                 ((&sb->s_feature_compat)[(type)] & (mask)))
>> @@ -1095,8 +1096,8 @@ mmp_error:
>>         if (!Q_flag) {
>>             Q_flag = 1;
>>             /* Enable both user quota and group quota by default */
>> -            usrquota = QOPT_ENABLE;
>> -            grpquota = QOPT_ENABLE;
>> +            for (i = 0; i < MAXQUOTAS; i++)
>> +                quota[i] = QOPT_ENABLE;
>>         }
>>         sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
>>     }
>> @@ -1112,8 +1113,8 @@ mmp_error:
>>                 "arguments.\n"), stderr);
>>         Q_flag = 1;
>>         /* Disable both user quota and group quota by default */
>> -        usrquota = QOPT_DISABLE;
>> -        grpquota = QOPT_DISABLE;
>> +        for (i = 0; i < MAXQUOTAS; i++)
>> +            quota[i] = QOPT_DISABLE;
>>     }
>>
>>     if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
>> @@ -1222,47 +1223,53 @@ static void handle_quota_options(ext2_fi
>> {
>>     quota_ctx_t qctx;
>>     ext2_ino_t qf_ino;
>> +    int i;
>> +    int enable = 0;
>>
>> -    if (!usrquota && !grpquota)
>> +    for (i = 0 ; i < MAXQUOTAS; i++)
>> +        if (quota[i])
>
> (style) since quota[i] is not boolean, this would be better as:
>
>         if (quota[i] != 0)
>
>> +            break;
>> +    if (i == MAXQUOTAS)
>>         /* Nothing to do. */
>>         return;
>>
>> -    quota_init_context(&qctx, fs, -1);
>> -
>> -    if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
>> +    quota_init_context(&qctx, fs, ALLQUOTA_BIT);
>> +    for (i = 0 ; i < MAXQUOTAS; i++)
>> +        if (quota[i] == QOPT_ENABLE) {
>> +            enable = 1;
>> +            break;
>> +        }
>> +    if (enable)
>>         quota_compute_usage(qctx);
>>
>> -    if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
>> -        if ((qf_ino = quota_file_exists(fs, USRQUOTA,
>> -                        QFMT_VFS_V1)) > 0)
>> -            quota_update_limits(qctx, qf_ino, USRQUOTA);
>> -        quota_write_inode(qctx, USRQUOTA);
>> -    } else if (usrquota == QOPT_DISABLE) {
>> -        quota_remove_inode(fs, USRQUOTA);
>> -    }
>> -
>> -    if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
>> -        if ((qf_ino = quota_file_exists(fs, GRPQUOTA,
>> -                        QFMT_VFS_V1)) > 0)
>> -            quota_update_limits(qctx, qf_ino, GRPQUOTA);
>> -        quota_write_inode(qctx, GRPQUOTA);
>> -    } else if (grpquota == QOPT_DISABLE) {
>> -        quota_remove_inode(fs, GRPQUOTA);
>> +    for (i = 0 ; i < MAXQUOTAS; i++) {
>> +        if (quota[i] == QOPT_ENABLE && !fs->super->s_quota_inum[i]) {
>> +            if ((qf_ino = quota_file_exists(fs, i,
>> +                            QFMT_VFS_V1)) > 0)
>> +                quota_update_limits(qctx, qf_ino, i);
>> +            quota_write_inode(qctx, i);
>> +        } else if (quota[i] == QOPT_DISABLE) {
>> +            quota_remove_inode(fs, i);
>> +        }
>>     }
>>
>>     quota_release_context(&qctx);
>>
>> -    if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
>> +    if (enable) {
>>         fprintf(stderr, "%s", _("\nWarning: the quota feature is still "
>>                   "under development\n"
>>                   "See https://ext4.wiki.kernel.org/"
>>                   "index.php/Quota for more information\n\n"));
>>         fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
>>         ext2fs_mark_super_dirty(fs);
>> -    } else if (!fs->super->s_usr_quota_inum &&
>> -           !fs->super->s_grp_quota_inum) {
>> -        fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
>> -        ext2fs_mark_super_dirty(fs);
>> +    } else {
>> +        for (i = 0 ; i < MAXQUOTAS; i++)
>> +            if (fs->super->s_quota_inum[i])
>> +                break;
>> +        if (i == MAXQUOTAS) {
>> +            fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
>> +            ext2fs_mark_super_dirty(fs);
>> +        }
>>     }
>>
>>     return;
>> @@ -1291,13 +1298,13 @@ static void parse_quota_opts(const char
>>         }
>>
>>         if (strcmp(token, "usrquota") == 0) {
>> -            usrquota = QOPT_ENABLE;
>> +            quota[USRQUOTA] = QOPT_ENABLE;
>>         } else if (strcmp(token, "^usrquota") == 0) {
>> -            usrquota = QOPT_DISABLE;
>> +            quota[USRQUOTA] = QOPT_DISABLE;
>>         } else if (strcmp(token, "grpquota") == 0) {
>> -            grpquota = QOPT_ENABLE;
>> +            quota[GRPQUOTA] = QOPT_ENABLE;
>>         } else if (strcmp(token, "^grpquota") == 0) {
>> -            grpquota = QOPT_DISABLE;
>> +            quota[GRPQUOTA] = QOPT_DISABLE;
>>         } else {
>>             fputs(_("\nBad quota options specified.\n\n"
>>                 "Following valid quota options are available "
>> Index: e2fsprogs.git/debugfs/set_fields.c
>> ===================================================================
>> --- e2fsprogs.git.orig/debugfs/set_fields.c
>> +++ e2fsprogs.git/debugfs/set_fields.c
>> @@ -147,8 +147,8 @@ static struct field_set_info super_field
>>       NULL, 8, parse_uint },
>>     { "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint },
>>     { "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
>> -    { "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
>> -    { "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
>> +    { "quota_inum", &set_sb.s_quota_inum, NULL, 4, parse_uint, FLAG_ARRAY,
>> +      MAXQUOTAS },
>
> This will also need to be fixed, to avoid clobbering s_overhead_blocks.
>
>>     { "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, parse_uint },
>>     { "checksum", &set_sb.s_checksum, NULL, 4, parse_uint },
>>     { "checksum_type", &set_sb.s_checksum_type, NULL, 1, parse_uint },
>> Index: e2fsprogs.git/lib/ext2fs/tst_super_size.c
>> ===================================================================
>> --- e2fsprogs.git.orig/lib/ext2fs/tst_super_size.c
>> +++ e2fsprogs.git/lib/ext2fs/tst_super_size.c
>> @@ -132,8 +132,7 @@ int main(int argc, char **argv)
>>     check_field(s_last_error_block, 8);
>>     check_field(s_last_error_func, 32);
>>     check_field(s_mount_opts, 64);
>> -    check_field(s_usr_quota_inum, 4);
>> -    check_field(s_grp_quota_inum, 4);
>> +    check_field(s_quota_inum, 4 * MAXQUOTAS);
>>     check_field(s_overhead_blocks, 4);
>>     check_field(s_reserved, 108 * 4);
>>     check_field(s_checksum, 4);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Cheers, Andreas
>
>
>
>
>
