From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] jbd: Fix comment to match the code in journal_start()
Date: Tue, 24 May 2011 00:17:34 +0800
Message-ID: <1306167454-28638-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62615 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1EWQPu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 12:15:50 -0400
Received: by pwi15 with SMTP id 15so2664039pwi.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 09:15:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

journal_start returns an ERR_PTR() value rather than NULL on failure.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/jbd/transaction.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 60d2319..f7ee81a 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -266,7 +266,8 @@ static handle_t *new_handle(int nblocks)
  * This function is visible to journal users (like ext3fs), so is not
  * called with the journal already locked.
  *
- * Return a pointer to a newly allocated handle, or NULL on failure
+ * Return a pointer to a newly allocated handle, or an ERR_PTR() value
+ * on failure.
  */
 handle_t *journal_start(journal_t *journal, int nblocks)
 {
-- 
1.7.3.4

