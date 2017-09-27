From: Jan Kara <jack@suse.cz>
Subject: [PATCH 04/15] ext4: Use pagevec_lookup_range_tag()
Date: Wed, 27 Sep 2017 18:03:23 +0200
Message-ID: <20170927160334.29513-5-jack@suse.cz>
References: <20170927160334.29513-1-jack@suse.cz>
Cc: <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170927160334.29513-1-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

We want only pages from given range in ext4_writepages(). Use
pagevec_lookup_range_tag() instead of pagevec_lookup_tag() and remove
unnecessary code.

CC: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org
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
-
-			/*
 			 * Accumulated enough dirty pages? This doesn't apply
 			 * to WB_SYNC_ALL mode. For integrity sync we have to
 			 * keep going because someone may be concurrently
-- 
2.12.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
