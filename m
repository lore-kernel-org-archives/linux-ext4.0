From: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
Subject: [PATCH 2/2] jbd: fix a bug of leaking jh->b_jcount
Date: Thu, 26 May 2011 10:29:01 +0800
Message-ID: <1306376941-13349-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Cc: dingdinghua@nrchpc.ac.cn
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [221.122.61.228] ([221.122.61.228]:42326 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754137Ab1EZC3I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 22:29:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

journal_get_create_access should drop jh->b_jcount in error handling path

Signed-off-by: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
---
 fs/jbd/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index f7ee81a..3b3b01f 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -844,8 +844,8 @@ int journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 	 */
 	JBUFFER_TRACE(jh, "cancelling revoke");
 	journal_cancel_revoke(handle, jh);
-	journal_put_journal_head(jh);
 out:
+	journal_put_journal_head(jh);
 	return err;
 }
 
-- 
1.7.4.1

