From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] quota: fix coredump if projid file dose not exist
Date: Tue,  5 Jul 2016 16:00:40 +0900
Message-ID: <1467702040-14764-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org, sihara@ddn.com, lixi@ddn.com,
	Wang Shilong <wshilong@ddn.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34779 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbcGEH7k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jul 2016 03:59:40 -0400
Received: by mail-pa0-f66.google.com with SMTP id us13so17754736pab.1
        for <linux-ext4@vger.kernel.org>; Tue, 05 Jul 2016 00:59:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

if '/etc/projid' dose not exist,@project_file will
be NULL pointer, fclose will cause coredump, add
check in endprent().

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 quotasys.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/quotasys.c b/quotasys.c
index c78e02c..d04f25a 100644
--- a/quotasys.c
+++ b/quotasys.c
@@ -98,8 +98,10 @@ void setprent(void)
 /* Close /etc/projid file */
 void endprent(void)
 {
-	fclose(project_file);
-	project_file = NULL;
+	if (project_file) {
+		fclose(project_file);
+		project_file = NULL;
+	}
 }
 
 /* Get next entry in /etc/projid */
-- 
2.7.4

