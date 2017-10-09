From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/16] ext4: Use pagevec_lookup_range_tag()
Date: Mon,  9 Oct 2017 17:13:47 +0200
Message-ID: <20171009151359.31984-5-jack@suse.cz>
References: <20171009151359.31984-1-jack@suse.cz>
Cc: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49795 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754740AbdJIPOJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 9 Oct 2017 11:14:09 -0400
In-Reply-To: <20171009151359.31984-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We want only pages from given range in ext4_writepages(). Use
pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

CC: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 31db875bc7a1..69f11233d0d6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2619,8 +2619,8 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 	mpd->map.m_len = 0;
 	mpd->next_page = index;
 	while (index <= end) {
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
-			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup_range_tag(&pvec, mapping, &index, end,
+				tag, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			goto out;
 
@@ -2628,16 +2628,6 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			struct page *page = pvec.pages[i];
 
 			/*
-			 * At this point, the page may be truncated or
-			 * invalidated (changing page->mapping to NULL), or
-			 * even swizzled back from swapper_space to tmpfs file
-			 * mapping. However, page->index will not change
-			 * because we have a reference on the page.
-			 */
-			if (page->index > end)
-				goto out;
