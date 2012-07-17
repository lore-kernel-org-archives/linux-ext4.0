From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 06/12 v2] mm: teach truncate_inode_pages_range() to hadnle
 non page aligned ranges
Date: Tue, 17 Jul 2012 01:28:08 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207170114490.1577@eggly.anvils>
References: <1342185555-21146-1-git-send-email-lczerner@redhat.com> <1342185555-21146-6-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, achender@linux.vnet.ibm.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1342185555-21146-6-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 13 Jul 2012, Lukas Czerner wrote:
> This commit changes truncate_inode_pages_range() so it can handle non
> page aligned regions of the truncate. Currently we can hit BUG_ON when
> the end of the range is not page aligned, but he can handle unaligned
> start of the range.
> 
> Being able to handle non page aligned regions of the page can help file
> system punch_hole implementations and save some work, because once we're
> holding the page we might as well deal with it right away.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Hugh Dickins <hughd@google.com>

As I said under 02/12, I'd much rather not change from the existing -1
convention: I don't think it's wonderful, but I do think it's confusing
and a waste of effort to change from it; and I'd rather keep the code
in truncate.c close to what's doing the same job in shmem.c.

Here's what I came up with (and hacked tmpfs to use it without swap
temporarily, so I could run fsx for an hour to validate it).  But you
can see I've a couple of questions; and probably ought to reduce the
partial page code duplication once we're sure what should go in there.

Hugh

[PATCH]...

Apply to truncate_inode_pages_range() the changes 83e4fa9c16e4 ("tmpfs:
support fallocate FALLOC_FL_PUNCH_HOLE") made to shmem_truncate_range():
so the generic function can handle partial end offset for hole-punching.

In doing tmpfs, I became convinced that it needed a set_page_dirty() on
the partial pages, and I'm doing that here: but perhaps it should be the
responsibility of the calling filesystem?  I don't know.

And I'm doubtful whether this code can be correct (on a filesystem with
blocksize less than pagesize) without adding an end offset argument to
address_space_operations invalidatepage(page, offset): convince me!

Not-yet-signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/truncate.c |   69 +++++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 27 deletions(-)

--- 3.5-rc7/mm/truncate.c	2012-06-03 06:42:11.249787128 -0700
+++ linux/mm/truncate.c	2012-07-16 22:54:16.903821549 -0700
@@ -49,14 +49,6 @@ void do_invalidatepage(struct page *page
 		(*invalidatepage)(page, offset);
 }
 
-static inline void truncate_partial_page(struct page *page, unsigned partial)
-{
-	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
-	cleancache_invalidate_page(page->mapping, page);
-	if (page_has_private(page))
-		do_invalidatepage(page, partial);
-}
-
 /*
  * This cancels just the dirty bit on the kernel page itself, it
  * does NOT actually remove dirty bits on any mmap's that may be
@@ -190,8 +182,8 @@ int invalidate_inode_page(struct page *p
  * @lend: offset to which to truncate
  *
  * Truncate the page cache, removing the pages that are between
- * specified offsets (and zeroing out partial page
- * (if lstart is not page aligned)).
+ * specified offsets (and zeroing out partial pages
+ * if lstart or lend + 1 is not page aligned).
  *
  * Truncate takes two passes - the first pass is nonblocking.  It will not
  * block on page locks and it will not block on writeback.  The second pass
@@ -206,31 +198,32 @@ int invalidate_inode_page(struct page *p
 void truncate_inode_pages_range(struct address_space *mapping,
 				loff_t lstart, loff_t lend)
 {
-	const pgoff_t start = (lstart + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
-	const unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
+	pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	pgoff_t end = (lend + 1) >> PAGE_CACHE_SHIFT;
+	unsigned int partial_start = lstart & (PAGE_CACHE_SIZE - 1);
+	unsigned int partial_end = (lend + 1) & (PAGE_CACHE_SIZE - 1);
 	struct pagevec pvec;
 	pgoff_t index;
-	pgoff_t end;
 	int i;
 
 	cleancache_invalidate_inode(mapping);
 	if (mapping->nrpages == 0)
 		return;
 
-	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
-	end = (lend >> PAGE_CACHE_SHIFT);
+	if (lend == -1)
+		end = -1;	/* unsigned, so actually very big */
 
 	pagevec_init(&pvec, 0);
 	index = start;
-	while (index <= end && pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+	while (index < end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE))) {
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 
 			/* We rely upon deletion not changing page->index */
 			index = page->index;
-			if (index > end)
+			if (index >= end)
 				break;
 
 			if (!trylock_page(page))
@@ -249,27 +242,51 @@ void truncate_inode_pages_range(struct a
 		index++;
 	}
 
-	if (partial) {
+	if (partial_start) {
 		struct page *page = find_lock_page(mapping, start - 1);
 		if (page) {
+			unsigned int top = PAGE_CACHE_SIZE;
+			if (start > end) {
+				top = partial_end;
+				partial_end = 0;
+			}
 			wait_on_page_writeback(page);
-			truncate_partial_page(page, partial);
+			zero_user_segment(page, partial_start, top);
+			cleancache_invalidate_page(mapping, page);
+			if (page_has_private(page))
+				do_invalidatepage(page, partial_start);
+			set_page_dirty(page);
 			unlock_page(page);
 			page_cache_release(page);
 		}
 	}
+	if (partial_end) {
+		struct page *page = find_lock_page(mapping, end);
+		if (page) {
+			wait_on_page_writeback(page);
+			zero_user_segment(page, 0, partial_end);
+			cleancache_invalidate_page(mapping, page);
+			if (page_has_private(page))
+				do_invalidatepage(page, 0);
+			set_page_dirty(page);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+	if (start >= end)
+		return;
 
 	index = start;
 	for ( ; ; ) {
 		cond_resched();
 		if (!pagevec_lookup(&pvec, mapping, index,
-			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+			min(end - index, (pgoff_t)PAGEVEC_SIZE))) {
 			if (index == start)
 				break;
 			index = start;
 			continue;
 		}
-		if (index == start && pvec.pages[0]->index > end) {
+		if (index == start && pvec.pages[0]->index >= end) {
 			pagevec_release(&pvec);
 			break;
 		}
@@ -279,7 +296,7 @@ void truncate_inode_pages_range(struct a
 
 			/* We rely upon deletion not changing page->index */
 			index = page->index;
-			if (index > end)
+			if (index >= end)
 				break;
 
 			lock_page(page);
@@ -624,10 +641,8 @@ void truncate_pagecache_range(struct ino
 	 * This rounding is currently just for example: unmap_mapping_range
 	 * expands its hole outwards, whereas we want it to contract the hole
 	 * inwards.  However, existing callers of truncate_pagecache_range are
-	 * doing their own page rounding first; and truncate_inode_pages_range
-	 * currently BUGs if lend is not pagealigned-1 (it handles partial
-	 * page at start of hole, but not partial page at end of hole).  Note
-	 * unmap_mapping_range allows holelen 0 for all, and we allow lend -1.
+	 * doing their own page rounding first.  Note that unmap_mapping_range
+	 * allows holelen 0 for all, and we allow lend -1 for end of file.
 	 */
 
 	/*
