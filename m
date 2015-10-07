From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: don't mount filesystems with compat features we
 know only ext4 supports
Date: Wed, 7 Oct 2015 15:29:55 +0200
Message-ID: <20151007132955.GA7634@quack.suse.cz>
References: <20150928223626.GI10390@birch.djwong.org>
 <20150930084126.GB16909@quack.suse.cz>
 <20150930163635.GK10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbbJGN37 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Oct 2015 09:29:59 -0400
Content-Disposition: inline
In-Reply-To: <20150930163635.GK10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 30-09-15 09:36:35, Darrick J. Wong wrote:
> On Wed, Sep 30, 2015 at 10:41:26AM +0200, Jan Kara wrote:
> > On Mon 28-09-15 15:36:26, Darrick J. Wong wrote:
> > > The ext2 mount code never checks the compat features against the ones
> > > it knows about.  This is correct behavior since compat features are
> > > supposed to be rw-compatible with old drivers; however, for certain
> > > configurations (journalled rootfs) we probably want the ext4 driver
> > > to load, not ext2.
> > > 
> > > Reported-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Isn't this a bit too harsh? I agree we should at least warn (and that's
> > probably regardless of EXT4 config option) but just refusing mount looks
> > too much to me...
> 
> I admit that refusing the mount might be a bit much; the goal here was
> merely to make it so that if the FS has a journal and ext4 was turned on,
> hopefully ext2 rejects the mount and ext4 will probe it next.
> 
> <shrug>

OK, after some more thought about this I agree that your solution is
probably the best. I'd say it's exceedingly rare that someone would like to
mount ext3 filesystem using ext2 driver when he has ext4 available.
Definitely more rare than someone wanting to mount clean ext3 filesystem
and unexpectedly using ext2 driver for that. So my:

Acked-by: Jan Kara <jack@suse.com>

Ted, can you please pick up the patch? Thanks!

								Honza
> > > ---
> > >  fs/ext2/ext2.h  |    6 +++++-
> > >  fs/ext2/super.c |   13 ++++++++++---
> > >  2 files changed, 15 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> > > index 8d15feb..ce508b1 100644
> > > --- a/fs/ext2/ext2.h
> > > +++ b/fs/ext2/ext2.h
> > > @@ -547,7 +547,11 @@ struct ext2_super_block {
> > >  #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
> > >  #define EXT2_FEATURE_INCOMPAT_ANY		0xffffffff
> > >  
> > > -#define EXT2_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
> > > +#define EXT2_FEATURE_COMPAT_SUPP	(EXT2_FEATURE_COMPAT_DIR_PREALLOC| \
> > > +					 EXT2_FEATURE_COMPAT_IMAGIC_INODES| \
> > > +					 EXT2_FEATURE_COMPAT_EXT_ATTR| \
> > > +					 EXT2_FEATURE_COMPAT_RESIZE_INO| \
> > > +					 EXT2_FEATURE_COMPAT_DIR_INDEX)
> > >  #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
> > >  					 EXT2_FEATURE_INCOMPAT_META_BG)
> > >  #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
> > > diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> > > index 900e19c..4efb018 100644
> > > --- a/fs/ext2/super.c
> > > +++ b/fs/ext2/super.c
> > > @@ -896,6 +896,16 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> > >  	 * previously didn't change the revision level when setting the flags,
> > >  	 * so there is a chance incompat flags are set on a rev 0 filesystem.
> > >  	 */
> > > +#ifdef CONFIG_EXT4_FS
> > > +	/* Journalled FS should mount with ext4 if it's available */
> > > +	features = EXT2_HAS_COMPAT_FEATURE(sb, ~EXT2_FEATURE_COMPAT_SUPP);
> > > +	if (features) {
> > > +		ext2_msg(sb, KERN_ERR,	"error: won't mount because of "
> > > +		       "unsupported optional features (%x); try ext4",
> > > +			le32_to_cpu(features));
> > > +		goto failed_mount;
> > > +	}
> > > +#endif
> > >  	features = EXT2_HAS_INCOMPAT_FEATURE(sb, ~EXT2_FEATURE_INCOMPAT_SUPP);
> > >  	if (features) {
> > >  		ext2_msg(sb, KERN_ERR,	"error: couldn't mount because of "
> > > 
> > -- 
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
