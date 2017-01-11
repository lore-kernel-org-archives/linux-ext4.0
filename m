From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: fix DAX write locking
Date: Wed, 11 Jan 2017 10:01:36 +0100
Message-ID: <20170111090136.GE16116@quack2.suse.cz>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
 <1484063288-18255-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        Ted Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484063288-18255-2-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 10-01-17 16:48:07, Christoph Hellwig wrote:
> Unlike O_DIRECT DAX is not an optional opt-in feature selected by the
> application, so we'll have to provide the traditional synchronіzation
> of overlapping writes as we do for buffered writes.
> 
> This was broken historically for DAX, but got fixed for ext2 and XFS
> as part of the iomap conversion.  Fix up ext4 as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

Ted, can you please pick it up? Thanks!

								Honza

> ---
>  fs/ext4/file.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index d663d3d..a1e88aa 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -175,7 +175,6 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  {
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	ssize_t ret;
> -	bool overwrite = false;
>  
>  	inode_lock(inode);
>  	ret = ext4_write_checks(iocb, from);
> @@ -188,16 +187,9 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	if (ret)
>  		goto out;
>  
> -	if (ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
> -		overwrite = true;
> -		downgrade_write(&inode->i_rwsem);
> -	}
>  	ret = dax_iomap_rw(iocb, from, &ext4_iomap_ops);
>  out:
> -	if (!overwrite)
> -		inode_unlock(inode);
> -	else
> -		inode_unlock_shared(inode);
> +	inode_unlock(inode);
>  	if (ret > 0)
>  		ret = generic_write_sync(iocb, ret);
>  	return ret;
> -- 
> 2.1.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
