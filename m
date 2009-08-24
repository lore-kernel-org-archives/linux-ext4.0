From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e4defrag: fix ppc build
Date: Sun, 23 Aug 2009 22:09:58 -0700
Message-ID: <4A9220A6.7020000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kyle McMartin <kyle@mcmartin.ca>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:12679 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbZHXFJ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 01:09:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Kyle McMartin <kyle@mcmartin.ca>

ppc glibc seems to be missing sync_file_range, so we fell back
to the local define, and there ppc differs as well, so the
build was failing.

Thanks to Kyle for the patch w/ the tidy solution.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 4c83fa3..23f01b8 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -305,8 +305,10 @@ static int posix_fadvise(int fd, loff_t offset, size_t len, int advise)
 #warning Using locally defined sync_file_range interface.
 
 #ifndef __NR_sync_file_range
+#ifndef __NR_sync_file_range2 /* ppc */
 #error Your kernel headers dont define __NR_sync_file_range
 #endif
+#endif
 
 /*
  * sync_file_range() -	Sync file region.
@@ -318,7 +320,11 @@ static int posix_fadvise(int fd, loff_t offset, size_t len, int advise)
  */
 int sync_file_range(int fd, loff_t offset, loff_t length, unsigned int flag)
 {
+#ifdef __NR_sync_file_range
 	return syscall(__NR_sync_file_range, fd, offset, length, flag);
+#else
+	return syscall(__NR_sync_file_range2, fd, flag, offset, length);
+#endif
 }
 #endif /* ! HAVE_SYNC_FILE_RANGE */
 

