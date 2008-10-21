From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: [PATCH -v2] ext4: remove usage of Uptodate flag to initialize
	buddy after an online resize
Date: Tue, 21 Oct 2008 17:16:31 +0200
Message-ID: <1224602191.3569.25.camel@frecb007923.frec.bull.fr>
References: <1222872243.11560.19.camel@frecb007923.frec.bull.fr>
	 <1223036515.4075.11.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42804 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYJUPPt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Oct 2008 11:15:49 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 7F90219D935
	for <linux-ext4@vger.kernel.org>; Tue, 21 Oct 2008 17:15:41 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22556-06 for <linux-ext4@vger.kernel.org>;
 Tue, 21 Oct 2008 17:15:38 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id BE1EF19D94F
	for <linux-ext4@vger.kernel.org>; Tue, 21 Oct 2008 17:14:42 +0200 (CEST)
Received: from [129.183.101.223] (dhcp129183101223.frec.bull.fr [129.183.101.223])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 0205A2728D
	for <linux-ext4@vger.kernel.org>; Tue, 21 Oct 2008 17:14:40 +0200 (CEST)
In-Reply-To: <1223036515.4075.11.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

Remove page cache's uptodate flag usage to force an extended group's
buddy to be re-initialized after an online resize.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
The previous patch uses only one flag to force the initialization. This
lead the bitmap of a group to be potentially initialized several times
by several threads, until one thread has finished to initialize the
buddy and clear the flag for this group. This produce inconsistency in
the mballocator's data. So I use two flags to be sure bitmap and buddy
are initialized only once.

 ext4.h    |    3 +-
 mballoc.c |   69 +++++++++++++++-----------------------------------------------
 mballoc.h |   10 +++++++-
 resize.c  |   49 +++-----------------------------------------
 4 files changed, 31 insertions(+), 100 deletions(-)

Index: linux/fs/ext4/ext4.h
===================================================================
--- linux.orig/fs/ext4/ext4.h	2008-10-17 10:54:46.000000000 +0200
+++ linux/fs/ext4/ext4.h	2008-10-17 14:24:03.000000000 +0200
@@ -1073,7 +1073,8 @@ extern int __init init_ext4_mballoc(void
 extern void exit_ext4_mballoc(void);
 extern void ext4_mb_free_blocks(handle_t *, struct inode *,
 		unsigned long, unsigned long, int, unsigned long *);
-extern int ext4_mb_add_more_groupinfo(struct super_block *sb,
+extern void ext4_mb_force_init(struct ext4_group_info *);
+extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
 extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
 		ext4_grpblk_t add);
Index: linux/fs/ext4/mballoc.c
===================================================================
--- linux.orig/fs/ext4/mballoc.c	2008-10-17 10:54:46.000000000 +0200
+++ linux/fs/ext4/mballoc.c	2008-10-21 15:29:02.000000000 +0200
@@ -701,6 +701,7 @@ static void ext4_mb_generate_buddy(struc
 	}
 
 	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
+	clear_bit(EXT4_GROUP_INFO_FORCE_BUDDY_INIT, &(grp->bb_state));
 
 	period = get_cycles() - period;
 	spin_lock(&EXT4_SB(sb)->s_bal_lock);
@@ -918,13 +919,15 @@ ext4_mb_load_buddy(struct super_block *s
 	/* we could use find_or_create_page(), but it locks page
 	 * what we'd like to avoid in fast path ... */
 	page = find_get_page(inode->i_mapping, pnum);
-	if (page == NULL || !PageUptodate(page)) {
+	if (page == NULL || !PageUptodate(page) ||
+	    EXT4_MB_GRP_FORCE_BITMAP_INIT(e4b->bd_info)) {
 		if (page)
 			page_cache_release(page);
 		page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
 		if (page) {
 			BUG_ON(page->mapping != inode->i_mapping);
-			if (!PageUptodate(page)) {
+			if (!PageUptodate(page) ||
+			    EXT4_MB_GRP_FORCE_BITMAP_INIT(e4b->bd_info)) {
 				ret = ext4_mb_init_cache(page, NULL);
 				if (ret) {
 					unlock_page(page);
@@ -949,13 +952,15 @@ ext4_mb_load_buddy(struct super_block *s
 	poff = block % blocks_per_page;
 
 	page = find_get_page(inode->i_mapping, pnum);
-	if (page == NULL || !PageUptodate(page)) {
+	if (page == NULL || !PageUptodate(page) ||
+	    EXT4_MB_GRP_FORCE_BUDDY_INIT(e4b->bd_info)) {
 		if (page)
 			page_cache_release(page);
 		page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
 		if (page) {
 			BUG_ON(page->mapping != inode->i_mapping);
-			if (!PageUptodate(page)) {
+			if (!PageUptodate(page) ||
+			    EXT4_MB_GRP_FORCE_BUDDY_INIT(e4b->bd_info)) {
 				ret = ext4_mb_init_cache(page, e4b->bd_bitmap);
 				if (ret) {
 					unlock_page(page);
@@ -2240,6 +2245,11 @@ ext4_mb_store_history(struct ext4_alloca
 #define ext4_mb_history_init(sb)
 #endif
 
+void ext4_mb_force_init(struct ext4_group_info *grp)
+{
+	set_bit(EXT4_GROUP_INFO_FORCE_BITMAP_INIT, &(grp->bb_state));
+	set_bit(EXT4_GROUP_INFO_FORCE_BUDDY_INIT, &(grp->bb_state));
+}
 
 /* Create and initialize ext4_group_info data for the given group. */
 int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
@@ -2327,54 +2337,6 @@ exit_meta_group_info:
 } /* ext4_mb_add_groupinfo */
 
 /*
- * Add a group to the existing groups.
- * This function is used for online resize
- */
-int ext4_mb_add_more_groupinfo(struct super_block *sb, ext4_group_t group,
-			       struct ext4_group_desc *desc)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct inode *inode = sbi->s_buddy_cache;
-	int blocks_per_page;
-	int block;
-	int pnum;
-	struct page *page;
-	int err;
-
-	/* Add group based on group descriptor*/
-	err = ext4_mb_add_groupinfo(sb, group, desc);
-	if (err)
-		return err;
-
-	/*
-	 * Cache pages containing dynamic mb_alloc datas (buddy and bitmap
-	 * datas) are set not up to date so that they will be re-initilaized
-	 * during the next call to ext4_mb_load_buddy
-	 */
-
-	/* Set buddy page as not up to date */
-	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-	block = group * 2;
-	pnum = block / blocks_per_page;
-	page = find_get_page(inode->i_mapping, pnum);
-	if (page != NULL) {
-		ClearPageUptodate(page);
-		page_cache_release(page);
-	}
-
-	/* Set bitmap page as not up to date */
-	block++;
-	pnum = block / blocks_per_page;
-	page = find_get_page(inode->i_mapping, pnum);
-	if (page != NULL) {
-		ClearPageUptodate(page);
-		page_cache_release(page);
-	}
-
-	return 0;
-}
-
-/*
  * Update an existing group.
  * This function is used for online resize
  */
@@ -3355,6 +3317,9 @@ static void ext4_mb_generate_from_pa(str
 		preallocated += len;
 		count++;
 	}
+
+	clear_bit(EXT4_GROUP_INFO_FORCE_BITMAP_INIT, &(grp->bb_state));
+
 	mb_debug("prellocated %u for group %lu\n", preallocated, group);
 }
 
Index: linux/fs/ext4/mballoc.h
===================================================================
--- linux.orig/fs/ext4/mballoc.h	2008-10-17 10:54:46.000000000 +0200
+++ linux/fs/ext4/mballoc.h	2008-10-21 16:24:11.000000000 +0200
@@ -131,11 +131,17 @@ struct ext4_group_info {
 	unsigned short	bb_counters[];
 };
 
-#define EXT4_GROUP_INFO_NEED_INIT_BIT	0
-#define EXT4_GROUP_INFO_LOCKED_BIT	1
+#define EXT4_GROUP_INFO_NEED_INIT_BIT		0
+#define EXT4_GROUP_INFO_LOCKED_BIT		1
+#define EXT4_GROUP_INFO_FORCE_BUDDY_INIT	2
+#define EXT4_GROUP_INFO_FORCE_BITMAP_INIT	3
 
 #define EXT4_MB_GRP_NEED_INIT(grp)	\
 	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &((grp)->bb_state)))
+#define EXT4_MB_GRP_FORCE_BUDDY_INIT(grp)      \
+	(test_bit(EXT4_GROUP_INFO_FORCE_BUDDY_INIT, &((grp)->bb_state)))
+#define EXT4_MB_GRP_FORCE_BITMAP_INIT(grp)     \
+	(test_bit(EXT4_GROUP_INFO_FORCE_BITMAP_INIT, &((grp)->bb_state)))
 
 
 struct ext4_prealloc_space {
Index: linux/fs/ext4/resize.c
===================================================================
--- linux.orig/fs/ext4/resize.c	2008-10-17 10:54:46.000000000 +0200
+++ linux/fs/ext4/resize.c	2008-10-20 15:01:07.000000000 +0200
@@ -870,7 +870,7 @@ int ext4_group_add(struct super_block *s
 	 * We can allocate memory for mb_alloc based on the new group
 	 * descriptor
 	 */
-	err = ext4_mb_add_more_groupinfo(sb, input->group, gdp);
+	err = ext4_mb_add_groupinfo(sb, input->group, gdp);
 	if (err)
 		goto exit_journal;
 
@@ -1082,50 +1082,9 @@ int ext4_group_extend(struct super_block
 	if ((err = ext4_journal_stop(handle)))
 		goto exit_put;
 
-	/*
-	 * Mark mballoc pages as not up to date so that they will be updated
-	 * next time they are loaded by ext4_mb_load_buddy.
-	 *
-	 * XXX Bad, Bad, BAD!!!  We should not be overloading the
-	 * Uptodate flag, particularly on thte bitmap bh, as way of
-	 * hinting to ext4_mb_load_buddy() that it needs to be
-	 * overloaded.  A user could take a LVM snapshot, then do an
-	 * on-line fsck, and clear the uptodate flag, and this would
-	 * not be a bug in userspace, but a bug in the kernel.  FIXME!!!
-	 */
-	{
-		struct ext4_sb_info *sbi = EXT4_SB(sb);
-		struct inode *inode = sbi->s_buddy_cache;
-		int blocks_per_page;
-		int block;
-		int pnum;
-		struct page *page;
-
-		/* Set buddy page as not up to date */
-		blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-		block = group * 2;
-		pnum = block / blocks_per_page;
-		page = find_get_page(inode->i_mapping, pnum);
-		if (page != NULL) {
-			ClearPageUptodate(page);
-			page_cache_release(page);
-		}
-
-		/* Set bitmap page as not up to date */
-		block++;
-		pnum = block / blocks_per_page;
-		page = find_get_page(inode->i_mapping, pnum);
-		if (page != NULL) {
-			ClearPageUptodate(page);
-			page_cache_release(page);
-		}
-
-		/* Get the info on the last group */
-		grp = ext4_get_group_info(sb, group);
