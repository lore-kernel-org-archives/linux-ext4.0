From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 19/22] e2fsck: check inline_data in pass3
Date: Sat, 12 Oct 2013 17:06:35 +0800
Message-ID: <20131012090635.GG6462@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-20-git-send-email-wenqing.lz@taobao.com>
 <20131012005410.GY6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41944 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3JLJEl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 05:04:41 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so5311407pdi.41
        for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 02:04:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131012005410.GY6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 11, 2013 at 05:54:10PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 02, 2013 at 05:49:46PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > In e2fsck_expand_directory() we don't handle a dir with inline data
> > because when this function is called the directory inode shouldn't
> > contains inline data.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  e2fsck/pass3.c  |   12 ++++++++++++
> >  e2fsck/rehash.c |    3 ++-
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
> > index a379e9b..5052345 100644
> > --- a/e2fsck/pass3.c
> > +++ b/e2fsck/pass3.c
> > @@ -787,6 +787,18 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
> >  	es.ctx = ctx;
> >  	es.dir = dir;
> >  
> > +	/*
> > +	 * 'lost+found' dir shouldn't contains inline data.  So we
> > +	 * need to clear this flag.
> > +	 */
> > +	if (ext2fs_inode_has_inline_data(fs, dir)) {
> > +		retval = ext2fs_read_inode(fs, dir, &inode);
> > +		if (retval)
> > +			return retval;
> > +		inode.i_flags &= ~EXT4_INLINE_DATA_FL;
> > +		e2fsck_write_inode(ctx, dir, &inode, "clear inline_data flag");
> > +	}
> > +
> >  	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
> >  				       0, expand_dir_proc, &es);
> 
> Are you saying that lost+found can have inline_data set yet i_blocks is
> actually a block map/extent head?  Or are we supposed to zero i_blocks?
> 
> If we clear EXT4_INLINE_DATA_FL and then try to iterate blocks, are we setting
> ourselves up to read (formerly inline) dirents as a block map and iterate it?
> 
> Shouldn't we care if the inode write fails?

lost+found dir shouldn't have inline_data flag because this is a special
directory that it is preallocated some blocks when it is created because
we need to avoid to allocate some blocks for it when we check a file
system using e2fsck.  So we need to clear inline_data flag if this dir
has this flag.

                                                - Zheng
