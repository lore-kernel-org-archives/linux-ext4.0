From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4-mm-delalloc-ext4.patch
Date: Fri, 29 Feb 2008 09:26:36 -0800
Message-ID: <1204305996.3629.5.camel@localhost.localdomain>
References: <20080229010555.21ab9c77.akpm@linux-foundation.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40904 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYB2R1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Feb 2008 12:27:41 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1THRCGw019105
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 12:27:12 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1THR7JT231262
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 12:27:12 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1THR7WS028848
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 12:27:07 -0500
In-Reply-To: <20080229010555.21ab9c77.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-02-29 at 01:05 -0800, Andrew Morton wrote:
> generic_commit_write() is scheduled for removal in 2.6.26 and is
> removed already from -mm.
> 
> Please switch to the new write_begin/write_end interface.

I have a patch for that, sent to linux-ext4 last week. I will merge it
to the parent patch and update in ext4 patch queue.

ext4: use write_begin/write_end in delalloc instead of prepare_write()
From: Mingming Cao <cmm@us.ibm.com>

Since generally the current mainline VFS API changed to use write-begin()
and write_end(), updating ext4 delayed allocation to adopt this change.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

Index: linux-2.6.25-rc2/fs/ext4/inode.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/inode.c	2008-02-21 17:30:59.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/inode.c	2008-02-22 12:17:16.000000000 -0800
@@ -1421,13 +1421,6 @@ static int ext4_da_get_block_prep(struct
 	return ret;
 }
 
-
-static int ext4_da_prepare_write(struct file *file, struct page *page,
-				 unsigned from, unsigned to)
-{
-	return block_prepare_write(page, from, to, ext4_da_get_block_prep);
-}
-
 static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -1485,11 +1478,34 @@ out:
 }
 
 static int ext4_da_writepages(struct address_space *mapping,
-			      struct writeback_control *wbc)
+				struct writeback_control *wbc)
 {
 	return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
 }
 
+static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned flags,
+				struct page **pagep, void **fsdata)
+{
+	int ret;
+ 	struct page *page;
+ 	pgoff_t index;
+ 	unsigned from, to;
+
+ 	index = pos >> PAGE_CACHE_SHIFT;
+ 	from = pos & (PAGE_CACHE_SIZE - 1);
+ 	to = from + len;
+
+ 	page = __grab_cache_page(mapping, index);
+ 	if (!page)
+ 		return -ENOMEM;
+ 	*pagep = page;
+
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+							ext4_da_get_block_prep);
+	return ret;
+}
+
 static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
 {
 	struct buffer_head *head, *bh;
@@ -1990,8 +2006,8 @@ static const struct address_space_operat
 	.writepage	= ext4_writeback_writepage,
 	.writepages	= ext4_da_writepages,
 	.sync_page	= block_sync_page,
-	.prepare_write	= ext4_da_prepare_write,
-	.commit_write	= generic_commit_write,
+	.write_begin	= ext4_da_write_begin,
+	.write_end	= generic_write_end,
 	.bmap		= ext4_bmap,
 	.invalidatepage	= ext4_da_invalidatepage,
 	.releasepage	= ext4_releasepage,


