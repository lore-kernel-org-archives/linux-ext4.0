From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Subject: [PATCH] ext4: fix error handling in ext4_fill_super()
Date: Mon,  8 Oct 2012 15:09:42 +0400
Message-ID: <1349694582-16958-1-git-send-email-eugene.shatokhin@rosalab.ru>
Cc: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from collab.rosalab.ru ([217.199.216.181]:54638 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2JHLRi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 07:17:38 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by collab.rosalab.ru (Postfix) with ESMTP id 5CFB629C2AB
	for <linux-ext4@vger.kernel.org>; Mon,  8 Oct 2012 15:11:13 +0400 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext4_mb_init() returns error (e.g. if there is not enough memory),
ext4_fill_super() returns 0 rather than the error code.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=48431

The patch fixes that problem.

Signed-off-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 982f6fc..7292532 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3982,6 +3982,7 @@ no_journal:
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
 			 err);
+		ret = err;
 		goto failed_mount5;
 	}
 
-- 
1.7.10.4

