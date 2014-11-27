From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Date: Thu, 27 Nov 2014 13:34:29 +0100
Message-ID: <20141127123429.GD30152@quack.suse.cz>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
 <20141126192328.GA20436@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141126192328.GA20436@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 26-11-14 11:23:28, Christoph Hellwig wrote:
> As mentioned last round please move the addition of the is_readonly
> operation to the first thing in the series, so that the ordering makes
> more sense.
> 
> Second I think this patch is incorrect for XFS - XFS uses ->update_time
> to set the time stampst in the dinode.  These two need to be coherent
> as we can write out a dirty inode any time, so it needs to have the
> timestamp uptodate.
  But Ted changed XFS to copy timestamps to on-disk structure from the
in-memory inode fields after VFS updated the timestamps. So the stamps
should be coherent AFAICT, shouldn't they?

> Third update_time now calls mark_inode_dirty unconditionally, while
> previously it wasn't called when ->update_time was set.  At least
> for XFS that's a major change in behavior as XFS never used VFS dirty
> tracking for metadata updates.
  We don't call mark_inode_dirty() when ->write_time is set (note the
return, I missed it on the first reading) which looks sensible to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
