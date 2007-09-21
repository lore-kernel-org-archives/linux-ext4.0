From: Jan Kara <jack@suse.cz>
Subject: Re: Enabling h-trees too early?
Date: Fri, 21 Sep 2007 15:49:02 +0200
Message-ID: <20070921134902.GQ17271@atrey.karlin.mff.cuni.cz>
References: <20070919150715.GH9232@duck.suse.cz> <20070919182450.GF25497@thunk.org> <20070920133350.GH2689@duck.suse.cz> <20070920142800.GC30221@thunk.org> <20070920145839.GD1986@atrey.karlin.mff.cuni.cz> <20070920151440.GE30221@thunk.org> <20070920161903.GJ2689@duck.suse.cz> <20070920170250.GF30221@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36522 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXIUNtD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 09:49:03 -0400
Content-Disposition: inline
In-Reply-To: <20070920170250.GF30221@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Thu, Sep 20, 2007 at 06:19:04PM +0200, Jan Kara wrote:
> > if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_DIR_INDEX) &&
> >     ((EXT4_I(inode)->i_flags & EXT4_INDEX_FL) ||
> >      ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
> >         error = ext4_dx_readdir(filp, dirent, filldir);
> >         if (error != ERR_BAD_DX_DIR) {
> >                 ret = error;
> >                 goto out;
> >         }
> >         /*
> >          * We don't set the inode dirty flag since it's not
> >          * critical that it get flushed back to the disk.
> >          */
> >         EXT4_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT4_INDEX_FL;
> > }
> >   It calls ext4_dx_readdir() for *every* directory with 1 block (we have
> > 1326 of them in the kernel tree). Now ext4_dx_readdir() calls
> > ext4_htree_fill_tree() which finds out the directory is not h-tree and
> > and calls htree_dirblock_to_tree(). So even for 4KB directories we end up
> > deleting inodes in hash order! And as a bonus we burn some cycles building
> > trees etc. What is the point of this?
> 
> That was added so we wouldn't get screwed when a directory that was
> previously non htree became an htree directory while the directory fd
> is open.  So the failure case is one where you do opendir(), readdir()
> on 25% of the directory, sleep for 2 hours, and in the meantime, 200
> files are added to the directory and it gets converted into a htree
> index, causing all of the previously returned readdir() results in
> directory order to be completely screwed up now that the directory has
> been converted into an htree.  (All of the readdir/telldir/seekdir 
> POSIX requirements cause filesystem designers to tear their hair out.)
  Oh, yes. Thanks for explanation.

> What we would need to do to avoid needing this is to read in the
> entire directory leaf page into the rbtree, sorted by inode number,
> and then to keep that rbtree for the entire life of the open directory
> file descriptor.  We would also have to change telldir/seekdir to use
> something else as a telldir cookie, and readdir would have to be set
> up to *only* use the rbtree, and never look at the on-disk directory.
> This would also mean that all of the files created or deleted after
> the initial opendir() would never be reflected in results returned by
> readdir(), but that's allowed by POSIX.  And if we do this for a
> single block 4k directory, we might as well do it for a 32k or 64k
> HTREE directory as well.
  Yes, this makes sence...

								Honza 
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
