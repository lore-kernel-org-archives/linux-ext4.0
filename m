From: Artemiy Volkov <artemiyv@acm.org>
Subject: [PATCH] misc/e2freefrag: Fix argument parsing in do_freefrag()
Date: Sun,  3 Aug 2014 03:13:31 +1000
Message-ID: <1406999611-11532-1-git-send-email-artemiyv@acm.org>
Cc: Artemiy Volkov <artemiyv@acm.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57215 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaHBRNl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2014 13:13:41 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so7529005pad.8
        for <linux-ext4@vger.kernel.org>; Sat, 02 Aug 2014 10:13:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When do_freefrag() is called from debugfs, the value of optind is
not reset. Rectify that by calling reset_getopt().

Signed-off-by: Artemiy Volkov <artemiyv@acm.org>
---
 misc/e2freefrag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index bb72c70..90acb7e 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -277,6 +277,7 @@ int main(int argc, char *argv[])
 #ifdef DEBUGFS
 	if (check_fs_open(argv[0]))
 		return;
+	reset_getopt();
 #else
 	char *device_name;
 
-- 
1.9.1

