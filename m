From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Add statx support
Date: Wed, 12 Apr 2017 09:34:12 +0200
Message-ID: <20170412073412.GA32477@quack2.suse.cz>
References: <148966413352.3279.15659219505999889147.stgit@warthog.procyon.org.uk>
 <20170317054755.GA595@zzz>
 <1A035757-CBE2-40F1-9CD3-9554F56F63CB@dilger.ca>
 <20170319111237.GB1844@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, Jan Kara <jack@suse.cz>,
        David Howells <dhowells@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170319111237.GB1844@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 19-03-17 12:12:37, Jan Kara wrote:
> On Fri 17-03-17 14:19:22, Andreas Dilger wrote:
> > On Mar 16, 2017, at 11:47 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> > > On Thu, Mar 16, 2017 at 11:35:33AM +0000, David Howells wrote:
> > >> +
> > >> +	ext4_get_inode_flags(ei);
> > >> +	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
> > >> +	if (flags & EXT4_APPEND_FL)
> > >> +		stat->attributes |= STATX_ATTR_APPEND;
> > >> +	if (flags & EXT4_COMPR_FL)
> > >> +		stat->attributes |= STATX_ATTR_COMPRESSED;
> > >> +	if (flags & EXT4_ENCRYPT_FL)
> > >> +		stat->attributes |= STATX_ATTR_ENCRYPTED;
> > >> +	if (flags & EXT4_IMMUTABLE_FL)
> > >> +		stat->attributes |= STATX_ATTR_IMMUTABLE;
> > >> +	if (flags & EXT4_NODUMP_FL)
> > >> +		stat->attributes |= STATX_ATTR_NODUMP;
> > >> 
> > >> -	inode = d_inode(path->dentry);
> > >> 	generic_fillattr(inode, stat);
> > >> +	return 0;
> > >> +}
> > > 
> > > I think it's the wrong approach to be calling ext4_get_inode_flags() here to
> > > sync the generic inode flags (inode->i_flags) to the ext4-specific inode flags
> > > (ei->i_flags).  I know the GETFLAGS and FSGETXATTR ioctls do it too, but I
> > > think it's a mistake --- at least, when done so without holding the inode lock.
> > > The issue is that flag syncs can occur in both directions concurrently and
> > > cause an update to be lost.  For example, with thread 1 doing a stat() and
> > > thread 2 doing the SETFLAGS ioctl to set the APPEND flag:
> > > 
> > > Thread 1, ext4_get_inode_flags()	Thread 2, ext4_ioctl_setflags()
> > > -----------------------------------	---------------------------
> > > Read inode->i_flags; S_APPEND clear
> > > 					Set EXT4_APPEND_FL in ei->i_flags
> > > Clear EXT4_APPEND_FL in ei->i_flags
> > > 					Read ei->i_flags; EXT4_APPEND_FL clear
> > > 					Clear S_APPEND in inode->i_flags
> > > 
> > > So the flag set by SETFLAGS gets lost.  This bug probably hasn't really been
> > > noticable with GETFLAGS and FSGETXATTR since they're rarely used, but stat() on
> > > the other hand is very common, and I'm worried that with this change people
> > > would start seeing this race more often.
> > > 
> > > Ultimately this needs to be addressed in ext4 more fully, but how about for
> > > ->getattr() just skipping the call to ext4_get_inode_flags() and instead
> > > populating the generic attributes like STATX_ATTR_APPEND and
> > > STATX_ATTR_IMMUTABLE from the generic inode flags, rather than from the
> > > ext4-specific flags?  Actually, it could even be done in generic_fillattr(), so
> > > that all filesystems benefit.
> > 
> > Wouldn't it make more sense to just extract the ext4 flags directly from
> > ei->i_flags?  I think ext4_get_inode_flags() is only really useful when
> > the VFS inode flags are changed and they need to be propagated to the ext4
> > inode.
> > 
> > I guess the other more significant question is when/where are the VFS inode
> > flags changed that they need to be propagated into the ext4 disk inode?
> > The main avenue for changing these attribute flags that I know about is via
> > EXT4_IOC_SETFLAGS (FS_IOC_SETFLAGS), and there is one place that I could
> > find in fs/nsfs.c that sets S_IMMUTABLE but I don't think that propagates
> > down to an ext4 disk inode.
> 
> Yes, you seem to be right. And actually I have checked and XFS does not
> bother to copy inode->i_flags to its on-disk flags so it seems generally we
> are not expected to reflect inode->i_flags in on-disk state.
> 
> > It seems like the use of ext4_get_inode_flags() is largely superfluous.
> > The original commit ff9ddf7e847 indicates this was for quota inodes only.
> > I think it can be removed from EXT4_IOC_FSGETXATTR, and EXT4_IOC_GETFLAGS
> > and made conditional in ext4_do_update_inode():
> > 
> > #ifdef CONFIG_QUOTA
> >         for (i = 0; i < EXT4_MAXQUOTAS; i++) {
> >                 if (unlikely(sb_dqopt(sb)->files[i] == inode))
> >                         ext4_get_inode_flags(EXT4_I(inode));
> >         }
> > #endif
> > 
> > Jan, what do you think?
> 
> So I think even better would be to have ext4_quota_on() and
> ext4_quota_off() just update the flags as needed and avoid doing it
> anywhere else... I'll have a look into it.

FYI I have just sent out patches to do this...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
