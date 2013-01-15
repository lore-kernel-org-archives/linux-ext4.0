From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Tue, 15 Jan 2013 13:55:09 -0500
Message-ID: <20130115185509.GA17719@thunk.org>
References: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43540 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab3AOSzQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 13:55:16 -0500
Content-Disposition: inline
In-Reply-To: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 14, 2013 at 10:18:30PM +0800, Zheng Liu wrote:
> +static errcode_t ext2fs_file_llseek_data(ext2_file_t file, __u64 offset)
> +{
> +	int		ret_flags, flag = 1;
> +	ext2_filsys	fs = file->fs;
> +	errcode_t	retval;
> +
> +	/*
> +	 * If offset == EXT2_SEEK_OFFSET_INVALID, that means that
> +	 * the caller wants to find the data from file->pos.
> +	 */
> +	offset = offset != EXT2_SEEK_OFFSET_INVALID ? offset : file->pos;
> +	file->blockno = offset / fs->blocksize;
> +	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
> +		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
> +				      BMAP_BUFFER, 0, file->blockno,
> +				      &ret_flags, &file->physblock);

Using bmap will certainly work, although as an optimization we can do
much better for extents if we use the extents interface.  I won't
insist on this, though.  (We can always optimize this later).

       	  		     	 	- Ted
