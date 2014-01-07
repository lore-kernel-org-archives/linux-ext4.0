From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] e4defrag: remove local sync_file_range and fallocate
Date: Tue,  7 Jan 2014 10:29:52 +0200
Message-ID: <f2848e6c0e067d62a4ee672f18364b20d4c901d9.1389083392.git.baruch@tkos.co.il>
Cc: linux-ext4@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:48312 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbaAGIae (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 03:30:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The locally defined versions of both sync_file_range and fallocate are broken
on 32bit systems. On these systems two 32bit registers are needed for each
64bit parameter. Also, sync_file_range on MIPS32 needs a dummy parameters
after the fd parameter. Just leave all these subtleties to the C library.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 misc/e4defrag.c | 50 +++-----------------------------------------------
 1 file changed, 3 insertions(+), 47 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c2695e825d6b..620f4e7981c8 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -39,7 +39,6 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
-#include <sys/syscall.h>
 #include <sys/vfs.h>
 
 /* A relatively new ioctl interface ... */
@@ -194,56 +193,13 @@ static struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
 #error posix_fadvise not available!
 #endif
 
-/*
- * Local definitions of some syscalls glibc may not yet have
- */
 #ifndef HAVE_SYNC_FILE_RANGE
-#warning Using locally defined sync_file_range interface.
-
-#ifndef __NR_sync_file_range
-#ifndef __NR_sync_file_range2 /* ppc */
-#error Your kernel headers dont define __NR_sync_file_range
-#endif
-#endif
-
-/*
- * sync_file_range() -	Sync file region.
- *
- * @fd:			defrag target file's descriptor.
- * @offset:		file offset.
- * @length:		area length.
- * @flag:		process flag.
- */
-int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
-{
-#ifdef __NR_sync_file_range
-	return syscall(__NR_sync_file_range, fd, offset, length, flag);
-#else
-	return syscall(__NR_sync_file_range2, fd, flag, offset, length);
-#endif
-}
+#error sync_file_range not available!
 #endif /* ! HAVE_SYNC_FILE_RANGE */
 
 #ifndef HAVE_FALLOCATE64
-#warning Using locally defined fallocate syscall interface.
-
-#ifndef __NR_fallocate
-#error Your kernel headers dont define __NR_fallocate
-#endif
