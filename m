From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: ext4_page_mkwrite and delalloc
Date: Thu, 12 Jun 2008 23:44:07 +0530
Message-ID: <20080612181407.GE22481@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:48391 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbYFLSOS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 14:14:18 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5CIDcWZ029556
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 04:13:38 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5CIDs4O3948590
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 04:13:54 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5CIEEIB003992
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 04:14:14 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

With delalloc we should not do writepage in ext4_page_mkwrite. The idea
with delalloc is to delay the block allocation and make sure we allocate
chunks of blocks together at writepages. So i guess we should update
ext4_page_mkwrite to use write_begin and write_end instead of writepage.
Taking i_alloc_sem should protect against parallel truncate and the page
lock should protect against parallel write_begin/write_end.

How about the patch below ?

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cac132b..7f162cc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3543,18 +3543,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	return err;
 }
 
-static int ext4_bh_prepare_fill(handle_t *handle, struct buffer_head *bh)
-{
-	if (!buffer_mapped(bh)) {
-		/*
-		 * Mark buffer as dirty so that
-		 * block_write_full_page() writes it
-		 */
-		set_buffer_dirty(bh);
-	}
-	return 0;
-}
-
 static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
 {
 	return !buffer_mapped(bh);
@@ -3596,24 +3584,22 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 				       ext4_bh_unmapped))
 			goto out_unlock;
-		/*
-		 * Now mark all the  buffer head dirty so
-		 * that writepage can write it
-		 */
-		walk_page_buffers(NULL, page_buffers(page), 0, len,
-					NULL, ext4_bh_prepare_fill);
 	}
 	/*
-	 * OK, we need to fill the hole... Lock the page and do writepage.
-	 * We can't do write_begin and write_end here because we don't
-	 * have inode_mutex and that allow parallel write_begin, write_end call.
+	 * OK, we need to fill the hole... Lock the page and do write_begin
+	 * write_end. We are not holding inode.i__mutex here. That allow
+	 * parallel write_begin, write_end call.
 	 * (lock_page prevent this from happening on the same page though)
 	 */
-	lock_page(page);
-	wbc.range_start = page_offset(page);
-	wbc.range_end = page_offset(page) + len;
-	ret = mapping->a_ops->writepage(page, &wbc);
-	/* writepage unlocks the page */
+	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
+			len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
+	if (ret < 0)
+		goto out_unlock;
+	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
+			len, len, page, NULL);
+	if (ret < 0)
+		goto out_unlock;
+	ret = 0;
 out_unlock:
 	up_read(&inode->i_alloc_sem);
 	return ret;



If we agree i will send an updated ext4_page_mkwrite.patch and other
related patches that needed to be updated so that the patch queue apply
cleanly. 

-aneesh
