From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't manipulate recovery flag when freezing
 no-journal fs
Date: Sat, 15 Aug 2015 10:50:47 -0400
Message-ID: <20150815145047.GC2976@thunk.org>
References: <55C28AA6.6070606@redhat.com>
 <20150811192237.GE2659@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Stu Mark <smark@datto.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60348 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbbHOOux (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Aug 2015 10:50:53 -0400
Content-Disposition: inline
In-Reply-To: <20150811192237.GE2659@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 11, 2015 at 09:22:37PM +0200, Jan Kara wrote:
> On Wed 05-08-15 15:13:58, Eric Sandeen wrote:
> > ext4 started setting needs_recovery on filesystems without journals
> > when they are unfrozen.  This makes no sense, and in fact confuses
> > blkid to the point where it doesn't recognize the filesystem at all.
> > 
> > (freeze ext2; unfreeze ext2; run blkid; see no output; run dumpe2fs,
> > see needs_recovery set on fs w/ no journal).
> > 
> > To fix this, don't manipulate the INCOMPAT_RECOVER feature on
> > filesystems without journals.
> > 
> > Reported-by: Stu Mark <smark@datto.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> The patch looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.com>

Thanks, applied.

> > Note, is there a reason that in ext4_freeze, if journal_flush
> > fails, we skip the ext4_commit_super call?  I didn't change that
> > here, but it seems odd.

The only reason to call ext4_commit_super() is to persistent the
changed INCOMPAT_RECOVER flag --- well, and to update the global free
inode/block counts.  OTOH, if the journal_flush() has failed, the fact
that the global free counts aren't up to date will be the least of
your problems as far as the consistency of the file system snapshot is
concerned....

						- Ted
