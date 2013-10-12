From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 04/22] libext2fs: handle inline data in dir iterator
 function
Date: Sat, 12 Oct 2013 13:55:21 +0800
Message-ID: <20131012055521.GB6377@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-5-git-send-email-wenqing.lz@taobao.com>
 <20131011233342.GB20432@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48892 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3JLFx2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 01:53:28 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so5115216pbb.5
        for <linux-ext4@vger.kernel.org>; Fri, 11 Oct 2013 22:53:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131011233342.GB20432@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 11, 2013 at 04:33:42PM -0700, Darrick J. Wong wrote:
[..]
> > +errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
> > +			       ext2_ino_t ino,
> > +			       int flags,
> > +			       char *block_buf,
> > +			       int (*func)(ext2_filsys fs,
> > +					   char *buf,
> > +					   unsigned int buf_len,
> > +					   e2_blkcnt_t blockcnt,
> > +					   struct ext2_inode_large *inode,
> > +					   void *priv_data),
> > +			       void *priv_data)
> > +{
> > +	struct dir_context *ctx;
> > +	struct ext2_inode_large *inode;
> > +	struct ext2_dir_entry dirent;
> > +	struct inline_data data;
> > +	errcode_t retval = 0;
> > +	e2_blkcnt_t blockcnt = 0;
> > +	void *inline_start;
> > +	int inline_size;
> > +
> > +	ctx = (struct dir_context *)priv_data;
> > +
> > +	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
> > +	if (retval)
> > +		return retval;
> > +
> > +	retval = ext2fs_read_inode_full(fs, ino, (void *)inode,
> > +					EXT2_INODE_SIZE(fs->super));
> > +	if (retval)
> > +		goto out;
> > +
> > +	if (inode->i_size == 0)
> > +		goto out;
> > +
> > +	/* we first check '.' and '..' dir */
> > +	dirent.inode = ino;
> > +	dirent.name_len = 1;
> > +	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
> > +	dirent.name[0] = '.';
> > +	dirent.name[1] = '\0';
> > +	retval |= (*func)(fs, (void *)&dirent, dirent.rec_len, blockcnt++,
> > +			 inode, priv_data);
> > +	if (retval & BLOCK_ABORT)
> > +		goto out;
> > +
> > +	dirent.inode = (__u32)*inode->i_block;
> > +	dirent.name_len = 2;
> > +	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
> > +	dirent.name[0] = '.';
> > +	dirent.name[1] = '.';
> > +	dirent.name[2] = '\0';
> > +	retval |= (*func)(fs, (void *)&dirent, dirent.rec_len, blockcnt++,
> > +			 inode, priv_data);
> > +	if (retval & BLOCK_ABORT)
> > +		goto out;
> 
> Perhaps this function should be called ext2fs_inline_dirblock_iterate()?
> The name alone makes me think this function could work for regular inline_data
> files, if such things ever exist.

Fair enough.  I will fix it in next version.

Thanks,
                                                - Zheng

> 
> --D
> 
> > +
> > +	inline_start = (char *)inode->i_block + EXT4_INLINE_DATA_DOTDOT_SIZE;
> > +	inline_size = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
> > +	retval |= (*func)(fs, inline_start, inline_size, blockcnt++,
> > +			 inode, priv_data);
> > +	if (retval & BLOCK_ABORT)
> > +		goto out;
> > +
> > +	retval = ext2fs_inline_data_find(fs, inode, &data);
> > +	if (retval)
> > +		goto out;
> > +	if (data.inline_size > EXT4_MIN_INLINE_DATA_SIZE) {
> > +		inline_start = ext2fs_get_inline_xattr_pos(inode, &data);
> > +		inline_size = data.inline_size - EXT4_MIN_INLINE_DATA_SIZE;
> > +		retval |= (*func)(fs, inline_start, inline_size, blockcnt++,
> > +			 inode, priv_data);
> > +		if (retval & BLOCK_ABORT)
> > +			goto out;
> > +	}
> > +
> > +out:
> > +	retval |= BLOCK_ERROR;
> > +	ext2fs_free_mem(&inode);
> > +	return retval & BLOCK_ERROR ? ctx->errcode : 0;
> > +}
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
