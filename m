From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] chattr: add maximum value check for project
Date: Wed, 27 Sep 2017 12:21:15 +0800
Message-ID: <20170927042115.6711-1-wshilong@ddn.com>
Cc: sihara@ddn.com, Wang Shilong <wshilong@ddn.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34941 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031435AbdI0EVe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Sep 2017 00:21:34 -0400
Received: by mail-pf0-f196.google.com with SMTP id i23so5881201pfi.2
        for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2017 21:21:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

See following output:
[root@mds03 client]# chattr -R +P -p 4294967296 testdir/
[root@mds03 client]# lsattr -dp testdir/
    0 ----------------P testdir/
[root@mds03 client]# chattr -R +P -p 4294967297 testdir/
[root@mds03 client]# lsattr -dp testdir/
    1 ----------------P testdir/

Reported-by: Shuichi Ihara <sihara@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 lib/ext2fs/ext2_fs.h |  2 ++
 misc/chattr.c        | 11 ++++++++---
 misc/mke2fs.c        |  2 --
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 3b55000..99f89ec 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -75,6 +75,8 @@
  */
 #define EXT2_LINK_MAX		65000
 
+#define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
+
 /*
  * Macro-instructions used to manage several block sizes
  */
diff --git a/misc/chattr.c b/misc/chattr.c
index a5b401a..bab20e8 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -152,13 +152,18 @@ static int decode_arg (int * i, int argc, char ** argv)
 			if (*p == 'p') {
 				(*i)++;
 				if (*i >= argc)
-					usage ();
-				project = strtol (argv[*i], &tmp, 0);
+					usage();
+				project = strtol(argv[*i], &tmp, 0);
 				if (*tmp) {
 					com_err (program_name, 0,
 						 _("bad project - %s\n"),
 						 argv[*i]);
-					usage ();
+					usage();
+				}
+				if (project > MAX_32_NUM) {
+					com_err(program_name, 0,
+						_("Kernel does not support set project ID this large"));
+					exit(1);
 				}
 				set_project = 1;
 				continue;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d585a9e..22812cd 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -63,8 +63,6 @@ extern int optind;
 
 #define STRIDE_LENGTH 8
 
-#define MAX_32_NUM ((((unsigned long long) 1) << 32) - 1)
