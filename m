From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] ext2fs: fix undeclared posix_memalign() warning
Date: Thu,  9 Jun 2011 23:17:16 -0600
Message-ID: <1307683036-4564-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:13324 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1FJFRT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 01:17:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Older distros do not define posix_memalign() by default in the
headers.  If ext2fs.h is included early in the headers, it is
possible to "#define _XOPEN_SOURCE 600" so that the stdlib.h
header will define it, but if ext2fs.h is included after stdlib.h
there is no posix_memalign() declaration.

Add a posix_memalign() declaration if stdlib.h didn't do it.  This
is a bit of a hack for GNU headers, but it works on Linux and OS/X
without problems.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/ext2fs.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9acccf2..975ab9d 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -29,6 +29,10 @@ extern "C" {
 #define NO_INLINE_FUNCS
 #endif
 
+#ifndef _XOPEN_SOURCE
+#define _XOPEN_SOURCE 600	/* for posix_memalign() */
+#endif
+
 /*
  * Where the master copy of the superblock is located, and how big
  * superblocks are supposed to be.  We define SUPERBLOCK_SIZE because
@@ -37,7 +41,7 @@ extern "C" {
  * 1032 bytes long).
  */
 #define SUPERBLOCK_OFFSET	1024
-#define SUPERBLOCK_SIZE 	1024
+#define SUPERBLOCK_SIZE		1024
 
 /*
  * The last ext2fs revision level that this version of the library is
@@ -54,6 +58,13 @@ extern "C" {
 #include <string.h>
 #include <errno.h>
 
+#ifndef __USE_XOPEN2K
+/* If the "#define _XOPEN_SOURCE 600" didn't succeed in declaring
+ * posix_memalign(), maybe due to <features.h> or <stdlib.h> included beforej
+ * _XOPEN_SOURCE, declare it here to avoid compiler warnings. */
+extern int posix_memalign(void **__memptr, size_t __alignment, size_t __size);
+#endif
+
 #if EXT2_FLAT_INCLUDES
 #include "e2_types.h"
 #include "ext2_fs.h"
-- 
1.7.3.4

