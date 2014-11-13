From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH,RFC] ext4: add lazytime mount option
Date: Fri, 14 Nov 2014 07:48:32 +1100
Message-ID: <20141113204832.GJ28565@dastard>
References: <1415765227-9561-1-git-send-email-tytso@mit.edu>
 <20141113064150.GI28565@dastard>
 <20141113163511.GA15585@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141113163511.GA15585@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 13, 2014 at 11:35:11AM -0500, Theodore Ts'o wrote:
> On Thu, Nov 13, 2014 at 05:41:50PM +1100, Dave Chinner wrote:
> > 
> > I think this needs to a VFS level inode timestamp update option.
> > The games ext4 is playing with reference counts inside .drop_inode are
> > pretty nasty and could be avoided if this is implemented at the VFs
> > level..
> 
> I'm happy to implement this at the VFS level, assuming that there are
> no objections from other file system developers.  I do need to note
> that one potential downside of this feature is that if an inode stays
> in the inode cache for potentially a long, long time, and the file is
> a preallocated file which is updated using random DIO or AIO writes
> (for example, enterprise database files on a long-running server), and
> the system crashes, the mtime in memory could potentially out of synch
> for days, weeks, months, etc.  I'm personally not bothered by this,
> but I could imagine that some other folks might.

I really don't care what the behaviour is, as long as it's
*consistent across all filesystems*.

However, we'd be fools to ignore the development of relatime, which
in it's original form never updated the atime until m/ctime updated.
3 years after it was introduced, relatime was changed to limit the
update delay to 24 hours (before it was made the default) so that
applications that required regular updates to timestamps didn't
silently stop working.

So perhaps what we should simply define "lazytime" policy to be
"only update timestamps once a day or whenever the inode is
otherwise modified, whichever comes first". 

> One other thing we could do at the VFS layer is to change the default
> from relatime (which is not POSIX compliant) to enabling atime update
> plus lazytime enabled (which is POSIX compliant).  Would there be
> consensus in making such a change in the default?

lazytime isn't POSIX compliant as it is implemented in the patch.
sync() won't write back inodes with lazy timestamp updates as they
are not tracked in dirty lists or the ext4 journal, therefore a
crash after a sync() can still lose timestamp updates from before
the sync() ran.

w.r.t. default behaviour, like relatime, I think this it will be a
couple of years before we can consider it to be a default.  We'll
need to shake out it's impact on the Real World first....

> > I think that the "lazy time update" status should really be tracked
> > in the inode->i_state field. Something like lazytime updates do not
> > call ->update_inode, nor do they mark the inode dirty, but they do
> > update the inode->i_[acm]time fields and set a TIMEDIRTY state flag.
> 
> It looks like the only file systems that have an update_inode today is
> btrfs and xfs, and it looks like this change should be fine for both
> of them, so sure, that sounds workable.

For those that don't implement ->update_time, just calling
write_inode_now() if the TIMEDIRTY flag set in iput_final()
should end up doing the right thing, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
