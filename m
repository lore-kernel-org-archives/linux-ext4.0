From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] e2p: fix getflags for link file
Date: Mon,  4 Dec 2017 22:56:35 +0900
Message-ID: <1512395795-10022-1-git-send-email-wshilong1991@gmail.com>
Cc: sihara@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33701 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754156AbdLDN4n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2017 08:56:43 -0500
Received: by mail-pg0-f66.google.com with SMTP id g7so8243768pgs.0
        for <linux-ext4@vger.kernel.org>; Mon, 04 Dec 2017 05:56:43 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

Steps to reproduce:

$ touch a
$ lsattr -dp a
 2000 ----------------P a
$ ln -s a b
$ lsattr -dp b
lsattr: Operation not supported While reading flags on b

Link files should be supported, fix it.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 lib/e2p/fgetflags.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/e2p/fgetflags.c b/lib/e2p/fgetflags.c
index 7b93cba..a39cdbd 100644
--- a/lib/e2p/fgetflags.c
+++ b/lib/e2p/fgetflags.c
@@ -73,7 +73,8 @@ int fgetflags (const char * name, unsigned long * flags)
 	int fd, r, f, save_errno = 0;
 
 	if (!lstat(name, &buf) &&
-	    !S_ISREG(buf.st_mode) && !S_ISDIR(buf.st_mode)) {
+	    !S_ISREG(buf.st_mode) && !S_ISDIR(buf.st_mode) &&
+	    !S_ISLNK(buf.st_mode)) {
 		goto notsupp;
 	}
 #if !APPLE_DARWIN
-- 
1.8.3.1
