From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 06/12 v2] mm: teach truncate_inode_pages_range() to hadnle non page aligned ranges
Date: Fri, 13 Jul 2012 15:19:09 +0200
Message-ID: <1342185555-21146-6-git-send-email-lczerner@redhat.com>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	achender@linux.vnet.ibm.com, Lukas Czerner <lczerner@redhat.com>,
	Hugh Dickins <hughd@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1342185555-21146-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This commit changes truncate_inode_pages_range() so it can handle non
page aligned regions of the truncate. Currently we can hit BUG_ON when
the end of the range is not page aligned, but he can handle unaligned
start of the range.

Being able to handle non page aligned regions of the page can help file
system punch_hole implementations and save some work, because once we're
holding the page we might as well deal with it right away.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/truncate.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 77a693e..92aa4ad 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -49,6 +49,16 @@ void do_invalidatepage(struct page *page, unsigned long offset)
 		(*invalidatepage)(page, offset);
 }
 
+static inline void punch_hole_into_page(struct page *page, unsigned start,
+					unsigned end)
+{
+	BUG_ON(end > PAGE_CACHE_SIZE);
+	zero_user_segment(page, start, end);
+	cleancache_invalidate_page(page->mapping, page);
+	if (page_has_private(page))
+		do_invalidatepage(page, start);
+}
+
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
 	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
@@ -206,24 +216,30 @@ int invalidate_inode_page(struct page *page)
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, loff_t lend)
 {
-	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
-	const unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
+	const unsigned partial_start = lstart & (PAGE_CACHE_SIZE - 1);
+	const unsigned partial_end = lend & (PAGE_CACHE_SIZE - 1);
+	loff_t start = lstart >> PAGE_CACHE_SHIFT;
+	loff_t end = lend >> PAGE_CACHE_SHIFT;
 	struct pagevec pvec;
-	pgoff_t index;
-	pgoff_t end;
+	loff_t index;
 	int i;
 
+	BUG_ON(lend < start || lend < 0);
+
 	cleancache_invalidate_inode(mapping);
 	if (mapping->nrpages == 0)
 		return;
 
-	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
-	end = (lend >> PAGE_CACHE_SHIFT);
+	/* Adjust start and end so we cover only full pages */
+	if (partial_start)
+		start++;
+	if (partial_end < PAGE_CACHE_SIZE - 1)
+		end--;
 
 	pagevec_init(&pvec, 0);
 	index = start;
 	while (index <= end && pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+			min(end - index, (loff_t)PAGEVEC_SIZE - 1) + 1)) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
@@ -249,21 +265,44 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		index++;
 	}
 
-	if (partial) {
+	/* truncate happened within the page - punch hole */
+	if ((start > end) && (start - end > 1)) {
 		struct page *page = find_lock_page(mapping, start - 1);
 		if (page) {
 			wait_on_page_writeback(page);
-			truncate_partial_page(page, partial);
+			punch_hole_into_page(page, partial_start,
+					     partial_end + 1);
 			unlock_page(page);
 			page_cache_release(page);
 		}
+	} else {
+		/* Partial page truncate at the start of the region */
+		if (partial_start) {
+			struct page *page = find_lock_page(mapping, start - 1);
+			if (page) {
+				wait_on_page_writeback(page);
+				truncate_partial_page(page, partial_start);
+				unlock_page(page);
+				page_cache_release(page);
+			}
+		}
+		/* Partial page truncate at the end of the region */
+		if (partial_end < PAGE_CACHE_SIZE - 1) {
+			struct page *page = find_lock_page(mapping, end + 1);
+			if (page) {
+				wait_on_page_writeback(page);
+				punch_hole_into_page(page, 0, partial_end + 1);
+				unlock_page(page);
+				page_cache_release(page);
+			}
+		}
 	}
 
 	index = start;
-	for ( ; ; ) {
+	while (index <= end) {
 		cond_resched();
 		if (!pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+			min(end - index, (loff_t)PAGEVEC_SIZE - 1) + 1)) {
 			if (index == start)
 				break;
 			index = start;
-- 
1.7.7.6

