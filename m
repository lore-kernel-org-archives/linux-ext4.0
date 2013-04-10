From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix data corruption with direct IO read in
 dioread_nolock mode
Date: Wed, 10 Apr 2013 23:08:21 +0200
Message-ID: <20130410210821.GB31424@quack.suse.cz>
References: <1365438463-23025-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3DJVIX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Apr 2013 17:08:23 -0400
Content-Disposition: inline
In-Reply-To: <1365438463-23025-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 08-04-13 18:27:43, Jan Kara wrote:
> When ext4 is mounted in dioread_nolock mode, it calls
> __blockdev_direct_IO() without DIO_LOCKING flag which also means mapping
> is not synced before direct IO starts. As a result consistency between
> buffered writes and following direct IO reads is broken. More
> importantly, if the file is truncated, and extented back, zeroing of the
> tail page is not visible to the following direct IO read which will return
> stale data.
> 
> Fix the problem by flushing dirty pages before issuing direct IO read.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
  Ted, didn't you miss this patch?
	
								Honza

> ---
>  fs/ext4/indirect.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index b505a14..c18bf1c 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -809,6 +809,10 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> +		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
> +						   offset + count - 1);
> +		if (ret)
> +			goto out;
>  		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
>  			mutex_lock(&inode->i_mutex);
>  			ext4_flush_unwritten_io(inode);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
