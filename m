From: Jan Kara <jack@suse.cz>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Date: Thu, 15 Jan 2015 13:41:06 +0100
Message-ID: <20150115124106.GF12739@quack.suse.cz>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, andreas.dilger@intel.com,
	axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com,
	hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com,
	mathieu.desnoyers@efficios.com, matthew.r.wilcox@intel.com,
	rdunlap@infradead.org, tytso@mit.edu, mm-commits@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: ross.zwisler@linux.intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbbAOMlN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Jan 2015 07:41:13 -0500
Content-Disposition: inline
In-Reply-To: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 12-01-15 15:11:17, Andrew Morton wrote:
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
> Subject: ext4: add DAX functionality
> 
> This is a port of the DAX functionality found in the current version of
> ext2.
> 
> [matthew.r.wilcox@intel.com: heavily tweaked]
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/filesystems/dax.txt  |    1 
>  Documentation/filesystems/ext4.txt |    4 +
>  fs/ext4/ext4.h                     |    6 +
>  fs/ext4/file.c                     |   50 ++++++++++++++-
>  fs/ext4/indirect.c                 |   18 +++--
>  fs/ext4/inode.c                    |   89 ++++++++++++++++++---------
>  fs/ext4/namei.c                    |   10 ++-
>  fs/ext4/super.c                    |   39 +++++++++++
>  8 files changed, 180 insertions(+), 37 deletions(-)
> 
> diff -puN Documentation/filesystems/dax.txt~ext4-add-dax-functionality Documentation/filesystems/dax.txt
> --- a/Documentation/filesystems/dax.txt~ext4-add-dax-functionality
> +++ a/Documentation/filesystems/dax.txt
> @@ -73,6 +73,7 @@ or a write()) work correctly.
>  
>  These filesystems may be used for inspiration:
>  - ext2: the second extended filesystem, see Documentation/filesystems/ext2.txt
> +- ext4: the fourth extended filesystem, see Documentation/filesystems/ext4.txt
>  
>  
>  Shortcomings
> diff -puN Documentation/filesystems/ext4.txt~ext4-add-dax-functionality Documentation/filesystems/ext4.txt
> --- a/Documentation/filesystems/ext4.txt~ext4-add-dax-functionality
> +++ a/Documentation/filesystems/ext4.txt
> @@ -386,6 +386,10 @@ max_dir_size_kb=n	This limits the size o
>  i_version		Enable 64-bit inode version support. This option is
>  			off by default.
>  
> +dax			Use direct access (no page cache).  See
> +			Documentation/filesystems/dax.txt.  Note that
> +			this option is incompatible with data=journal.
> +
>  Data Mode
>  =========
>  There are 3 different data modes:
> diff -puN fs/ext4/ext4.h~ext4-add-dax-functionality fs/ext4/ext4.h
> --- a/fs/ext4/ext4.h~ext4-add-dax-functionality
> +++ a/fs/ext4/ext4.h
> @@ -965,6 +965,11 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_ERRORS_MASK		0x00070
>  #define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
>  #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
> +#ifdef CONFIG_FS_DAX
> +#define EXT4_MOUNT_DAX			0x00200	/* Direct Access */
> +#else
> +#define EXT4_MOUNT_DAX			0
> +#endif
  Again, why do you make definition of EXT4_MOUNT_DAX dependent on
CONFIG_FS_DAX?

> diff -puN fs/ext4/file.c~ext4-add-dax-functionality fs/ext4/file.c
> --- a/fs/ext4/file.c~ext4-add-dax-functionality
> +++ a/fs/ext4/file.c
> @@ -95,7 +95,7 @@ ext4_file_write_iter(struct kiocb *iocb,
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	struct mutex *aio_mutex = NULL;
>  	struct blk_plug plug;
> -	int o_direct = file->f_flags & O_DIRECT;
> +	int o_direct = io_is_direct(file);
>  	int overwrite = 0;
>  	size_t length = iov_iter_count(from);
>  	ssize_t ret;
> @@ -191,6 +191,27 @@ errout:
>  	return ret;
>  }
>  
> +#ifdef CONFIG_FS_DAX
> +static int ext4_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	return dax_fault(vma, vmf, ext4_get_block);
> +					/* Is this the right get_block? */
  You can remove the comment. It is the right get_block function.

...
> diff -puN fs/ext4/inode.c~ext4-add-dax-functionality fs/ext4/inode.c
> --- a/fs/ext4/inode.c~ext4-add-dax-functionality
> +++ a/fs/ext4/inode.c
> @@ -657,6 +657,18 @@ has_zeroout:
>  	return retval;
>  }
>  
> +static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
> +{
> +	struct inode *inode = bh->b_assoc_map->host;
> +	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
  That should be 16 TB if I'm doing the math right - 32-bit block number *
block size (4k) = 16 TB. And that's the max limit of ext4 (as logical file
offset in blocks has to fit in 32-bits for ext4). So I think you can just
remove the comment. But also see comment below.

> +	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
> +	int err;
> +	if (!uptodate)
> +		return;
> +	WARN_ON(!buffer_unwritten(bh));
> +	err = ext4_convert_unwritten_extents(NULL, inode, offset, bh->b_size);
> +}
> +
>  /* Maximum number of blocks we map for direct IO at once. */
>  #define DIO_MAX_BLOCKS 4096
>  
> @@ -694,6 +706,11 @@ static int _ext4_get_block(struct inode
>  
>  		map_bh(bh, inode->i_sb, map.m_pblk);
>  		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
> +		if (IS_DAX(inode) && buffer_unwritten(bh) && !io_end) {
> +			bh->b_assoc_map = inode->i_mapping;
> +			bh->b_private = (void *)(unsigned long)iblock;
> +			bh->b_end_io = ext4_end_io_unwritten;
> +		}
  So why is this needed? It would deserve a comment. It confuses me in
particular because:
1) This is a often a phony bh used just as a container for passed data and
   b_end_io is just ignored.
2) Even if it was real bh attached to a page, for DAX we don't do any
   writeback and thus ->b_end_io will never get called?
3) And if it does get called, you certainly cannot call
   ext4_convert_unwritten_extents() from softirq context where ->b_end_io
   gets called.

>  		if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN)
>  			set_buffer_defer_completion(bh);
>  		bh->b_size = inode->i_sb->s_blocksize * map.m_len;

								Honza
