From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] Update maximum journal size in tune2fs man page
Date: Sat, 23 May 2015 16:49:45 -0400
Message-ID: <1432414185-5997-1-git-send-email-psusi@ubuntu.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:33976 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbbEWUtw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 May 2015 16:49:52 -0400
Received: by yhom41 with SMTP id m41so13282034yho.1
        for <linux-ext4@vger.kernel.org>; Sat, 23 May 2015 13:49:51 -0700 (PDT)
Received: from localhost.localdomain (72-238-77-169.res.bhn.net. [72.238.77.169])
        by mx.google.com with ESMTPSA id v6sm4901501yhc.34.2015.05.23.13.49.49
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 23 May 2015 13:49:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The man page for tune2fs still listed the upper limit for
the journal as 102,400 blocks.
---
 misc/tune2fs.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 4373fc4..fcdf668 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -337,7 +337,7 @@ Create a journal stored in the filesystem of size
 .I journal-size
 megabytes.   The size of the journal must be at least 1024 filesystem blocks
 (i.e., 1MB if using 1k blocks, 4MB if using 4k blocks, etc.)
-and may be no more than 102,400 filesystem blocks.
+and may be no more than 10,240,000 filesystem blocks.
 There must be enough free space in the filesystem to create a journal of
 that size.
 .TP
-- 
2.1.4

