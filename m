From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [Patch] mistaken ext4_inode_bitmap for ext4_block_bitmap
Date: Tue, 26 Jun 2007 13:24:10 +0900
Message-ID: <468094EA.60609@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52285 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXFZEY4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2007 00:24:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi.

I found an obvious mistake in ext4_new_blocks().
I made a fix patch for it.
Please confirm it.

This patch is for 2.6.22-rc5.

---

In ext4_new_blocks(), one of two ext4_block_bitmap() calls should be ext4_inode_bitmap() call.
It is not harmful in normal processing, but it should be fixed.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext4/balloc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)
--- linux-2.6.22-rc5.org/fs/ext4/balloc.c	2007-06-17 11:09:12.000000000 +0900
+++ linux-2.6.22-rc5/fs/ext4/balloc.c	2007-06-22 13:50:22.000000000 +0900
@@ -1585,7 +1585,7 @@ allocated:
 	ret_block = grp_alloc_blk + ext4_group_first_block_no(sb, group_no);

 	if (in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
-	    in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
+	    in_range(ext4_inode_bitmap(sb, gdp), ret_block, num) ||
 	    in_range(ret_block, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group) ||
 	    in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
