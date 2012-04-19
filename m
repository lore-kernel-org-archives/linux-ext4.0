From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 1/3] fs: add new open flags O_HOT and O_COLD
Date: Thu, 19 Apr 2012 15:20:09 -0400
Message-ID: <1334863211-19504-2-git-send-email-tytso@mit.edu>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59399 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398Ab2DSTUO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 15:20:14 -0400
In-Reply-To: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The O_HOT and O_COLD flag are hints to the file system that the file
is going to be frequently accessed (a "hot" file) and or very
infrequently accessed (a "cold" file).  It is up the file system to
decide how these flags should be interpreted; in some cases, such as
O_HOT, the file system may require appropriate privileges or implement
check some kind of per-user quota before deciding to honor the flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/fcntl.c                  |    5 +++--
 include/asm-generic/fcntl.h |    7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 75e7c1f..463352d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -835,14 +835,15 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		__FMODE_EXEC	| O_PATH
+		__FMODE_EXEC	| O_PATH	| O_HOT		|
+		O_COLD
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 9e5b035..1fdcbb1 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -84,6 +84,13 @@
 #define O_PATH		010000000
 #endif
 
+#ifndef O_HOT
+#define O_HOT		020000000	
+#endif
+#ifndef O_COLD
+#define O_COLD		040000000	
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
-- 
1.7.10.rc3

