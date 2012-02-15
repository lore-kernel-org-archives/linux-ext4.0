From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] libext2fs: Only link an inode into a directory once
Date: Wed, 15 Feb 2012 12:40:15 -0800
Message-ID: <20120215204015.GB15164@tux1.beaverton.ibm.com>
References: <20120107044743.3366.16848.stgit@elm3c44.beaverton.ibm.com> <20120215192537.GI11382@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50237 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab2BOUlF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 15:41:05 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 15 Feb 2012 15:40:52 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id F3DE938C806A
	for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2012 15:40:16 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q1FKeGPC237926
	for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2012 15:40:16 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q1FKeGbS015726
	for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2012 18:40:16 -0200
Content-Disposition: inline
In-Reply-To: <20120215192537.GI11382@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 15, 2012 at 02:25:37PM -0500, Ted Ts'o wrote:
> On Fri, Jan 06, 2012 at 08:47:43PM -0800, Darrick J. Wong wrote:
> > The ext2fs_link helper function link_proc does not check the value of ls->done,
> > which means that if the function finds multiple empty spaces that will fit the
> > new directory entry, it will create a directory entry in each of the spaces.
> > Instead of doing that, check the done value and don't do anything more if we've
> > already added the directory entry.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> This should't necessary, since when we insert the directory entry, we
> return with the DIRENT_ABORT bit set:
> 
>         dirent->inode = ls->inode;
>         dirent->name_len = ls->namelen;
>         strncpy(dirent->name, ls->name, ls->namelen);
>         if (ls->sb->s_feature_incompat & EXT2_FEATURE_INCOMPAT_FILETYPE)
>                 dirent->name_len |= (ls->flags & 0x7) << 8;
> 
>         ls->done++;
>         return DIRENT_ABORT|DIRENT_CHANGED;
> 
> Did you actually observe this happening?

Yes.  I took a look at the block iteration code again, and I'm wondering, do we
need one of these:

if (ret & BLOCK_ABORT)
	break;

...around lib/ext2fs/block.c, line 450?  This is the code blob:

if (!(extent.e_flags & EXT2_EXTENT_FLAGS_LEAF)) {
        if (ctx.flags & BLOCK_FLAG_DATA_ONLY)
                continue;
        if ((!(extent.e_flags &
               EXT2_EXTENT_FLAGS_SECOND_VISIT) &&
             !(ctx.flags & BLOCK_FLAG_DEPTH_TRAVERSE)) ||
            ((extent.e_flags &
              EXT2_EXTENT_FLAGS_SECOND_VISIT) &&
             (ctx.flags & BLOCK_FLAG_DEPTH_TRAVERSE))) {
                ret |= (*ctx.func)(fs, &blk,
                                   -1, 0, 0, priv_data);
                if (ret & BLOCK_CHANGED) {
                        extent.e_pblk = blk;
                        ctx.errcode =
        ext2fs_extent_replace(handle, 0, &extent);
                        if (ctx.errcode)
                                break;
                }
		/* INSERT HERE? */
        }
        continue;
}

It looks to me that when ctx.func returns BLOCK_ABORT, the continue causes
the code to loop around and get the next extent, which isn't what we want.

--D

