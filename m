From: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
Subject: [PATCH 2/2] Jbd: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 18:20:41 +0800
Message-ID: <1306318841-8363-1-git-send-email-dingdinghua@nrchpc.ac.cn>
Cc: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [221.122.61.228] ([221.122.61.228]:39032 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751884Ab1EYL04 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 07:26:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

drop jh->b_jcount in error path
---
 fs/jbd/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 60d2319..3f7bf84 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -843,8 +843,8 @@ int journal_get_create_access(handle_t *handle, struct buffer_head *bh)
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

