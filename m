From: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
Subject: [PATCH 1/2] jbd2: fix a bug of leaking jh->b_jcount
Date: Thu, 26 May 2011 10:28:22 +0800
Message-ID: <1306376902-13308-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Cc: dingdinghua@nrchpc.ac.cn
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [221.122.61.228] ([221.122.61.228]:42233 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755115Ab1EZC2c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 22:28:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd2_journal_get_create_access should drop jh->b_jcount in error
handling path

Signed-off-by: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
---
 fs/jbd2/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..d66672a 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -921,8 +921,8 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 	 */
 	JBUFFER_TRACE(jh, "cancelling revoke");
 	jbd2_journal_cancel_revoke(handle, jh);
-	jbd2_journal_put_journal_head(jh);
 out:
+	jbd2_journal_put_journal_head(jh);
 	return err;
 }
 
-- 
1.7.4.1

