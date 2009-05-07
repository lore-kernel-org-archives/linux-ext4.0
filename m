From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ext4: Properly initialize the buffer_head state
Date: Thu,  7 May 2009 16:09:28 +0530
Message-ID: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38040 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZEGKjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 May 2009 06:39:41 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n47Ad0MF013436
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:00 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n47Addh6381304
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:39 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n47AddKv008692
	for <linux-ext4@vger.kernel.org>; Thu, 7 May 2009 20:39:39 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These buffer_heads are allocated on stack and are
used only to make get_blocks calls. So we can set the
b_state to 0

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |    2 +-
 fs/mpage.c        |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e963870..10b3028 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3141,6 +3141,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 			ret = PTR_ERR(handle);
 			break;
 		}
+		map_bh.b_state = 0;
 		ret = ext4_get_blocks_wrap(handle, inode, block,
 					  max_blocks, &map_bh,
 					  EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 43884e3..c3cd00f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2104,7 +2104,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if ((mpd->b_state  & (1 << BH_Mapped)) &&
 	    !(mpd->b_state & (1 << BH_Delay)))
 		return 0;
-	new.b_state = mpd->b_state;
+	new.b_state = 0;
 	new.b_blocknr = 0;
 	new.b_size = mpd->b_size;
 	next = mpd->b_blocknr;
diff --git a/fs/mpage.c b/fs/mpage.c
index 680ba60..cd98409 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -412,7 +412,7 @@ int mpage_readpage(struct page *page, get_block_t get_block)
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
 
-	clear_buffer_mapped(&map_bh);
+	map_bh.b_state = 0;
 	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
 			&map_bh, &first_logical_block, get_block);
 	if (bio)
-- 
1.6.3.rc4

