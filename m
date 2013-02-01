From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 06/18] ocfs2: use ->invalidatepage() length argument
Date: Fri,  1 Feb 2013 11:43:32 +0100
Message-ID: <1359715424-32318-7-git-send-email-lczerner@redhat.com>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
        Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in ocfs2_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ocfs2/aops.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1393114..d8c0076 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -608,8 +608,7 @@ static void ocfs2_invalidatepage(struct page *page, unsigned int offset,
 {
 	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
 
-	jbd2_journal_invalidatepage(journal, page, offset,
-				    PAGE_CACHE_SIZE - offset);
+	jbd2_journal_invalidatepage(journal, page, offset, length);
 }
 
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
-- 
1.7.7.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
