From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] jbd2: Fix comment to match the code in jbd2__journal_start()
Date: Tue, 24 May 2011 00:17:58 +0800
Message-ID: <1306167478-28682-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40147 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1EWQQO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 12:16:14 -0400
Received: by pvg12 with SMTP id 12so2619877pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 09:16:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd2__journal_start() returns an ERR_PTR() value rather than NULL on
failure.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/jbd2/transaction.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..7e6a5d6 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -316,7 +316,8 @@ static handle_t *new_handle(int nblocks)
  * This function is visible to journal users (like ext3fs), so is not
  * called with the journal already locked.
  *
- * Return a pointer to a newly allocated handle, or NULL on failure
+ * Return a pointer to a newly allocated handle, or an ERR_PTR() value
+ * on failure.
  */
 handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
 {
-- 
1.7.3.4

