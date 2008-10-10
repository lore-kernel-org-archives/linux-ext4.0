From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: check for read-only devices before starting fsck
Date: Fri, 10 Oct 2008 17:17:43 -0500
Message-ID: <48EFD487.5070105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59442 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbYJJWRq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 18:17:46 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9AMHkWk003738
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:17:46 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9AMHjT2023161
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:17:45 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id m9AMHifl022164
	for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2008 18:17:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we open a device on linux, test whether it is writable
right away, rather than trying to proceed and clean up when
writes start failing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/unix_io.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/unix_io.c
+++ e2fsprogs/lib/ext2fs/unix_io.c
@@ -30,6 +30,7 @@
 #include <time.h>
 #ifdef __linux__
 #include <sys/utsname.h>
+#include <linux/fs.h>
 #endif
 #if HAVE_SYS_STAT_H
 #include <sys/stat.h>
@@ -454,6 +455,21 @@ static errcode_t unix_open(const char *n
 	}
 
 #ifdef __linux__
+	if (flags & IO_FLAG_RW) {
+		int error;
+		int readonly = 0;
+
+		/* Is the block device actually writable? */
+		error = ioctl(data->dev, BLKROGET, &readonly);
+		if (!error && readonly) {
+			close(data->dev);
+			retval = EPERM;
+			goto cleanup;
+		}
+	}
+#endif
+
+#ifdef __linux__
 #undef RLIM_INFINITY
 #if (defined(__alpha__) || ((defined(__sparc__) || defined(__mips__)) && (SIZEOF_LONG == 4)))
 #define RLIM_INFINITY	((unsigned long)(~0UL>>1))

