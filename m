From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] ext3: Fix buffer dirtying in data=journal mode
Date: Mon, 19 Jul 2010 14:02:22 -0400
Message-ID: <20100719180222.GB2456@localhost.localdomain>
References: <1277116973-4183-1-git-send-email-jack@suse.cz> <1277116973-4183-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934711Ab0GSSC0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jul 2010 14:02:26 -0400
Content-Disposition: inline
In-Reply-To: <1277116973-4183-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 21, 2010 at 12:42:52PM +0200, Jan Kara wrote:
> block_prepare_write() can dirty freshly created buffer. This is a problem
> for data=journal mode because data buffers shouldn't be dirty unless they
> are undergoing checkpoint. So we have to tweak get_block function for
> data=journal mode to catch the case when block_prepare_write would dirty
> the buffer, do the work instead of block_prepare_write, and properly handle
> dirty buffer as data=journal mode requires it.
> 
> It might be cleaner to avoid using block_prepare_write() for data=journal
> mode writes but that would require us to duplicate most of the function
> which isn't nice either...
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext3/inode.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index ea33bdf..2b61cc4 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -993,6 +993,43 @@ out:
>  	return ret;
>  }
>  
> +static int ext3_journalled_get_block(struct inode *inode, sector_t iblock,
> +				     struct buffer_head *bh, int create)
> +{
> +	handle_t *handle = ext3_journal_current_handle();
> +	int ret;
> +
> +	/* This function should ever be used only for real buffers */
> +	BUG_ON(!bh->b_page);
> +
> +	ret = ext3_get_blocks_handle(handle, inode, iblock, 1, bh, create);
> +	if (ret > 0) {
> +		if (buffer_new(bh)) {
> +			struct page *page = bh->b_page;
> +
> +			/*
> +			 * This is a terrible hack to avoid block_prepare_write
> +			 * marking our buffer as dirty
> +			 */
> +			if (PageUptodate(page)) {
> +				ret = ext3_journal_get_write_access(handle, bh);
> +				if (ret < 0)
> +					goto out;
> +				unmap_underlying_metadata(bh->b_bdev,
> +							  bh->b_blocknr);
> +				clear_buffer_new(bh);
> +				set_buffer_uptodate(bh);
> +				ret = ext3_journal_dirty_metadata(handle, bh);
> +				if (ret < 0)
> +					goto out;
> +			}
> +		}

Hey Jan,

It looks like in __block_prepare_write we zero out the end of the page if we're
not writing to the entire block, but you short-circuit this behavior with this
get_block.  So it's possible that if we only write to half of the block, the
last half is going to have whatever stale data was in there before, right?
Thanks,

Josef
