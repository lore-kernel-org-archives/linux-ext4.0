From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] ext4: add error processing when calling ext4_mb_init_cache
 in mballoc
Date: Wed, 28 May 2008 17:40:20 +0800
Message-ID: <483D2884.30309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: alex@clusterfs.com, Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbYE1JnB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 05:43:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add error processing for ext4_mb_load_buddy when it calls
ext4_mb_init_cache.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/mballoc.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 35c12db..a30a35d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -883,6 +883,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	int pnum;
 	int poff;
 	struct page *page;
+	int ret;
 
 	mb_debug("load group %lu\n", group);
 
@@ -914,15 +915,21 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 		if (page) {
 			BUG_ON(page->mapping != inode->i_mapping);
 			if (!PageUptodate(page)) {
-				ext4_mb_init_cache(page, NULL);
+				ret = ext4_mb_init_cache(page, NULL);
+				if (ret) {
+					unlock_page(page);
+					goto err;
+				}
 				mb_cmp_bitmaps(e4b, page_address(page) +
 					       (poff * sb->s_blocksize));
 			}
 			unlock_page(page);
 		}
 	}
-	if (page == NULL || !PageUptodate(page))
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
 		goto err;
+	}
 	e4b->bd_bitmap_page = page;
 	e4b->bd_bitmap = page_address(page) + (poff * sb->s_blocksize);
 	mark_page_accessed(page);
@@ -938,14 +945,20 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 		page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
 		if (page) {
 			BUG_ON(page->mapping != inode->i_mapping);
-			if (!PageUptodate(page))
-				ext4_mb_init_cache(page, e4b->bd_bitmap);
-
+			if (!PageUptodate(page)) {
+				ret = ext4_mb_init_cache(page, e4b->bd_bitmap);
+				if (ret) {
+					unlock_page(page);
+					goto err;
+				}
+			}
 			unlock_page(page);
 		}
 	}
-	if (page == NULL || !PageUptodate(page))
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
 		goto err;
+	}
 	e4b->bd_buddy_page = page;
 	e4b->bd_buddy = page_address(page) + (poff * sb->s_blocksize);
 	mark_page_accessed(page);
@@ -962,7 +975,7 @@ err:
 		page_cache_release(e4b->bd_buddy_page);
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
-	return -EIO;
+	return ret;
 }
 
 static void ext4_mb_release_desc(struct ext4_buddy *e4b)
-- 
1.5.4.5
