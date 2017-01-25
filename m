From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: [PATCH] e2fsprogs: supersede i_dir_acl with i_size_high for all cases
Date: Wed, 25 Jan 2017 20:07:29 +0300
Message-ID: <CAO3qy=HC58uTfpq13b31wOqJ79pWrnuP3TVfUCDesxStW3xfWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:38424 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751656AbdAYRHn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 25 Jan 2017 12:07:43 -0500
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0PGrGZ8020738
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 12:07:32 -0500
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com [209.85.216.199])
        by mx0a-00003501.pphosted.com with ESMTP id 286sqvsryc-45
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 12:07:32 -0500
Received: by mail-qt0-f199.google.com with SMTP id g49so186009465qta.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 09:07:31 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch removes i_dir_acl macros and macros users.
Now structure field can be accessed as i_size_high. This field
is useful for largedir feature.

Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 debugfs/debugfs.c            |   16 +++++++---------
 debugfs/set_fields.c         |    1 -
 e2fsck/message.c             |    4 ----
 e2fsck/pass1.c               |    3 +--
 e2fsck/pass2.c               |    8 --------
 e2fsck/problem.c             |    5 -----
 e2fsck/problem.h             |    3 ---
 lib/ext2fs/ext2_fs.h         |    6 ++----
 lib/ext2fs/swapfs.c          |    2 +-
 tests/d_special_files/expect |   10 +++++-----
 tests/f_badcluster/expect    |   14 +++++++-------
 tests/f_recnect_bad/expect.1 |    3 ---
 12 files changed, 23 insertions(+), 52 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index b40d9e2..795bdc3 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -841,16 +841,15 @@ void internal_dump_inode(FILE *out, const char *prefix,
         fprintf(out, "%d\n", inode->i_size);
     if (os == EXT2_OS_HURD)
         fprintf(out,
-            "%sFile ACL: %d    Directory ACL: %d Translator: %d\n",
+            "%sFile ACL: %d Translator: %d\n",
             prefix,
-            inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) ?
inode->i_dir_acl : 0,
+            inode->i_file_acl,
             inode->osd1.hurd1.h_i_translator);
     else
-        fprintf(out, "%sFile ACL: %llu    Directory ACL: %d\n",
+        fprintf(out, "%sFile ACL: %llu\n",
             prefix,
             inode->i_file_acl | ((long long)
-                (inode->osd2.linux2.l_i_file_acl_high) << 32),
-            LINUX_S_ISDIR(inode->i_mode) ? inode->i_dir_acl : 0);
+                (inode->osd2.linux2.l_i_file_acl_high) << 32));
     if (os != EXT2_OS_HURD)
         fprintf(out, "%sLinks: %d   Blockcount: %llu\n",
             prefix, inode->i_links_count,
@@ -1347,10 +1346,9 @@ void do_modify_inode(int argc, char *argv[])
     modify_u32(argv[0], "Reserved1", decimal_format, &inode.i_reserved1);
 #endif
     modify_u32(argv[0], "File acl", decimal_format, &inode.i_file_acl);
-    if (LINUX_S_ISDIR(inode.i_mode))
-        modify_u32(argv[0], "Directory acl", decimal_format, &inode.i_dir_acl);
-    else
-        modify_u32(argv[0], "High 32bits of size", decimal_format,
&inode.i_size_high);
+
+    modify_u32(argv[0], "High 32bits of size", decimal_format,
+           &inode.i_size_high);

     if (os == EXT2_OS_HURD)
         modify_u32(argv[0], "Translator Block",
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ff9b7b6..ca68862 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -212,7 +212,6 @@ static struct field_set_info inode_fields[] = {
     /* Special case: i_file_acl_high is 2 bytes */
     { "file_acl", &set_inode.i_file_acl,
         &set_inode.osd2.linux2.l_i_file_acl_high, 6, parse_uint },
-    { "dir_acl", &set_inode.i_dir_acl, NULL, 4, parse_uint, FLAG_ALIAS },
     { "faddr", &set_inode.i_faddr, NULL, 4, parse_uint },
     { "frag", &set_inode.osd2.hurd2.h_i_frag, NULL, 1, parse_uint,
FLAG_ALIAS },
     { "fsize", &set_inode.osd2.hurd2.h_i_fsize, NULL, 1, parse_uint },
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 1c3fcd8..d21ba05 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -318,10 +318,6 @@ static _INLINE_ void expand_inode_expression(FILE
*f, ext2_filsys fs, char ch,
     case 'f':
         fprintf(f, "%llu", ext2fs_file_acl_block(fs, inode));
         break;
-    case 'd':
-        fprintf(f, "%u", (LINUX_S_ISDIR(inode->i_mode) ?
-                  inode->i_dir_acl : 0));
-        break;
     case 'u':
         fprintf(f, "%d", inode_uid(*inode));
         break;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8ef40f6..2d21aae 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1715,8 +1715,7 @@ void e2fsck_pass1(e2fsck_t ctx)
             frag = fsize = 0;
         }

-        if (inode->i_faddr || frag || fsize ||
-            (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
+        if (inode->i_faddr || frag || fsize)
             mark_inode_bad(ctx, ino);
         if ((fs->super->s_creator_os != EXT2_OS_HURD) &&
             !ext2fs_has_feature_64bit(fs->super) &&
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 11c19e8..3b141db 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1811,14 +1811,6 @@ int e2fsck_process_bad_inode(e2fsck_t ctx,
ext2_ino_t dir,
         } else
             not_fixed++;
     }
-    if (inode.i_dir_acl &&
-        LINUX_S_ISDIR(inode.i_mode)) {
-        if (fix_problem(ctx, PR_2_DIR_ACL_ZERO, &pctx)) {
-            inode.i_dir_acl = 0;
-            inode_modified++;
-        } else
-            not_fixed++;
-    }

     if (inode_modified)
         e2fsck_write_inode(ctx, ino, &inode, "process_bad_inode");
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 34a671e..ce2f79d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1360,11 +1360,6 @@ static struct e2fsck_problem problem_table[] = {
       N_("i_file_acl @F %If, @s zero.\n"),
       PROMPT_CLEAR, 0 },

-    /* i_dir_acl should be zero */
-    { PR_2_DIR_ACL_ZERO,
-      N_("i_dir_acl @F %Id, @s zero.\n"),
-      PROMPT_CLEAR, 0 },
-
     /* i_frag should be zero */
     { PR_2_FRAG_ZERO,
       N_("i_frag @F %N, @s zero.\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 86cb614..f07f9b6 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -808,9 +808,6 @@ struct problem_context {
 /* i_file_acl should be zero */
 #define PR_2_FILE_ACL_ZERO    0x02000E

-/* i_dir_acl should be zero */
-#define PR_2_DIR_ACL_ZERO    0x02000F
-
 /* i_frag should be zero */
 #define PR_2_FRAG_ZERO        0x020010

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 27a7d3a..195e366 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -398,7 +398,7 @@ struct ext2_inode {
     __u32    i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
     __u32    i_generation;    /* File version (for NFS) */
     __u32    i_file_acl;    /* File ACL */
-    __u32    i_size_high;    /* Formerly i_dir_acl, directory ACL */
+    __u32    i_size_high;
     __u32    i_faddr;    /* Fragment address */
     union {
         struct {
@@ -446,7 +446,7 @@ struct ext2_inode_large {
     __u32    i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
     __u32    i_generation;    /* File version (for NFS) */
     __u32    i_file_acl;    /* File ACL */
-    __u32    i_size_high;    /* Formerly i_dir_acl, directory ACL */
+    __u32    i_size_high;
     __u32    i_faddr;    /* Fragment address */
     union {
         struct {
@@ -484,8 +484,6 @@ struct ext2_inode_large {
 #define EXT4_EPOCH_BITS 2
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)

-#define i_dir_acl    i_size_high
-
 #define i_checksum_lo    osd2.linux2.l_i_checksum_lo

 #define inode_includes(size, field)            \
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index d63fc55..2d05ee7 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -247,7 +247,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct
ext2_inode_large *t,
         has_extents = 1;
     if (!hostorder && (t->i_flags & EXT4_INLINE_DATA_FL))
         has_inline_data = 1;
-    t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
+    t->i_size_high = ext2fs_swab32(f->i_size_high);
     /*
      * Extent data and inline data are swapped on access, not here
      */
diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
index f729b0f..c825932 100644
--- a/tests/d_special_files/expect
+++ b/tests/d_special_files/expect
@@ -5,7 +5,7 @@ debugfs -R ''stat foo'' -w test.img
 Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
 Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 3
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -17,7 +17,7 @@ debugfs -R ''stat foo2'' -w test.img
 Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0
 Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 80
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -42,7 +42,7 @@ debugfs -R ''stat pipe'' -w test.img
 Inode: 14   Type: FIFO    Mode:  0000   Flags: 0x0
 Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 0
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -55,7 +55,7 @@ debugfs -R ''stat sda'' -w test.img
 Inode: 15   Type: block special    Mode:  0000   Flags: 0x0
 Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 0
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
@@ -67,7 +67,7 @@ debugfs -R ''stat null'' -w test.img
 Inode: 16   Type: character special    Mode:  0000   Flags: 0x0
 Generation: 0    Version: 0x00000000
 User:     0   Group:     0   Size: 0
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
diff --git a/tests/f_badcluster/expect b/tests/f_badcluster/expect
index 65a1641..75a3820 100644
--- a/tests/f_badcluster/expect
+++ b/tests/f_badcluster/expect
@@ -116,7 +116,7 @@ debugfs: stat /a
 Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152157    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 32
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -128,7 +128,7 @@ debugfs: stat /b
 Inode: 13   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152158    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 32
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -140,7 +140,7 @@ debugfs: stat /c
 Inode: 14   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152159    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 32
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -152,7 +152,7 @@ debugfs: stat /d
 Inode: 15   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152160    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -163,7 +163,7 @@ debugfs: stat /e
 Inode: 16   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152161    Version: 0x00000001
 User:     0   Group:     0   Size: 6144
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 32
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -175,7 +175,7 @@ debugfs: stat /f
 Inode: 17   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152162    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 32
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
@@ -187,7 +187,7 @@ debugfs: stat /g
 Inode: 18   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152163    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
-File ACL: 0    Directory ACL: 0
+File ACL: 0
 Links: 1   Blockcount: 32
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
diff --git a/tests/f_recnect_bad/expect.1 b/tests/f_recnect_bad/expect.1
index 8ba81e6..6433c8d 100644
--- a/tests/f_recnect_bad/expect.1
+++ b/tests/f_recnect_bad/expect.1
@@ -3,9 +3,6 @@ Pass 2: Checking directory structure
 i_faddr for inode 15 (/test/quux) is 23, should be zero.
 Clear? yes

-i_dir_acl for inode 15 (/test/quux) is 12, should be zero.
-Clear? yes
