From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 7/8] lib/ext2fs/qcow2.h: Fix #defined 1<<63 values to be
 unsigned.
Date: Fri, 14 Dec 2012 00:04:31 +0200
Message-ID: <20121213220431.GO9713@sli.dy.fi>
References: <cover.1355435985.git.sami.liedes@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:57571 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab2LMWiz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Dec 2012 17:38:55 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4fTn019960
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:41 +0200
Received: from smtp-3.hut.fi ([130.233.228.93])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 30627-1411 for <linux-ext4@vger.kernel.org>;
 Fri, 14 Dec 2012 00:04:41 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id qBDM4W8e019948
	for <linux-ext4@vger.kernel.org>; Fri, 14 Dec 2012 00:04:32 +0200
Content-Disposition: inline
In-Reply-To: <cover.1355435985.git.sami.liedes@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

QCOW_OFLAG_COPIED in qcow2.h and e2image.c was defined as a signed
value, which however does not fit in a signed 64-bit integer.

Caught by clang -fsanitize=undefined.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
---
 lib/ext2fs/qcow2.h |    4 ++--
 misc/e2image.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/qcow2.h b/lib/ext2fs/qcow2.h
index 81e0ec9..b997653 100644
--- a/lib/ext2fs/qcow2.h
+++ b/lib/ext2fs/qcow2.h
@@ -30,8 +30,8 @@
 
 #define QCOW_MAGIC (('Q' << 24) | ('F' << 16) | ('I' << 8) | 0xfb)
 #define QCOW_VERSION		2
-#define QCOW_OFLAG_COPIED	(1LL << 63)
-#define QCOW_OFLAG_COMPRESSED	(1LL << 62)
+#define QCOW_OFLAG_COPIED	(1LLU << 63)
+#define QCOW_OFLAG_COMPRESSED	(1LLU << 62)
 
 #define QCOW_COMPRESSED		1
 #define QCOW_ENCRYPTED		2
diff --git a/misc/e2image.c b/misc/e2image.c
index e6ea52a..36769c1 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -47,7 +47,7 @@ extern int optind;
 #include "../version.h"
 #include "nls-enable.h"
 
-#define QCOW_OFLAG_COPIED     (1LL << 63)
+#define QCOW_OFLAG_COPIED     (1LLU << 63)
 
 
 const char * program_name = "e2image";
-- 
1.7.10.4
