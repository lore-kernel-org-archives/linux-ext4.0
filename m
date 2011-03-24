From: amir73il@users.sourceforge.net
Subject: [PATCH v2 4/5] ext4: teach ext4_mb_init_cache() to skip uptodate buddy caches
Date: Thu, 24 Mar 2011 18:58:12 +0200
Message-ID: <1300985893-4371-5-git-send-email-amir73il@users.sourceforge.net>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34574 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab1CXQ6g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Mar 2011 12:58:36 -0400
Received: by bwz15 with SMTP id 15so226914bwz.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Mar 2011 09:58:35 -0700 (PDT)
In-Reply-To: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

After online resize which adds new groups, some of the groups
in a buddy page may be initialized and uptodate, while other
(new ones) may be uninitialized.

The indication for init of new block groups is when ext4_mb_init_cache()
is called with an uptodate buddy page. In this case, initialized groups
on that buddy page must be skipped when initializing the buddy cache.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/mballoc.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 69601b2..1ddb92b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -787,6 +787,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	struct inode *inode;
 	char *data;
 	char *bitmap;
+	struct ext4_group_info *grinfo;
 
 	mb_debug(1, "init page %lu\n", page->index);
 
@@ -819,6 +820,18 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		if (first_group + i >= ngroups)
 			break;
 
+		grinfo = ext4_get_group_info(sb, first_group + i);
+		/*
+		 * If page is uptodate then we came here after online resize
+		 * which added some new uninitialized group info structs, so
+		 * we must skip all initialized uptodate buddies on the page,
+		 * which may be currently in use by an allocating task.
+		 */
+		if (PageUptodate(page) && !EXT4_MB_GRP_NEED_INIT(grinfo)) {
+			bh[i] = NULL;
+			continue;
+		}
+
 		err = -EIO;
 		desc = ext4_get_group_desc(sb, first_group + i, NULL);
 		if (desc == NULL)
@@ -871,26 +884,28 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 	}
 
 	/* wait for I/O completion */
-	for (i = 0; i < groups_per_page && bh[i]; i++)
-		wait_on_buffer(bh[i]);
+	for (i = 0; i < groups_per_page; i++)
+		if (bh[i])
+			wait_on_buffer(bh[i]);
 
 	err = -EIO;
-	for (i = 0; i < groups_per_page && bh[i]; i++)
-		if (!buffer_uptodate(bh[i]))
+	for (i = 0; i < groups_per_page; i++)
+		if (bh[i] && !buffer_uptodate(bh[i]))
 			goto out;
 
 	err = 0;
 	first_block = page->index * blocks_per_page;
-	/* init the page  */
-	memset(page_address(page), 0xff, PAGE_CACHE_SIZE);
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
-		struct ext4_group_info *grinfo;
 
 		group = (first_block + i) >> 1;
 		if (group >= ngroups)
 			break;
 
+		if (!bh[group - first_group])
+			/* skip initialized uptodate buddy */
+			continue;
+
 		/*
 		 * data carry information regarding this
 		 * particular group in the format specified
@@ -919,6 +934,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			 * incore got set to the group block bitmap below
 			 */
 			ext4_lock_group(sb, group);
+			/* init the buddy */
+			memset(data, 0xff, blocksize);
 			ext4_mb_generate_buddy(sb, data, incore, group);
 			ext4_unlock_group(sb, group);
 			incore = NULL;
@@ -948,7 +965,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 out:
 	if (bh) {
-		for (i = 0; i < groups_per_page && bh[i]; i++)
+		for (i = 0; i < groups_per_page; i++)
 			brelse(bh[i]);
 		if (bh != &bhs)
 			kfree(bh);
-- 
1.7.0.4

