From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 15/28] debugfs: handle inline_data feature in bmap
 command
Date: Wed, 4 Dec 2013 11:46:20 +0800
Message-ID: <20131204034620.GB20409@gmail.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-16-git-send-email-wenqing.lz@taobao.com>
 <20131204031125.GK9535@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50258 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LDDnX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 22:43:23 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so22662369pbb.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 19:43:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131204031125.GK9535@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 03, 2013 at 07:11:25PM -0800, Darrick J. Wong wrote:
> On Tue, Dec 03, 2013 at 08:11:42PM +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > No physical block mapping if an inode has inline data.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  lib/ext2fs/bmap.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
> > index 5074587..0d043bd 100644
> > --- a/lib/ext2fs/bmap.c
> > +++ b/lib/ext2fs/bmap.c
> > @@ -273,6 +273,13 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
> >  		block_buf = buf;
> >  	}
> >  
> > +	/*
> > +	 * If an inode has inline data, that means that it doesn't have
> > +	 * any blocks and we shouldn't map any blocks for it.
> > +	 */
> > +	if (inode->i_flags & EXT4_INLINE_DATA_FL)
> > +		goto done;
> 
> If you move this to before the ext2fs_get_array() chunk above it, you could
> return straight out of the function.

Good catch!

> 
> This should return an error code of some kind, because otherwise the client
> will think that something happened when the function returns 0, especially if
> BMAP_{ALLOC,SET,UNINIT} are passed in.

Fair enough

                                                - Zheng

> 
> --D
> 
> > +
> >  	if (inode->i_flags & EXT4_EXTENTS_FL) {
> >  		retval = ext2fs_extent_open2(fs, ino, inode, &handle);
> >  		if (retval)
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
