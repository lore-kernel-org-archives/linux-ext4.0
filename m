From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC PATCH] ext4:  Update i_diskzie during writepage for
	delayed allocation.
Date: Fri, 21 Mar 2008 15:08:27 -0700
Message-ID: <1206137307.3605.29.camel@localhost.localdomain>
References: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, sandeen@redhat.com, Solofo.Ramangalahy@bull.net,
	dmonakhov@openvz.org, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40930 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYCUWIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2008 18:08:35 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2LM8Vds017581
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 18:08:31 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2LM8VOU267800
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 18:08:31 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2LM8UXX015705
	for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2008 18:08:31 -0400
In-Reply-To: <1206080337-8732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-03-21 at 11:48 +0530, Aneesh Kumar K.V wrote:
> We need to update i_disksize after allocating blocks. writepages
> already does this. Update writepage to also  update i_disksize.
> 

I agree that we should update the i_disk size after the allocation, to
avoid possible exposing stale data in case of fs crash happened after
the metadata hit to disk but before data being written out.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/inode.c |   40 +++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 39 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 79930df..50d700f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1488,6 +1488,44 @@ out:
> 
>  	return ret;
>  }
> +/* FIXME!! only support data=writeback mode */
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
> @@ -2015,7 +2053,7 @@ static const struct address_space_operations ext4_journalled_aops = {
>  static const struct address_space_operations ext4_da_aops = {
>  	.readpage	= ext4_readpage,
>  	.readpages	= ext4_readpages,
> -	.writepage	= ext4_writeback_writepage,
> +	.writepage	= ext4_da_writepage,
>  	.writepages	= ext4_da_writepages,
>  	.sync_page	= block_sync_page,
>  	.write_begin	= ext4_da_write_begin,

