From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 1/2] ext2fs: add multi-mount protection (INCOMPAT_MMP)
Date: Fri, 29 Jul 2011 19:44:43 +0200
Message-ID: <4E32F18B.6000800@itwm.fraunhofer.de>
References: <1311937077-22262-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Johann Lombardi <johann@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:50886 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1G2Roy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jul 2011 13:44:54 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p6THiqIB032502
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jul 2011 19:44:52 +0200
In-Reply-To: <1311937077-22262-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas, Johann,

thanks a lot for sending those patches! From a previous review I still 
remember ext2fs_mmp_read(), see below.
I will look through the other parts later on.


> +errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
> +{
> +	struct mmp_struct *mmp_cmp;
> +	errcode_t retval = 0;
> +
> +	if ((mmp_blk<= fs->super->s_first_data_block) ||
> +	    (mmp_blk>= fs->super->s_blocks_count))
> +		return EXT2_ET_MMP_BAD_BLOCK;
> +
> +	if (fs->mmp_cmp == NULL) {
> +		/* O_DIRECT in linux 2.4: page aligned
> +		 * O_DIRECT in linux 2.6: sector aligned
> +		 * A filesystem cannot be created with blocksize<  sector size,
> +		 * or with blocksize>  page_size. */
> +		int bufsize = fs->blocksize;
> +
> +		if (bufsize<  mmp_pagesize())
> +			bufsize = mmp_pagesize();
> +		retval = ext2fs_get_memalign(bufsize, bufsize,&fs->mmp_cmp);
> +		if (retval)
> +			return retval;
> +	}
> +
> +	/* ext2fs_open reserves fd0,1,2 to avoid stdio collision */
> +	if (fs->mmp_fd<= 0) {
> +		fs->mmp_fd = open(fs->device_name, O_RDWR | O_DIRECT);
> +		if (fs->mmp_fd<  0) {
> +			retval = EXT2_ET_MMP_OPEN_DIRECT;
> +			goto out;
> +		}
> +	}
> +
> +	if (ext2fs_llseek(fs->mmp_fd, mmp_blk * fs->blocksize, SEEK_SET) !=
> +	    mmp_blk * fs->blocksize) {
> +		retval = EXT2_ET_LLSEEK_FAILED;
> +		goto out;
> +	}
> +
> +	if (read(fs->mmp_fd, fs->mmp_cmp, fs->blocksize) != fs->blocksize) {
> +		retval = EXT2_ET_SHORT_READ;
> +		goto out;
> +	}

While ext2fs_llseek() and read() works fine, I still wonder why the code 
does not use io_channel_read_blk64() here, similarly as 
io_channel_write_blk64() write in ext2fs_mmp_write().

> +
> +	mmp_cmp = fs->mmp_cmp;
> +#ifdef EXT2FS_ENABLE_SWAPFS
> +	if (fs->flags&  EXT2_FLAG_SWAP_BYTES)
> +		ext2fs_swap_mmp(mmp_cmp);
> +#endif
> +
> +	if (buf != NULL&&  buf != fs->mmp_cmp)
> +		memcpy(buf, fs->mmp_cmp, fs->blocksize);
> +
> +	if (mmp_cmp->mmp_magic != EXT4_MMP_MAGIC) {
> +		retval = EXT2_ET_MMP_MAGIC_INVALID;
> +		goto out;
> +	}
> +
> +out:
> +	return retval;
> +}
> +
> +errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
> +{
> +	struct mmp_struct *mmp_s = buf;
> +	struct timeval tv;
> +	errcode_t retval = 0;
> +
> +	gettimeofday(&tv, 0);
> +	mmp_s->mmp_time = tv.tv_sec;
> +	fs->mmp_last_written = tv.tv_sec;
> +
> +	if (fs->super->s_mmp_block<  fs->super->s_first_data_block ||
> +	    fs->super->s_mmp_block>  ext2fs_blocks_count(fs->super))
> +		return EXT2_ET_MMP_BAD_BLOCK;
> +
> +#ifdef EXT2FS_ENABLE_SWAPFS
> +	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
> +		ext2fs_swap_mmp(mmp_s);
> +#endif
> +
> +	/* I was tempted to make this use O_DIRECT and the mmp_fd, but
> +	 * this caused no end of grief, while leaving it as-is works. */
> +	retval = io_channel_write_blk64(fs->io, mmp_blk, -fs->blocksize, buf);
> +
> +#ifdef EXT2FS_ENABLE_SWAPFS
> +	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
> +		ext2fs_swap_mmp(mmp_s);
> +#endif
> +
> +	/* Make sure the block gets to disk quickly */
> +	io_channel_flush(fs->io);
> +	return retval;
> +}


Thanks,
Bernd
