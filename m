From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 2/3] jbd2: replace potentially false assertion with if block
Date: Fri,  7 Mar 2008 01:31:23 +0000
Message-ID: <1204853484-25968-2-git-send-email-duaneg@dghda.com>
References: <1204853484-25968-1-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1988 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757384AbYCGBba (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 20:31:30 -0500
In-Reply-To: <1204853484-25968-1-git-send-email-duaneg@dghda.com>
Message-Id: <48afbb3a44aa24dc1e31835c14e86c3c6c1c3b0a.1204844851.git.duaneg@dghda.com>
In-Reply-To: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
References: <5e28cd633c71f6354a203a43000cbe5fef045589.1204844851.git.duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an error occurs during jbd2 cache initialisation it is possible for the
journal_head_cache to be NULL when jbd2_journal_destroy_journal_head_cache is
called. Replace the J_ASSERT with an if block to handle the situation
correctly.

Note that even with this fix things will break badly if jbd2 is statically
compiled in and cache initialisation fails.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
 fs/jbd2/journal.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 96ba846..0d8a595 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1985,9 +1985,10 @@ static int journal_init_jbd2_journal_head_cache(void)
 
 static void jbd2_journal_destroy_jbd2_journal_head_cache(void)
 {
-	J_ASSERT(jbd2_journal_head_cache != NULL);
-	kmem_cache_destroy(jbd2_journal_head_cache);
-	jbd2_journal_head_cache = NULL;
+	if (jbd2_journal_head_cache) {
+		kmem_cache_destroy(jbd2_journal_head_cache);
+		jbd2_journal_head_cache = NULL;
+	}
 }
 
 /*
-- 
1.5.3.7

