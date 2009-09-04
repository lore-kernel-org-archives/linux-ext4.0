From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/ext4/mballoc.c:1721!
Date: Fri, 4 Sep 2009 14:19:43 +0530
Message-ID: <20090904084943.GB19757@skywalker.linux.vnet.ibm.com>
References: <4A9F7B48.9010903@in.ibm.com> <20090903112003.GA13105@skywalker.linux.vnet.ibm.com> <4AA0CF83.8060405@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Sachin Sant <sachinp@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:36620 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbZIDItu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 04:49:50 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id n848njNM003906
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 14:19:45 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n848njZd1880286
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 14:19:45 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n848njCi022520
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:49:45 +1000
Content-Disposition: inline
In-Reply-To: <4AA0CF83.8060405@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 01:57:47PM +0530, Sachin Sant wrote:
> Aneesh Kumar K.V wrote:
>> Can you try this patch ?
>>   
> Thanks for the patch Aneesh.
>
> I have executed the tests several times against this patch and haven't 
> seen this issue. So at this point the patch looks good.
>
> Tested-by : Sachin Sant <sachinp@in.ibm.com>
>
> Will execute the tests few times more just to be doubly sure about this.
>
> Thanks

Ok i am running test with the below patch. It is more invasive in that it
moves the need init flag check into load buddy. I guess we need to do that,
otherwise we will be operating with stale buddy information when
we have resize happening parallel. Also with the patch i posted before
we still have issues as explained below

a) we check for init flag we find it doesn't need an cache init
b) we resize and mark the group in need for init
c) in load buddy we look at the pageuptodate flag and find it uptodate
   and continue using the old buddy cache information.

-aneesh

    ext4: check for need init flag in ext4_mb_load_buddy
    
    We should check for need init flag with group info alloc_sem
    held. That would make sure when we are loading the buddy cache
    and holding a reference to it a file system resize can't add
    new blocks to same group.
    
    The patch also drops for the need init flag check in
    ext4_mb_regular_allocator because doing the check without holding
    alloc_sem is racy
    
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd25846..d646e5e 100644
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
@@ -941,8 +1032,26 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	 * groups mapped by the page is blocked
 	 * till we are done with allocation
 	 */
+repeat_load_buddy:
 	down_read(e4b->alloc_semp);
 
+	if (EXT4_MB_GRP_NEED_INIT(grp)) {
+		/* we need to check for group need init flag
+		 * with alloc_semp held so that we can be sure
+		 * that new blocks didn't get added to the group
+		 * when we are loading the buddy cache
+		 */
+		up_read(e4b->alloc_semp);
+		/*
+		 * we need full data about the group
+		 * to make a good selection
+		 */
+		ret = ext4_mb_init_group(sb, group);
+		if (ret)
+			return ret;
+		goto repeat_load_buddy;
+	}
+
 	/*
 	 * the buddy cache inode stores the block bitmap
 	 * and buddy information in consecutive blocks.
@@ -1837,97 +1946,6 @@ void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
 
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
-
 static noinline_for_stack int
 ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
@@ -2015,27 +2033,6 @@ repeat:
 			if (grp->bb_free == 0)
 				continue;
 
-			/*
-			 * if the group is already init we check whether it is
-			 * a good group and if not we don't load the buddy
-			 */
-			if (EXT4_MB_GRP_NEED_INIT(grp)) {
-				/*
-				 * we need full data about the group
-				 * to make a good selection
-				 */
-				err = ext4_mb_init_group(sb, group);
-				if (err)
-					goto out;
-			}
-
-			/*
-			 * If the particular group doesn't satisfy our
-			 * criteria we continue with the next group
-			 */
-			if (!ext4_mb_good_group(ac, group, cr))
-				continue;
