From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC] delayed allocation, mballoc, etc
Date: Thu, 07 Dec 2006 18:18:14 +0100
Message-ID: <45784CD6.3090501@bull.net>
References: <m3irgwv59d.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030009070409090706020007"
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49438 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162549AbWLGRUS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2006 12:20:18 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3irgwv59d.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------030009070409090706020007
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Alex Tomas wrote:
> Good day,
> 
> I'd like to ask the community to discuss and review few things
> I've been working on. we propose set of patches with intention
> to improve performance of ext4:
> 
>  * mballoc v4
> 
Hi Alex,
I retrieved the patches from your site and began to have a look at them.
I found some issues in the ext4-mballoc patch concerning the 48bit 
physical block number support.
The patch in attachment fixes the problem, if I'm not wrong.
Regards,

    Valérie


--------------030009070409090706020007
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="fix_48bit_support_in_mballoc.patch"
Content-Disposition: inline;
 filename="fix_48bit_support_in_mballoc.patch"

Index: linux-2.6.19-rc6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/mballoc.c	2006-12-07 17:54:01.000000000 +0100
+++ linux-2.6.19-rc6/fs/ext4/mballoc.c	2006-12-07 19:19:11.000000000 +0100
@@ -745,7 +745,7 @@ static int ext4_mb_init_cache(struct pag
 			goto out;
 
 		err = -ENOMEM;
-		bh[i] = sb_getblk(sb, le32_to_cpu(desc->bg_block_bitmap));
+		bh[i] = sb_getblk(sb, ext4_block_bitmap(sb, desc));
 		if (bh[i] == NULL)
 			goto out;
 
@@ -2794,9 +2794,9 @@ int ext4_mb_mark_diskspace_used(struct e
 		+ ac->ac_b_ex.fe_start
 		+ le32_to_cpu(es->s_first_data_block);
 
-	if (block == le32_to_cpu(gdp->bg_block_bitmap) ||
-			block == le32_to_cpu(gdp->bg_inode_bitmap) ||
-			in_range(block, le32_to_cpu(gdp->bg_inode_table),
+	if (block == ext4_block_bitmap(sb, gdp) ||
+			block == ext4_inode_bitmap(sb, gdp) ||
+			in_range(block, ext4_inode_table(sb, gdp),
 				EXT4_SB(sb)->s_itb_per_group))
 		ext4_error(sb, "ext4_new_block",
 				"Allocating block in system zone - block = %lu",
@@ -3837,11 +3837,11 @@ do_more:
 	if (!gdp)
 		goto error_return;
 
-	if (in_range (le32_to_cpu(gdp->bg_block_bitmap), block, count) ||
-			in_range (le32_to_cpu(gdp->bg_inode_bitmap), block, count) ||
-			in_range (block, le32_to_cpu(gdp->bg_inode_table),
+	if (in_range (ext4_block_bitmap(sb, gdp), block, count) ||
+			in_range (ext4_inode_bitmap(sb, gdp), block, count) ||
+			in_range (block, ext4_inode_table(sb, gdp),
 				EXT4_SB(sb)->s_itb_per_group) ||
-			in_range (block + count - 1, le32_to_cpu(gdp->bg_inode_table),
+			in_range (block + count - 1, ext4_inode_table(sb, gdp),
 				EXT4_SB(sb)->s_itb_per_group))
 		ext4_error (sb, "ext4_free_blocks",
 				"Freeing blocks in system zones - "

--------------030009070409090706020007--
