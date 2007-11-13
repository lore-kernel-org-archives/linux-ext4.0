From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 2/2] FIEMAP ioctl for ext4
Date: Tue, 13 Nov 2007 14:54:30 +1100
Message-ID: <20071113035430.GI995458@sgi.com>
References: <1194901206.12045.18.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andreas Dilger <adilger@Sun.COM>,
	Eric Sandeen <sandeen@redhat.com>, mark.fasheh@oracle.com,
	dgc@sgi.com
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1194901206.12045.18.camel@garfield>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 13, 2007 at 02:30:06AM +0530, Kalpak Shah wrote:
> Recently there was discussion about an "FIle Extent MAP"(FIEMAP) ioctl for efficiently mapping the extents and holes of a file. This will be many times more efficient than FIBMAP by cutting down the number of ioctls.
> 
> This patch adds the FIEMAP ioctl for ext4. The spec for the FIEMAP ioctl was posted earlier by Andreas Dilger and can be found at:
> http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg03944.html
....
>  	}
> +	case EXT4_IOC_FIEMAP: {
> +		return ext4_fiemap(inode, filp, cmd, arg);
> +	}
>  
>  	default:
>  		return -ENOTTY;
> Index: linux-2.6.23.1/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.23.1.orig/include/linux/ext4_fs.h
> +++ linux-2.6.23.1/include/linux/ext4_fs.h
> @@ -228,15 +228,20 @@ struct ext4_new_group_data {
>  #define	EXT4_IOC_SETFLAGS		FS_IOC_SETFLAGS
>  #define	EXT4_IOC_GETVERSION		_IOR('f', 3, long)
>  #define	EXT4_IOC_SETVERSION		_IOW('f', 4, long)
> +#define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
> +#define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
>  #define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
>  #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
> +#define EXT4_IOC_FIEMAP			_IOWR('f', 10, struct fiemap)

Please make this common - we dont want a new ioctl for every
filesystem; we want a single common to all filesystems.

> +int ext4_fiemap(struct inode *inode, struct file *filp, unsigned int cmd,
> +		unsigned long arg)
> +{

Most of this function will be common to all IOC_FIEMAP
implementations.

> +	struct fiemap *fiemap_s;
> +	struct fiemap_internal fiemap_i;
> +	struct fiemap_extent *last_extent;
> +	ext4_fsblk_t start_blk;
> +	int fm_extent_size = sizeof(struct fiemap_extent);
> +	int err = 0;
> +
> +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +		return -EOPNOTSUPP;

	struct address_space *mapping = filp->f_mapping;

	if (!mapping->a_ops->fiemap)
		return -EOPNOTSUPP;

> +
> +	fiemap_s = kmalloc(sizeof(*fiemap_s), GFP_KERNEL);
> +	if (fiemap_s == NULL)
> +		return -ENOMEM;
> +	if (copy_from_user(fiemap_s, (struct fiemap __user *)arg,
> +			   sizeof(*fiemap_s)))
> +		return -EFAULT;

This is common

> +
> +	if (fiemap_s->fm_flags & EXT4_FIEMAP_FLAG_INCOMPAT_UNSUPP)
> +		return -EOPNOTSUPP;
> +
> +	if (fiemap_s->fm_flags & FIEMAP_FLAG_SYNC)
> +		ext4_sync_file(filp, filp->f_dentry, 1);

The common form is:

	if (fiemap_s->fm_flags & FIEMAP_FLAG_SYNC)
		filemap_write_and_wait(mapping);

> +	start_blk = fiemap_s->fm_start >> inode->i_sb->s_blocksize_bits;
> +	fiemap_i.fiemap_s = fiemap_s;
> +	fiemap_i.tot_mapping_len = 0;
> +	fiemap_i.cur_ext_ptr = (char *)(arg + sizeof(*fiemap_s));
> +	fiemap_i.current_extent = 0;
> +	fiemap_i.err = 0;

Seems common.

> +
> +	/*
> +	 * Walk the extent tree gathering extent information
> +	 */
> +	mutex_lock(&EXT4_I(inode)->truncate_mutex);
> +	err = ext4_ext_walk_space(inode, start_blk , EXT_MAX_BLOCK - start_blk,
> +				  ext4_ext_fiemap_cb, &fiemap_i);
> +	mutex_unlock(&EXT4_I(inode)->truncate_mutex);

This becomes:

	error = mapping->a_ops->fiemap(inode, ....);

and the lock, extent walk, etc becomes ext4_fiemap() which is set up
in the a_ops for the filesystem. Any filesystems specific checks go
there as well.

> +	if (err)
> +		return err;
> +
> +	fiemap_s->fm_extent_count = fiemap_i.current_extent;
> +	fiemap_s->fm_length = fiemap_i.tot_mapping_len;
> +	/*
> +	 * Mark last extent as EXTENT_LAST and copy the extent to userspace.
> +	 */
> +	if (fiemap_i.current_extent != 0 &&
> +	    fiemap_i.current_extent < fiemap_s->fm_extent_count &&
> +	    !(fiemap_s->fm_flags & FIEMAP_FLAG_NUM_EXTENTS)) {
> +		char *dest;
> +
> +		last_extent = &fiemap_i.fm_extent;
> +		last_extent->fe_flags |= FIEMAP_EXTENT_LAST;
> +		dest = (char *)arg + sizeof(*fiemap_s) + fm_extent_size *
> +						(fiemap_s->fm_extent_count - 1);
> +		err = copy_to_user(dest, last_extent, fm_extent_size);
> +		if (err)
> +			return err;
> +	}
> +	err = copy_to_user((void *)arg, fiemap_s, sizeof(*fiemap_s));
> +
> +	return err;

That's common, too.

I don't want to see this implemented over and over again with minute
variations and bugs. The common implementation should be called from
in do_file_ioctl() like FIBMAP....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
