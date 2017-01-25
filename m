From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: [PATCH 1/3 v2] e2fsprogs: add support for 3-level htree
Date: Wed, 25 Jan 2017 20:20:42 +0300
Message-ID: <CAO3qy=HcyNh7rV9vaTnvEeFpUTwJU4sTnKkFM=pfbagXAezUHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:43395 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751429AbdAYRUp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 25 Jan 2017 12:20:45 -0500
Received: from pps.filterd (m0075555.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0PHIJ6E000415
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 12:20:44 -0500
Received: from mail-qt0-f198.google.com (mail-qt0-f198.google.com [209.85.216.198])
        by mx0a-00003501.pphosted.com with ESMTP id 286ttdsgkf-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 12:20:44 -0500
Received: by mail-qt0-f198.google.com with SMTP id x49so185364135qtc.7
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 09:20:43 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Darrick J. Wong, thank you for inspection. Here is second version of the patch.

Changes since v1
* Part that removes dir_acl moved to separate patch "e2fsprogs:
supersede i_dir_acl with i_size_high for all  cases"

The INCOMPAT_LARGEDIR feature allows larger directories to
be created, both with directory sizes over 2GB and and a
maximum htree depth of 3 instead of the current limit of 2.
These features are needed in order to exceed the currently
limit of approximately 10M entries in a single directory.

debugfs, e2fsck, ext2fs, mke2fs and tune2fs support is
added.

This patch depends on "e2fsprogs: supersede i_dir_acl with i_size_high
for all  cases"

Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 e2fsck/pass1.c       |    2 +-
 e2fsck/pass2.c       |    3 ++-
 lib/ext2fs/ext2_fs.h |    3 ++-
 lib/ext2fs/ext2fs.h  |   15 ++++++++++++++-
 misc/mke2fs.c        |    3 ++-
 misc/tune2fs.c       |    3 ++-
 6 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2d21aae..8444b37 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2468,7 +2468,7 @@ static int handle_htree(e2fsck_t ctx, struct
problem_context *pctx,
         return 1;

     pctx->num = root->indirect_levels;
-    if ((root->indirect_levels > 1) &&
+    if ((root->indirect_levels > ext2_dir_htree_level(fs)) &&
         fix_problem(ctx, PR_1_HTREE_DEPTH, pctx))
         return 1;

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 3b141db..7ded7bb 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1058,7 +1058,8 @@ inline_read_fail:
             dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
             if ((root->reserved_zero ||
                  root->info_length < 8 ||
-                 root->indirect_levels > 1) &&
+                 root->indirect_levels
+                > ext2_dir_htree_level(fs)) &&
                 fix_problem(ctx, PR_2_HTREE_BAD_ROOT, &cd->pctx)) {
                 clear_htree(ctx, ino);
                 dx_dir->numblocks = 0;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 195e366..6d9a5d0 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -921,7 +921,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,        4, ENCRYPT)

 #define EXT2_FEATURE_COMPAT_SUPP    0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
-                       EXT4_FEATURE_INCOMPAT_MMP)
+                       EXT4_FEATURE_INCOMPAT_MMP|\
+                       EXT4_FEATURE_INCOMPAT_LARGEDIR)
 #define EXT2_FEATURE_RO_COMPAT_SUPP    (EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
                      EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
                      EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 786ded8..5e956d0 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -588,7 +588,8 @@ typedef struct ext2_icount *ext2_icount_t;
                      EXT4_FEATURE_INCOMPAT_64BIT|\
                      EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
                      EXT4_FEATURE_INCOMPAT_ENCRYPT|\
-                     EXT4_FEATURE_INCOMPAT_CSUM_SEED)
+                     EXT4_FEATURE_INCOMPAT_CSUM_SEED|\
+                     EXT4_FEATURE_INCOMPAT_LARGEDIR)

 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP
(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
                      EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
@@ -1924,6 +1925,18 @@ _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
     return (blk_t) ext2fs_inode_data_blocks2(fs, inode);
 }

+/* htree levels for ext4 */
+#define EXT4_HTREE_LEVEL_COMPAT 1
+#define EXT4_HTREE_LEVEL    3
+
+_INLINE_ unsigned int ext2_dir_htree_level(ext2_filsys fs)
+{
+        if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+                          EXT4_FEATURE_INCOMPAT_LARGEDIR))
+                    return EXT4_HTREE_LEVEL;
+            return EXT4_HTREE_LEVEL_COMPAT;
+}
+
 /*
  * This is an efficient, overflow safe way of calculating ceil((1.0 * a) / b)
  */
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9f18c83..b2bf461 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1081,7 +1081,8 @@ static __u32 ok_features[3] = {
         EXT4_FEATURE_INCOMPAT_64BIT|
         EXT4_FEATURE_INCOMPAT_INLINE_DATA|
         EXT4_FEATURE_INCOMPAT_ENCRYPT |
-        EXT4_FEATURE_INCOMPAT_CSUM_SEED,
+        EXT4_FEATURE_INCOMPAT_CSUM_SEED |
+        EXT4_FEATURE_INCOMPAT_LARGEDIR,
     /* R/O compat */
     EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
         EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6239577..f78d105 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -156,7 +156,8 @@ static __u32 ok_features[3] = {
         EXT4_FEATURE_INCOMPAT_MMP |
         EXT4_FEATURE_INCOMPAT_64BIT |
         EXT4_FEATURE_INCOMPAT_ENCRYPT |
-        EXT4_FEATURE_INCOMPAT_CSUM_SEED,
+        EXT4_FEATURE_INCOMPAT_CSUM_SEED |
+        EXT4_FEATURE_INCOMPAT_LARGEDIR,
     /* R/O compat */
     EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
         EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
--
