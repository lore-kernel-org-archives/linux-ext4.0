From: Jan Kara <jack@suse.cz>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk
 addressability check
Date: Fri, 13 Aug 2010 18:30:07 +0200
Message-ID: <20100813163006.GB4329@quack.suse.cz>
References: <874ofr2myq.fsf@patl.com>
 <20100812174215.GC6561@mail.oracle.com>
 <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca>
 <20100812201534.GA22777@mail.oracle.com>
 <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca>
 <20100812222949.GC22777@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, Ted Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org Patrick J. LoPresti"
	<lopresti@gmail.com>
To: Joel Becker <Joel.Becker@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100812222949.GC22777@mail.oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 12-08-10 15:29:49, Joel Becker wrote:
> diff --git a/fs/libfs.c b/fs/libfs.c
> index dcaf972..f099566 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -955,6 +955,35 @@ int generic_file_fsync(struct file *file, int datasync)
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
> +	if (unlikely(num_blocks == 0))
> +		return 0;
> +
> +	if ((blocksize_bits < 9) || (blocksize_bits > PAGE_CACHE_SHIFT))
> +		return -EINVAL;
> +
> +	if ((last_fs_block >
> +	     (sector_t)(~0ULL) >> (blocksize_bits - 9)) ||
> +	    (last_fs_block >
> +	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - blocksize_bits))) {
            ^^^ I don't get the pgoff_t check. Shouldn't it rather be
(u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)?
Because on 32-bit arch we are able to address 16TB device, which is for 1KB
blocksize 1<<34 blocks. But your math gives 1<<30 blocks...

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
