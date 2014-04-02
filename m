From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Note the error in ext4_end_bio()
Date: Wed, 2 Apr 2014 18:42:40 +0200
Message-ID: <20140402164240.GB8657@quack.suse.cz>
References: <20140402143507.GA27299@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbaDBQmn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 12:42:43 -0400
Content-Disposition: inline
In-Reply-To: <20140402143507.GA27299@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 02-04-14 10:35:07, Matthew Wilcox wrote:
> 
> ext4_end_bio() currently throws away the error that it receives.  Chances
> are this is part of a spate of errors, one of which will end up getting
> the error returned to userspace somehow, but we shouldn't take that risk.
> Also print out the errno to aid in debug.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ---
>  fs/ext4/page-io.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index ab95508..c18d95b 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -308,13 +308,14 @@ static void ext4_end_bio(struct bio *bio, int error)
>  	if (error) {
>  		struct inode *inode = io_end->inode;
>  
> -		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
> +		ext4_warning(inode->i_sb, "I/O error %d writing to inode %lu "
>  			     "(offset %llu size %ld starting block %llu)",
> -			     inode->i_ino,
> +			     error, inode->i_ino,
>  			     (unsigned long long) io_end->offset,
>  			     (long) io_end->size,
>  			     (unsigned long long)
>  			     bi_sector >> (inode->i_blkbits - 9));
> +		mapping_set_error(inode->i_mapping, error);
>  	}
>  
>  	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
