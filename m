From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v3] e2fsprogs: clean up codes for adding new quota type
Date: Wed, 22 Jan 2014 20:20:31 +0800
Message-ID: <CAPTn0cBMDht60MBKmiuuLFsitXti-JzoehALfmMqwSL9+42z4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@dilger.ca>, Shuichi Ihara <sihara@ddn.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48570 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAVMUc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jan 2014 07:20:32 -0500
Received: by mail-ig0-f171.google.com with SMTP id uy17so13732111igb.4
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jan 2014 04:20:31 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changelog:
* V3:
  - Add check of MAXQUOTAS <= 32
  - Change iterator from "i"/"type" to "qtype".
  - Add assertion of qtype range in quota_type2* funtions
  - Rename quota_type2ino to quota_type2inum
  - Change get_qid()
  - Replace quota_type2offset() with quota_sb_inump()
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
@@ -206,11 +207,27 @@ static const char *checksum_type(__u8 ty
     }
 }

+static const char const *quota_prefix[MAXQUOTAS] = {
+        [USRQUOTA] = "User quota inode:",
+        [GRPQUOTA] = "Group quota inode:",
+};
+
+/**
+ * Convert type of quota to written representation
+ */
+const char *quota_type2prefix(quota_type_t qtype)
+{
+    assert(qtype >= 0);
+    assert(qtype < MAXQUOTAS);
+    return quota_prefix[qtype];
+}
+
 void list_super2(struct ext2_super_block * sb, FILE *f)
 {
     int inode_blocks_per_group;
     char buf[80], *str;
     time_t    tm;
+    quota_type_t qtype;

     inode_blocks_per_group = (((sb->s_inodes_per_group *
                     EXT2_INODE_SIZE(sb)) +
@@ -426,13 +443,12 @@ void list_super2(struct ext2_super_block
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
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        if (*quota_sb_inump(sb, qtype) != 0)
+            fprintf(f, "%-26s%u\n",
+                quota_type2prefix(qtype),
+                *quota_sb_inump(sb, qtype));
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
+    inump = quota_sb_inump(fs->super, qtype);

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
+    qf_ino = *quota_sb_inump(fs->super, qtype);
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
+    quota_type_t    qtype;
     dict_t        *dict;
     ext2_filsys    fs;
     struct quota_handle *h = NULL;
@@ -139,15 +138,15 @@ errcode_t quota_write_inode(quota_ctx_t

     ext2fs_read_bitmaps(fs);

-    for (i = 0; i < MAXQUOTAS; i++) {
-        if ((qtype != -1) && (i != qtype))
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        if (((1 << qtype) & qtype_bits) == 0)
             continue;

-        dict = qctx->quota_dict[i];
+        dict = qctx->quota_dict[qtype];
         if (!dict)
             continue;

-        retval = quota_file_create(h, fs, i, fmt);
+        retval = quota_file_create(h, fs, qtype, fmt);
         if (retval < 0) {
             log_err("Cannot initialize io on quotafile");
             continue;
@@ -165,7 +164,7 @@ errcode_t quota_write_inode(quota_ctx_t
         }

         /* Set quota inode numbers in superblock. */
-        quota_set_sb_inum(fs, h->qh_qf.ino, i);
+        quota_set_sb_inum(fs, h->qh_qf.ino, qtype);
         ext2fs_mark_super_dirty(fs);
         ext2fs_mark_bb_dirty(fs);
         fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
@@ -192,11 +191,20 @@ static int dict_uint_cmp(const void *a,
     return c - d;
 }

-static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
+static inline qid_t get_qid(struct ext2_inode *inode, quota_type_t qtype)
 {
-    if (qtype == USRQUOTA)
-        return inode_uid(*inode);
-    return inode_gid(*inode);
+    assert(qtype >= 0);
+    assert(qtype < MAXQUOTAS);
+    switch (qtype) {
+        case USRQUOTA:
+            return inode_uid(*inode);
+        case GRPQUOTA:
+            return inode_gid(*inode);
+        default:
+            return 0;
+    }
+
+    return 0;
 }

 static void quota_dnode_free(dnode_t *node,
@@ -211,9 +219,11 @@ static void quota_dnode_free(dnode_t *no
 /*
  * Set up the quota tracking data structures.
  */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
+                 unsigned int qtype_bits)
 {
-    int    i, err = 0;
+    int        err = 0;
+    quota_type_t    qtype;
     dict_t    *dict;
     quota_ctx_t ctx;

@@ -224,8 +234,8 @@ errcode_t quota_init_context(quota_ctx_t
     }

     memset(ctx, 0, sizeof(struct quota_ctx));
-    for (i = 0; i < MAXQUOTAS; i++) {
-        if ((qtype != -1) && (i != qtype))
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        if (((1 << qtype) & qtype_bits) == 0)
             continue;
         err = ext2fs_get_mem(sizeof(dict_t), &dict);
         if (err) {
@@ -233,7 +243,7 @@ errcode_t quota_init_context(quota_ctx_t
             quota_release_context(&ctx);
             return err;
         }
-        ctx->quota_dict[i] = dict;
+        ctx->quota_dict[qtype] = dict;
         dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
         dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
     }
@@ -246,16 +256,16 @@ errcode_t quota_init_context(quota_ctx_t
 void quota_release_context(quota_ctx_t *qctx)
 {
     dict_t    *dict;
-    int    i;
+    quota_type_t    qtype;
     quota_ctx_t ctx;

     if (!qctx)
         return;

     ctx = *qctx;
-    for (i = 0; i < MAXQUOTAS; i++) {
-        dict = ctx->quota_dict[i];
-        ctx->quota_dict[i] = 0;
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        dict = ctx->quota_dict[qtype];
+        ctx->quota_dict[qtype] = 0;
         if (dict) {
             dict_free_nodes(dict);
             free(dict);
@@ -294,7 +304,7 @@ void quota_data_add(quota_ctx_t qctx, st
 {
     struct dquot    *dq;
     dict_t        *dict;
-    int        i;
+    quota_type_t    qtype;

     if (!qctx)
         return;
@@ -302,10 +312,10 @@ void quota_data_add(quota_ctx_t qctx, st
     log_debug("ADD_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
             inode_uid(*inode),
             inode_gid(*inode), space);
-    for (i = 0; i < MAXQUOTAS; i++) {
-        dict = qctx->quota_dict[i];
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        dict = qctx->quota_dict[qtype];
         if (dict) {
-            dq = get_dq(dict, get_qid(inode, i));
+            dq = get_dq(dict, get_qid(inode, qtype));
             if (dq)
                 dq->dq_dqb.dqb_curspace += space;
         }
@@ -320,7 +330,7 @@ void quota_data_sub(quota_ctx_t qctx, st
 {
     struct dquot    *dq;
     dict_t        *dict;
-    int        i;
+    quota_type_t    qtype;

     if (!qctx)
         return;
@@ -328,10 +338,10 @@ void quota_data_sub(quota_ctx_t qctx, st
     log_debug("SUB_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
             inode_uid(*inode),
             inode_gid(*inode), space);
-    for (i = 0; i < MAXQUOTAS; i++) {
-        dict = qctx->quota_dict[i];
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        dict = qctx->quota_dict[qtype];
         if (dict) {
-            dq = get_dq(dict, get_qid(inode, i));
+            dq = get_dq(dict, get_qid(inode, qtype));
             dq->dq_dqb.dqb_curspace -= space;
         }
     }
@@ -345,7 +355,7 @@ void quota_data_inodes(quota_ctx_t qctx,
 {
     struct dquot    *dq;
     dict_t        *dict;
-    int        i;
+    quota_type_t    qtype;

     if (!qctx)
         return;
@@ -353,10 +363,10 @@ void quota_data_inodes(quota_ctx_t qctx,
     log_debug("ADJ_INODE: Inode: %u, UID/GID: %u/%u, adjust: %d", ino,
             inode_uid(*inode),
             inode_gid(*inode), adjust);
-    for (i = 0; i < MAXQUOTAS; i++) {
-        dict = qctx->quota_dict[i];
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        dict = qctx->quota_dict[qtype];
         if (dict) {
-            dq = get_dq(dict, get_qid(inode, i));
+            dq = get_dq(dict, get_qid(inode, qtype));
             dq->dq_dqb.dqb_curinodes += adjust;
         }
     }
@@ -486,7 +496,8 @@ static errcode_t quota_write_all_dquots(
 /*
  * Updates the in-memory quota limits from the given quota inode.
  */
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
+                  quota_type_t qtype)
 {
     struct quota_handle *qh;
     errcode_t err;
@@ -500,7 +511,7 @@ errcode_t quota_update_limits(quota_ctx_
         return err;
     }

-    err = quota_file_open(qh, qctx->fs, qf_ino, type, -1, 0);
+    err = quota_file_open(qh, qctx->fs, qf_ino, qtype, -1, 0);
     if (err) {
         log_err("Open quota file failed");
         goto out;
@@ -525,7 +536,7 @@ out:
  * on disk and updates the limits in qctx->quota_dict. 'usage_inconsistent' is
  * set to 1 if the supplied and on-disk quota usage values are not identical.
  */
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+errcode_t quota_compare_and_update(quota_ctx_t qctx, quota_type_t qtype,
                    int *usage_inconsistent)
 {
     ext2_filsys fs = qctx->fs;
@@ -537,8 +548,7 @@ errcode_t quota_compare_and_update(quota
     if (!qctx->quota_dict[qtype])
         goto out;

-    qf_ino = qtype == USRQUOTA ? fs->super->s_usr_quota_inum :
-                     fs->super->s_grp_quota_inum;
+    qf_ino = *quota_sb_inump(fs->super, qtype);
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
+    quota_type_t qtype;
+
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+        if (*quota_sb_inump(sb, qtype) == ino)
+            return 1;
+
+    return 0;
+}
+
+static int quota_inum_is_reserved(ext2_ino_t ino)
+{
+    quota_type_t qtype;
+
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+        if (quota_type2inum(qtype) == ino)
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
+    quota_type_t qtype;
+    ext2_ino_t quota_ino;

     clear_problem_context(&pctx);

@@ -70,22 +72,14 @@ void e2fsck_hide_quota(e2fsck_t ctx)
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
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+        pctx.ino = *quota_sb_inump(sb, qtype);
+        quota_ino = quota_type2inum(qtype);
+        if (pctx.ino && (pctx.ino != quota_ino) &&
+            fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
+            move_quota_inode(fs, pctx.ino, quota_ino, qtype);
+            *quota_sb_inump(sb, qtype) = quota_ino;
+        }
     }

     return;
Index: e2fsprogs.git/e2fsck/unix.c
===================================================================
--- e2fsprogs.git.orig/e2fsck/unix.c
+++ e2fsprogs.git/e2fsck/unix.c
@@ -1180,7 +1180,8 @@ int main (int argc, char *argv[])
     int old_bitmaps;
     __u32 features[3];
     char *cp;
-    int qtype = -99;  /* quota type */
+    unsigned int qtype_bits = 0;
+    quota_type_t qtype;

     clear_problem_context(&pctx);
     sigcatcher_setup();
@@ -1624,13 +1625,12 @@ print_unsupp_features:

     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
         /* Quotas were enabled. Do quota accounting during fsck. */
-        if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
-            (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
-            qtype = -1;
-        else
-            qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
+        for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+            if (*quota_sb_inump(sb, qtype) != 0)
+                qtype_bits |= 1 << qtype;
+        }

-        quota_init_context(&ctx->qctx, ctx->fs, qtype);
+        quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
     }

     run_result = e2fsck_run(ctx);
@@ -1667,17 +1667,17 @@ print_unsupp_features:
 no_journal:

     if (ctx->qctx) {
-        int i, needs_writeout;
-        for (i = 0; i < MAXQUOTAS; i++) {
-            if (qtype != -1 && qtype != i)
+        int needs_writeout;
+        for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+            if (((1 << qtype) & qtype_bits) == 0)
                 continue;
             needs_writeout = 0;
-            pctx.num = i;
-            retval = quota_compare_and_update(ctx->qctx, i,
+            pctx.num = qtype;
+            retval = quota_compare_and_update(ctx->qctx, qtype,
                               &needs_writeout);
             if ((retval || needs_writeout) &&
                 fix_problem(ctx, PR_6_UPDATE_QUOTAS, &pctx))
-                quota_write_inode(ctx->qctx, i);
+                quota_write_inode(ctx->qctx, 1 << qtype);
         }
         quota_release_context(&ctx->qctx);
     }
Index: e2fsprogs.git/lib/quota/mkquota.h
===================================================================
--- e2fsprogs.git.orig/lib/quota/mkquota.h
+++ e2fsprogs.git/lib/quota/mkquota.h
@@ -10,14 +10,13 @@
  * {
  *    quota_ctx_t qctx;
  *
- *    quota_init_context(&qctx, fs, -1);
+ *    quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
  *    {
  *        quota_compute_usage(qctx, -1);
  *        AND/OR
  *        quota_data_add/quota_data_sub/quota_data_inodes();
  *    }
- *    quota_write_inode(qctx, USRQUOTA);
- *    quota_write_inode(qctx, GRPQUOTA);
+ *    quota_write_inode(qctx, QUOTA_ALL_BIT);
  *    quota_release_context(&qctx);
  * }
  *
@@ -43,22 +42,24 @@ struct quota_ctx {
 };

 /* In mkquota.c */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
+                 unsigned int qtype_bits);
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
+                  quota_type_t qtype);
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
@@ -15,6 +15,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/file.h>
+#include <assert.h>

 #include "common.h"
 #include "quotaio.h"
@@ -37,15 +38,35 @@ struct disk_dqheader {
 /**
  * Convert type of quota to written representation
  */
-const char *type2name(int type)
+const char *quota_type2name(quota_type_t qtype)
 {
-    return extensions[type];
+    assert(qtype >= 0);
+    assert(qtype < MAXQUOTAS);
+    return extensions[qtype];
+}
+
+ext2_ino_t quota_type2inum(quota_type_t qtype)
+{
+    assert(qtype >= 0);
+    assert(qtype < MAXQUOTAS);
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
 }

 /**
  * Creates a quota file name for given type and format.
  */
-const char *quota_get_qf_name(int type, int fmt, char *buf)
+const char *quota_get_qf_name(quota_type_t type, int fmt, char *buf)
 {
     if (!buf)
         return NULL;
@@ -55,7 +76,7 @@ const char *quota_get_qf_name(int type,
     return buf;
 }

-const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+const char *quota_get_qf_path(const char *mntpt, quota_type_t qtype, int fmt,
                   char *path_buf, size_t path_buf_size)
 {
     char qf_name[QUOTA_NAME_LEN];
@@ -114,11 +135,16 @@ errcode_t quota_inode_truncate(ext2_fils
 {
     struct ext2_inode inode;
     errcode_t err;
+    quota_type_t qtype;

     if ((err = ext2fs_read_inode(fs, ino, &inode)))
         return err;

-    if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO)) {
+    for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+        if (ino == quota_type2inum(qtype))
+            break;
+
+    if (qtype != MAXQUOTAS) {
         inode.i_dtime = fs->now ? fs->now : time(0);
         if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
             return 0;
@@ -198,7 +224,8 @@ static unsigned int quota_read_nomount(s
  * Detect quota format and initialize quota IO
  */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
-              ext2_ino_t qf_ino, int type, int fmt, int flags)
+              ext2_ino_t qf_ino, quota_type_t qtype, int fmt,
+              int flags)
 {
     ext2_file_t e2_file;
     errcode_t err;
@@ -223,13 +250,13 @@ errcode_t quota_file_open(struct quota_h
     h->e2fs_write = quota_write_nomount;
     h->e2fs_read = quota_read_nomount;
     h->qh_io_flags = 0;
-    h->qh_type = type;
+    h->qh_type = qtype;
     h->qh_fmt = fmt;
     memset(&h->qh_info, 0, sizeof(h->qh_info));
     h->qh_ops = &quotafile_ops_2;

     if (h->qh_ops->check_file &&
-        (h->qh_ops->check_file(h, type, fmt) == 0)) {
+        (h->qh_ops->check_file(h, qtype, fmt) == 0)) {
         log_err("qh_ops->check_file failed");
         ext2fs_file_close(e2_file);
         return -1;
@@ -280,7 +307,8 @@ static errcode_t quota_inode_init_new(ex
 /*
  * Create new quotafile of specified format on given filesystem
  */
-errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
int type, int fmt)
+errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
+                quota_type_t qtype, int fmt)
 {
     ext2_file_t e2_file;
     int err;
@@ -290,11 +318,8 @@ errcode_t quota_file_create(struct quota
         fmt = QFMT_VFS_V1;

     h->qh_qf.fs = fs;
-    if (type == USRQUOTA)
-        qf_inum = EXT4_USR_QUOTA_INO;
-    else if (type == GRPQUOTA)
-        qf_inum = EXT4_GRP_QUOTA_INO;
-    else
+    qf_inum = quota_type2inum(qtype);
+    if (qf_inum == 0)
         return -1;

     err = ext2fs_read_bitmaps(fs);
@@ -310,7 +335,7 @@ errcode_t quota_file_create(struct quota
     h->e2fs_write = quota_write_nomount;
     h->e2fs_read = quota_read_nomount;

-    log_debug("Creating quota ino=%lu, type=%d", qf_inum, type);
+    log_debug("Creating quota ino=%lu, type=%d", qf_inum, qtype);
     err = ext2fs_file_open(fs, qf_inum,
             EXT2_FILE_WRITE | EXT2_FILE_CREATE, &e2_file);
     if (err) {
@@ -320,7 +345,7 @@ errcode_t quota_file_create(struct quota
     h->qh_qf.e2_file = e2_file;

     h->qh_io_flags = 0;
-    h->qh_type = type;
+    h->qh_type = qtype;
     h->qh_fmt = fmt;
     memset(&h->qh_info, 0, sizeof(h->qh_info));
     h->qh_ops = &quotafile_ops_2;
Index: e2fsprogs.git/lib/quota/quotaio.h
===================================================================
--- e2fsprogs.git.orig/lib/quota/quotaio.h
+++ e2fsprogs.git/lib/quota/quotaio.h
@@ -16,9 +16,20 @@

 typedef int64_t qsize_t;    /* Type in which we store size limitations */

+typedef enum {
+    USRQUOTA = 0,
+    GRPQUOTA = 1,
+} quota_type_t;
+
 #define MAXQUOTAS 2
-#define USRQUOTA 0
-#define GRPQUOTA 1
+
+#if MAXQUOTAS > 32
+#error "cannot have more than 32 quota types to fit in qtype_bits"
+#endif
+
+#define QUOTA_USR_BIT (1 << USRQUOTA)
+#define QUOTA_GRP_BIT (1 << GRPQUOTA)
+#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT)

 /*
  * Definitions of magics and versions of current quota files
@@ -68,7 +79,7 @@ struct quota_file {

 /* Structure for one opened quota file */
 struct quota_handle {
-    int qh_type;        /* Type of quotafile */
+    quota_type_t qh_type;    /* Type of quotafile */
     int qh_fmt;        /* Quotafile format */
     int qh_io_flags;    /* IO flags for file */
     struct quota_file qh_qf;
@@ -135,12 +146,13 @@ extern struct quotafile_ops quotafile_op
 /* Open existing quotafile of given type (and verify its format) on given
  * filesystem. */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
-              ext2_ino_t qf_ino, int type, int fmt, int flags);
+              ext2_ino_t qf_ino, quota_type_t type, int fmt,
+              int flags);


 /* Create new quotafile of specified format on given filesystem */
 errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
-                int type, int fmt);
+                quota_type_t qtype, int fmt);

 /* Close quotafile */
 errcode_t quota_file_close(struct quota_handle *h);
@@ -150,7 +162,8 @@ struct dquot *get_empty_dquot(void);

 errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);

-const char *type2name(int type);
+const char *quota_type2name(quota_type_t qtype);
+ext2_ino_t quota_type2inum(quota_type_t qtype);

 void update_grace_times(struct dquot *q);

@@ -158,8 +171,31 @@ void update_grace_times(struct dquot *q)
    than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
 #define QUOTA_NAME_LEN 16

-const char *quota_get_qf_name(int type, int fmt, char *buf);
-const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+const char *quota_get_qf_name(quota_type_t type, int fmt, char *buf);
+const char *quota_get_qf_path(const char *mntpt, quota_type_t qtype, int fmt,
                   char *path_buf, size_t path_buf_size);

+#include <assert.h>
+
+static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb,
quota_type_t qtype)
+{
+    assert(qtype >= 0);
+    assert(qtype < MAXQUOTAS);
+    switch (qtype) {
+        case USRQUOTA:
+            return &sb->s_quota_inum[0];
+        case GRPQUOTA:
+            return &sb->s_quota_inum[1];
+        /* Skip s_overhead_blocks like this */
+        /*
+        case PRJQUOTA:
+            return &sb->s_quota_inum[3];
+        */
+        default:
+            return NULL;
+    }
+
+    return NULL;
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
+    quota_type_t    qtype;

 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
                 ((&sb->s_feature_compat)[(type)] & (mask)))
@@ -1094,9 +1095,9 @@ mmp_error:
          */
         if (!Q_flag) {
             Q_flag = 1;
-            /* Enable both user quota and group quota by default */
-            usrquota = QOPT_ENABLE;
-            grpquota = QOPT_ENABLE;
+            /* Enable all quota by default */
+            for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+                quota_enable[qtype] = QOPT_ENABLE;
         }
         sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
     }
@@ -1111,9 +1112,9 @@ mmp_error:
             fputs(_("\nWarning: '^quota' option overrides '-Q'"
                 "arguments.\n"), stderr);
         Q_flag = 1;
-        /* Disable both user quota and group quota by default */
-        usrquota = QOPT_DISABLE;
-        grpquota = QOPT_DISABLE;
+        /* Disable all quota by default */
+        for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+            quota_enable[qtype] = QOPT_DISABLE;
     }

     if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
@@ -1222,47 +1223,55 @@ static void handle_quota_options(ext2_fi
 {
     quota_ctx_t qctx;
     ext2_ino_t qf_ino;
+    quota_type_t qtype;
+    int enable = 0;

-    if (!usrquota && !grpquota)
+    for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
+        if (quota_enable[qtype] != 0)
+            break;
+    if (qtype == MAXQUOTAS)
         /* Nothing to do. */
         return;

-    quota_init_context(&qctx, fs, -1);
-
-    if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
+    quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
+    for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
+        if (quota_enable[qtype] == QOPT_ENABLE) {
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
+    for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
+        if (quota_enable[qtype] == QOPT_ENABLE &&
+            *quota_sb_inump(fs->super, qtype) != 0) {
+            if ((qf_ino = quota_file_exists(fs, qtype,
+                            QFMT_VFS_V1)) > 0)
+                quota_update_limits(qctx, qf_ino, qtype);
+            quota_write_inode(qctx, 1 << qtype);
+        } else if (quota_enable[qtype] == QOPT_DISABLE) {
+            quota_remove_inode(fs, qtype);
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
+        for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
+            if (*quota_sb_inump(fs->super, qtype) != 0)
+                break;
+        if (qtype == MAXQUOTAS) {
+            fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
+            ext2fs_mark_super_dirty(fs);
+        }
     }

     return;
@@ -1291,13 +1300,13 @@ static void parse_quota_opts(const char
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
@@ -39,6 +39,7 @@
 #include "debugfs.h"
 #include "uuid/uuid.h"
 #include "e2p/e2p.h"
+#include "quota/quotaio.h"

 static struct ext2_super_block set_sb;
 static struct ext2_inode_large set_inode;
@@ -147,8 +148,8 @@ static struct field_set_info super_field
       NULL, 8, parse_uint },
     { "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint },
     { "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
-    { "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
-    { "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
+    { "usr_quota_inum", &set_sb.s_quota_inum[0], NULL, 4, parse_uint },
+    { "grp_quota_inum", &set_sb.s_quota_inum[1], NULL, 4, parse_uint },
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
all quotas by default */
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
