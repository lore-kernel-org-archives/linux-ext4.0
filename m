From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: [PATCH] debugfs: increase inode reference count after link
Date: Fri, 20 Jan 2017 19:53:42 +0300
Message-ID: <CAO3qy=EnXgiYPFDPkksSzGAaYms2KpNgAb55S_=GryJCRyhg5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:38853 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751196AbdATQym (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Jan 2017 11:54:42 -0500
Received: from pps.filterd (m0075555.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0KGlYTI043625
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2017 11:53:49 -0500
Received: from mail-yb0-f200.google.com (mail-yb0-f200.google.com [209.85.213.200])
        by mx0a-00003501.pphosted.com with ESMTP id 283ggmsgct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2017 11:53:49 -0500
Received: by mail-yb0-f200.google.com with SMTP id 186so118666968yby.5
        for <linux-ext4@vger.kernel.org>; Fri, 20 Jan 2017 08:53:49 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode reference count is not increased after debugfs link command.
This leads to inconsistent file system state. fsck can find such
inodes and can fix. There is right code in add_link() that:
1) create link
2) expand directory if needed
3) increase inode referance
This patch uses add_link() function for debug link command.
Automatic directory expanding is useful when many files
are created in the same directory.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
---
 debugfs/debugfs.c     |    7 +------
 misc/create_inode.c   |    2 +-
 misc/create_inode.h   |    2 ++
 tests/f_dup4/expect.1 |    6 ------
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 165f924..b40d9e2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1440,7 +1440,6 @@ void do_print_working_directory(int argc, char *argv[])
 static void make_link(char *sourcename, char *destname)
 {
     ext2_ino_t    ino;
-    struct ext2_inode inode;
     int        retval;
     ext2_ino_t    dir;
     char        *dest, *cp, *base_name;
@@ -1480,11 +1479,7 @@ static void make_link(char *sourcename, char *destname)
         }
     }

-    if (debugfs_read_inode(ino, &inode, sourcename))
-        return;
-
-    retval = ext2fs_link(current_fs, dir, dest, ino,
-                 ext2_file_type(inode.i_mode));
+    retval = add_link(current_fs, dir, ino, dest);
     if (retval)
         com_err("make_link", retval, 0);
     return;
diff --git a/misc/create_inode.c b/misc/create_inode.c
index ae22ff6..e2d80b4 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -59,7 +59,7 @@ static int ext2_file_type(unsigned int mode)
 }

 /* Link an inode number to a directory */
-static errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
+errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
               ext2_ino_t ino, const char *name)
 {
     struct ext2_inode    inode;
diff --git a/misc/create_inode.h b/misc/create_inode.h
index cf49df2..9c787ab 100644
--- a/misc/create_inode.h
+++ b/misc/create_inode.h
@@ -37,5 +37,7 @@ extern errcode_t do_mkdir_internal(ext2_filsys fs,
ext2_ino_t cwd,
 extern errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd,
                    const char *src, const char *dest,
                    ext2_ino_t root);
+extern errcode_t add_link(ext2_filsys fs, ext2_ino_t parent_ino,
+              ext2_ino_t ino, const char *name);

 #endif /* _CREATE_INODE_H */
diff --git a/tests/f_dup4/expect.1 b/tests/f_dup4/expect.1
index 7d51bb1..9fec126 100644
--- a/tests/f_dup4/expect.1
+++ b/tests/f_dup4/expect.1
@@ -99,12 +99,6 @@ Inode 14 ref count is 4, should be 3.  Fix? yes

 Inode 15 ref count is 0, should be 3.  Fix? yes

-Inode 16 ref count is 1, should be 3.  Fix? yes
-
-Inode 17 ref count is 1, should be 2.  Fix? yes
-
-Inode 19 ref count is 1, should be 3.  Fix? yes
