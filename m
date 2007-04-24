From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Copy i_flags to ext3 inode flags on write (version 2)
Date: Tue, 24 Apr 2007 17:35:35 +0200
Message-ID: <20070424153534.GB20356@duck.suse.cz>
References: <20070417103855.GB11815@duck.suse.cz> <1177427677.15516.21.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49954 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753107AbXDXP0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2007 11:26:40 -0400
Content-Disposition: inline
In-Reply-To: <1177427677.15516.21.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 24-04-07 10:14:37, Dave Kleikamp wrote:
> On Tue, 2007-04-17 at 12:38 +0200, Jan Kara wrote:
> >   Hi,
> > 
> >   attached is a second version of a patch that stores inode flags such as
> > S_IMMUTABLE, S_APPEND, etc. from i_flags to EXT3_I(inode)->i_flags when
> > inode is written to disk. The same thing is done on GETFLAGS ioctl.
> >   Quota code changes these flags on quota files (to make it harder for
> > sysadmin to screw himself) and these changes were not correctly
> > propagated into the filesystem (especially, lsattr did not show them and
> > users were wondering...). Andrew, could you please put the patch into your
> > queue? Thanks.
> 
> I think you need a call to ext3_get_inode_flags in one more place.  In
> ext3_ioctl(), EXT3_IOC_SETFLAGS modifies the flags based on what is in
> ei->i_flags, so this code should make sure that ei->i_flags is in sync
> with inode->i_flags.
  Hmm, I don't think so. The code does:
                flags = flags & EXT3_FL_USER_MODIFIABLE;
                flags |= oldflags & ~EXT3_FL_USER_MODIFIABLE;
                ei->i_flags = flags;
  So all EXT3_FL_USER_MODIFIABLE are overwritten by what user has supplied,
which happens to be a superset of flags influenced by
ext3_get_inode_flags(). On the other hand, from some point of view, after your
change the code is safer (in case we add some new unmodifiable flags) so I
don't object against adding the call. I just wanted to point out, that
currently there's no difference...

									Honza

> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> 
> diff -Nurp linux-orig/fs/ext3/ioctl.c linux/fs/ext3/ioctl.c
> --- linux-orig/fs/ext3/ioctl.c	2007-04-24 10:04:50.000000000 -0500
> +++ linux/fs/ext3/ioctl.c	2007-04-24 10:05:59.000000000 -0500
> @@ -51,6 +51,7 @@ int ext3_ioctl (struct inode * inode, st
>  			flags &= ~EXT3_DIRSYNC_FL;
>  
>  		mutex_lock(&inode->i_mutex);
> +		ext3_get_inode_flags(ei);
>  		oldflags = ei->i_flags;
>  
>  		/* The JOURNAL_DATA flag is modifiable only by root */
> 
> -- 
> David Kleikamp
> IBM Linux Technology Center
> 
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
