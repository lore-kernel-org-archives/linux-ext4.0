From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Thu, 19 Dec 2013 12:58:44 +1100
Message-ID: <20131219015843.GE20579@dastard>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
 <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218123319.GH31386@dastard>
 <20131218152234.GB9207@parisc-linux.org>
 <20131219004831.GU31386@dastard>
 <20131219010530.GA17545@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131219010530.GA17545@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 18, 2013 at 06:05:31PM -0700, Matthew Wilcox wrote:
> On Thu, Dec 19, 2013 at 11:48:31AM +1100, Dave Chinner wrote:
> > We already have a model for handling non page cache based IO paths:
> > Direct IO has to handle this read/truncate race condition without
> > page lock serialisation, and it works just fine. Go and look at
> > inode_dio_wait() rather than reinventing the wheel.
> 
> I've spent most of today looking at that code.  Here's where I'm at
> right now.  It doesn't even compile.

Comments in line.

> 
> diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
> index 18b34d2..29be737 100644
> --- a/fs/ext2/xip.h
> +++ b/fs/ext2/xip.h
> @@ -16,9 +16,7 @@ static inline int ext2_use_xip (struct super_block *sb)
>  }
>  int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
>  				void **, unsigned long *);
> -#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
>  #else
> -#define mapping_is_xip(map)			0
>  #define ext2_xip_verify_sb(sb)			do { } while (0)
>  #define ext2_use_xip(sb)			0
>  #define ext2_clear_xip_target(inode, chain)	0
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index b9499b2..66d2b35 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -190,7 +190,8 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  		}
>  	}
>  
> -	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
> +	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT) ||
> +	    (mapping_is_xip(inode->i_mapping)))

I suspect a helper function a good idea here. Something like
"is_io_direct(iocb->ki_filp)"

> index 594009f..ae760d9 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -686,15 +686,22 @@ retry:
>  			inode_dio_done(inode);
>  			goto locked;
>  		}
> -		ret = __blockdev_direct_IO(rw, iocb, inode,
> -				 inode->i_sb->s_bdev, iov,
> -				 offset, nr_segs,
> -				 ext4_get_block, NULL, NULL, 0);
> +		if (mapping_is_xip(file->f_mapping))
> +			ret = xip_io(rw, iocb, inode, iov, offset, nr_segs,
> +					ext4_get_block, NULL, 0);

xip_direct_io() might be a better name here...

> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2511,6 +2511,14 @@ extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
>  extern int xip_truncate_page(struct address_space *mapping, loff_t from);
>  extern int xip_zero_page_range(struct address_space *, loff_t from,
>  			       unsigned length);
> +extern ssize_t xip_io(int rw, struct kiocb *, struct inode *,
> +			const struct iovec *, loff_t, unsigned segs,
> +			get_block_t, dio_iodone_t, int flags);
> +
> +static inline bool mapping_is_xip(struct address_space *mapping)
> +{
> +	return mapping->a_ops->get_xip_mem != NULL;
> +}

I think that you should put a flag in the mapping for this, rather
than chase pointers to do the check.

> +static ssize_t __xip_io(int rw, struct inode *inode, const struct iovec *iov,
> +		loff_t offset, loff_t end, unsigned nr_segs,
> +		get_block_t get_block, struct buffer_head *bh)
> +{
> +	ssize_t retval;
> +	unsigned seg = 0;
> +	unsigned len;
> +	unsigned copied = 0;
> +	loff_t max = offset;
> +
> +	while (offset < end) {
> +		void __user *buf = iov[seg].iov_base + copied;
> +		bool hole;
> +
> +		if (max == offset) {
> +			sector_t block = offset >> inode->i_blkbits;
> +			memset(bh, 0, sizeof(*bh));
> +			bh->b_size = ALIGN(end - offset, PAGE_SIZE);
> +			retval = get_block(inode, block, bh, 0);
> +			if (retval)
> +				break;
> +			if (buffer_mapped(bh))
> +				hole = false;
> +			else
> +				hole = true;
> +			if (rw == WRITE && hole) {
> +				bh->b_size = ALIGN(end - offset, PAGE_SIZE);
> +				retval = get_block(inode, block, bh, 1);
> +				if (retval)
> +					break;
> +			} 

Why do two write mappings here? If it's a write, then we always want
to fill a hole, so the create value sent to getblock is:

			retval = get_block(inode, block, bh, rw == WRITE);
			if (retval)
				break;
			if (buffer_mapped(bh))
				hole = false;
			else
				hole = true;

And that's all you need.

> +			max = offset + bh->b_size;
> +		}
> +
> +		len = min_t(unsigned, iov[seg].iov_len - copied, max - offset);
> +
> +		if (rw == WRITE)
> +			len -= __copy_from_user_nocache(addr, buf, len);
> +		else if (!hole)
> +			len -= __copy_to_user(buf, addr, len);
> +		else
> +			len -= __clear_user(buf, len);
> +
> +		offset += len;
> +		copied += len;
> +		if (copied == iov[seg].iov_len) {
> +			seg++;
> +			copied = 0;
> +		}
> +	}
> +
> +	return retval;
> +}
> +
> +/*
> + * Perform I/O to an XIP file.  We follow the same rules as
> + * __blockdev_direct_IO with respect to locking
> + */

OK, that's interesting, because it means that it will be different
to normal buffered page cache IO. It will allow concurrent
overlapping reads and writes - something that POSIX does not allow -
and places the burden of synchronising concurrent reads and writes
on the application.

That is different to the current XIP, which serialises writes
against each other, but not against reads. That's not strictly POSIX
compliant, either, but it prevents concurrent overlapping writes
from occurring and so behaves more like applications expect buffered
IO to work.

For persistent memory, I'd prefer that we have concurrent write Io
capabilities from the start, but I'm not sure we should just do this
without first talking about it....

> +ssize_t xip_io(int rw, struct kiocb *iocb, struct inode *inode,
> +		const struct iovec *iov, loff_t offset, unsigned nr_segs,
> +		get_block_t get_block, dio_iodone_t end_io, int flags)
> +{
> +	struct buffer_head bh;
> +	unsigned seg;
> +	ssize_t retval = -EINVAL;
> +	loff_t end = offset;
> +
> +	for (seg = 0; seg < nr_segs; seg++)
> +		end += iov[seg].iov_len;
> +
> +	if ((flags & DIO_LOCKING) && (rw == READ)) {
> +		struct address_space *mapping = inode->i_mapping;
> +		mutex_lock(&inode->i_mutex);
> +		retval = filemap_write_and_wait_range(mapping, offset, end - 1);
> +		if (retval) {
> +			mutex_unlock(&inode->i_mutex);
> +			goto out;
> +		}
> +	}
> +
> +	/* Protects against truncate */
> +	atomic_inc(&inode->i_dio_count);
> +
> +	retval = __xip_io(rw, inode, iov, offset, end, nr_segs, get_block, &bh);

Can we avoid using "__" prefixes for new code? xip_do_direct_io() is
a much better name....

> +
> +	if ((flags & DIO_LOCKING) && (rw == READ))
> +		mutex_unlock(&inode->i_mutex);
> +
> +	inode_dio_done(inode);
> +
> +	if (end_io)
> +		end_io(iocb, offset, transferred, bh.b_private);

And that solves the unwritten extent problem for the IO path. Now we
just need to solve it for the mmap path. That, I suspect will
require a custom .page_mkwrite handler....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
