From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] use unsigned values for memory tracking stats
Date: Thu, 28 May 2009 00:47:37 -0600
Message-ID: <20090528064737.GF3218@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36135 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZE1Grx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 May 2009 02:47:53 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n4S6lnEs026429
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2009 23:47:51 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KKC00C00D7YJV00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 27 May 2009 23:47:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use unsigned values for printing memory tracking to avoid overflows.
The mallinfo() data is currently signed ints, but it might change in
the future so we may as well compute/print unsigned longs.

Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-cfs/e2fsck/util.c
===================================================================
--- e2fsprogs-cfs.orig/e2fsck/util.c
+++ e2fsprogs-cfs/e2fsck/util.c
@@ -330,15 +330,15 @@ void print_resource_track(const char *de
 		printf("%s: ", desc);
 
 #ifdef HAVE_MALLINFO
-#define kbytes(x)	(((x) + 1023) / 1024)
+#define kbytes(x)	(((unsigned long)(x) + 1023) / 1024)
 
 	malloc_info = mallinfo();
-	printf(_("Memory used: %dk/%dk (%dk/%dk), "),
+	printf(_("Memory used: %luk+%luk (%luk+%luk), "),
 	       kbytes(malloc_info.arena), kbytes(malloc_info.hblkhd),
 	       kbytes(malloc_info.uordblks), kbytes(malloc_info.fordblks));
 #else
-	printf(_("Memory used: %d, "),
-	       (int) (((char *) sbrk(0)) - ((char *) track->brk_start)));
+	printf(_("Memory used: %lu, "),
+	       (long) (((char *) sbrk(0)) - ((char *) track->brk_start)));
 #endif
 #ifdef HAVE_GETRUSAGE
 	getrusage(RUSAGE_SELF, &r);

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

