From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 17/28] libext2fs: handle inline data in read/write
 function
Date: Tue, 3 Dec 2013 19:02:42 -0800
Message-ID: <20131204030242.GJ9535@birch.djwong.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-18-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43718 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3LDDCu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 22:02:50 -0500
Content-Disposition: inline
In-Reply-To: <1386072715-9869-18-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 08:11:44PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently ext2fs_file_read/write are used to copy data from/to a file.
> But they manipulate data by blocksize.  For supporting inline data, we
> handle it in two new fucntions called ext2fs_file_read/write_inline_data.
> 
> In read path the implementation is straightforward.  But in write path
> things get more complicated because if the size of data is greater than
> the maximum size of inline data we will expand this file.  So now we
> will check this in ext2fs_xattr_set().  If this inode doesn't have
> enough space, it will return EXT2_ET_INLINE_DATA_NO_SPACE error.  Then
> the caller will check this error and tries to expand the file.
> 
> The following commands in debugfs can handle inline_data feature after
> applying this patch:
> 	- dump
> 	- cat
> 	- rdump
> 	- write
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  debugfs/debugfs.c         |   13 ++++--
>  lib/ext2fs/ext2_err.et.in |    3 ++
>  lib/ext2fs/ext2fsP.h      |    6 +++
>  lib/ext2fs/ext_attr.c     |   76 +++++++++++++++++++++++++++++++
>  lib/ext2fs/fileio.c       |  108 +++++++++++++++++++++++++++++++++++++++++++++
>  lib/ext2fs/inline_data.c  |   90 ++++++++++++++++++++++++++++++++++---
>  6 files changed, 287 insertions(+), 9 deletions(-)
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index d1c81f1..0903c8e 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -1684,7 +1684,6 @@ fail:
>  	return retval;
>  }
>  
> -
>  void do_write(int argc, char *argv[])
>  {
>  	int		fd;
> @@ -1750,8 +1749,11 @@ void do_write(int argc, char *argv[])
>  		current_fs->now ? current_fs->now : time(0);
>  	inode.i_links_count = 1;
>  	inode.i_size = statbuf.st_size;
> -	if (current_fs->super->s_feature_incompat &
> -	    EXT3_FEATURE_INCOMPAT_EXTENTS) {
> +	if (EXT2_HAS_INCOMPAT_FEATURE(current_fs->super,
> +				      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
> +		inode.i_flags |= EXT4_INLINE_DATA_FL;
> +	} else if (current_fs->super->s_feature_incompat &
> +		   EXT3_FEATURE_INCOMPAT_EXTENTS) {
>  		int i;
>  		struct ext3_extent_header *eh;
>  
> @@ -1768,6 +1770,11 @@ void do_write(int argc, char *argv[])
>  		close(fd);
>  		return;
>  	}
> +	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
> +		retval = ext2fs_inline_data_init(current_fs, newfile);
> +		if (retval)
> +			return;
> +	}
>  	if (LINUX_S_ISREG(inode.i_mode)) {
>  		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
>  			make_holes = 1;
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index 0781145..68aa3e0 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -503,4 +503,7 @@ ec	EXT2_ET_EA_NO_SPACE,
>  ec	EXT2_ET_NO_INLINE_DATA,
>  	"Inode doesn't have inline data"
>  
> +ec	EXT2_ET_INLINE_DATA_NO_SPACE,
> +	"No free space in inline data"
> +
>  	end
> diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> index bfc321c..e159128 100644
> --- a/lib/ext2fs/ext2fsP.h
> +++ b/lib/ext2fs/ext2fsP.h
> @@ -102,6 +102,12 @@ extern errcode_t ext2fs_inline_data_dir_iterate(ext2_filsys fs,
>  						  int	      ref_offset,
>  						  void	      *priv_data),
>  				      void *priv_data);
> +extern errcode_t ext2fs_inline_data_get(ext2_filsys fs, ext2_ino_t ino,
> +					struct ext2_inode *inode,
> +					void *buf, size_t *size);
> +extern errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
> +					struct ext2_inode *inode,
> +					void *buf, size_t size);
>  
>  /* Generic numeric progress meter */
>  
> diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> index 0e9a9ab..98f0fbb 100644
> --- a/lib/ext2fs/ext_attr.c
> +++ b/lib/ext2fs/ext_attr.c
> @@ -818,6 +818,71 @@ errcode_t ext2fs_xattr_get(struct ext2_xattr_handle *h, const char *key,
>  	return EXT2_ET_EA_KEY_NOT_FOUND;
>  }
>  
> +static errcode_t ext2fs_xattr_max_size(struct ext2_xattr_handle *handle, size_t *size)
> +{
> +	struct ext2_ext_attr_header *header;
> +	struct ext2_ext_attr_entry *entry;
> +	struct ext2_inode_large *inode;
> +	__u32 ea_inode_magic;
> +	unsigned int storage_size, freesize, minoff;
> +	void *start;
> +	int i;
> +	errcode_t err;
> +
> +	i = EXT2_INODE_SIZE(handle->fs->super);
> +	if (i < sizeof(*inode))
> +		i = sizeof(*inode);
> +	err = ext2fs_get_memzero(i, &inode);
> +	if (err)
> +		return err;
> +
> +	err = ext2fs_read_inode_full(handle->fs, handle->ino,
> +				     (struct ext2_inode *)inode,
> +				     EXT2_INODE_SIZE(handle->fs->super));
> +	if (err)
> +		goto out;
> +
> +	/* Does the inode have size for EA? */
> +	if (EXT2_INODE_SIZE(handle->fs->super) <= EXT2_GOOD_OLD_INODE_SIZE +
> +						  inode->i_extra_isize +
> +						  sizeof(__u32)) {
> +		err = EXT2_ET_INLINE_DATA_NO_SPACE;
> +		goto out;
> +	}
> +
> +	minoff = EXT2_INODE_SIZE(handle->fs->super) -
> +		 sizeof(*inode) - sizeof(__u32);
> +	memcpy(&ea_inode_magic, ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
> +	       inode->i_extra_isize, sizeof(__u32));
> +	if (ea_inode_magic == EXT2_EXT_ATTR_MAGIC) {
> +		/* has xattrs.  calculate the size */
> +		storage_size = EXT2_INODE_SIZE(handle->fs->super) -
> +			EXT2_GOOD_OLD_INODE_SIZE - inode->i_extra_isize -
> +			sizeof(__u32);
> +		start= ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
> +			inode->i_extra_isize + sizeof(__u32);
> +		entry = start;
> +		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> +			if (!entry->e_value_block && entry->e_value_size) {
> +				unsigned int offs = entry->e_value_offs;
> +				if (offs < minoff)
> +					minoff = offs;
> +			}
> +			entry = EXT2_EXT_ATTR_NEXT(entry);
> +		}
> +		*size = minoff - ((char *)entry - (char *)start) - sizeof(__u32);
> +	} else {
> +		/* no xattr.  return a maximum size */
> +		*size = EXT2_EXT_ATTR_SIZE(minoff -
> +					   EXT2_EXT_ATTR_LEN(strlen("data")) -
> +					   EXT2_EXT_ATTR_ROUND - sizeof(__u32));
> +	}
> +
> +out:
> +	ext2fs_free_mem(&inode);
> +	return err;
> +}
> +
>  errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
>  			   const char *key,
>  			   const void *value,
> @@ -827,6 +892,17 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
>  	char *new_value;
>  	errcode_t err;
>  
> +	/* we need to check inline data space */
> +	if (strcmp(key, "system.data") == 0) {
> +		size_t max_size;
> +
> +		err = ext2fs_xattr_max_size(handle, &max_size);
> +		if (err)
> +			return err;
> +		if (value_len > max_size)
> +			return EXT2_ET_INLINE_DATA_NO_SPACE;
> +	}
> +
>  	last_empty = NULL;
>  	for (x = handle->attrs; x < handle->attrs + handle->length; x++) {
>  		if (!x->name) {
> diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
> index 02e6263..acb705d 100644
> --- a/lib/ext2fs/fileio.c
> +++ b/lib/ext2fs/fileio.c
> @@ -224,6 +224,39 @@ errcode_t ext2fs_file_close(ext2_file_t file)
>  }
>  
>  
> +static errcode_t
> +ext2fs_file_read_inline_data(ext2_file_t file, void *buf,
> +			     unsigned int wanted, unsigned int *got)
> +{
> +	ext2_filsys fs;
> +	errcode_t retval;
> +	unsigned int start, count = 0;
> +	size_t size;
> +
> +	fs = file->fs;
> +	retval = ext2fs_inline_data_get(fs, file->ino, &file->inode,
> +					file->buf, &size);
> +	if (retval)
> +		return retval;
> +
> +	if (file->pos >= size)
> +		goto out;
> +
> +	start = file->pos % size;

If file->pos can never be larger than size, this is unnecessary.

> +	count = size - start;
> +	if (count > wanted)
> +		count = wanted;
> +	memcpy(buf, file->buf + start, count);
> +	file->pos += count;
> +	buf += count;
> +
> +out:
> +	if (got)
> +		*got = count;
> +	return retval;
> +}
> +
> +
>  errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
>  			   unsigned int wanted, unsigned int *got)
>  {
> @@ -236,6 +269,10 @@ errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
>  	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
>  	fs = file->fs;
>  
> +	/* If an inode has inline data, things get complicated. */
> +	if (file->inode.i_flags & EXT4_INLINE_DATA_FL)
> +		return ext2fs_file_read_inline_data(file, buf, wanted, got);
> +
>  	while ((file->pos < EXT2_I_SIZE(&file->inode)) && (wanted > 0)) {
>  		retval = sync_buffer_position(file);
>  		if (retval)
> @@ -266,6 +303,67 @@ fail:
>  }
>  
>  
> +static errcode_t
> +ext2fs_file_write_inline_data(ext2_file_t file, const void *buf,
> +			      unsigned int nbytes, unsigned int *written)
> +{
> +	ext2_filsys fs;
> +	errcode_t retval;
> +	unsigned int start, count = 0;
> +	size_t size;
> +
> +	fs = file->fs;
> +	retval = ext2fs_inline_data_get(fs, file->ino, &file->inode,
> +					file->buf, &size);
> +	if (retval)
> +		return retval;
> +
> +	if (file->pos < size) {
> +		start = file->pos % fs->blocksize;

Since we're not dealing with blocks, I don't think you need to '%' with the
block size.

--D

> +		count = nbytes - start;
> +		memcpy(file->buf + start, buf, count);
> +
> +		retval = ext2fs_inline_data_set(fs, file->ino, &file->inode,
> +						file->buf, count);
> +		if (retval == EXT2_ET_INLINE_DATA_NO_SPACE)
> +			goto expand;
> +		if (retval)
> +			return retval;
> +
> +		file->pos += count;
> +
> +		/* Update inode size */
> +		if (count != 0 && EXT2_I_SIZE(&file->inode) < file->pos) {
> +			errcode_t	rc;
> +
> +			rc = ext2fs_file_set_size2(file, file->pos);
> +			if (retval == 0)
> +				retval = rc;
> +		}
> +
> +		if (written)
> +			*written = count;
> +		return 0;
> +	}
> +
> +expand:
> +	retval = ext2fs_inline_data_expand(fs, file->ino);
> +	if (retval)
> +		return retval;
> +	/*
> +	 * reload inode and return no space error
> +	 *
> +	 * XXX: file->inode could be copied from the outside
> +	 * in ext2fs_file_open2().  We have no way to modify
> +	 * the outside inode.
> +	 */
> +	retval = ext2fs_read_inode(fs, file->ino, &file->inode);
> +	if (retval)
> +		return retval;
> +	return EXT2_ET_INLINE_DATA_NO_SPACE;
> +}
> +
> +
>  errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
>  			    unsigned int nbytes, unsigned int *written)
>  {
> @@ -280,6 +378,16 @@ errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
>  	if (!(file->flags & EXT2_FILE_WRITE))
>  		return EXT2_ET_FILE_RO;
>  
> +	/* If an inode has inline data, things get complicated. */
> +	if (file->inode.i_flags & EXT4_INLINE_DATA_FL) {
> +		retval = ext2fs_file_write_inline_data(file, buf, nbytes,
> +						       written);
> +		if (retval != EXT2_ET_INLINE_DATA_NO_SPACE)
> +			return retval;
> +		/* fall through to read data from the block */
> +		retval = 0;
> +	}
> +
>  	while (nbytes > 0) {
>  		retval = sync_buffer_position(file);
>  		if (retval)
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 16af814..4a35209 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -309,6 +309,7 @@ errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
>  	struct ext2_inline_data data;
>  	errcode_t retval;
>  	blk64_t blk;
> +	size_t inline_size;
>  	char *inline_buf = 0;
>  	char *blk_buf = 0;
>  
> @@ -327,8 +328,8 @@ errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
>  	retval = ext2fs_inline_data_ea_get(&data);
>  	if (retval)
>  		return retval;
> -	retval = ext2fs_get_mem(EXT4_MIN_INLINE_DATA_SIZE + data.ea_size,
> -				&inline_buf);
> +	inline_size = data.ea_size + EXT4_MIN_INLINE_DATA_SIZE;
> +	retval = ext2fs_get_mem(inline_size, &inline_buf);
>  	if (retval)
>  		goto errout;
>  
> @@ -347,10 +348,14 @@ errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
>  	if (retval)
>  		goto errout;
>  
> -	/* Adjust the rec_len */
> -	retval = ext2fs_inline_data_convert_dir(fs, ino, blk_buf, inline_buf,
> -						EXT4_MIN_INLINE_DATA_SIZE +
> -							data.ea_size);
> +	if (LINUX_S_ISDIR(inode.i_mode)) {
> +		/* Adjust the rec_len */
> +		retval = ext2fs_inline_data_convert_dir(fs, ino, blk_buf,
> +							inline_buf, inline_size);
> +	} else {
> +		/* Copy data for a regular inode */
> +		memcpy(blk_buf, inline_buf, inline_size);
> +	}
>  	if (retval)
>  		goto errout;
>  
> @@ -389,3 +394,76 @@ errout:
>  	ext2fs_free_mem(&data.ea_data);
>  	return retval;
>  }
> +
> +/*
> + * When caller uses this function to retrieve the inline data, it must
> + * allocate a buffer which has the size of inline data.  The size of
> + * inline data can be know by ext2fs_inline_data_get_size().
> + */
> +errcode_t ext2fs_inline_data_get(ext2_filsys fs, ext2_ino_t ino,
> +				 struct ext2_inode *inode,
> +				 void *buf, size_t *size)
> +{
> +	struct ext2_inode inode_buf;
> +	struct ext2_inline_data data;
> +	errcode_t retval;
> +
> +	if (!inode) {
> +		retval = ext2fs_read_inode(fs, ino, &inode_buf);
> +		if (retval)
> +			return retval;
> +		inode = &inode_buf;
> +	}
> +
> +	data.fs = fs;
> +	data.ino = ino;
> +	retval = ext2fs_inline_data_ea_get(&data);
> +	if (retval)
> +		return retval;
> +
> +	memcpy(buf, (void *)inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
> +	if (data.ea_size > 0)
> +		memcpy(buf + EXT4_MIN_INLINE_DATA_SIZE,
> +		       data.ea_data, data.ea_size);
> +
> +	if (size)
> +		*size = EXT4_MIN_INLINE_DATA_SIZE + data.ea_size;
> +	ext2fs_free_mem(&data.ea_data);
> +	return 0;
> +}
> +
> +errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
> +				 struct ext2_inode *inode,
> +				 void *buf, size_t size)
> +{
> +	struct ext2_inode inode_buf;
> +	struct ext2_inline_data data;
> +	unsigned int max_size = 0;
> +	errcode_t retval;
> +
> +	if (!inode) {
> +		retval = ext2fs_read_inode(fs, ino, &inode_buf);
> +		if (retval)
> +			return retval;
> +		inode = &inode_buf;
> +	}
> +
> +	/* simple case */
> +	if (size <= EXT4_MIN_INLINE_DATA_SIZE) {
> +		memcpy((void *)inode->i_block, buf, size);
> +		return ext2fs_write_inode(fs, ino, inode);
> +	}
> +
> +	/*
> +	 * complicated case
> +	 */
> +	memcpy((void *)inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);
> +	retval = ext2fs_write_inode(fs, ino, inode);
> +	if (retval)
> +		return retval;
> +	data.fs = fs;
> +	data.ino = ino;
> +	data.ea_size = size - EXT4_MIN_INLINE_DATA_SIZE;
> +	data.ea_data = buf + EXT4_MIN_INLINE_DATA_SIZE;
> +	return ext2fs_inline_data_ea_set(&data);
> +}
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
