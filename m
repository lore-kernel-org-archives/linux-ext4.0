From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] debugfs: fix ncheck program output
Date: Thu,  9 Nov 2017 15:59:34 +0900
Message-ID: <1510210774-4251-1-git-send-email-wshilong1991@gmail.com>
Cc: qian@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:55733 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdKIG7k (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Nov 2017 01:59:40 -0500
Received: by mail-pg0-f65.google.com with SMTP id 207so1183337pgc.12
        for <linux-ext4@vger.kernel.org>; Wed, 08 Nov 2017 22:59:40 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Qian Yingjin <qian@ddn.com>

Fix the bug that print the inode number not the program name
when reporting bad inode name during checking in ncheck.
Minor bug fix: it should reduce iw->inodes_left when found
matched inode number.

Signed-off-by: Qian Yingjin <qian@ddn.com>
---
 debugfs/ncheck.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 5d9b5d2..dc4ab56 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -81,6 +81,7 @@ static int ncheck_proc(struct ext2_dir_entry *dirent,
 				}
 			}
 			putc('\n', stdout);
+			iw->inodes_left--;
 		}
 	}
 	if (!iw->inodes_left)
@@ -111,10 +112,8 @@ void do_ncheck(int argc, char **argv)
 			goto print_usage;
 		}
 	}
-	argc -= optind;
-	argv += optind;
 
-	if (argc < 1) {
+	if (argc <= 1) {
 	print_usage:
 		com_err(argv[0], 0, "Usage: ncheck [-c] <inode number> ...");
 		return;
@@ -122,6 +121,8 @@ void do_ncheck(int argc, char **argv)
 	if (check_fs_open(argv[0]))
 		return;
 
+	argc -= optind;
+	argv += optind;
 	iw.iarray = malloc(sizeof(ext2_ino_t) * argc);
 	if (!iw.iarray) {
 		com_err("ncheck", ENOMEM,
@@ -133,7 +134,7 @@ void do_ncheck(int argc, char **argv)
 	for (i=0; i < argc; i++) {
 		iw.iarray[i] = strtol(argv[i], &tmp, 0);
 		if (*tmp) {
-			com_err(argv[0], 0, "Bad inode - %s", argv[i]);
+			com_err("ncheck", 0, "Bad inode - %s", argv[i]);
 			goto error_out;
 		}
 	}
-- 
1.7.1
