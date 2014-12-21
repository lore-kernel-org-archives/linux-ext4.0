From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] Update maximum journal size in tune2fs man page
Date: Sun, 21 Dec 2014 15:02:38 -0500
Message-ID: <1419192158-9531-1-git-send-email-psusi@ubuntu.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:55251 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752054AbaLUUCl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Dec 2014 15:02:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The man page for tune2fs still listed the upper limit for
the journal as 102,400 blocks.
---
 misc/tune2fs.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index c50d475..2431880 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -333,7 +333,7 @@ Create a journal stored in the filesystem of size
 .I journal-size
 megabytes.   The size of the journal must be at least 1024 filesystem blocks
 (i.e., 1MB if using 1k blocks, 4MB if using 4k blocks, etc.)
-and may be no more than 102,400 filesystem blocks.
+and may be no more than 10,240,000 filesystem blocks.
 There must be enough free space in the filesystem to create a journal of
 that size.
 .TP
-- 
2.1.0

