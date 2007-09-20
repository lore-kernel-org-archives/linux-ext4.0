From: Jan Kara <jack@suse.cz>
Subject: Re: Enabling h-trees too early?
Date: Thu, 20 Sep 2007 18:19:04 +0200
Message-ID: <20070920161903.GJ2689@duck.suse.cz>
References: <20070919150715.GH9232@duck.suse.cz> <20070919182450.GF25497@thunk.org> <20070920133350.GH2689@duck.suse.cz> <20070920142800.GC30221@thunk.org> <20070920145839.GD1986@atrey.karlin.mff.cuni.cz> <20070920151440.GE30221@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45395 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756174AbXITP6L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 11:58:11 -0400
Content-Disposition: inline
In-Reply-To: <20070920151440.GE30221@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 20-09-07 11:14:40, Theodore Tso wrote:
> On Thu, Sep 20, 2007 at 04:58:39PM +0200, Jan Kara wrote:
> >   Hmm, strange - I've just looked at my computer and dir_index is set
> > just for 5 directories in my tree.
> 
> I looked at a tree that had object files, which is probably why I had
> 8 directories; I'm guessing you probably just had kernel sources and
> no build files.
> 
> > If I try deleting just them, I also
> > see some performance decrease but it's less than if I try deleting the
> > whole tree (and that result seems to be quite consistent)... There's something
> > fishy there. Maybe I could try seekwatcher or something similar to see
> > what's really happening.
> 
> That is very strange.....
  Just a guess: Can't the culprit be the following test in ext3/4_readdir()?
if (EXT4_HAS_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_COMPAT_DIR_INDEX) &&
    ((EXT4_I(inode)->i_flags & EXT4_INDEX_FL) ||
     ((inode->i_size >> sb->s_blocksize_bits) == 1))) {
        error = ext4_dx_readdir(filp, dirent, filldir);
        if (error != ERR_BAD_DX_DIR) {
                ret = error;
                goto out;
        }
        /*
         * We don't set the inode dirty flag since it's not
         * critical that it get flushed back to the disk.
         */
        EXT4_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT4_INDEX_FL;
}
  It calls ext4_dx_readdir() for *every* directory with 1 block (we have
1326 of them in the kernel tree). Now ext4_dx_readdir() calls
ext4_htree_fill_tree() which finds out the directory is not h-tree and
and calls htree_dirblock_to_tree(). So even for 4KB directories we end up
deleting inodes in hash order! And as a bonus we burn some cycles building
trees etc. What is the point of this?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
