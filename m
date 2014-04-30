From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2] ext4: fix data integrity sync in ordered mode
Date: Wed, 30 Apr 2014 19:04:41 +0900
Message-ID: <004301cf645b$9a960c00$cfc22400$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>, Jan kara <jack@suse.de>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:10588 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaD3KEv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Apr 2014 06:04:51 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4U0015U9BU1P10@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 30 Apr 2014 19:04:42 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we perform a data integrity sync we tag all the dirty pages with
PAGECACHE_TAG_TOWRITE at start of ext4_da_writepages.
Later we check for this tag in write_cache_pages_da and creates a
struct mpage_da_data containing contiguously indexed pages tagged with this
tag and sync these pages with a call to mpage_da_map_and_submit.
This process is done in while loop until all the PAGECACHE_TAG_TOWRITE pages
are synced. We also do journal start and stop in each iteration.
journal_stop could initiate journal commit which would call ext4_writepage
which in turn will call ext4_bio_write_page even for delayed OR unwritten
buffers. When ext4_bio_write_page is called for such buffers, even though it
does not sync them but it clears the PAGECACHE_TAG_TOWRITE of the corresponding
page and hence these pages are also not synced by the currently running data
integrity sync. We will end up with dirty pages although sync is completed.

This could cause a potential data loss when the sync call is followed by a
truncate_pagecache call, which is exactly the case in collapse_range.
(It will cause generic/127 failure in xfstests)

Cc: stable@vger.kernel.org
Cc: Jan kara <jack@suse.de>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/inode.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b1dc334..bd85712 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1865,12 +1865,19 @@ static int ext4_writepage(struct page *page,
 	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
 				   ext4_bh_delay_or_unwritten)) {
 		redirty_page_for_writepage(wbc, page);
-		if (current->flags & PF_MEMALLOC) {
+		if ((current->flags & PF_MEMALLOC) ||
+		     radix_tree_tag_get(&page->mapping->page_tree,
+					page->index, PAGECACHE_TAG_TOWRITE)) {
 			/*
 			 * For memory cleaning there's no point in writing only
 			 * some buffers. So just bail out. Warn if we came here
 			 * from direct reclaim.
-			 */
+			 * We should also bail out when a journal commit happen
+			 * during an integrity sync operation because calling
+			 * ext4_bio_write_page in this case will clear
+			 * PAGECACHE_TAG_TOWRITE and we could end up with
+			 * dirty pages even after completion of a sync call.
+			 */
 			WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD))
 							== PF_MEMALLOC);
 			unlock_page(page);
-- 
1.7.11-rc0

