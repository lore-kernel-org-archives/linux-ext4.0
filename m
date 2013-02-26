From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests: use native definition of O_DIRECT flag
Date: Tue, 26 Feb 2013 16:03:22 -0500
Message-ID: <20130226210322.GB5275@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45763 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759860Ab3BZVD1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Feb 2013 16:03:27 -0500
Received: by mail-qa0-f53.google.com with SMTP id z4so2800420qan.5
        for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2013 13:03:26 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The definition of O_DIRECT in src/trunc.c causes xfstest 125 to fail
when run on a Pandaboard.  On ARM, the value used (0x040000) is
O_DIRECTORY rather than O_DIRECT as it is on x86.  Prefer the platform's
native definition of O_DIRECT supplied by fcntl.h if available.  Also,
fix a couple of error messages to properly reflect their context.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 src/trunc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/trunc.c b/src/trunc.c
index 7539532..38fb21f 100644
--- a/src/trunc.c
+++ b/src/trunc.c
@@ -26,7 +26,9 @@
 #include <stdlib.h>
 #include <string.h>
 
+#ifndef O_DIRECT
 #define O_DIRECT	040000
+#endif
 
 #define WAITTIME	60
 #define BUFSIZE		4096
@@ -82,7 +84,7 @@ while((c=getopt(argc,argv,"f:"))!=EOF) {
 
 	printf("direct write of 1's into file\n");	
 	err = write(fd, buf, BUFSIZE);
-	if (err < 0) perror("buffered write failed");
+	if (err < 0) perror("direct write failed");
 
 	close(fd);
 	
@@ -96,7 +98,7 @@ while((c=getopt(argc,argv,"f:"))!=EOF) {
 
 	printf("buffered write of 2's into file\n");	
 	err = write(fd, buf, BUFSIZE);
-	if (err < 0) perror("direct write failed");
+	if (err < 0) perror("buffered write failed");
 
 	/* 1 now on disk, but 2 data is buffered */
 
-- 
1.7.10.4

