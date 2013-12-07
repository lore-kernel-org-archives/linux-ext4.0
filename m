From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] debugfs: print missing argument in usage for open, filefrag and ls
Date: Sat,  7 Dec 2013 15:11:45 +0800
Message-ID: <1386400305-16757-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:61550 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3LGHIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Dec 2013 02:08:51 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so2355128pbc.11
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 23:08:51 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit prints missing argument in usage for open, filefrag and ls
commands, which might help us to use debugfs tool.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/debugfs.c  |    3 ++-
 debugfs/filefrag.c |    2 +-
 debugfs/ls.c       |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 8c32eff..4dd5ba9 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -201,7 +201,8 @@ void do_open_filesys(int argc, char **argv)
 	return;
 
 print_usage:
-	fprintf(stderr, "%s: Usage: open [-s superblock] [-b blocksize] [-c] "
+	fprintf(stderr, "%s: Usage: open [-s superblock] [-b blocksize] "
+		"[d image_filename] [-c] [-i] [-f] [-e] [-D] "
 #ifndef READ_ONLY
 		"[-w] "
 #endif
diff --git a/debugfs/filefrag.c b/debugfs/filefrag.c
index e82d133..6219d7c 100644
--- a/debugfs/filefrag.c
+++ b/debugfs/filefrag.c
@@ -289,7 +289,7 @@ void do_filefrag(int argc, char *argv[])
 
 	if (argc > optind+1) {
 	print_usage:
-		com_err(0, 0, "Usage: filefrag [-dv] file");
+		com_err(0, 0, "Usage: filefrag [-dvr] file");
 		return;
 	}
 
diff --git a/debugfs/ls.c b/debugfs/ls.c
index 69c7897..3603e46 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -167,7 +167,7 @@ void do_list_dir(int argc, char *argv[])
 
 	if (argc > optind+1) {
 	print_usage:
-		com_err(0, 0, "Usage: ls [-l] [-d] [-p] file");
+		com_err(0, 0, "Usage: ls [-l] [-d] [-p] [-c] file");
 		return;
 	}
 
-- 
1.7.9.7

