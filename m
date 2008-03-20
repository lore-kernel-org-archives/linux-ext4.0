From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: BUG with delayed allocation
Date: Wed, 19 Mar 2008 17:46:58 -0700
Message-ID: <1205974018.3637.9.camel@localhost.localdomain>
References: <20080319085235.GA6752@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52406 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759099AbYCTArH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 20:47:07 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2K0n5pC032766
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2008 20:49:06 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2K0l4vc182746
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2008 20:47:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2K0l3N1023487
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2008 20:47:04 -0400
In-Reply-To: <20080319085235.GA6752@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-03-19 at 14:22 +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> Eric actually observed it yesterday. I am able to reproduce it locally.
> With delayed allocation we are observing wrong value of i_size.
> 

The problem is current delalloc does not update on-disk i_size until
writeout time, the in-core i_size is updated though. 

Could you try the following patch? It updates the i_disksize at the
write_end time.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/inode.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

Index: linux-2.6.25-rc5/fs/ext4/inode.c
===================================================================
--- linux-2.6.25-rc5.orig/fs/ext4/inode.c	2008-03-19 17:32:44.000000000 -0700
+++ linux-2.6.25-rc5/fs/ext4/inode.c	2008-03-19 17:43:19.000000000 -0700
@@ -1355,6 +1355,43 @@ static int ext4_writeback_write_end(stru
 	return ret ? ret : copied;
 }
 
+static int ext4_da_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	handle_t *handle;
+	struct inode *inode = file->f_mapping->host;
+	int needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret = 0, ret2;
+	loff_t new_i_size;
+
+	handle = ext4_journal_start(inode, needed_blocks);
+	if (IS_ERR(handle)) {
+		unlock_page(page);
+		page_cache_release(page);
+		ret = PTR_ERR(handle);
+		return ret;
+	}
+
+	new_i_size = pos + copied;
+	if (new_i_size > EXT4_I(inode)->i_disksize)
+		EXT4_I(inode)->i_disksize = new_i_size;
+
+	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
+	if (copied < 0)
+		ret = copied;
+
+	ret2 = ext4_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
+	return ret ? ret : copied;
+}
+
 static int ext4_journalled_write_end(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
@@ -2020,7 +2057,7 @@ static const struct address_space_operat
 	.writepages	= ext4_da_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= ext4_da_write_begin,
-	.write_end	= generic_write_end,
+	.write_end	= ext4_da_write_end,
 	.bmap		= ext4_bmap,
 	.invalidatepage	= ext4_da_invalidatepage,
 	.releasepage	= ext4_releasepage,


