From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 03/11] ext4: Convert DAX reads to iomap infrastructure
Date: Thu, 10 Nov 2016 14:54:31 -0700
Message-ID: <20161110215431.GC27200@linux.intel.com>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
 <1478603297-11793-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478603297-11793-4-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 08, 2016 at 12:08:09PM +0100, Jan Kara wrote:
> Implement basic iomap_begin function that handles reading and use it for
> DAX reads.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h  |  2 ++
>  fs/ext4/file.c  | 38 +++++++++++++++++++++++++++++++++++++-
>  fs/ext4/inode.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 282a51b07c57..098b39910001 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3271,6 +3271,8 @@ static inline bool ext4_aligned_io(struct inode *inode, loff_t off, loff_t len)
>  	return IS_ALIGNED(off, blksize) && IS_ALIGNED(len, blksize);
>  }
>  
> +extern struct iomap_ops ext4_iomap_ops;
> +
>  #endif	/* __KERNEL__ */
>  
>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 9facb4dc5c70..1f25c644cb12 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -31,6 +31,42 @@
>  #include "xattr.h"
>  #include "acl.h"
>  
> +#ifdef CONFIG_FS_DAX
> +static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	ssize_t ret;
> +
> +	inode_lock_shared(inode);
> +	/*
> +	 * Recheck under inode lock - at this point we are sure it cannot
> +	 * change anymore
> +	 */
> +	if (!IS_DAX(inode)) {
> +		inode_unlock_shared(inode);
> +		/* Fallback to buffered IO in case we cannot support DAX */
> +		return generic_file_read_iter(iocb, to);

Is this not also racy, since we've just dropped the inode lock?  What's to
prevent this sequence?

Thread 0				Thread 1
--------				--------
ext4_file_read_iter()
  IS_DAX() returns true
  					changes S_DAX to false
  ext4_dax_read_iter()
    inode_lock_shared()
    IS_DAX() returns false
    inode_unlock_shared()
  					changes S_DAX to true
    generic_file_read_iter() on a DAX inode


Or are we okay in this scenario?
