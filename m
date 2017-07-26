From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/10] ext4: Use pagevec_lookup_range() in writeback code
Date: Wed, 26 Jul 2017 13:47:00 +0200
Message-ID: <20170726114704.7626-7-jack@suse.cz>
References: <20170726114704.7626-1-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: <linux-mm@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54159 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751538AbdGZLr1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Jul 2017 07:47:27 -0400
In-Reply-To: <20170726114704.7626-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Both occurences of pagevec_lookup() actually want only pages from a
given range. Use pagevec_lookup_range() for the lookup.

CC: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 68d0166d5ebc..eb86c1baf40c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1676,13 +1676,13 @@ static void mpage_release_unused_pages(struct mpage_da_data *mpd,
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, &index, PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, mapping, &index, end,
+						PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
-			if (page->index > end)
-				break;
+
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 			if (invalidate) {
@@ -2303,15 +2303,13 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 
 	pagevec_init(&pvec, 0);
 	while (start <= end) {
-		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, &start,
-					  PAGEVEC_SIZE);
+		nr_pages = pagevec_lookup_range(&pvec, inode->i_mapping,
+						&start, end, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			if (page->index > end)
-				break;
 			bh = head = page_buffers(page);
 			do {
 				if (lblk < mpd->map.m_lblk)
-- 
2.12.3
