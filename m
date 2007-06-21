From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext2fs_block_iterate() on fast symlink
Date: Thu, 21 Jun 2007 05:10:46 -0600
Message-ID: <20070621111046.GS5181@schatzie.adilger.int>
References: <20070620125653.GG27218@duck.suse.cz> <20070621093343.GO5181@schatzie.adilger.int> <20070621095449.GA3744@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:34070 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbXFULKt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Jun 2007 07:10:49 -0400
Content-Disposition: inline
In-Reply-To: <20070621095449.GA3744@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 21, 2007  11:54 +0200, Jan Kara wrote:
> On Thu 21-06-07 03:33:43, Andreas Dilger wrote:
> > > +	if (LINUX_S_ISCHR(inode.i_mode) || LINUX_S_ISBLK(inode.i_mode) ||
> > > +	    (LINUX_S_ISLNK(inode.i_mode) &&
> > > +	     ext2fs_inode_data_blocks(fs, &inode) == 0))
> > > +		return EXT2_ET_INVAL_INODE_TYPE;
> > 
> > I would prefer that we NOT continue to make fast symlinks conditional upon
> > the i_blocks count.  That causes problems if e.g. an EA block is present
> > (that would cause this blocks == 0 test to incorrectly fail), and may making
> > the check (blocks - !!i_file_acl) can still fail for other reasons where a
> > block is added to an inode (e.g. if we have larger EAs, etc).
>
>   Note that ext2fs_inode_data_blocks() subtract number of EA blocks, so it
> is equivalent to (blocks - !!i_file_acl). The function is supposed to
> return the number of real data blocks so the test should be fine even in
> future.

This is where I disagree.  We had a whole series of bugs in different places
when SELinux patched ext2/3 to allow EAs on symlinks (also breaking ext2/3
compatibility in the process), because fast symlink checking was based on
i_blocks and not i_size.  Then we fixed those bugs, but we are open to a
whole series of new bugs should any other blocks be assigned to an symlink.

> > I'd prefer to make this check "i_size < sizeof(i_block)" or similar, which
> > has always been true for fast symlinks, for every kernel that I have ever
> > seen.
>
>   Personally I don't mind much. If Ted finds this better, I'll change that.
> Maybe introducing some macro LINUX_S_ISFASTLNK() would be fine.

Ted, are you aware of any kernel that ever wrote a short symlink into an
external block?  Since it isn't possible to modify a symlink after it is
created (except adding an EA ;-) it should never be possible that a "slow"
symlink is shortened but left in the external block.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
