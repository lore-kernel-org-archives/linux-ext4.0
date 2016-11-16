From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 09/11] ext4: Rip out DAX handling from direct IO path
Date: Wed, 16 Nov 2016 10:13:35 -0700
Message-ID: <20161116171335.GA31337@linux.intel.com>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-10-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478603297-11793-10-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 08, 2016 at 12:08:15PM +0100, Jan Kara wrote:
> Reads and writes for DAX inodes should no longer end up in direct IO
> code. Rip out the support and add a warning.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 49 +++++++++++++++----------------------------------
>  1 file changed, 15 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4d71c7bc3524..72886e3bf0d3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3594,19 +3594,7 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter)
>  	iocb->private = NULL;
>  	if (overwrite)
>  		get_block_func = ext4_dio_get_block_overwrite;
> -	else if (IS_DAX(inode)) {
> -		/*
> -		 * We can avoid zeroing for aligned DAX writes beyond EOF. Other
> -		 * writes need zeroing either because they can race with page
> -		 * faults or because they use partial blocks.
> -		 */
> -		if (round_down(offset, 1<<inode->i_blkbits) >= inode->i_size &&
> -		    ext4_aligned_io(inode, offset, count))
> -			get_block_func = ext4_dio_get_block;
> -		else
> -			get_block_func = ext4_dax_get_block;

This was the last use of ext4_dax_get_block(), so that function can safely be
removed.  I can do that in a separate patch, if you don't want to pull it into
this set.

Otherwise this looks correct to me.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
