From: akpm@linux-foundation.org
Subject: - ext4-use-simple_prepare_write-to-zero-page-data.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:24:15 -0700
Message-ID: <200708250324.l7P3OFDJ027967@imap1.linux-foundation.org>
To: nate.diller@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbXHYDYU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Aug 2007 23:24:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: use simple_prepare_write to zero page data
has been removed from the -mm tree.  Its filename was
     ext4-use-simple_prepare_write-to-zero-page-data.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: ext4: use simple_prepare_write to zero page data
From: Nate Diller <nate.diller@gmail.com>

It's common for file systems to need to zero data on either side of a
write, if a page is not Uptodate during prepare_write.  It just so happens
that simple_prepare_write() in libfs.c does exactly that, so we can avoid
duplication and just call that function to zero page data.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/writeback.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN fs/ext4/writeback.c~ext4-use-simple_prepare_write-to-zero-page-data fs/ext4/writeback.c
--- a/fs/ext4/writeback.c~ext4-use-simple_prepare_write-to-zero-page-data
+++ a/fs/ext4/writeback.c
@@ -829,21 +829,6 @@ int ext4_wb_writepages(struct address_sp
 	return 0;
 }
 
-static void ext4_wb_clear_page(struct page *page, int from, int to)
-{
-	void *kaddr;
-
-	if (to < PAGE_CACHE_SIZE || from > 0) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		if (PAGE_CACHE_SIZE > to)
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-		if (0 < from)
-			memset(kaddr, 0, from);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
-	}
-}
-
 int ext4_wb_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
@@ -873,7 +858,7 @@ int ext4_wb_prepare_write(struct file *f
 			/* this block isn't allocated yet, reserve space */
 			wb_debug("reserve space for new block\n");
 			page->private = 1;
-			ext4_wb_clear_page(page, from, to);
+			simple_prepare_write(file, page, from, to);
 			ClearPageMappedToDisk(page);
 		} else {
 			/* block is already mapped, so no need to reserve */
_

Patches currently in -mm which might be from nate.diller@gmail.com are

reiser4.patch
