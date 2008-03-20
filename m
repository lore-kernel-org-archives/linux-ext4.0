From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG with delayed allocation
Date: Thu, 20 Mar 2008 09:51:58 +0530
Message-ID: <20080320042157.GC6967@skywalker>
References: <20080319085235.GA6752@skywalker> <47E12645.40203@redhat.com> <20080319183255.GA15209@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, Eric Sandeen <sandeen@redhat.com>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:33650 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYCTEWI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2008 00:22:08 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2K4LkqE020804
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 15:21:46 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2K4Pp9v288334
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 15:25:51 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2K4MCSF004795
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 15:22:12 +1100
Content-Disposition: inline
In-Reply-To: <20080319183255.GA15209@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This mail didn't seem to reach the list.

-aneesh

On Thu, Mar 20, 2008 at 12:02:55AM +0530, Aneesh Kumar K.V wrote:
> On Wed, Mar 19, 2008 at 09:42:13AM -0500, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > Hi,
> > > 
> > > Eric actually observed it yesterday. I am able to reproduce it locally.
> > > With delayed allocation we are observing wrong value of i_size.
> > > 
> > > kenrel: 2.6.25-rc5 +
> > > With all the patches in the patch queue
> > 
> > ...
> > 
> > I also see this with only:
> > 
> > patches/delalloc-vfs.patch
> > patches/delalloc-ext4.patch
> > 
> > applied.
> 
> This one seems to work for me. Need to think a bit more about parallel
> truncate.
> 
> -aneesh
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 79930df..b74426d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1488,6 +1488,43 @@ out:
>  
>  	return ret;
>  }
> +static int ext4_da_writepage(struct page *page,
> +				struct writeback_control *wbc)
> +{
> +	struct inode *inode = page->mapping->host;
> +	handle_t *handle = NULL;
> +	int ret = 0;
> +	int err;
> +
> +	if (ext4_journal_current_handle())
> +		goto out_fail;
> +
> +	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
> +	if (IS_ERR(handle)) {
> +		ret = PTR_ERR(handle);
> +		goto out_fail;
> +	}
> +
> +	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
> +		ret = nobh_writepage(page, ext4_get_block, wbc);
> +	else
> +		ret = block_write_full_page(page, ext4_get_block, wbc);
> +
> +	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
> +		EXT4_I(inode)->i_disksize = inode->i_size;
> +		ext4_mark_inode_dirty(handle, inode);
> +	}
> +
> +	err = ext4_journal_stop(handle);
> +	if (!ret)
> +		ret = err;
> +	return ret;
> +
> +out_fail:
> +	redirty_page_for_writepage(wbc, page);
> +	unlock_page(page);
> +	return ret;
> +}
>  
>  static int ext4_da_writepages(struct address_space *mapping,
>  				struct writeback_control *wbc)
> @@ -2015,7 +2052,7 @@ static const struct address_space_operations ext4_journalled_aops = {
>  static const struct address_space_operations ext4_da_aops = {
>  	.readpage	= ext4_readpage,
>  	.readpages	= ext4_readpages,
> -	.writepage	= ext4_writeback_writepage,
> +	.writepage	= ext4_da_writepage,
>  	.writepages	= ext4_da_writepages,
>  	.sync_page	= block_sync_page,
>  	.write_begin	= ext4_da_write_begin,
