From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: assert that i_rwsem is held exclusive for writes
Date: Wed, 11 Jan 2017 10:02:50 +0100
Message-ID: <20170111090250.GF16116@quack2.suse.cz>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
 <1484063288-18255-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        Ted Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484063288-18255-3-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 10-01-17 16:48:08, Christoph Hellwig wrote:
> Make sure all callers follow the same locking protocol, given that DAX
> transparantly replaced the normal buffered I/O path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Probably also for Ted since it depends on the ext4 fix...

								Honza
> ---
>  fs/dax.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5c74f60..04734da 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1061,8 +1061,12 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
>  	unsigned flags = 0;
>  
> -	if (iov_iter_rw(iter) == WRITE)
> +	if (iov_iter_rw(iter) == WRITE) {
> +		lockdep_assert_held_exclusive(&inode->i_rwsem);
>  		flags |= IOMAP_WRITE;
> +	} else {
> +		lockdep_assert_held(&inode->i_rwsem);
> +	}
>  
>  	while (iov_iter_count(iter)) {
>  		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
> -- 
> 2.1.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
