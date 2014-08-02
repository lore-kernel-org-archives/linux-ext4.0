From: Artemiy Volkov <artemiyv@acm.org>
Subject: [PATCH] .gitignore: Add misc/e2fuzz file
Date: Sun,  3 Aug 2014 03:19:06 +1000
Message-ID: <1406999946-11584-1-git-send-email-artemiyv@acm.org>
Cc: Artemiy Volkov <artemiyv@acm.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62895 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaHBRTW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2014 13:19:22 -0400
Received: by mail-pa0-f46.google.com with SMTP id lj1so7559876pab.33
        for <linux-ext4@vger.kernel.org>; Sat, 02 Aug 2014 10:19:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds the misc/e2fuzz tool executable file to .gitignore.

Signed-off-by: Artemiy Volkov <artemiyv@acm.org>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index ac0fd2b..baf9b1a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -154,6 +154,7 @@ misc/dumpe2fs
 misc/dumpe2fs.8
 misc/e2freefrag
 misc/e2freefrag.8
+misc/e2fuzz
 misc/e2image
 misc/e2image.8
 misc/e2initrd_helper
-- 
1.9.1

