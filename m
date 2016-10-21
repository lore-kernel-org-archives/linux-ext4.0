From: Jan Kara <jack@suse.cz>
Subject: Re: ext4: remove another test in ext4_alloc_file_blocks()
Date: Fri, 21 Oct 2016 11:54:35 +0200
Message-ID: <20161021095435.GC8271@quack2.suse.cz>
References: <20161012060002.GA12778@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Fabian Frederick <fabf@skynet.be>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161012060002.GA12778@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 12-10-16 09:00:02, Dan Carpenter wrote:
> Before commit c3fe493ccdb1 ('ext4: remove unneeded test in
> ext4_alloc_file_blocks()') then it was possible for "depth" to be -1
> but now, it's not possible that it is negative.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c930a01..dca394c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4701,7 +4701,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  		/*
>  		 * Recalculate credits when extent tree depth changes.
>  		 */
> -		if (depth >= 0 && depth != ext_depth(inode)) {
> +		if (depth != ext_depth(inode)) {
>  			credits = ext4_chunk_trans_blocks(inode, len);
>  			depth = ext_depth(inode);
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
