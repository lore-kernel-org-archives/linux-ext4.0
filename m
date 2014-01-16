From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH] e2fsprogs: clean up codes for adding new quota type
Date: Thu, 16 Jan 2014 11:29:48 +0800
Message-ID: <CAPTn0cBB=aEunH9sK+DTC=_WsmnaQSdu=ajU0JsXvgfB2fAMew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, Shuichi Ihara <sihara@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:38105 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaAPD3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jan 2014 22:29:51 -0500
Received: by mail-ie0-f179.google.com with SMTP id tp5so3238016ieb.38
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jan 2014 19:29:50 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Adding directory/project quota support to ext4 is widely discussed
these days. E2fsprogs has to be updated if we want that new feature.
As a preparation for it, this patch cleans up quota codes of e2fsprogs
so as to make it easier to add new quota type(s).

Test suits are all passed when "make rpm". I am trying to avoid
breaking anything, so please let me know if there is any extra test
suits we have run to check its correctness. Thanks!

Signed-off-by: Li Xi <lixi <at> ddn.com>
---
Index: e2fsprogs.git/lib/e2p/ls.c
===================================================================
--- e2fsprogs.git.orig/lib/e2p/ls.c
+++ e2fsprogs.git/lib/e2p/ls.c
@@ -206,11 +206,22 @@ static const char *checksum_type(__u8 ty
     }
 }

+static const char * const names[MAXQUOTAS] = {"User", "Group"};
+
+/**
+ * Convert type of quota to written representation
+ */
+const char *type2Name(int type)
+{
+    return names[type];
+}
+
 void list_super2(struct ext2_super_block * sb, FILE *f)
 {
     int inode_blocks_per_group;
     char buf[80], *str;
     time_t    tm;
+    int type;

     inode_blocks_per_group = (((sb->s_inodes_per_group *
                     EXT2_INODE_SIZE(sb)) +
@@ -426,13 +437,12 @@ void list_super2(struct ext2_super_block
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
+        if (sb->s_quota_inum[type])
+            fprintf(f, "%s quota inode:         %u\n",
+                type2Name(type),
+                sb->s_quota_inum[type]);
+    }
     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
         fprintf(f, "Checksum type:            %s\n",
             checksum_type(sb->s_checksum_type));
Index: e2fsprogs.git/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.git.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs.git/lib/ext2fs/ext2_fs.h
@@ -18,6 +18,8 @@

 #include <ext2fs/ext2_types.h>        /* Changed from linux/types.h */

+#define MAXQUOTAS 2
+
 /*
  * The second extended filesystem constants/structures
  */
@@ -666,8 +668,7 @@ struct ext2_super_block {
     __u8    s_last_error_func[32];    /* function where the error happened */
 #define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, s_mount_opts)
     __u8    s_mount_opts[64];
-    __u32    s_usr_quota_inum;    /* inode number of user quota file */
-    __u32    s_grp_quota_inum;    /* inode number of group quota file */
+    __u32    s_quota_inum[MAXQUOTAS];/* inode numbers of quota files */
     __u32    s_overhead_blocks;    /* overhead blocks/clusters in fs */
     __u32   s_reserved[108];        /* Padding to the end of the block */
     __u32    s_checksum;        /* crc32c(superblock) */
Index: e2fsprogs.git/lib/quota/mkquota.c
===================================================================
--- e2fsprogs.git.orig/lib/quota/mkquota.c
+++ e2fsprogs.git/lib/quota/mkquota.c
@@ -77,8 +77,7 @@ void quota_set_sb_inum(ext2_filsys fs, e
 {
     ext2_ino_t *inump;

-    inump = (qtype == USRQUOTA) ? &fs->super->s_usr_quota_inum :
-        &fs->super->s_grp_quota_inum;
+    inump = &fs->super->s_quota_inum[qtype];

     log_debug("setting quota ino in superblock: ino=%u, type=%d", ino,
          qtype);
@@ -91,8 +90,7 @@ errcode_t quota_remove_inode(ext2_filsys
     ext2_ino_t qf_ino;

     ext2fs_read_bitmaps(fs);
-    qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
-        fs->super->s_grp_quota_inum;
+    qf_ino = fs->super->s_quota_inum[qtype];
     quota_set_sb_inum(fs, 0, qtype);
     /* Truncate the inode only if its a reserved one. */
     if (qf_ino < EXT2_FIRST_INODE(fs->super))
@@ -211,7 +209,7 @@ static void quota_dnode_free(dnode_t *no
 /*
  * Set up the quota tracking data structures.
  */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype_bits)
 {
     int    i, err = 0;
     dict_t    *dict;
@@ -225,7 +223,7 @@ errcode_t quota_init_context(quota_ctx_t

     memset(ctx, 0, sizeof(struct quota_ctx));
     for (i = 0; i < MAXQUOTAS; i++) {
-        if ((qtype != -1) && (i != qtype))
+        if (((1 << i) & qtype_bits) == 0)
             continue;
         err = ext2fs_get_mem(sizeof(dict_t), &dict);
         if (err) {
@@ -537,8 +535,7 @@ errcode_t quota_compare_and_update(quota
     if (!qctx->quota_dict[qtype])
         goto out;

-    qf_ino = qtype == USRQUOTA ? fs->super->s_usr_quota_inum :
-                     fs->super->s_grp_quota_inum;
+    qf_ino = fs->super->s_quota_inum[qtype];
     err = quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
     if (err) {
         log_err("Open quota file failed");
Index: e2fsprogs.git/e2fsck/pass1.c
===================================================================
--- e2fsprogs.git.orig/e2fsck/pass1.c
+++ e2fsprogs.git/e2fsck/pass1.c
@@ -574,6 +574,24 @@ static errcode_t recheck_bad_inode_check
     return 0;
 }

+static int is_super_quota_inum(struct ext2_super_block *sb, ext2_ino_t ino)
+{
+    int i;
+    for (i = 0; i < MAXQUOTAS; i++)
+        if (sb->s_quota_inum[i] == ino)
+            return 1;
+    return 0;
+}
+
+static int is_quota_inum(ext2_ino_t ino)
+{
+    int i;
+    for (i = 0; i < MAXQUOTAS; i++)
+        if (type2ino(i) == ino)
+            return 1;
+    return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
     int    i;
@@ -970,13 +988,11 @@ void e2fsck_pass1(e2fsck_t ctx)
                 e2fsck_write_inode_full(ctx, ino, inode,
                             inode_size, "pass1");
             }
-        } else if ((ino == EXT4_USR_QUOTA_INO) ||
-               (ino == EXT4_GRP_QUOTA_INO)) {
+        } else if (is_quota_inum(ino)) {
             ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
             if ((fs->super->s_feature_ro_compat &
                     EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-                ((fs->super->s_usr_quota_inum == ino) ||
-                 (fs->super->s_grp_quota_inum == ino))) {
+                is_super_quota_inum(fs->super, ino)) {
                 if (!LINUX_S_ISREG(inode->i_mode) &&
                     fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
                             &pctx)) {
Index: e2fsprogs.git/e2fsck/quota.c
===================================================================
--- e2fsprogs.git.orig/e2fsck/quota.c
+++ e2fsprogs.git/e2fsck/quota.c
@@ -63,6 +63,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
     struct ext2_super_block *sb = ctx->fs->super;
     struct problem_context    pctx;
     ext2_filsys        fs = ctx->fs;
+    int i;
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
+        pctx.ino = sb->s_quota_inum[i];
+        quota_ino = type2ino(i);
+        if (sb->s_quota_inum[i] &&
+            (sb->s_quota_inum[i] != quota_ino) &&
+            fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
+            move_quota_inode(fs, sb->s_quota_inum[i],
+                     quota_ino,
+                     i);
+            sb->s_quota_inum[i] = quota_ino;
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
+    int qtype_bits = 0;  /* quota type */

     clear_problem_context(&pctx);
     sigcatcher_setup();
@@ -1623,14 +1623,14 @@ print_unsupp_features:
         journal_size = -1;

     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
+        int i;
         /* Quotas were enabled. Do quota accounting during fsck. */
-        if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
-            (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
-            qtype = -1;
-        else
-            qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
+        for (i = 0; i < MAXQUOTAS; i++) {
+            if (sb->s_quota_inum[i])
+                qtype_bits |= 1 << i;
+        }

-        quota_init_context(&ctx->qctx, ctx->fs, qtype);
+        quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
     }

     run_result = e2fsck_run(ctx);
@@ -1669,7 +1669,7 @@ no_journal:
     if (ctx->qctx) {
         int i, needs_writeout;
         for (i = 0; i < MAXQUOTAS; i++) {
-            if (qtype != -1 && qtype != i)
+            if (((1 << i) & qtype_bits) == 0)
                 continue;
             needs_writeout = 0;
             pctx.num = i;
Index: e2fsprogs.git/lib/quota/mkquota.h
===================================================================
--- e2fsprogs.git.orig/lib/quota/mkquota.h
+++ e2fsprogs.git/lib/quota/mkquota.h
@@ -10,7 +10,7 @@
  * {
  *    quota_ctx_t qctx;
  *
- *    quota_init_context(&qctx, fs, -1);
+ *    quota_init_context(&qctx, fs, ALLQUOTA_BIT);
  *    {
  *        quota_compute_usage(qctx, -1);
  *        AND/OR
@@ -43,7 +43,7 @@ struct quota_ctx {
 };

 /* In mkquota.c */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int
qtype_bits);
 void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
ext2_ino_t ino,
         int adjust);
 void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
Index: e2fsprogs.git/lib/quota/quotaio.c
===================================================================
--- e2fsprogs.git.orig/lib/quota/quotaio.c
+++ e2fsprogs.git/lib/quota/quotaio.c
@@ -42,6 +42,22 @@ const char *type2name(int type)
     return extensions[type];
 }

+ext2_ino_t type2ino(int qtype)
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
@@ -114,11 +130,16 @@ errcode_t quota_inode_truncate(ext2_fils
 {
     struct ext2_inode inode;
     errcode_t err;
+    int i;

     if ((err = ext2fs_read_inode(fs, ino, &inode)))
         return err;

-    if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO)) {
+    for (i = 0; i < MAXQUOTAS; i++)
+        if (ino == type2ino(i))
+            break;
+
+    if (i != MAXQUOTAS) {
         inode.i_dtime = fs->now ? fs->now : time(0);
         if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
             return 0;
@@ -290,11 +311,8 @@ errcode_t quota_file_create(struct quota
         fmt = QFMT_VFS_V1;

     h->qh_qf.fs = fs;
-    if (type == USRQUOTA)
-        qf_inum = EXT4_USR_QUOTA_INO;
-    else if (type == GRPQUOTA)
-        qf_inum = EXT4_GRP_QUOTA_INO;
-    else
+    qf_inum = type2ino(type);
+    if (qf_inum == 0)
         return -1;

     err = ext2fs_read_bitmaps(fs);
Index: e2fsprogs.git/lib/quota/quotaio.h
===================================================================
--- e2fsprogs.git.orig/lib/quota/quotaio.h
+++ e2fsprogs.git/lib/quota/quotaio.h
@@ -20,6 +20,10 @@ typedef int64_t qsize_t;    /* Type in whic
 #define USRQUOTA 0
 #define GRPQUOTA 1

+#define USRQUOTA_BIT (1 << USRQUOTA)
+#define GRPQUOTA_BIT (1 << GRPQUOTA)
+#define ALLQUOTA_BIT (USRQUOTA_BIT | GRPQUOTA_BIT)
+
 /*
  * Definitions of magics and versions of current quota files
  */
@@ -151,6 +155,7 @@ struct dquot *get_empty_dquot(void);
 errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);

 const char *type2name(int type);
+ext2_ino_t type2ino(int qtype);

 void update_grace_times(struct dquot *q);

Index: e2fsprogs.git/misc/tune2fs.c
===================================================================
--- e2fsprogs.git.orig/misc/tune2fs.c
+++ e2fsprogs.git/misc/tune2fs.c
@@ -94,7 +94,7 @@ static int stride_set, stripe_width_set;
 static char *extended_cmd;
 static unsigned long new_inode_size;
 static char *ext_mount_opts;
-static int usrquota, grpquota;
+static int quota[MAXQUOTAS];
 static int rewrite_checksums;

 int journal_size, journal_flags;
@@ -862,6 +862,7 @@ static int update_feature_set(ext2_filsy
     __u32        old_features[3];
     int        type_err;
     unsigned int    mask_err;
+    int        i;

 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
                 ((&sb->s_feature_compat)[(type)] & (mask)))
@@ -1095,8 +1096,8 @@ mmp_error:
         if (!Q_flag) {
             Q_flag = 1;
             /* Enable both user quota and group quota by default */
-            usrquota = QOPT_ENABLE;
-            grpquota = QOPT_ENABLE;
+            for (i = 0; i < MAXQUOTAS; i++)
+                quota[i] = QOPT_ENABLE;
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
+            quota[i] = QOPT_DISABLE;
     }

     if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
@@ -1222,47 +1223,53 @@ static void handle_quota_options(ext2_fi
 {
     quota_ctx_t qctx;
     ext2_ino_t qf_ino;
+    int i;
+    int enable = 0;

-    if (!usrquota && !grpquota)
+    for (i = 0 ; i < MAXQUOTAS; i++)
+        if (quota[i])
+            break;
+    if (i == MAXQUOTAS)
         /* Nothing to do. */
         return;

-    quota_init_context(&qctx, fs, -1);
-
-    if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
+    quota_init_context(&qctx, fs, ALLQUOTA_BIT);
+    for (i = 0 ; i < MAXQUOTAS; i++)
+        if (quota[i] == QOPT_ENABLE) {
+            enable = 1;
+            break;
+        }
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
+        if (quota[i] == QOPT_ENABLE && !fs->super->s_quota_inum[i]) {
+            if ((qf_ino = quota_file_exists(fs, i,
+                            QFMT_VFS_V1)) > 0)
+                quota_update_limits(qctx, qf_ino, i);
+            quota_write_inode(qctx, i);
+        } else if (quota[i] == QOPT_DISABLE) {
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
+            if (fs->super->s_quota_inum[i])
+                break;
+        if (i == MAXQUOTAS) {
+            fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
+            ext2fs_mark_super_dirty(fs);
+        }
     }

     return;
@@ -1291,13 +1298,13 @@ static void parse_quota_opts(const char
         }

         if (strcmp(token, "usrquota") == 0) {
-            usrquota = QOPT_ENABLE;
+            quota[USRQUOTA] = QOPT_ENABLE;
         } else if (strcmp(token, "^usrquota") == 0) {
-            usrquota = QOPT_DISABLE;
+            quota[USRQUOTA] = QOPT_DISABLE;
         } else if (strcmp(token, "grpquota") == 0) {
-            grpquota = QOPT_ENABLE;
+            quota[GRPQUOTA] = QOPT_ENABLE;
         } else if (strcmp(token, "^grpquota") == 0) {
-            grpquota = QOPT_DISABLE;
+            quota[GRPQUOTA] = QOPT_DISABLE;
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
+      MAXQUOTAS },
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
+    check_field(s_quota_inum, 4 * MAXQUOTAS);
     check_field(s_overhead_blocks, 4);
     check_field(s_reserved, 108 * 4);
     check_field(s_checksum, 4);
