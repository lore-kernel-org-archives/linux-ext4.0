From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Copy i_flags to ext3 inode flags on write
Date: Tue, 17 Apr 2007 12:35:00 +0200
Message-ID: <20070417103500.GA11815@duck.suse.cz>
References: <20070416170504.GH25785@atrey.karlin.mff.cuni.cz> <20070416181421.GJ5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38520 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbXDQK0j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2007 06:26:39 -0400
Content-Disposition: inline
In-Reply-To: <20070416181421.GJ5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 16-04-07 12:14:21, Andreas Dilger wrote:
> On Apr 16, 2007  19:05 +0200, Jan Kara wrote:
> >   attached is a patch that stores inode flags such as S_IMMUTABLE,
> > S_APPEND, etc. from i_flags to EXT3_I(inode)->i_flags when inode is
> > written to disk. The same thing is done on GETFLAGS ioctl.
> >   Quota code changes these flags on quota files (to make it harder for
> > sysadmin to screw himself) and these changes were not correctly
> > propagated into the filesystem (especially, lsattr did not show them and
> > users were wondering...).
> >  
> > +/* Propagate flags from i_flags to EXT3_I(inode)->i_flags */
> > +void ext3_get_inode_flags(struct inode *inode)
> > +{
> > +	unsigned int flags = inode->i_flags;
> > +
> > +	EXT3_I(inode)->i_flags &= ~(EXT3_SYNC_FL|EXT3_APPEND_FL|
> > +			EXT3_IMMUTABLE_FL|EXT3_NOATIME_FL|EXT3_DIRSYNC_FL);
> > +	if (flags & S_SYNC)
> > +		EXT3_I(inode)->i_flags |= EXT3_SYNC_FL;
> > +	if (flags & S_APPEND)
> > +		EXT3_I(inode)->i_flags |= EXT3_APPEND_FL;
> > +	if (flags & S_IMMUTABLE)
> > +		EXT3_I(inode)->i_flags |= EXT3_IMMUTABLE_FL;
> > +	if (flags & S_NOATIME)
> > +		EXT3_I(inode)->i_flags |= EXT3_NOATIME_FL;
> > +	if (flags & S_DIRSYNC)
> > +		EXT3_I(inode)->i_flags |= EXT3_DIRSYNC_FL;
> > +}
> 
> It probably makes sense to pass "struct ext3_inode_info *ei" to this
> function, which is available at both callsites and avoids some pointer
> math for each access.
  OK, makes sence. Will resend the patch in a while.

> >  void ext3_read_inode(struct inode * inode)
> >  {
> >  	struct ext3_iloc iloc;
> > @@ -2736,6 +2755,7 @@ static int ext3_do_update_inode(handle_t
> >  	if (ei->i_state & EXT3_STATE_NEW)
> >  		memset(raw_inode, 0, EXT3_SB(inode->i_sb)->s_inode_size);
> >  
> > +	ext3_get_inode_flags(inode);
> >  	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
> >  	if(!(test_opt(inode->i_sb, NO_UID32))) {
> >  		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
> > diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/fs/ext3/ioctl.c linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/ioctl.c
> > --- linux-2.6.21-rc6/fs/ext3/ioctl.c	2007-02-07 12:03:23.000000000 +0100
> > +++ linux-2.6.21-rc6-1-ext3_flags_update/fs/ext3/ioctl.c	2007-04-12 18:22:54.000000000 +0200
> > @@ -28,6 +28,7 @@ int ext3_ioctl (struct inode * inode, st
> >  
> >  	switch (cmd) {
> >  	case EXT3_IOC_GETFLAGS:
> > +		ext3_get_inode_flags(inode);
> >  		flags = ei->i_flags & EXT3_FL_USER_VISIBLE;
> >  		return put_user(flags, (int __user *) arg);
> >  	case EXT3_IOC_SETFLAGS: {
> 
> Looks fine otherwise - there is already ext3_set_inode_flags() which sets the
> VFS inode flags properly in ext3_read_inode().
  Yes, I know :).

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
