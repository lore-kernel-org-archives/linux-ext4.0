From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] xfstests: fix msync() call in fsx.c:domapwrite()
Date: Tue,  7 Feb 2012 11:16:06 -0800
Message-ID: <1328642166-389-1-git-send-email-curtw@google.com>
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54969 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2BGTQJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Feb 2012 14:16:09 -0500
Received: by yenm1 with SMTP id m1so135245yen.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Feb 2012 11:16:08 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This explicitly sends MS_SYNC as the flag to msync() in
fsx.c, in domapwrite().  Without this flag, the memory
written to the mmap'ed region will not be flushed to disk;
in fact, on Linux, calling msync() with a '0' or MS_ASYNC
flag is a no-op.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 ltp/fsx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index b36c201..2f1e3e8 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -779,7 +779,7 @@ domapwrite(unsigned offset, unsigned size)
 		report_failure(202);
 	}
 	memcpy(p + pg_offset, good_buf + offset, size);
-	if (msync(p, map_size, 0) != 0) {
+	if (msync(p, map_size, MS_SYNC) != 0) {
 		prterr("domapwrite: msync");
 		report_failure(203);
 	}
-- 
1.7.7.3

