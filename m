From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Thu, 12 Aug 2010 10:42:16 -0700
Message-ID: <20100812174215.GC6561@mail.oracle.com>
References: <874ofr2myq.fsf@patl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <874ofr2myq.fsf@patl.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 22, 2010 at 03:03:41PM -0700, Patrick J. LoPresti wrote:
> As part of adding support for OCFS2 to mount huge volumes, we need to
> check that the sector_t and page cache of the system are capable of
> addressing the entire volume.
> 
> An identical check already appears in ext3 and ext4.  This patch moves
> the addressability check into its own function in fs/libfs.c and
> modifies ext3 and ext4 to invoke it.
> 
> Signed-off-by: Patrick LoPresti <lopresti@gmail.com>

Dear ext3/4 folks,
	I've pushed this patch to the merge-window branch of ocfs2.git.
I'm ready to send it to Linus, But I need your OK.

Joel

> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 471e1ff..6aff3f5 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2399,6 +2399,8 @@ extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
>  
>  extern int generic_file_fsync(struct file *, int);
>  
> +extern int generic_check_addressable(unsigned, u64);
> +
>  #ifdef CONFIG_MIGRATION
>  extern int buffer_migrate_page(struct address_space *,
>  				struct page *, struct page *);
> diff --git a/fs/libfs.c b/fs/libfs.c
> index dcaf972..b969648 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -955,6 +955,38 @@ int generic_file_fsync(struct file *file, int datasync)
>  }
>  EXPORT_SYMBOL(generic_file_fsync);
>  
> +/**
> + * generic_check_addressable - Check addressability of file system
> + * @blocksize_bits:	log of file system block size
> + * @num_blocks:		number of blocks in file system
> + *
> + * Determine whether a file system with @num_blocks blocks (and a
> + * block size of 2**@blocksize_bits) is addressable by the sector_t
> + * and page cache of the system.  Return 0 if so and -EFBIG otherwise.
> + */
> +int generic_check_addressable(unsigned blocksize_bits, u64 num_blocks)
> +{
> +	u64 last_fs_block = num_blocks - 1;
> +
> +	BUG_ON(blocksize_bits < 9);
> +	BUG_ON(blocksize_bits > PAGE_CACHE_SHIFT);
> +
> +	if (unlikely(num_blocks == 0))
> +		return 0;
> +
> +	printk(KERN_INFO "HERE %u %lu %u %u", blocksize_bits, last_fs_block,
> +	       sizeof(sector_t), sizeof(pgoff_t));

Minus this printk(), of course ;-)

> +
> +	if ((last_fs_block >
> +	     (sector_t)(~0ULL) >> (blocksize_bits - 9)) ||
> +	    (last_fs_block >
> +	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - blocksize_bits))) {
> +		return -EFBIG;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(generic_check_addressable);
> +
>  /*
>   * No-op implementation of ->fsync for in-memory filesystems.
>   */
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 6c953bb..d0643db 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1862,8 +1862,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  		goto failed_mount;
>  	}
>  
> -	if (le32_to_cpu(es->s_blocks_count) >
> -		    (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
> +	if (generic_check_addressable(sb->s_blocksize_bits,
> +				      le32_to_cpu(es->s_blocks_count))) {
>  		ext3_msg(sb, KERN_ERR,
>  			"error: filesystem is too large to mount safely");
>  		if (sizeof(sector_t) < 8)
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4e8983a..979cc57 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2706,15 +2706,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	 * Test whether we have more sectors than will fit in sector_t,
>  	 * and whether the max offset is addressable by the page cache.
>  	 */
> -	if ((ext4_blocks_count(es) >
> -	     (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) ||
> -	    (ext4_blocks_count(es) >
> -	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - sb->s_blocksize_bits))) {
> +	ret = generic_check_addressable(sb->s_blocksize_bits,
> +					ext4_blocks_count(es));
> +	if (ret) {
>  		ext4_msg(sb, KERN_ERR, "filesystem"
>  			 " too large to mount safely on this system");
>  		if (sizeof(sector_t) < 8)
>  			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
> -		ret = -EFBIG;
>  		goto failed_mount;
>  	}
>  
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"What does it say about a society's priorities when the time you
 spend in meetings on Monday is greater than the total number of
 hours you spent sleeping over the weekend?"
	- Nat Friedman

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
