From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [RFC] ext4-delayed-allocation.patch
Date: Fri, 12 Jan 2007 15:45:27 +0100
Message-ID: <45A79F07.7010204@bull.net>
References: <m37iwjwumf.fsf@bzzz.home.net> <m3tzznvfnz.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070702050907070105050400"
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48341 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbXALOpF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2007 09:45:05 -0500
To: Alex Tomas <alex@clusterfs.com>
In-Reply-To: <m3tzznvfnz.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------070702050907070105050400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Hi Alex,

I tested your patch on my system with a 20TB device, but some tests 
failed. Looking at the code, I saw that the support of 48-bit block 
number in extents is lacking.

I made some changes in the code (see the patch in attachment) and now 
all my tests are OK.
The patch is not complete, I didn't update calls to wb_debug() which 
dump "ee_start".

Hope this helps.

   Valérie


--------------070702050907070105050400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="ext4-delalloc-extents-48bit.patch"
Content-Disposition: inline;
 filename="ext4-delalloc-extents-48bit.patch"

Index: linux-2.6.20-rc1/fs/ext4/writeback.c
===================================================================
--- linux-2.6.20-rc1.orig/fs/ext4/writeback.c	2007-01-09 18:41:27.000000000 +0100
+++ linux-2.6.20-rc1/fs/ext4/writeback.c	2007-01-11 13:25:38.000000000 +0100
@@ -274,7 +274,8 @@ static int ext4_wb_submit_extent(struct 
 	struct inode *inode = wc->mapping->host;
 	int blkbits = inode->i_blkbits;
 	struct page *page;
-	unsigned long blk, off, len, remain;
+	ext4_fsblk_t off;
+	unsigned long blk, len, remain;
 	unsigned long pstart, plen, prev;
 	struct bio *bio = NULL;
 	int nr_pages;
@@ -332,6 +333,7 @@ alloc_new_bio:
 			nr_pages = (ex->ee_len - (blk - ex->ee_block));
 			nr_pages = (nr_pages >> (PAGE_CACHE_SHIFT - blkbits));
 			off = ex->ee_start + (blk - ex->ee_block);
+			off |= (ext4_fsblk_t) ex->ee_start_hi << 32;
 			bio = ext4_wb_bio_alloc(inode, off, nr_pages + 2);
 			if (bio == NULL)
 				return -ENOMEM;
@@ -377,7 +379,9 @@ ext4_wb_find_goal(struct inode *inode, s
 		
 		/* try to predict block placement */
 		if ((ex = path[depth].p_ext))
-			return ex->ee_start + (block - ex->ee_block);
+			return ((ex->ee_start
+				| ((ext4_fsblk_t) ex->ee_start_hi << 32))
+				+ (block - ex->ee_block);
 
 		/* it looks index is empty
 		 * try to find starting from index itself */
@@ -416,7 +420,8 @@ static int ext4_wb_handle_extent(struct 
 				(unsigned) ec->ec_block,
 				(unsigned) ec->ec_len,
 				(unsigned) ec->ec_start);
-		nex.ee_start = ec->ec_start;
+		nex.ee_start = ec->ec_start & 0xffffffff;
+		nex.ee_start_hi = (ec->ec_start >> 32) & 0xffff;
 		nex.ee_block = ec->ec_block;
 		nex.ee_len = ec->ec_len;
 		err = ext4_wb_submit_extent(wc, NULL, &nex, 0);
@@ -488,8 +493,8 @@ static int ext4_wb_handle_extent(struct 
 			pblock, count, inode->i_ino, ec->ec_len);
 
 	/* insert new extent */
-	nex.ee_start = pblock;
-	nex.ee_start_hi = 0;
+	nex.ee_start = pblock & 0xffffffff;
+	nex.ee_start_hi = (pblock >> 32) & 0xffff;
 	nex.ee_len = count;
 	nex.ee_block = ec->ec_block;
 	err = ext4_ext_insert_extent(handle, inode, path, &nex);
@@ -520,7 +525,9 @@ static int ext4_wb_handle_extent(struct 
 	/* block have been allocated for data, so time to drop dirty
 	 * in correspondend buffer_heads to prevent corruptions */
 	for (i = 0; i < nex.ee_len; i++)
-		unmap_underlying_metadata(sb->s_bdev, nex.ee_start + i);
+		unmap_underlying_metadata(sb->s_bdev,
+				((ext4_fsblk_t) nex.ee_start_hi << 32)
+				+ nex.ee_start + i);
 
 	/* correct on-disk inode size */
 	if (nex.ee_len > 0) {

--------------070702050907070105050400--
