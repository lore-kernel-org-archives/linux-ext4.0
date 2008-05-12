From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 3/3][v2] jbd: replace potentially false assertion with if block
Date: Mon, 12 May 2008 17:57:41 +0100
Message-ID: <1210611461-8526-4-git-send-email-duaneg@dghda.com>
References: <1210611461-8526-1-git-send-email-duaneg@dghda.com>
 <1210611461-8526-2-git-send-email-duaneg@dghda.com>
 <1210611461-8526-3-git-send-email-duaneg@dghda.com>
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com, sct@redhat.com,
	linux-ext4@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1955 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbYELQ5u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 12:57:50 -0400
In-Reply-To: <1210611461-8526-3-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an error occurs during jbd cache initialisation it is possible for the
journal_head_cache to be NULL when journal_destroy_journal_head_cache is
called. Replace the J_ASSERT with an if block to handle the situation
correctly.

Note that even with this fix things will break badly if jbd is statically
compiled in and cache initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com
---
 fs/jbd/journal.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 1ecd005..f6a7c93 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1641,9 +1641,10 @@ static int journal_init_journal_head_cache(void)
 
 static void journal_destroy_journal_head_cache(void)
 {
-	J_ASSERT(journal_head_cache != NULL);
-	kmem_cache_destroy(journal_head_cache);
-	journal_head_cache = NULL;
+	if (journal_head_cache) {
+		kmem_cache_destroy(journal_head_cache);
+		journal_head_cache = NULL;
+	}
 }
 
 /*
-- 
1.5.3.7

