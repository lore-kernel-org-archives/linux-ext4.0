From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] create_inode: don't indiscriminately #include "nls-enable.h"
Date: Fri, 19 Sep 2014 01:50:55 -0400
Message-ID: <1411105858-21120-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36943 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbaISFvE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 01:51:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The create_inode.h header file is pulled in by debugfs, which is not
internationalized.  It had no business pulling in nls-enable.h; that
header file should only be used in specific .c files that support
internationalization.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/create_inode.c | 1 +
 misc/create_inode.h | 1 -
 misc/mke2fs.c       | 1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 7f57979..cf7c097 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -17,6 +17,7 @@
 #endif
 
 #include "create_inode.h"
+#include "nls-enable.h"
 
 #if __STDC_VERSION__ < 199901L
 # if __GNUC__ >= 2
diff --git a/misc/create_inode.h b/misc/create_inode.h
index 067bf96..145fd57 100644
--- a/misc/create_inode.h
+++ b/misc/create_inode.h
@@ -7,7 +7,6 @@
 #include "et/com_err.h"
 #include "e2p/e2p.h"
 #include "ext2fs/ext2fs.h"
-#include "nls-enable.h"
 
 struct hdlink_s
 {
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 69045b2..f09351d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -58,6 +58,7 @@ extern int optind;
 #include "quota/quotaio.h"
 #include "mke2fs.h"
 #include "create_inode.h"
+#include "nls-enable.h"
 
 #define STRIDE_LENGTH 8
 
-- 
2.1.0

