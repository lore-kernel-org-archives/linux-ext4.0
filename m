From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4/balloc.c:read_block_bitmap(): inconsequent NULL checking
Date: Fri, 19 Oct 2007 20:16:11 +0530
Message-ID: <4718C333.9040405@linux.vnet.ibm.com>
References: <20071019134700.GB3778@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:40756 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758707AbXJSOqm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Oct 2007 10:46:42 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9JEkb7r002079
	for <linux-ext4@vger.kernel.org>; Sat, 20 Oct 2007 00:46:37 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9JEoEx9263266
	for <linux-ext4@vger.kernel.org>; Sat, 20 Oct 2007 00:50:14 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9JEkMVr024904
	for <linux-ext4@vger.kernel.org>; Sat, 20 Oct 2007 00:46:23 +1000
In-Reply-To: <20071019134700.GB3778@stusta.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I checked rest of the ext4 sources to make sure we return properly after ext4_error.
I guess i have taken care of all the places.

-aneesh

Adrian Bunk wrote:
> Commit 7c9e69faa28027913ee059c285a5ea8382e24b5d results in the following 
> inconsequent NULL checking in fs/ext4/balloc.c:
> 
> <--  snip  -->
> 
> ...
> struct buffer_head *
> read_block_bitmap(struct super_block *sb, unsigned int block_group)
> {
> ...
>         if (!bh)
>                 ext4_error (sb, __FUNCTION__,
>                             "Cannot read block bitmap - "
>                             "block_group = %d, block_bitmap = %llu",
>                             block_group, bitmap_blk);
> 
>         /* check whether block bitmap block number is set */
>         if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
> ...                                       ^^^^^^^^^^
> 
> <--  snip  -->
> 
> Spotted by the Coverity checker.
> 
> 



>From 5c04ec0d8e43ef582cec2856f262b575376233ba Mon Sep 17 00:00:00 2001
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2007 20:10:17 +0530
Subject: [PATCH] ext4: Return after ext4_error in case of failures

This fix some instances where we were continuing
after marking the file system errors.
Even though ext4_error mark the file system read only
and panic depending on mount option it is good
to handle the return properly.

Reported by:
Adrian Bunk <bunk@kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e906b65..8517dd7 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -234,11 +234,13 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	} else {
 		bh = sb_bread(sb, bitmap_blk);
 	}
-	if (!bh)
+	if (!bh) {
 		ext4_error (sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
 			    "block_group = %d, block_bitmap = %llu",
 			    block_group, bitmap_blk);
+		return NULL;
+	}
 
 	/* check whether block bitmap block number is set */
 	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
@@ -628,11 +630,13 @@ do_more:
 	    in_range(ext4_inode_bitmap(sb, desc), block, count) ||
 	    in_range(block, ext4_inode_table(sb, desc), sbi->s_itb_per_group) ||
 	    in_range(block + count - 1, ext4_inode_table(sb, desc),
-		     sbi->s_itb_per_group))
+		     sbi->s_itb_per_group)) {
 		ext4_error (sb, "ext4_free_blocks",
 			    "Freeing blocks in system zones - "
 			    "Block = %llu, count = %lu",
 			    block, count);
+		goto error_return;
+	}
 
 	/*
 	 * We are about to start releasing blocks in the bitmap,
@@ -1733,11 +1737,13 @@ allocated:
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
-		     EXT4_SB(sb)->s_itb_per_group))
+		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, "ext4_new_block",
 			    "Allocating block in system zone - "
 			    "blocks from %llu, length %lu",
 			     ret_block, num);
+		goto out;
+	}
 
 	performed_allocation = 1;
 
-- 
1.5.3.4.206.g58ba4-dirty
