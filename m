From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 17/28] libext2fs: handle inline data in read/write
 function
Date: Wed, 4 Dec 2013 11:47:58 +0800
Message-ID: <20131204034757.GC20409@gmail.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-18-git-send-email-wenqing.lz@taobao.com>
 <20131204030242.GJ9535@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38928 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LDDpB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 22:45:01 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so22372943pbc.6
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 19:45:01 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131204030242.GJ9535@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 07:02:42PM -0800, Darrick J. Wong wrote:
[...]
> > +static errcode_t
> > +ext2fs_file_read_inline_data(ext2_file_t file, void *buf,
> > +			     unsigned int wanted, unsigned int *got)
> > +{
> > +	ext2_filsys fs;
> > +	errcode_t retval;
> > +	unsigned int start, count = 0;
> > +	size_t size;
> > +
> > +	fs = file->fs;
> > +	retval = ext2fs_inline_data_get(fs, file->ino, &file->inode,
> > +					file->buf, &size);
> > +	if (retval)
> > +		return retval;
> > +
> > +	if (file->pos >= size)
> > +		goto out;
> > +
> > +	start = file->pos % size;
> 
> If file->pos can never be larger than size, this is unnecessary.

Good catch!  I will fix it soon.

Thanks,
                                                - Zheng

> 
> > +	count = size - start;
> > +	if (count > wanted)
> > +		count = wanted;
> > +	memcpy(buf, file->buf + start, count);
> > +	file->pos += count;
> > +	buf += count;
> > +
> > +out:
> > +	if (got)
> > +		*got = count;
> > +	return retval;
> > +}
> > +
> > +
> >  errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
> >  			   unsigned int wanted, unsigned int *got)
> >  {
> > @@ -236,6 +269,10 @@ errcode_t ext2fs_file_read(ext2_file_t file, void *buf,
> >  	EXT2_CHECK_MAGIC(file, EXT2_ET_MAGIC_EXT2_FILE);
> >  	fs = file->fs;
> >  
> > +	/* If an inode has inline data, things get complicated. */
> > +	if (file->inode.i_flags & EXT4_INLINE_DATA_FL)
> > +		return ext2fs_file_read_inline_data(file, buf, wanted, got);
> > +
> >  	while ((file->pos < EXT2_I_SIZE(&file->inode)) && (wanted > 0)) {
> >  		retval = sync_buffer_position(file);
> >  		if (retval)
> > @@ -266,6 +303,67 @@ fail:
> >  }
> >  
> >  
> > +static errcode_t
> > +ext2fs_file_write_inline_data(ext2_file_t file, const void *buf,
> > +			      unsigned int nbytes, unsigned int *written)
> > +{
> > +	ext2_filsys fs;
> > +	errcode_t retval;
> > +	unsigned int start, count = 0;
> > +	size_t size;
> > +
> > +	fs = file->fs;
> > +	retval = ext2fs_inline_data_get(fs, file->ino, &file->inode,
> > +					file->buf, &size);
> > +	if (retval)
> > +		return retval;
> > +
> > +	if (file->pos < size) {
> > +		start = file->pos % fs->blocksize;
> 
> Since we're not dealing with blocks, I don't think you need to '%' with the
> block size.
> 
> --D
> 
> > +		count = nbytes - start;
> > +		memcpy(file->buf + start, buf, count);
> > +
> > +		retval = ext2fs_inline_data_set(fs, file->ino, &file->inode,
> > +						file->buf, count);
> > +		if (retval == EXT2_ET_INLINE_DATA_NO_SPACE)
> > +			goto expand;
> > +		if (retval)
> > +			return retval;
> > +
> > +		file->pos += count;
> > +
> > +		/* Update inode size */
> > +		if (count != 0 && EXT2_I_SIZE(&file->inode) < file->pos) {
> > +			errcode_t	rc;
> > +
> > +			rc = ext2fs_file_set_size2(file, file->pos);
> > +			if (retval == 0)
> > +				retval = rc;
> > +		}
> > +
> > +		if (written)
> > +			*written = count;
> > +		return 0;
> > +	}
> > +
> > +expand:
> > +	retval = ext2fs_inline_data_expand(fs, file->ino);
> > +	if (retval)
> > +		return retval;
> > +	/*
> > +	 * reload inode and return no space error
> > +	 *
> > +	 * XXX: file->inode could be copied from the outside
> > +	 * in ext2fs_file_open2().  We have no way to modify
> > +	 * the outside inode.
> > +	 */
> > +	retval = ext2fs_read_inode(fs, file->ino, &file->inode);
> > +	if (retval)
> > +		return retval;
> > +	return EXT2_ET_INLINE_DATA_NO_SPACE;
> > +}
> > +
> > +
> >  errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
> >  			    unsigned int nbytes, unsigned int *written)
> >  {
> > @@ -280,6 +378,16 @@ errcode_t ext2fs_file_write(ext2_file_t file, const void *buf,
> >  	if (!(file->flags & EXT2_FILE_WRITE))
> >  		return EXT2_ET_FILE_RO;
> >  
> > +	/* If an inode has inline data, things get complicated. */
> > +	if (file->inode.i_flags & EXT4_INLINE_DATA_FL) {
> > +		retval = ext2fs_file_write_inline_data(file, buf, nbytes,
> > +						       written);
> > +		if (retval != EXT2_ET_INLINE_DATA_NO_SPACE)
> > +			return retval;
> > +		/* fall through to read data from the block */
> > +		retval = 0;
> > +	}
> > +
> >  	while (nbytes > 0) {
> >  		retval = sync_buffer_position(file);
> >  		if (retval)
> > diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> > index 16af814..4a35209 100644
> > --- a/lib/ext2fs/inline_data.c
> > +++ b/lib/ext2fs/inline_data.c
> > @@ -309,6 +309,7 @@ errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
> >  	struct ext2_inline_data data;
> >  	errcode_t retval;
> >  	blk64_t blk;
> > +	size_t inline_size;
> >  	char *inline_buf = 0;
> >  	char *blk_buf = 0;
> >  
> > @@ -327,8 +328,8 @@ errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
> >  	retval = ext2fs_inline_data_ea_get(&data);
> >  	if (retval)
> >  		return retval;
> > -	retval = ext2fs_get_mem(EXT4_MIN_INLINE_DATA_SIZE + data.ea_size,
> > -				&inline_buf);
> > +	inline_size = data.ea_size + EXT4_MIN_INLINE_DATA_SIZE;
> > +	retval = ext2fs_get_mem(inline_size, &inline_buf);
> >  	if (retval)
> >  		goto errout;
> >  
> > @@ -347,10 +348,14 @@ errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
> >  	if (retval)
> >  		goto errout;
> >  
> > -	/* Adjust the rec_len */
> > -	retval = ext2fs_inline_data_convert_dir(fs, ino, blk_buf, inline_buf,
> > -						EXT4_MIN_INLINE_DATA_SIZE +
> > -							data.ea_size);
> > +	if (LINUX_S_ISDIR(inode.i_mode)) {
> > +		/* Adjust the rec_len */
> > +		retval = ext2fs_inline_data_convert_dir(fs, ino, blk_buf,
> > +							inline_buf, inline_size);
> > +	} else {
> > +		/* Copy data for a regular inode */
> > +		memcpy(blk_buf, inline_buf, inline_size);
> > +	}
> >  	if (retval)
> >  		goto errout;
> >  
> > @@ -389,3 +394,76 @@ errout:
> >  	ext2fs_free_mem(&data.ea_data);
> >  	return retval;
> >  }
> > +
> > +/*
> > + * When caller uses this function to retrieve the inline data, it must
> > + * allocate a buffer which has the size of inline data.  The size of
> > + * inline data can be know by ext2fs_inline_data_get_size().
> > + */
> > +errcode_t ext2fs_inline_data_get(ext2_filsys fs, ext2_ino_t ino,
> > +				 struct ext2_inode *inode,
> > +				 void *buf, size_t *size)
> > +{
> > +	struct ext2_inode inode_buf;
> > +	struct ext2_inline_data data;
> > +	errcode_t retval;
> > +
> > +	if (!inode) {
> > +		retval = ext2fs_read_inode(fs, ino, &inode_buf);
> > +		if (retval)
> > +			return retval;
> > +		inode = &inode_buf;
> > +	}
> > +
> > +	data.fs = fs;
> > +	data.ino = ino;
> > +	retval = ext2fs_inline_data_ea_get(&data);
> > +	if (retval)
> > +		return retval;
> > +
> > +	memcpy(buf, (void *)inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
> > +	if (data.ea_size > 0)
> > +		memcpy(buf + EXT4_MIN_INLINE_DATA_SIZE,
> > +		       data.ea_data, data.ea_size);
> > +
> > +	if (size)
> > +		*size = EXT4_MIN_INLINE_DATA_SIZE + data.ea_size;
> > +	ext2fs_free_mem(&data.ea_data);
> > +	return 0;
> > +}
> > +
> > +errcode_t ext2fs_inline_data_set(ext2_filsys fs, ext2_ino_t ino,
> > +				 struct ext2_inode *inode,
> > +				 void *buf, size_t size)
> > +{
> > +	struct ext2_inode inode_buf;
> > +	struct ext2_inline_data data;
> > +	unsigned int max_size = 0;
> > +	errcode_t retval;
> > +
> > +	if (!inode) {
> > +		retval = ext2fs_read_inode(fs, ino, &inode_buf);
> > +		if (retval)
> > +			return retval;
> > +		inode = &inode_buf;
> > +	}
> > +
> > +	/* simple case */
> > +	if (size <= EXT4_MIN_INLINE_DATA_SIZE) {
> > +		memcpy((void *)inode->i_block, buf, size);
> > +		return ext2fs_write_inode(fs, ino, inode);
> > +	}
> > +
> > +	/*
> > +	 * complicated case
> > +	 */
> > +	memcpy((void *)inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);
> > +	retval = ext2fs_write_inode(fs, ino, inode);
> > +	if (retval)
> > +		return retval;
> > +	data.fs = fs;
> > +	data.ino = ino;
> > +	data.ea_size = size - EXT4_MIN_INLINE_DATA_SIZE;
> > +	data.ea_data = buf + EXT4_MIN_INLINE_DATA_SIZE;
> > +	return ext2fs_inline_data_ea_set(&data);
> > +}
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
