From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ext3: Fix dirtying of journalled buffers in
 data=journal mode
Date: Thu, 5 Aug 2010 12:09:41 -0700
Message-ID: <20100805120941.d915ea09.akpm@linux-foundation.org>
References: <1281026536-10413-1-git-send-email-jack@suse.cz>
	<1281026536-10413-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755703Ab0HETKP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 15:10:15 -0400
In-Reply-To: <1281026536-10413-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu,  5 Aug 2010 18:42:16 +0200
Jan Kara <jack@suse.cz> wrote:

> In data=journal mode, we still use block_write_begin() to prepare page for
> writing. This function can occasionally mark buffer dirty which violates
> journalling assumptions - when a buffer is part of a transaction, it should be
> dirty and a buffer can be already part of a forget list of some transaction
> when block_write_begin() gets called. This violation of journalling assumptions
> then results in "JBD: Spotted dirty metadata buffer..." warnings.
> 
> In fact, temporary dirtying the buffer while the page is still locked does not
> really cause problems to the journalling because we won't write the buffer
> until the page gets unlocked. So we just have to make sure to clear dirty bits
> before unlocking the page.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext3/inode.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 735f019..1a84abb 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1149,9 +1149,25 @@ static int walk_page_buffers(	handle_t *handle,
>  static int do_journal_get_write_access(handle_t *handle,
>  					struct buffer_head *bh)
>  {
> +	int dirty = buffer_dirty(bh);
> +	int ret;
> +
>  	if (!buffer_mapped(bh) || buffer_freed(bh))
>  		return 0;
> -	return ext3_journal_get_write_access(handle, bh);
> +	/*
> +	 * __block_prepare_write() could have dirtied some buffers. Clean
> +	 * the dirty bit as jbd2_journal_get_write_access() could complain
> +	 * otherwise about fs integrity issues. Setting of the dirty bit
> +	 * by __block_prepare_write() isn't a real problem here as we clear
> +	 * the bit before releasing a page lock and thus writeback cannot
> +	 * ever write the buffer.
> +	 */
> +	if (dirty)
> +		clear_buffer_dirty(bh);

mark_buffer_dirty() can run set_page_dirty() which will set the page
dirty and increment dirty-page accounting.  If we then run
clear_buffer_dirty() we can end up with a dirty page which has clean
buffers and an off-by-one in dirty-page accounting.

Later, writeback will come along and will attempt to write the "dirty"
page.  It will discover the cleanness of the buffers, will mark the
page clean without doing any IO and will decrement the dirty-page
accounting.  So everything gets fixed up again.

So I don't see any problem here and this isn't the only place where
this sort of thing occurs.  It's just somethnig to be aware of and to
have a think about.


> +	ret = ext3_journal_get_write_access(handle, bh);
> +	if (!ret && dirty)
> +		ret = ext3_journal_dirty_metadata(handle, bh);
> +	return ret;
>  }
>  
>  /*
> -- 
> 1.6.4.2
