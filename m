From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG with delayed allocation
Date: Thu, 20 Mar 2008 11:09:02 +0530
Message-ID: <20080320053902.GD6967@skywalker>
References: <20080319085235.GA6752@skywalker> <1205974018.3637.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:49644 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYCTFkB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2008 01:40:01 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2K5dd5f012172
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 16:39:39 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2K5dvrP1065164
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 16:39:57 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2K5dulr013388
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 16:39:57 +1100
Content-Disposition: inline
In-Reply-To: <1205974018.3637.9.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 19, 2008 at 05:46:58PM -0700, Mingming Cao wrote:
> On Wed, 2008-03-19 at 14:22 +0530, Aneesh Kumar K.V wrote:
> > Hi,
> > 
> > Eric actually observed it yesterday. I am able to reproduce it locally.
> > With delayed allocation we are observing wrong value of i_size.
> > 
> 
> The problem is current delalloc does not update on-disk i_size until
> writeout time, the in-core i_size is updated though. 
> 

ext4_da_writepages actually update the i_disksize during writeout time.
The writepage callback for delalloc was using ext4_writeback_writepage,
which didn't update the i_disksize. That is why some of the files have
correct size while some doesn't. I tested the below change and sent this
to list. But i appears vger dropped the mail to the list.


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 79930df..b74426d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1488,6 +1488,43 @@ out:
 
 	return ret;
 }
+static int ext4_da_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	if (ext4_journal_current_handle())
+		goto out_fail;
+
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_fail;
+	}
+
+	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
+		ret = nobh_writepage(page, ext4_get_block, wbc);
+	else
+		ret = block_write_full_page(page, ext4_get_block, wbc);
+
+	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
+		EXT4_I(inode)->i_disksize = inode->i_size;
+		ext4_mark_inode_dirty(handle, inode);
+	}
+
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
+	return ret;
+
+out_fail:
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return ret;
+}
 
 static int ext4_da_writepages(struct address_space *mapping,
 				struct writeback_control *wbc)
@@ -2015,7 +2052,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 static const struct address_space_operations ext4_da_aops = {
 	.readpage	= ext4_readpage,
 	.readpages	= ext4_readpages,
-	.writepage	= ext4_writeback_writepage,
+	.writepage	= ext4_da_writepage,
 	.writepages	= ext4_da_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= ext4_da_write_begin,

> Could you try the following patch? It updates the i_disksize at the
> write_end time.
> 

I will test the patch and update you. BTW shouldn't we update
i_disksize only after actual block got allocated ?


> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/ext4/inode.c |   39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.25-rc5/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.25-rc5.orig/fs/ext4/inode.c	2008-03-19 17:32:44.000000000 -0700
> +++ linux-2.6.25-rc5/fs/ext4/inode.c	2008-03-19 17:43:19.000000000 -0700
> @@ -1355,6 +1355,43 @@ static int ext4_writeback_write_end(stru
>  	return ret ? ret : copied;
>  }
> 
> +static int ext4_da_write_end(struct file *file,
> +				struct address_space *mapping,
> +				loff_t pos, unsigned len, unsigned copied,
> +				struct page *page, void *fsdata)
> +{
> +	handle_t *handle;
> +	struct inode *inode = file->f_mapping->host;
> +	int needed_blocks = ext4_writepage_trans_blocks(inode);
> +	int ret = 0, ret2;
> +	loff_t new_i_size;
> +
> +	handle = ext4_journal_start(inode, needed_blocks);
> +	if (IS_ERR(handle)) {
> +		unlock_page(page);
> +		page_cache_release(page);
> +		ret = PTR_ERR(handle);
> +		return ret;
> +	}
> +
> +	new_i_size = pos + copied;
> +	if (new_i_size > EXT4_I(inode)->i_disksize)
> +		EXT4_I(inode)->i_disksize = new_i_size;
> +
> +	copied = ext4_generic_write_end(file, mapping, pos, len, copied,
> +							page, fsdata);
> +	if (copied < 0)
> +		ret = copied;
> +
> +	ret2 = ext4_journal_stop(handle);
> +	if (!ret)
> +		ret = ret2;
> +	unlock_page(page);
> +	page_cache_release(page);
> +
> +	return ret ? ret : copied;
> +}
> +
>  static int ext4_journalled_write_end(struct file *file,
>  				struct address_space *mapping,
>  				loff_t pos, unsigned len, unsigned copied,
> @@ -2020,7 +2057,7 @@ static const struct address_space_operat
>  	.writepages	= ext4_da_writepages,
>  	.sync_page	= block_sync_page,
>  	.write_begin	= ext4_da_write_begin,
> -	.write_end	= generic_write_end,
> +	.write_end	= ext4_da_write_end,
>  	.bmap		= ext4_bmap,
>  	.invalidatepage	= ext4_da_invalidatepage,
>  	.releasepage	= ext4_releasepage,
> 
> 

-aneesh
