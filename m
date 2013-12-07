From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v3 09/30] libext2fs: check inline_data in
 ext2fs_xattrs_read/write
Date: Sat, 7 Dec 2013 11:45:02 +0800
Message-ID: <20131207034502.GB13745@gmail.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
 <1386323897-2354-10-git-send-email-wenqing.lz@taobao.com>
 <20131206213826.GB10143@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56781 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3LGDmG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 22:42:06 -0500
Received: by mail-pd0-f181.google.com with SMTP id p10so2046672pdj.40
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 19:42:04 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131206213826.GB10143@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 06, 2013 at 01:38:26PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 06, 2013 at 05:57:56PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Now on kernel side we can enable inline data even without ext_attr.  So
> > we need to adjust sanity check on ext2fs_xattrs_read/write to let we
> > access extended attribute when filesystem is create with '-O ^ext_attr,
> > inline_data'.
> 
> Oops, I removed both of those checks in favor of looking for ext_attr or
> inline_data in ext2fs_xattrs_open().  Oh well, sorry about the
> miscommunication.

Got it.  I am happy to rebase against your latest patch.

Thanks,
                                                - Zheng

> 
> --D
> 
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  lib/ext2fs/ext_attr.c |   28 ++++++++++++++++++++++------
> >  1 file changed, 22 insertions(+), 6 deletions(-)
> > 
> > diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
> > index 09e13b2..e5e0fa9 100644
> > --- a/lib/ext2fs/ext_attr.c
> > +++ b/lib/ext2fs/ext_attr.c
> > @@ -469,9 +469,17 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
> >  	unsigned int i;
> >  	errcode_t err;
> >  
> > -	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
> > -				     EXT2_FEATURE_COMPAT_EXT_ATTR))
> > -		return 0;
> > +	/*
> > +	 * If inline_data is enabled, we don't check ext_attr because
> > +	 * inline_data needs to read/write extended attribute even
> > +	 * without ext_attr.
> > +	 */
> > +	if (!EXT2_HAS_INCOMPAT_FEATURE(handle->fs->super,
> > +				       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
> > +		if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
> > +					     EXT2_FEATURE_COMPAT_EXT_ATTR))
> > +			return 0;
> > +	}
> >  
> >  	i = EXT2_INODE_SIZE(handle->fs->super);
> >  	if (i < sizeof(*inode))
> > @@ -684,9 +692,17 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
> >  	int i;
> >  	errcode_t err;
> >  
> > -	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
> > -				     EXT2_FEATURE_COMPAT_EXT_ATTR))
> > -		return 0;
> > +	/*
> > +	 * If inline_data is enabled, we don't check ext_attr because
> > +	 * inline_data needs to read/write extended attribute even
> > +	 * without ext_attr.
> > +	 */
> > +	if (!EXT2_HAS_INCOMPAT_FEATURE(handle->fs->super,
> > +				       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
> > +		if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
> > +					     EXT2_FEATURE_COMPAT_EXT_ATTR))
> > +			return 0;
> > +	}
> >  
> >  	i = EXT2_INODE_SIZE(handle->fs->super);
> >  	if (i < sizeof(*inode))
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
