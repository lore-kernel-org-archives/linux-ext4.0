From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2 v2] libext2fs: introduce lseek SEEK_DATA/HOLE
Date: Wed, 16 Jan 2013 20:04:56 +0800
Message-ID: <20130116120455.GA21029@gmail.com>
References: <1358173111-10511-1-git-send-email-wenqing.lz@taobao.com>
 <20130115185509.GA17719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54056 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3APLvK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2013 06:51:10 -0500
Received: by mail-pb0-f54.google.com with SMTP id wz12so684739pbc.27
        for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2013 03:51:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130115185509.GA17719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2013 at 01:55:09PM -0500, Theodore Ts'o wrote:
> On Mon, Jan 14, 2013 at 10:18:30PM +0800, Zheng Liu wrote:
> > +static errcode_t ext2fs_file_llseek_data(ext2_file_t file, __u64 offset)
> > +{
> > +	int		ret_flags, flag = 1;
> > +	ext2_filsys	fs = file->fs;
> > +	errcode_t	retval;
> > +
> > +	/*
> > +	 * If offset == EXT2_SEEK_OFFSET_INVALID, that means that
> > +	 * the caller wants to find the data from file->pos.
> > +	 */
> > +	offset = offset != EXT2_SEEK_OFFSET_INVALID ? offset : file->pos;
> > +	file->blockno = offset / fs->blocksize;
> > +	while (file->blockno * fs->blocksize < EXT2_I_SIZE(&file->inode)) {
> > +		retval = ext2fs_bmap2(fs, file->ino, &file->inode,
> > +				      BMAP_BUFFER, 0, file->blockno,
> > +				      &ret_flags, &file->physblock);
> 
> Using bmap will certainly work, although as an optimization we can do
> much better for extents if we use the extents interface.  I won't
> insist on this, though.  (We can always optimize this later).

Yeah, it allows us to skip to the next data/hole directly if the extents
interface is used.  But if we do that, we will need to handle
extent-based file and indirect-based file resptively like this.

        if (inode->i_flags & EXT4_EXTENTS_FL) {
                ext2fs_file_ext_llseek_data();
                ...
        } else {
                ext2fs_file_ind_llseek_data();
                ...
        }

I am not sure whether it is too complicated or not for us.  What do you
think?

Thanks,
                                                - Zheng
