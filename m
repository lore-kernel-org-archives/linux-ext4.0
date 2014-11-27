From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v4 1/7] vfs: split update_time() into update_time() and
 write_time()
Date: Thu, 27 Nov 2014 09:41:16 -0500
Message-ID: <20141127144116.GA14091@thunk.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-2-git-send-email-tytso@mit.edu>
 <20141126192328.GA20436@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
	XFS Developers <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55215 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaK0OlZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Nov 2014 09:41:25 -0500
Content-Disposition: inline
In-Reply-To: <20141126192328.GA20436@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2014 at 11:23:28AM -0800, Christoph Hellwig wrote:
> As mentioned last round please move the addition of the is_readonly
> operation to the first thing in the series, so that the ordering makes
> more sense.

OK, will fix.

> Second I think this patch is incorrect for XFS - XFS uses ->update_time
> to set the time stampst in the dinode.  These two need to be coherent
> as we can write out a dirty inode any time, so it needs to have the
> timestamp uptodate.
> 
> Third update_time now calls mark_inode_dirty unconditionally, while
> previously it wasn't called when ->update_time was set.  At least
> for XFS that's a major change in behavior as XFS never used VFS dirty
> tracking for metadata updates.

Thanks, I'll fix both of the above.

							- Ted
