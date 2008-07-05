From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/52] ext4: add error processing when calling ext4_mb_init_cache in mballoc
Date: Sat,  5 Jul 2008 13:35:33 -0400
Message-ID: <1215279378-30504-8-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33106 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755112AbYGERge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:34 -0400
In-Reply-To: <1215279378-30504-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Shen Feng <shen@cn.fujitsu.com>

Add error processing for ext4_mb_load_buddy when it calls
ext4_mb_init_cache.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Reviewed-by:   Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 27498bf..49c1d1c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -884,6 +884,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	int pnum;
 	int poff;
 	struct page *page;
+	int ret;
 
 	mb_debug("load group %lu\n", group);
 
@@ -915,15 +916,21 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
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
@@ -939,14 +946,20 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
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
@@ -963,7 +976,7 @@ err:
 		page_cache_release(e4b->bd_buddy_page);
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
-	return -EIO;
+	return ret;
 }
 
 static void ext4_mb_release_desc(struct ext4_buddy *e4b)
-- 
1.5.6.rc3.1.g36b7.dirty

