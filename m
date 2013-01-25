From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] contrib: print missing '-p' argument in fallocate.c
Date: Fri, 25 Jan 2013 11:44:19 +0800
Message-ID: <1359085459-15711-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:62855 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3AYDaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 22:30:22 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so4565101dak.20
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jan 2013 19:30:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In fallocate.c it has supported hole punching, but '-p' argument does
not be printed in usage.  So fix it to let the user know it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 contrib/fallocate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/fallocate.c b/contrib/fallocate.c
index 1436b70..1f9b59a 100644
--- a/contrib/fallocate.c
+++ b/contrib/fallocate.c
@@ -39,7 +39,7 @@
 
 void usage(void)
 {
-	printf("Usage: fallocate [-nt] [-o offset] -l length filename\n");
+	printf("Usage: fallocate [-npt] [-o offset] -l length filename\n");
 	exit(EXIT_FAILURE);
 }
 
-- 
1.7.12.rc2.18.g61b472e

