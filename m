From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 12/28] debugfs: make expand command support inline data
Date: Wed, 4 Dec 2013 11:42:12 +0800
Message-ID: <20131204034212.GA20409@gmail.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-13-git-send-email-wenqing.lz@taobao.com>
 <20131203211954.GE9535@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61249 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3LDDjV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 22:39:21 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so21450145pdj.36
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 19:39:21 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131203211954.GE9535@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 01:19:54PM -0800, Darrick J. Wong wrote:
[...]
> > +errcode_t ext2fs_inline_data_expand(ext2_filsys fs, ext2_ino_t ino)
> 
> I couldn't tell from the name that this function only expands inline
> directories.  A name like ext2fs_inline_dir_expand() would make that more
> immediately clear; initially I thought this could be a method that also expands
> files.

Your initially thought is right.  This function will expand a directory
or a file.  In this commit, it just handles directory because it is only
used by ext2fs_expand_dir().  Later commit will let it handle a file.
Sorry, I don't clarify this.

> 
> > +{
> > +	struct ext2_inode inode;
> > +	struct ext2_inline_data data;
> > +	errcode_t retval;
> > +	blk64_t blk;
> > +	char *inline_buf = 0;
> > +	char *blk_buf = 0;
> > +
> > +	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> > +
> > +	retval = ext2fs_read_inode(fs, ino, &inode);
> > +	if (retval)
> > +		return retval;
> > +
> > +	if (!(inode.i_flags & EXT4_INLINE_DATA_FL))
> > +		return EXT2_ET_NO_INLINE_DATA;
> > +
> > +	/* Get inline data first */
> > +	data.fs = fs;
> > +	data.ino = ino;
> > +	retval = ext2fs_inline_data_ea_get(&data);
> > +	if (retval)
> > +		return retval;
> > +	retval = ext2fs_get_mem(EXT4_MIN_INLINE_DATA_SIZE + data.ea_size,
> > +				&inline_buf);
> > +	if (retval)
> > +		goto errout;
> > +
> > +	memcpy(inline_buf, (void *)inode.i_block, EXT4_MIN_INLINE_DATA_SIZE);
> > +	if (data.ea_size > 0) {
> > +		memcpy(inline_buf + EXT4_MIN_INLINE_DATA_SIZE,
> > +		       data.ea_data, data.ea_size);
> > +	}
> > +
> > +	memset((void *)inode.i_block, 0, EXT4_MIN_INLINE_DATA_SIZE);
> > +	retval = ext2fs_inline_data_ea_remove(fs, ino);
> > +	if (retval)
> > +		goto errout;
> > +
> > +	retval = ext2fs_get_mem(fs->blocksize, &blk_buf);
> > +	if (retval)
> > +		goto errout;
> > +
> > +	/* Adjust the rec_len */
> > +	retval = ext2fs_inline_data_convert_dir(fs, ino, blk_buf, inline_buf,
> > +						EXT4_MIN_INLINE_DATA_SIZE +
> > +							data.ea_size);
> > +	if (retval)
> > +		goto errout;
> > +
> > +	/* Allocate a new block */
> > +	retval = ext2fs_new_block2(fs, 0, 0, &blk);
> > +	if (retval)
> > +		goto errout;
> > +	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT3_FEATURE_INCOMPAT_EXTENTS))
> > +		inode.i_flags |= EXT4_EXTENTS_FL;
> > +	else
> > +		inode.i_block[0] = blk;
> > +	inode.i_flags &= ~EXT4_INLINE_DATA_FL;
> > +	ext2fs_iblk_set(fs, &inode, 1);
> > +	inode.i_size = fs->blocksize;
> > +	retval = ext2fs_write_inode(fs, ino, &inode);
> > +	if (retval)
> > +		goto errout;
> > +	retval = ext2fs_write_dir_block4(fs, blk, blk_buf, 0, ino);
> > +	if (retval)
> > +		goto errout;
> > +	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT3_FEATURE_INCOMPAT_EXTENTS)) {
> > +		ext2_extent_handle_t handle;
> > +
> > +		retval = ext2fs_extent_open2(fs, ino, &inode, &handle);
> > +		if (retval)
> > +			goto errout;
> > +		retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
> > +		ext2fs_extent_free(handle);
> > +	}
> 
> Would it be simpler to call ext2fs_bmap2() with bmap_flags = BMAP_SET here?
> Then you wouldn't need to open code the blockmap and extent setting cases.
> Then all you have to do is:
> 
> if (fs_has_extents)
> 	inode.i_flags |= EXT4_EXTENTS_FL;
> ext2fs_bmap2(fs, ino, &inode, NULL, BMAP_SET, 0, NULL, &blk);
> ext2fs_write_inode(...);

Yes, I remember that you have advised me to use this function in first
version.  I will fix it.

Thanks,
                                                - Zheng
