From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 15/22] tune2fs: add inline_data feature in tune2fs
Date: Sat, 12 Oct 2013 16:16:38 +0800
Message-ID: <20131012081638.GB6462@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-16-git-send-email-wenqing.lz@taobao.com>
 <20131012003945.GW6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54941 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3JLIOq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Oct 2013 04:14:46 -0400
Received: by mail-pa0-f48.google.com with SMTP id bj1so5347484pad.7
        for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 01:14:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131012003945.GW6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 11, 2013 at 05:39:45PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 02, 2013 at 05:49:42PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Inline_data feature can be set when ext_attr feature is enabled.  Now this
> > feature only can be enabled because we may be out of space when disabling
> > it.  If this feature is disabled, we need to allocate a block for every
> > file and directory, and it might exhaust all space.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  misc/tune2fs.8.in |    5 +++++
> >  misc/tune2fs.c    |   17 ++++++++++++++++-
> >  2 files changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> > index 55c6dd9..b768fff 100644
> > --- a/misc/tune2fs.8.in
> > +++ b/misc/tune2fs.8.in
> > @@ -531,6 +531,11 @@ Setting the filesystem feature is equivalent to using the
> >  .B \-j
> >  option.
> >  .TP
> > +.B inline_data
> > +Allow data to be stored in inode.
> > +.B Tune2fs
> > +only supports setting this filesystem feature.
> > +.TP
> >  .B large_file
> >  Filesystem can contain files that are greater than 2GB.  (Modern kernels
> >  set this feature automatically when a file > 2GB is created.)
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index 7d6520e..f22a736 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -137,7 +137,8 @@ static __u32 ok_features[3] = {
> >  	EXT2_FEATURE_INCOMPAT_FILETYPE |
> >  		EXT3_FEATURE_INCOMPAT_EXTENTS |
> >  		EXT4_FEATURE_INCOMPAT_FLEX_BG |
> > -		EXT4_FEATURE_INCOMPAT_MMP,
> > +		EXT4_FEATURE_INCOMPAT_MMP |
> > +		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
> >  	/* R/O compat */
> >  	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
> >  		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
> > @@ -995,6 +996,20 @@ mmp_error:
> >  		disable_uninit_bg(fs,
> >  				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
> >  
> > +	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
> > +		       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
> > +		/* Inline_data feature cannot be enabled if ext_attr is
> > +		 * disabled.
> > +		 */
> 
> Multiline comment issue.
> 
> > +		if (!(fs->super->s_feature_compat &
> > +		      EXT2_FEATURE_COMPAT_EXT_ATTR)) {
> 
> EXT2_HAS_COMPAT_FEATURE()?
> 
> > +			fputs(_("The inline_data feature cannot "
> > +				"be set if ext_attr feature is disabled.\n"),
> > +				stderr);
> > +			return 1;
> > +		}
> > +	}
> > +
> 
> Maybe I'm missing something, but I don't see anything prohibiting the user from
> disabling inline_data?  Or from doing the conversion?

Yes, now in tune2fs we can only enable inline_data feature.  If we want
to disable inline_data, that means that we need to allocate a block for
every inode with inline data, and we could exhaust all disk space.
Another implementation might be just clear inline_data flag from
super_block and doesn't allocate a block for these inodes.  The former
obviously is not a good choice.  But the latter might be better.  I am
really not sure for this.  What do you think?

Thanks,
                                                - Zheng
