From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 06/18] ocfs2: use ->invalidatepage() length argument
Date: Tue,  5 Feb 2013 10:11:59 +0100
Message-ID: <1360055531-26309-7-git-send-email-lczerner@redhat.com>
References: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Joel Becker <jlbec@evilplan.org>
To: linux-mm@kvack.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in ocfs2_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Joel Becker <jlbec@evilplan.org>
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
