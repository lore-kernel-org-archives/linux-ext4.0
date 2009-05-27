From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/11] vfs: Unmap underlying metadata of new data
	buffers only when buffer is mapped
Date: Wed, 27 May 2009 21:05:59 +0530
Message-ID: <20090527153559.GB19989@skywalker>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-9-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33715 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZE0PgK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 May 2009 11:36:10 -0400
Content-Disposition: inline
In-Reply-To: <1243429268-3028-9-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2009 at 03:01:05PM +0200, Jan Kara wrote:
> When we do delayed allocation of some buffer, we want to signal to VFS that
> the buffer is new (set buffer_new) so that it properly zeros out everything.
> But we don't have the buffer mapped yet so we cannot really unmap underlying
> metadata in this state. Make VFS avoid doing unmapping of metadata when the
> buffer is not yet mapped.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ddfcade..3d0bced 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1683,8 +1683,9 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
>  			if (buffer_new(bh)) {
>  				/* blockdev mappings never come here */
>  				clear_buffer_new(bh);
> -				unmap_underlying_metadata(bh->b_bdev,
> -							bh->b_blocknr);
> +				if (buffer_mapped(bh))
> +					unmap_underlying_metadata(bh->b_bdev,
> +						bh->b_blocknr);
>  			}
>  		}
>  		bh = bh->b_this_page;
> @@ -1869,8 +1870,9 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
>  			if (err)
>  				break;
>  			if (buffer_new(bh)) {
> -				unmap_underlying_metadata(bh->b_bdev,
> -							bh->b_blocknr);
> +				if (buffer_mapped(bh))
> +					unmap_underlying_metadata(bh->b_bdev,
> +						bh->b_blocknr);
>  				if (PageUptodate(page)) {
>  					clear_buffer_new(bh);
>  					set_buffer_uptodate(bh);
> @@ -2683,7 +2685,7 @@ int nobh_write_begin(struct file *file, struct address_space *mapping,
>  			goto failed;
>  		if (!buffer_mapped(bh))
>  			is_mapped_to_disk = 0;
> -		if (buffer_new(bh))
> +		if (buffer_new(bh) && buffer_mapped(bh))
>  			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
>  		if (PageUptodate(page)) {
>  			set_buffer_uptodate(bh);

Both xfs and ext4 return mapped delay buffer_head when we do a get_block
with delayed allocation in write_begin phase.

-aneesh
