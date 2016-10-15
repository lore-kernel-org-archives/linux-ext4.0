From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] partinfo: fix some build errors
Date: Sat, 15 Oct 2016 10:57:55 -0700
Message-ID: <20161015175755.GA5611@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46519 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbcJOR6B (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Oct 2016 13:58:01 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix some missing header files and library link targets.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/Makefile.in |    4 ++--
 misc/partinfo.c  |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index d6436c2..370fdac 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -157,9 +157,9 @@ findsuper: findsuper.o
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o findsuper findsuper.o $(LIBS) $(SYSLIBS)
 
-partinfo: partinfo.o
+partinfo: partinfo.o $(DEPLIBCOM_ERR)
 	$(E) "	LD $@"
-	$(Q) $(CC) $(ALL_LDFLAGS) -o partinfo partinfo.o
+	$(Q) $(CC) $(ALL_LDFLAGS) -o partinfo partinfo.o $(LIBCOM_ERR)
 
 e2initrd_helper: e2initrd_helper.o $(DEPLIBS) $(DEPLIBBLKID) $(LIBEXT2FS)
 	$(E) "	LD $@"
diff --git a/misc/partinfo.c b/misc/partinfo.c
index 2b69c89..b79d183 100644
--- a/misc/partinfo.c
+++ b/misc/partinfo.c
@@ -18,7 +18,9 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <errno.h>
+#include <string.h>
 #include "support/nls-enable.h"
+#include "et/com_err.h"
 
 #if defined(__linux__) && defined(_IO) && !defined(BLKGETSIZE)
 #define BLKGETSIZE _IO(0x12,96)	/* return device size */
