From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 20/28] tune2fs: add inline_data feature in tune2fs
Date: Wed, 4 Dec 2013 11:55:36 +0800
Message-ID: <20131204035536.GD20409@gmail.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-21-git-send-email-wenqing.lz@taobao.com>
 <20131203222946.GH9535@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45432 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3LDDwj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 22:52:39 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so22584796pbb.14
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 19:52:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131203222946.GH9535@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 02:29:46PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 03, 2013 at 08:11:47PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Inline_data can be enabled without ext_attr.  Hence we don't check it.
> > As doing in mke2fs we need to check inode size.
> > 
> > Now this feature only can be enabled because we may be out of space when
> > disabling it.  If this feature is disabled, we need to allocate a block
> > for every file and directory, and it might exhaust all space.
> 
> Could we at least try to turn off inlinedata and decline to clear the flag if
> we ENOSPC?

If we want to turn off inline_data, that means that we need to scan all
used inodes and try to expand it.  It isn't hard but I am wondering if
someone really want to disable this feature.  In my opinion, I really
want to enable inline_data feature by default when we believe it is very
stable because it will benefit for all desktop and Android users.

                                                - Zheng

> 
> (Yes, that's more of a TODO feature request...)
> 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  misc/tune2fs.8.in |    5 +++++
> >  misc/tune2fs.c    |   16 +++++++++++++++-
> >  2 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> > index 55c6dd9..78f965b 100644
> > --- a/misc/tune2fs.8.in
> > +++ b/misc/tune2fs.8.in
> > @@ -531,6 +531,11 @@ Setting the filesystem feature is equivalent to using the
> >  .B \-j
> >  option.
> >  .TP
> > +.B inline_data
> > +Allow data to be stored in the inode and extented attribute area.
> 
> "extended"
> 
> --D
> 
> > +.B Tune2fs
> > +only supports setting this filesystem feature.
> > +.TP
> >  .B large_file
> >  Filesystem can contain files that are greater than 2GB.  (Modern kernels
> >  set this feature automatically when a file > 2GB is created.)
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index 95c1886..1952081 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -140,7 +140,8 @@ static __u32 ok_features[3] = {
> >  	EXT2_FEATURE_INCOMPAT_FILETYPE |
> >  		EXT3_FEATURE_INCOMPAT_EXTENTS |
> >  		EXT4_FEATURE_INCOMPAT_FLEX_BG |
> > -		EXT4_FEATURE_INCOMPAT_MMP,
> > +		EXT4_FEATURE_INCOMPAT_MMP |
> > +		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
> >  	/* R/O compat */
> >  	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
> >  		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
> > @@ -1083,6 +1084,19 @@ mmp_error:
> >  		disable_uninit_bg(fs,
> >  				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
> >  
> > +	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
> > +		       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
> > +		/*
> > +		 * Check inode size.  If inode size is 128, tell user that
> > +		 * inline data is useless.
> > +		 */
> > +		if (EXT2_INODE_SIZE(fs->super) == EXT2_GOOD_OLD_INODE_SIZE) {
> > +			fputs(_("The inode size is too small to "
> > +				"store inline data.\n"), stderr);
> > +			return 1;
> > +		}
> > +	}
> > +
> >  	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
> >  				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
> >  		/*
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
