From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V4 05/11] misc/create_inode.c: copy regular file
Date: Thu, 6 Mar 2014 11:06:22 -0800
Message-ID: <20140306190622.GE9875@birch.djwong.org>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
 <1393661175-459-6-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, dvhart@linux.intel.com, linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50934 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaCFTG3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 14:06:29 -0500
Content-Disposition: inline
In-Reply-To: <1393661175-459-6-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I noticed a few things while merging -next into my dev tree...

On Sat, Mar 01, 2014 at 03:06:09AM -0500, Robert Yang wrote:
> The do_write_internal() is used for copying file from native fs to
> target, most of the code are from debugfs/debugfs.c, the
> debugfs/debugfs.c will be modified to use this function.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> ---
>  misc/create_inode.c |  183 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 183 insertions(+)
> 
> diff --git a/misc/create_inode.c b/misc/create_inode.c
> index f845103..98f4a93 100644
> --- a/misc/create_inode.c
> +++ b/misc/create_inode.c
> @@ -8,6 +8,16 @@
>  # endif
>  #endif
>  
> +/* 64KiB is the minimium blksize to best minimize system call overhead. */
> +#ifndef IO_BUFSIZE
> +#define IO_BUFSIZE 64*1024
> +#endif
> +
> +/* Block size for `st_blocks' */
> +#ifndef S_BLKSIZE
> +#define S_BLKSIZE 512
> +#endif
> +
>  /* Make a special file which is block, character and fifo */
>  errcode_t do_mknod_internal(ext2_ino_t cwd, const char *name, struct stat *st)
>  {
> @@ -127,9 +137,182 @@ errcode_t do_mkdir_internal(ext2_ino_t cwd, const char *name, struct stat *st)
>  {
>  }
>  
> +static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_holes)
> +{
> +	ext2_file_t	e2_file;
> +	errcode_t	retval;
> +	int		got;
> +	unsigned int	written;
> +	char		*buf;
> +	char		*ptr;
> +	char		*zero_buf;
> +	int		cmp;
> +
> +	retval = ext2fs_file_open(current_fs, newfile,
> +				  EXT2_FILE_WRITE, &e2_file);
> +	if (retval)
> +		return retval;
> +
> +	retval = ext2fs_get_mem(bufsize, &buf);
> +	if (retval) {
> +		com_err("copy_file", retval, "can't allocate buffer\n");
> +		return retval;
> +	}
> +
> +	/* This is used for checking whether the whole block is zero */
> +	retval = ext2fs_get_memzero(bufsize, &zero_buf);
> +	if (retval) {
> +		com_err("copy_file", retval, "can't allocate buffer\n");
> +		ext2fs_free_mem(&buf);
> +		return retval;
> +	}
> +
> +	while (1) {
> +		got = read(fd, buf, bufsize);
> +		if (got == 0)
> +			break;
> +		if (got < 0) {
> +			retval = errno;
> +			goto fail;
> +		}
> +		ptr = buf;
> +
> +		/* Sparse copy */
> +		if (make_holes) {
> +			/* Check whether all is zero */
> +			cmp = memcmp(ptr, zero_buf, got);
> +			if (cmp == 0) {
> +				 /* The whole block is zero, make a hole */
> +				retval = ext2fs_file_lseek(e2_file, got, EXT2_SEEK_CUR, NULL);
> +				if (retval)
> +					goto fail;
> +				got = 0;
> +			}
> +		}
> +
> +		/* Normal copy */
> +		while (got > 0) {
> +			retval = ext2fs_file_write(e2_file, ptr,
> +						   got, &written);
> +			if (retval)
> +				goto fail;
> +
> +			got -= written;
> +			ptr += written;
> +		}
> +	}
> +	ext2fs_free_mem(&buf);
> +	ext2fs_free_mem(&zero_buf);
> +	retval = ext2fs_file_close(e2_file);
> +	return retval;
> +
> +fail:
> +	ext2fs_free_mem(&buf);
> +	ext2fs_free_mem(&zero_buf);
> +	(void) ext2fs_file_close(e2_file);
> +	return retval;
> +}
> +
>  /* Copy the native file to the fs */
>  errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
>  {
> +	int		fd;
> +	struct stat	statbuf;
> +	ext2_ino_t	newfile;
> +	errcode_t	retval;
> +	struct ext2_inode inode;
> +	int		bufsize = IO_BUFSIZE;
> +	int		make_holes = 0;
> +
> +	fd = open(src, O_RDONLY);
> +	if (fd < 0) {
> +		com_err(src, errno, 0);
> +		return errno;
> +	}
> +	if (fstat(fd, &statbuf) < 0) {
> +		com_err(src, errno, 0);
> +		close(fd);
> +		return errno;
> +	}
> +
> +	retval = ext2fs_namei(current_fs, root, cwd, dest, &newfile);
> +	if (retval == 0) {
> +		com_err(__func__, 0, "The file '%s' already exists\n", dest);
> +		close(fd);
> +		return errno;
> +	}
> +
> +	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
> +	if (retval) {
> +		com_err(__func__, retval, 0);
> +		close(fd);
> +		return errno;

Why return errno here, instead of retval?

> +	}
> +#ifdef DEBUGFS
> +	printf("Allocated inode: %u\n", newfile);
> +#endif
> +	retval = ext2fs_link(current_fs, cwd, dest, newfile,
> +				EXT2_FT_REG_FILE);
> +	if (retval == EXT2_ET_DIR_NO_SPACE) {
> +		retval = ext2fs_expand_dir(current_fs, cwd);
> +		if (retval) {
> +			com_err(__func__, retval, "while expanding directory");
> +			close(fd);
> +			return errno;

Or here...

> +		}
> +		retval = ext2fs_link(current_fs, cwd, dest, newfile,
> +					EXT2_FT_REG_FILE);
> +	}
> +	if (retval) {
> +		com_err(dest, retval, 0);
> +		close(fd);
> +		return errno;

Or here...

--D
> +	}
> +        if (ext2fs_test_inode_bitmap2(current_fs->inode_map, newfile))
> +		com_err(__func__, 0, "Warning: inode already set");
> +	ext2fs_inode_alloc_stats2(current_fs, newfile, +1, 0);
> +	memset(&inode, 0, sizeof(inode));
> +	inode.i_mode = (statbuf.st_mode & ~LINUX_S_IFMT) | LINUX_S_IFREG;
> +	inode.i_atime = inode.i_ctime = inode.i_mtime =
> +		current_fs->now ? current_fs->now : time(0);
> +	inode.i_links_count = 1;
> +	inode.i_size = statbuf.st_size;
> +	if (current_fs->super->s_feature_incompat &
> +	    EXT3_FEATURE_INCOMPAT_EXTENTS) {
> +		int i;
> +		struct ext3_extent_header *eh;
> +
> +		eh = (struct ext3_extent_header *) &inode.i_block[0];
> +		eh->eh_depth = 0;
> +		eh->eh_entries = 0;
> +		eh->eh_magic = ext2fs_cpu_to_le16(EXT3_EXT_MAGIC);
> +		i = (sizeof(inode.i_block) - sizeof(*eh)) /
> +			sizeof(struct ext3_extent);
> +		eh->eh_max = ext2fs_cpu_to_le16(i);
> +		inode.i_flags |= EXT4_EXTENTS_FL;
> +	}
> +
> +	if ((retval = ext2fs_write_new_inode(current_fs, newfile, &inode))) {
> +		com_err(__func__, retval, "while creating inode %u", newfile);
> +		close(fd);
> +		return errno;
> +	}
> +	if (LINUX_S_ISREG(inode.i_mode)) {
> +		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
> +			make_holes = 1;
> +			/*
> +			 * Use I/O blocksize as buffer size when
> +			 * copying sparse files.
> +			 */
> +			bufsize = statbuf.st_blksize;
> +		}
> +		retval = copy_file(fd, newfile, bufsize, make_holes);
> +		if (retval)
> +			com_err("copy_file", retval, 0);
> +	}
> +	close(fd);
> +
> +	return 0;
>  }
>  
>  /* Copy files from source_dir to fs */
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
