From: Jan Kara <jack@suse.cz>
Subject: [PATCH 12/12] ext4: Fix ext4_writepage() to achieve data=ordered guarantees
Date: Fri, 18 Jan 2013 13:00:46 +0100
Message-ID: <1358510446-19174-13-git-send-email-jack@suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3ARMA7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:00:59 -0500
In-Reply-To: <1358510446-19174-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So far ext4_writepage() skipped writing pages that had any delayed or
unwritten buffers attached. When blocksize < pagesize this breaks
data=ordered mode guarantees as we can have a page with one freshly
allocated buffer whose allocation is part of the committing transaction
and another buffer in the page which is delayed or unwritten. So fix this
problem by calling ext4_bio_writepage() anyway. It will submit mapped
buffers and leave others alone.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3b6bb61..c4d45d5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1967,6 +1967,7 @@ static int ext4_writepage(struct page *page,
 	struct buffer_head *page_bufs = NULL;
 	struct inode *inode = page->mapping->host;
 	struct ext4_io_submit io_submit;
+	int redirty = 0;
 
 	trace_ext4_writepage(page);
 	size = i_size_read(inode);
@@ -1976,21 +1977,28 @@ static int ext4_writepage(struct page *page,
 		len = PAGE_CACHE_SIZE;
 
 	page_bufs = page_buffers(page);
-	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-				   ext4_bh_delay_or_unwritten)) {
-		/*
-		 * We don't want to do block allocation, so redirty
-		 * the page and return.  We may reach here when we do
-		 * a journal commit via journal_submit_inode_data_buffers.
-		 * We can also reach here via shrink_page_list but it
-		 * should never be for direct reclaim so warn if that
-		 * happens
-		 */
-		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
-								PF_MEMALLOC);
+	redirty = ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+				   ext4_bh_delay_or_unwritten);
+	/*
+	 * We cannot do block allocation or other extent handling in this
+	 * function. If there are buffers needing that, we have to redirty
+	 * the page. But we may reach here when we do a journal commit via
+	 * journal_submit_inode_data_buffers() and in that case we must write
+	 * allocated buffers to achieve data=ordered mode guarantees.
+	 */
+	if (redirty) {
 		redirty_page_for_writepage(wbc, page);
-		unlock_page(page);
-		return 0;
+		if (current->flags & PF_MEMALLOC) {
+			/*
+			 * For memory cleaning there's no point in writing only
+			 * some buffers. So just bail out. Warn if we came here
+			 * from direct reclaim.
+			 */
+			WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD))
+							== PF_MEMALLOC);
+			unlock_page(page);
+			return 0;
+		}
 	}
 
 	if (PageChecked(page) && ext4_should_journal_data(inode))
-- 
1.7.1

