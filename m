From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
 day stale
Date: Fri, 21 Nov 2014 16:36:51 -0500
Message-ID: <20141121213651.GF7112@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-4-git-send-email-tytso@mit.edu>
 <B1759DB3-7D86-499B-BE09-34D9927C75C8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B1759DB3-7D86-499B-BE09-34D9927C75C8@dilger.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 21, 2014 at 02:19:07PM -0600, Andreas Dilger wrote:
> > -	if (inode->i_sb->s_flags & MS_LAZYTIME) {
> > +	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
> > +	    (!inode->i_ts_dirty_day ||
> > +	     inode->i_ts_dirty_day == days_since_boot)) {
> > 		spin_lock(&inode->i_lock);
> > 		inode->i_state |= I_DIRTY_TIME;
> > 		spin_unlock(&inode->i_lock);
> > +		inode->i_ts_dirty_day = days_since_boot;
> 
> It isn't clear if this is correct.  It looks like the condition will
> only be entered if i_ts_dirty_day == days_since_boot, but that is only
> set inside the condition?

If i_ts_dirty_day is zero, the timestamps don't have to written to
disk.  This is either because the inode has been written to disk, or
the system has been up for less than a day, such that when we last a
lazy mtime update (i.e., we skipped the call to mark_inode_dirty)
since jiffies / (HZ * 86400) was zero.

If it is non-zero, then the timestamps were updated but were not sent
to disk N days since the system was booted.  So long as it remains N
days since the system was booted, we can skip calling
mark_inode_dirty().  But once it becomes N+1 days since the system was
booted, then we will call mark_inode_dirty() and set i_ts_dirty_day to
zero.

I'll add a comment so it's a bit more obvious what we're doing here,
but I'm pretty sure we currently have is in fact correct.

> and "days_since_boot" should be declared unsigned short so it wraps
> in the same way as i_ts_dirty_day

Good point, thanks.  This will only be an issue after the system has
been up for almost 90 years, but we might as well get it right,

     	    	      	     	    	  - Ted
