From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Fix debug message in do_get_write_access()
Date: Wed, 13 Oct 2010 23:14:07 +0900
Message-ID: <1286979247-7721-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Jiri Kosina <trivial@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59163 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0JMOOQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Oct 2010 10:14:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'buffer_head' should be 'journal_head'.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index c9bb7a7..846a3f3 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -526,7 +526,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 	transaction = handle->h_transaction;
 	journal = transaction->t_journal;
 
-	jbd_debug(5, "buffer_head %p, force_copy %d\n", jh, force_copy);
+	jbd_debug(5, "journal_head %p, force_copy %d\n", jh, force_copy);
 
 	JBUFFER_TRACE(jh, "entry");
 repeat:
-- 
1.7.0.4

