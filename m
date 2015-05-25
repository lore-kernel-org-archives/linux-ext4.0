From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] libext2fs: Support for orphan file feature
Date: Mon, 25 May 2015 09:49:58 +0200
Message-ID: <20150525074958.GC2387@quack.suse.cz>
References: <1432294137-26078-1-git-send-email-jack@suse.cz>
 <1432294137-26078-2-git-send-email-jack@suse.cz>
 <20150522173521.GB830@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbbEYHuD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2015 03:50:03 -0400
Content-Disposition: inline
In-Reply-To: <20150522173521.GB830@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 22-05-15 10:35:21, Darrick J. Wong wrote:
> On Fri, May 22, 2015 at 01:28:54PM +0200, Jan Kara wrote:
...
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index 28c46701da29..1e303d5d59ca 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -555,7 +555,8 @@ typedef struct ext2_icount *ext2_icount_t;
> >  					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
> >  					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
> >  					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
> > -					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2)
> > +					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2|\
> > +					 EXT4_FEATURE_COMPAT_ORPHAN_FILE)
> >  
> >  #ifdef CONFIG_MMP
> >  #define EXT4_LIB_INCOMPAT_MMP		EXT4_FEATURE_INCOMPAT_MMP
> > @@ -589,7 +590,8 @@ typedef struct ext2_icount *ext2_icount_t;
> >  					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
> >  					 EXT4_LIB_RO_COMPAT_QUOTA|\
> >  					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
> > -					 EXT4_FEATURE_RO_COMPAT_READONLY)
> > +					 EXT4_FEATURE_RO_COMPAT_READONLY|\
> > +					 EXT4_FEATURE_RO_COMPAT_ORPHAN_PRESENT)
> >  
> >  /*
> >   * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
> > @@ -1512,6 +1514,19 @@ errcode_t ext2fs_get_data_io(ext2_filsys fs, io_channel *old_io);
> >  errcode_t ext2fs_set_data_io(ext2_filsys fs, io_channel new_io);
> >  errcode_t ext2fs_rewrite_to_io(ext2_filsys fs, io_channel new_io);
> >  
> > +/* orphan.c */
> > +/*
> > + * Minimum orphan file size (it must be at least 1 block and smaller one isn't
> > + * very useful).
> > + */
> > +#define EXT4_MIN_ORPHAN_FILE_SIZE 16384
> 
> What about 64k block size?  I guess it's fine not to use the whole block in
> this (non-default) configuration.

We round up file size to be a multiple of fs block size.

> > +struct mkorphan_info {
> > +	char *buf;
> > +	char *zerobuf;
> > +	blk_t num_blocks;
> > +	blk_t alloc_blocks;
> > +	errcode_t err;
> > +};
> > +
> > +static int mkorphan_proc(ext2_filsys	fs,
> > +			 blk64_t	*blocknr,
> > +			 e2_blkcnt_t	blockcnt,
> > +			 blk64_t	ref_block EXT2FS_ATTR((unused)),
> > +			 int		ref_offset EXT2FS_ATTR((unused)),
> > +			 void		*priv_data)
> > +{
> > +	struct mkorphan_info *oi = (struct mkorphan_info *)priv_data;
> > +	blk64_t new_blk;
> > +	errcode_t err;
> > +
> > +	err = ext2fs_new_block2(fs, 0, 0, &new_blk);
> 
> Hm.  I think this breaks the cluster allocation rules, since this allocates
> a new block for every logical block inside a cluster.

Yes, I didn't think of cluster allocation. Frankly, I have just mirrored
what a code creating journal does. If this is wrong, then that code needs
fixing as well ;)

> Hopefully ext2fs_fallocate will land soon, then we can get rid of open-coding
> file block allocation like this.  You'll still have to have the iterate3 loop
> to write out the appropriate block footer, but iirc the library call can be
> told to allocate written extents without zeroing the blocks, precisely for
> cases like these.

So should I wait for that or do you have any pointer to code which does
it correctly?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
