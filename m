From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] jbd: Move debug message into #ifdef area
Date: Mon,  4 Oct 2010 17:26:53 +0900
Message-ID: <1286180813-4653-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58630 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0JDI05 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Oct 2010 04:26:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move call to jbd_debug() into #ifdef CONFIG_JBD_DEBUG block because
'dropped' is declared there. The code could be compiled without this
change anyway, simply because jbd_debug() expands to nothing if
!CONFIG_JBD_DEBUG but IMHO it doesn't look good in general.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/recovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 81051da..5b43e96 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -296,10 +296,10 @@ int journal_skip_recovery(journal_t *journal)
 #ifdef CONFIG_JBD_DEBUG
 		int dropped = info.end_transaction -
 			      be32_to_cpu(journal->j_superblock->s_sequence);
-#endif
 		jbd_debug(1,
 			  "JBD: ignoring %d transaction%s from the journal.\n",
 			  dropped, (dropped == 1) ? "" : "s");
+#endif
 		journal->j_transaction_sequence = ++info.end_transaction;
 	}
 
-- 
1.7.0.4

