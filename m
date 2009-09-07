From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 1/3] ext4: move ext4_mb_init_group around
Date: Mon,  7 Sep 2009 15:08:12 +0530
Message-ID: <1252316294-10164-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54709 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZIGJiY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 05:38:24 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp06.au.ibm.com (8.14.3/8.13.1) with ESMTP id n879cMgo031077
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:38:22 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n879cQXa917642
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:38:26 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n879cPJ1014713
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:38:26 +1000
In-Reply-To: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This moves the function around so that i can be called
from ext4_mb_load_buddy
---
 fs/ext4/mballoc.c |  182 ++++++++++++++++++++++++++--------------------------
 1 files changed, 91 insertions(+), 91 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd25846..78e907d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -908,6 +908,97 @@ out:
 	return err;
 }
 
+static noinline_for_stack
+int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
+{
+
+	int ret = 0;
+	void *bitmap;
+	int blocks_per_page;
+	int block, pnum, poff;
+	int num_grp_locked = 0;
+	struct ext4_group_info *this_grp;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode = sbi->s_buddy_cache;
+	struct page *page = NULL, *bitmap_page = NULL;
+
+	mb_debug("init group %lu\n", group);
+	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+	this_grp = ext4_get_group_info(sb, group);
+	/*
+	 * This ensures we don't add group
+	 * to this buddy cache via resize
+	 */
+	num_grp_locked =  ext4_mb_get_buddy_cache_lock(sb, group);
+	if (!EXT4_MB_GRP_NEED_INIT(this_grp)) {
+		/*
+		 * somebody initialized the group
+		 * return without doing anything
+		 */
+		ret = 0;
+		goto err;
+	}
+	/*
+	 * the buddy cache inode stores the block bitmap
+	 * and buddy information in consecutive blocks.
+	 * So for each group we need two blocks.
+	 */
+	block = group * 2;
+	pnum = block / blocks_per_page;
+	poff = block % blocks_per_page;
+	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
+	if (page) {
+		BUG_ON(page->mapping != inode->i_mapping);
+		ret = ext4_mb_init_cache(page, NULL);
+		if (ret) {
+			unlock_page(page);
+			goto err;
+		}
+		unlock_page(page);
+	}
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
+		goto err;
+	}
+	mark_page_accessed(page);
+	bitmap_page = page;
+	bitmap = page_address(page) + (poff * sb->s_blocksize);
+
+	/* init buddy cache */
+	block++;
+	pnum = block / blocks_per_page;
+	poff = block % blocks_per_page;
+	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
+	if (page == bitmap_page) {
+		/*
+		 * If both the bitmap and buddy are in
+		 * the same page we don't need to force
+		 * init the buddy
+		 */
+		unlock_page(page);
+	} else if (page) {
+		BUG_ON(page->mapping != inode->i_mapping);
+		ret = ext4_mb_init_cache(page, bitmap);
+		if (ret) {
+			unlock_page(page);
+			goto err;
+		}
+		unlock_page(page);
+	}
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
+		goto err;
+	}
+	mark_page_accessed(page);
+err:
+	ext4_mb_put_buddy_cache_lock(sb, group, num_grp_locked);
+	if (bitmap_page)
+		page_cache_release(bitmap_page);
+	if (page)
+		page_cache_release(page);
+	return ret;
+}
+
 static noinline_for_stack int
 ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 					struct ext4_buddy *e4b)
@@ -1837,97 +1928,6 @@ void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
 
 }
 
-static noinline_for_stack
-int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
-{
-
-	int ret;
-	void *bitmap;
-	int blocks_per_page;
-	int block, pnum, poff;
-	int num_grp_locked = 0;
-	struct ext4_group_info *this_grp;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct inode *inode = sbi->s_buddy_cache;
-	struct page *page = NULL, *bitmap_page = NULL;
-
-	mb_debug("init group %lu\n", group);
-	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-	this_grp = ext4_get_group_info(sb, group);
-	/*
-	 * This ensures we don't add group
-	 * to this buddy cache via resize
-	 */
-	num_grp_locked =  ext4_mb_get_buddy_cache_lock(sb, group);
-	if (!EXT4_MB_GRP_NEED_INIT(this_grp)) {
-		/*
-		 * somebody initialized the group
-		 * return without doing anything
-		 */
-		ret = 0;
-		goto err;
-	}
-	/*
-	 * the buddy cache inode stores the block bitmap
-	 * and buddy information in consecutive blocks.
-	 * So for each group we need two blocks.
-	 */
-	block = group * 2;
-	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
-	if (page) {
-		BUG_ON(page->mapping != inode->i_mapping);
-		ret = ext4_mb_init_cache(page, NULL);
-		if (ret) {
-			unlock_page(page);
-			goto err;
-		}
-		unlock_page(page);
-	}
-	if (page == NULL || !PageUptodate(page)) {
-		ret = -EIO;
-		goto err;
-	}
-	mark_page_accessed(page);
-	bitmap_page = page;
-	bitmap = page_address(page) + (poff * sb->s_blocksize);
-
-	/* init buddy cache */
-	block++;
-	pnum = block / blocks_per_page;
-	poff = block % blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
-	if (page == bitmap_page) {
-		/*
-		 * If both the bitmap and buddy are in
-		 * the same page we don't need to force
-		 * init the buddy
-		 */
-		unlock_page(page);
-	} else if (page) {
-		BUG_ON(page->mapping != inode->i_mapping);
-		ret = ext4_mb_init_cache(page, bitmap);
-		if (ret) {
-			unlock_page(page);
-			goto err;
-		}
-		unlock_page(page);
-	}
-	if (page == NULL || !PageUptodate(page)) {
-		ret = -EIO;
-		goto err;
-	}
-	mark_page_accessed(page);
-err:
-	ext4_mb_put_buddy_cache_lock(sb, group, num_grp_locked);
-	if (bitmap_page)
-		page_cache_release(bitmap_page);
-	if (page)
-		page_cache_release(page);
-	return ret;
-}
