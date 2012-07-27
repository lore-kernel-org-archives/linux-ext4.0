From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 05/15] ocfs2: implement invalidatepage_range aop
Date: Fri, 27 Jul 2012 10:01:04 +0200
Message-ID: <1343376074-28034-6-git-send-email-lczerner@redhat.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
	linux-mmc@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
	ocfs2-devel@oss.oracle.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

mm now supports invalidatepage_range address space operation which is
useful to allow truncating page range which is not aligned to the end of
the page. This will help in punch hole implementation once
truncate_inode_pages_range() is modify to allow this as well.

With this commit ocfs2 now register only invalidatepage_range.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: ocfs2-devel@oss.oracle.com
---
 fs/ocfs2/aops.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6577432..46c1757 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -603,11 +603,12 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
  * from ext3.  PageChecked() bits have been removed as OCFS2 does not
  * do journalled data.
  */
-static void ocfs2_invalidatepage(struct page *page, unsigned long offset)
+static void ocfs2_invalidatepage_range(struct page *page, unsigned long offset,
+				       unsigned long length)
 {
 	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
 
-	jbd2_journal_invalidatepage(journal, page, offset);
+	jbd2_journal_invalidatepage_range(journal, page, offset, length);
 }
 
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
@@ -2091,7 +2092,7 @@ const struct address_space_operations ocfs2_aops = {
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
 	.direct_IO		= ocfs2_direct_IO,
-	.invalidatepage		= ocfs2_invalidatepage,
+	.invalidatepage_range	= ocfs2_invalidatepage_range,
 	.releasepage		= ocfs2_releasepage,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate	= block_is_partially_uptodate,
-- 
1.7.7.6

