From: y@mx.nrchpc.ac.cn
Subject: [PATCH 1/2] Jbd2: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 18:19:46 +0800
Message-ID: <5848.07172786004$1306319237@news.gmane.org>
References: <y>
Cc: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [221.122.61.228] ([221.122.61.228]:55680 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750783Ab1EYK1J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 06:27:09 -0400
In-Reply-To: <y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ding Dinghua <dingdinghua@nrchpc.ac.cn>

drop jh->b_jcount in error path
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

