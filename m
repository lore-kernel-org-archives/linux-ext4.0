From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Ext4: avoid multiple quota reservation when retry
	block reservation for delalloc
Date: Mon, 21 Sep 2009 20:15:27 +0200
Message-ID: <20090921181527.GA27777@duck.suse.cz>
References: <1253551950.9099.10.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39562 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbZIUSPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Sep 2009 14:15:25 -0400
Content-Disposition: inline
In-Reply-To: <1253551950.9099.10.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-09-09 09:52:30, Mingming wrote:
> Ext4: release reserved quota before block reservation for delalloc retry
> 
> ext4_da_reserve_space() can reserve quota blocks multiple times if
> ext4_claim_free_blocks() fail and we retry the allocation. We should
> release the quota reservation before restarting.
> 
> Bug found be Jan Kara.
            ^^ by
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> ---
>  fs/ext4/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.31-rc4/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.31-rc4.orig/fs/ext4/inode.c
> +++ linux-2.6.31-rc4/fs/ext4/inode.c
> @@ -1785,11 +1785,11 @@ repeat:
>  
>  	if (ext4_claim_free_blocks(sbi, total)) {
>  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +		vfs_dq_release_reservation_block(inode, total);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
>  			goto repeat;
>  		}
> -		vfs_dq_release_reservation_block(inode, total);
>  		return -ENOSPC;
>  	}
>  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> 
  The patch is fine. Acked-by: Jan Kara <jack@suse.cz>
But it's certainly not the issue hit by Pavol but I'm out of ideas where
could be a problem provided he runs with extents...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
