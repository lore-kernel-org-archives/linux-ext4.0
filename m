From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: correct comment references to ext4_ext_direct_IO()
Date: Tue, 25 Jul 2017 12:56:20 +0200
Message-ID: <20170725105620.GB20040@quack2.suse.cz>
References: <20170714210426.GB12793@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751723AbdGYK4W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Jul 2017 06:56:22 -0400
Content-Disposition: inline
In-Reply-To: <20170714210426.GB12793@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 14-07-17 17:04:26, Eric Whitney wrote:
> Commit 914f82a32d0268847 "ext4: refactor direct IO code" deleted
> ext4_ext_direct_IO(), but references to that function remain in
> comments.  Update them to refer to ext4_direct_IO_write().
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3c600f0..2e6c022 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -892,7 +892,7 @@ static int ext4_dio_get_block_unwritten_async(struct inode *inode,
>  /*
>   * Get block function for non-AIO DIO writes when we create unwritten extent if
>   * blocks are not allocated yet. The extent will be converted to written
> - * after IO is complete from ext4_ext_direct_IO() function.
> + * after IO is complete by ext4_direct_IO_write().
>   */
>  static int ext4_dio_get_block_unwritten_sync(struct inode *inode,
>  		sector_t iblock, struct buffer_head *bh_result,	int create)
> @@ -907,7 +907,7 @@ static int ext4_dio_get_block_unwritten_sync(struct inode *inode,
>  
>  	/*
>  	 * Mark inode as having pending DIO writes to unwritten extents.
> -	 * ext4_ext_direct_IO() checks this flag and converts extents to
> +	 * ext4_direct_IO_write() checks this flag and converts extents to
>  	 * written.
>  	 */
>  	if (!ret && buffer_unwritten(bh_result))
> -- 
> 2.1.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
