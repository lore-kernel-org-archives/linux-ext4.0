From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 4/4] quota: add project quota support
Date: Fri, 1 Aug 2014 09:08:47 +0800
Message-ID: <CAPTn0cCqW-m8-z-98LCNWc1hwpZThvwNmrwp8WRK00BZQ9Jf0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:61079 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaHABIs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2014 21:08:48 -0400
Received: by mail-ig0-f173.google.com with SMTP id h18so642195igc.12
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2014 18:08:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adds project quota support for ext4

This patch adds mount options for enabling/disabling project quota
accounting and enforcement. A new specific inode is also used for
project quota accounting.

Signed-off-by: Li Xi <lixi <at> ddn.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
Index: linux.git/fs/ext4/ext4.h
===================================================================
--- linux.git.orig/fs/ext4/ext4.h
+++ linux.git/fs/ext4/ext4.h
@@ -217,6 +217,7 @@ struct ext4_io_submit {
 #define EXT4_UNDEL_DIR_INO     6    /* Undelete directory inode */
 #define EXT4_RESIZE_INO         7    /* Reserved group descriptors inode */
 #define EXT4_JOURNAL_INO     8    /* Journal inode */
+#define EXT4_PRJ_QUOTA_INO     9    /* Project quota inode */

 /* First non-reserved inode for old ext4 filesystems */
 #define EXT4_GOOD_OLD_FIRST_INO    11
@@ -987,6 +988,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DIOREAD_NOLOCK    0x400000 /* Enable support for
dio read nolocking */
 #define EXT4_MOUNT_JOURNAL_CHECKSUM    0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT    0x1000000 /* Journal Async Commit */
+#define EXT4_MOUNT_PRJQUOTA        0x4000000 /* Subtree quota support */
 #define EXT4_MOUNT_DELALLOC        0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT    0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY    0x20000000 /* Block validity checking */
@@ -1366,6 +1368,7 @@ static inline int ext4_valid_inum(struct
         ino == EXT4_BOOT_LOADER_INO ||
         ino == EXT4_JOURNAL_INO ||
         ino == EXT4_RESIZE_INO ||
+        ino == EXT4_PRJ_QUOTA_INO ||
         (ino >= EXT4_FIRST_INO(sb) &&
          ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
Index: linux.git/fs/ext4/super.c
===================================================================
--- linux.git.orig/fs/ext4/super.c
+++ linux.git/fs/ext4/super.c
@@ -1048,8 +1048,8 @@ static int bdev_try_to_free_page(struct
 }

 #ifdef CONFIG_QUOTA
-#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+static char *quotatypes[] = INITQFNAMES;
+#define QTYPE2NAME(t) (quotatypes[t])

 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
@@ -1159,10 +1159,11 @@ enum {
     Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
     Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
     Opt_data_err_abort, Opt_data_err_ignore,
-    Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
+    Opt_usrjquota, Opt_grpjquota, Opt_prjjquota,
+    Opt_offusrjquota, Opt_offgrpjquota, Opt_offprjjquota,
     Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
     Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
-    Opt_usrquota, Opt_grpquota, Opt_i_version,
+    Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
     Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
     Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
     Opt_inode_readahead_blks, Opt_journal_ioprio,
@@ -1213,6 +1214,8 @@ static const match_table_t tokens = {
     {Opt_usrjquota, "usrjquota=%s"},
     {Opt_offgrpjquota, "grpjquota="},
     {Opt_grpjquota, "grpjquota=%s"},
+    {Opt_offprjjquota, "prjjquota="},
+    {Opt_prjjquota, "prjjquota=%s"},
     {Opt_jqfmt_vfsold, "jqfmt=vfsold"},
     {Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
     {Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
@@ -1220,6 +1223,7 @@ static const match_table_t tokens = {
     {Opt_noquota, "noquota"},
     {Opt_quota, "quota"},
     {Opt_usrquota, "usrquota"},
+    {Opt_prjquota, "prjquota"},
     {Opt_barrier, "barrier=%u"},
     {Opt_barrier, "barrier"},
     {Opt_nobarrier, "nobarrier"},
@@ -1432,6 +1436,12 @@ static const struct mount_opts {
                             MOPT_SET | MOPT_Q},
     {Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
                             MOPT_SET | MOPT_Q},
+#ifdef CONFIG_EXT4_PRJQUOTA
+    {Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
+                            MOPT_SET | MOPT_Q},
+#else
+    {Opt_prjquota, 0, MOPT_NOSUPPORT},
+#endif
     {Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
                EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
     {Opt_usrjquota, 0, MOPT_Q},
@@ -1460,10 +1470,14 @@ static int handle_mount_opt(struct super
         return set_qf_name(sb, USRQUOTA, &args[0]);
     else if (token == Opt_grpjquota)
         return set_qf_name(sb, GRPQUOTA, &args[0]);
+    else if (token == Opt_prjjquota)
+        return set_qf_name(sb, PRJQUOTA, &args[0]);
     else if (token == Opt_offusrjquota)
         return clear_qf_name(sb, USRQUOTA);
     else if (token == Opt_offgrpjquota)
         return clear_qf_name(sb, GRPQUOTA);
+    else if (token == Opt_offprjjquota)
+        return clear_qf_name(sb, PRJQUOTA);
 #endif
     switch (token) {
     case Opt_noacl:
@@ -1689,19 +1703,28 @@ static int parse_options(char *options,
     }
 #ifdef CONFIG_QUOTA
     if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-        (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
+        (test_opt(sb, USRQUOTA) ||
+         test_opt(sb, GRPQUOTA) ||
+         test_opt(sb, PRJQUOTA))) {
         ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
              "feature is enabled");
         return 0;
     }
-    if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+    if (sbi->s_qf_names[USRQUOTA] ||
+        sbi->s_qf_names[GRPQUOTA] ||
+        sbi->s_qf_names[PRJQUOTA]) {
         if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
             clear_opt(sb, USRQUOTA);

         if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
             clear_opt(sb, GRPQUOTA);

-        if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
+        if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
+            clear_opt(sb, PRJQUOTA);
+
+        if (test_opt(sb, GRPQUOTA) ||
+            test_opt(sb, USRQUOTA) ||
+            test_opt(sb, PRJQUOTA)) {
             ext4_msg(sb, KERN_ERR, "old and new quota "
                     "format mixing");
             return 0;
@@ -1762,6 +1785,10 @@ static inline void ext4_show_quota_optio

     if (sbi->s_qf_names[GRPQUOTA])
         seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
+#ifdef CONFIG_EXT4_PRJQUOTA
+    if (sbi->s_qf_names[PRJQUOTA])
+        seq_printf(seq, ",prjjquota=%s", sbi->s_qf_names[PRJQUOTA]);
+#endif
 #endif
 }

@@ -5120,7 +5147,9 @@ static int ext4_mark_dquot_dirty(struct

     /* Are we journaling quotas? */
     if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) ||
-        sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+        sbi->s_qf_names[USRQUOTA] ||
+        sbi->s_qf_names[GRPQUOTA] ||
+        sbi->s_qf_names[PRJQUOTA]) {
         dquot_mark_dquot_dirty(dquot);
         return ext4_write_dquot(dquot);
     } else {
Index: linux.git/fs/ext4/Kconfig
===================================================================
--- linux.git.orig/fs/ext4/Kconfig
+++ linux.git/fs/ext4/Kconfig
@@ -64,6 +64,18 @@ config EXT4_FS_SECURITY
       If you are not using a security module that requires using
       extended attributes for file security labels, say N.

+config EXT4_PRJQUOTA
+    bool "Ext4 project quota support"
+    depends on EXT4_FS
+    select QUOTA_PROJECT
+    help
+      Enables project inode identifier support for ext4 filesystem.
+      This feature allow to assign extended inode's identifier similar to
+      uid/gid. Value is stored in xattr "system.project" and may be used
+      as additional quota limit.
+
+      If unsure, say N.
+
 config EXT4_DEBUG
     bool "EXT4 debugging support"
     depends on EXT4_FS
