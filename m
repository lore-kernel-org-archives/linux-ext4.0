From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v4 2/7] vfs: add support for a lazytime mount option
Date: Fri, 28 Nov 2014 13:41:35 +0100
Message-ID: <20141128124135.GA27902@quack.suse.cz>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-3-git-send-email-tytso@mit.edu>
 <20141127131421.GE30152@quack.suse.cz>
 <20141127201954.GF14091@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141127201954.GF14091@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 27-11-14 15:19:54, Ted Tso wrote:
> On Thu, Nov 27, 2014 at 02:14:21PM +0100, Jan Kara wrote:
> > Looking into the code & your patch I'd prefer to do something like:
> > * add support for I_DIRTY_TIME in __mark_inode_dirty() - update_time will
> >   call __mark_inode_dirty() with this flag if any of the times was updated.
> >   That way we can just remove your ->write_time() callback - filesystems
> >   can just handle this in their ->dirty_inode() methods if they wish.
> >   __mark_inode_dirty() will take care of moving inode into proper writeback
> >   list (i_dirty / i_dirty_time), dirtied_when will be set to current time.
> 
> One of the tricky bits about this is that btrfs wants to be able to
> return an error from write_time() which gets reflected up through
> update_time() to the callers of file_update_time().  Currently
> __mark_inode_dirty() and family return a void, and changing this is
> going to be a bit of a mess, since doing this correctly would require
> auditing all of the callers of mark_inode_dirty(),
> mark_inode_dirty_sync(), __mark_inode_dirty(), etc.
> 
> Doing this would be a good thing, and eventually I think it would be
> nice if we could allow the mark_inode_dirty() functions return an
> error instead of void, but I wonder if that's a cleanup that's better
> saved for later.  While we were at it, maybe we should rename
> mark_inode_dirty() to inode_dirty(), since that way we can be sure
> we've looked at all of the call site of mark_inode_dirty() and friends
> --- and we have a number of file systems, including btrfs, ext3, and
> ext4, where mark_inode_dirty() is doing a lot more than just marking
> the inode is dirty, and the only reason why it's named that is mostly
> historical.
  Except that lots of callers of update_time() / file_update_time() just
ignore the return value anyway. And frankly most of the time it's a
simplification we can get away with. I agree that ultimately we should
propagate and handle these errors but as you say above handling errors from
__mark_inode_dirty() is what we'd really need - that handles the whole
class of errors. So for now I would be OK, with just ignoring the error
when updating time stamps.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
