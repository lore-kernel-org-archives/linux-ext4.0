From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 11/30] libext2fs: handle inline data in dir iterator
 function
Date: Tue, 4 Mar 2014 08:56:24 -0500
Message-ID: <20140304135624.GA18385@thunk.org>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
 <1386323897-2354-12-git-send-email-wenqing.lz@taobao.com>
 <20140303221653.GA4452@thunk.org>
 <20140303233154.GB9875@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36833 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292AbaCDN4f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2014 08:56:35 -0500
Content-Disposition: inline
In-Reply-To: <20140303233154.GB9875@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 03, 2014 at 03:31:54PM -0800, Darrick J. Wong wrote:
> > diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
> > index 6bdfae5..8afccbe 100644
> > --- a/lib/ext2fs/dir_iterate.c
> > +++ b/lib/ext2fs/dir_iterate.c
> > @@ -129,9 +129,7 @@ errcode_t ext2fs_dir_iterate2(ext2_filsys fs,
> >  		ext2fs_free_mem(&ctx.buf);
> >  	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE) {
> >  		ctx.flags |= DIRENT_FLAG_INCLUDE_INLINE_DATA;
> > -		retval = ext2fs_inline_data_dir_iterate(fs, dir,
> > -						ext2fs_process_dir_block,
> > -						&ctx);
> > +		(void) ext2fs_inline_data_dir_iterate(fs, dir, &ctx);
> >  	}
> >  	if (retval)
> >  		return retval;
> 
> Hmm.  In order to get into ext2fs_inline_data_dir_iterate(), it has to be the
> case that retval == EXT2_ET_INLINE_DATA_CANT_ITERATE.  But then we immediately
> return that error code, which means that anything interesting in ctx.errcode
> will be lost.  I /think/ you want to set retval = 0 in that if clause?

Yes, I noticed this morning that it caused a regression test failure
(which is comforting from a code coverage point of view :-).  I've
made that change.

> 
> Was BLOCK_INLINE_DATA_CHANGED ever cleared from retval?  As written, I /think/
> that writing either dot or dotdot entries will result in the EA being written
> too, even if nothing changes there.

Yes, good point.  I've added the following change.

diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index db1bc03..9bfc8ef 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -133,6 +133,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 		err = ext2fs_write_inode(fs, ino, &inode);
 		if (err)
 			goto out;
+		ret &= ~BLOCK_INLINE_DATA_CHANGED;
 	}
 	if (ret & BLOCK_ABORT)
 		goto out;
@@ -159,6 +160,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 		ctx->errcode = ext2fs_write_inode(fs, ino, &inode);
 		if (ctx->errcode)
 			ret |= BLOCK_ABORT;
+		ret &= ~BLOCK_INLINE_DATA_CHANGED;
 	}
 	if (ret & BLOCK_ABORT)
 		goto out;
     	  	       
> Guess I'll have a look at the other patches too.

I've updated the pu branch with the inline data patches, so if you and
Zheng could take a look at it and sanity check it, I'd really
appreicate it.  Thanks!!

						- Ted
