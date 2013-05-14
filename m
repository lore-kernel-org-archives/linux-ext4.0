From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v4 06/20] ocfs2: use ->invalidatepage() length argument
Date: Tue, 14 May 2013 18:37:20 +0200
Message-ID: <1368549454-8930-7-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com
To: linux-mm@kvack.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in ocfs2_invalidatepage().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <jlbec@evilplan.org>
---
 fs/ocfs2/aops.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7c47755..79736a2 100644
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
