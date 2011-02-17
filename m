From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext4: cannot unfreeze a filesystem due to a deadlock
Date: Thu, 17 Feb 2011 11:45:52 +0100
Message-ID: <20110217104552.GD4947@quack.suse.cz>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
 <20110215160630.GH17313@quack.suse.cz>
 <20110215170352.GE4255@thunk.org>
 <20110215172954.GK17313@quack.suse.cz>
 <20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
 <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab1BQKpy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Feb 2011 05:45:54 -0500
Content-Disposition: inline
In-Reply-To: <4D5C9B1B.2050304@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 17-02-11 12:50:51, Toshiyuki Okajima wrote:
> (2011/02/16 23:56), Jan Kara wrote:
> >On Wed 16-02-11 08:17:46, Toshiyuki Okajima wrote:
> >>On Tue, 15 Feb 2011 18:29:54 +0100
> >>Jan Kara<jack@suse.cz>  wrote:
> >>>On Tue 15-02-11 12:03:52, Ted Ts'o wrote:
> >>>>On Tue, Feb 15, 2011 at 05:06:30PM +0100, Jan Kara wrote:
> >>>>>Thanks for detailed analysis. Indeed this is a bug. Whenever we do IO
> >>>>>under s_umount semaphore, we are prone to deadlock like the one you
> >>>>>describe above.
> >>>>
> >>>>One of the fundamental problems here is that the freeze and thaw
> >>>>routines are using down_write(&sb->s_umount) for two purposes.  The
> >>>>first is to prevent the resume/thaw from racing with a umount (which
> >>>>it could do just as well by taking a read lock), but the second is to
> >>>>prevent the resume/thaw code from racing with itself.  That's the core
> >>>>fundamental problem here.
> >>>>
> >>>>So I think we can solve this by introduce a new mutex, s_freeze, and
> >>>>having the the resume/thaw first take the s_freeze mutex and then
> >>>>second take a read lock on the s_umount.
> >>>   Sadly this does not quite work because even down_read(&sb->s_umount)
> >>>in thaw_super() can block if there is another process that tries to acquire
> >>>s_umount for writing - a situation like:
> >>>   TASK 1 (e.g. flusher)		TASK 2	(e.g. remount)		TASK 3 (unfreeze)
> >>>down_read(&sb->s_umount)
> >>>   block on s_frozen
> >>>				down_write(&sb->s_umount)
> >>>				  -blocked
> >>>								down_read(&sb->s_umount)
> >>>								  -blocked
> >>>behind the write access...
> >>>
> >>>The only working solution I see is to check for frozen filesystem before
> >>>taking s_umount semaphore which seems rather ugly (but might be bearable if
> >>>we did so in some well described wrapper).
> >>I created the patch that you imagine yesterday.
> >>
> >>I got a reproducer from Mizuma-san yesterday, and then I executed it on the kernel
> >>without a fixed patch. After an hour, I confirmed that this deadlock happened.
> >>
> >>However, on the kernel with a fixed patch, this deadlock doesn't still happen
> >>after 12 hours passed.
> >>
> >>The patch for linux-2.6.38-rc4 is as follows:
> >>---
> >>  fs/fs-writeback.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> >>index 59c6e49..1c9a05e 100644
> >>--- a/fs/fs-writeback.c
> >>+++ b/fs/fs-writeback.c
> >>@@ -456,7 +456,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
> >>         spin_unlock(&sb_lock);
> >>
> >>         if (down_read_trylock(&sb->s_umount)) {
> >>-               if (sb->s_root)
> >>+               if (sb->s_frozen == SB_UNFROZEN&&  sb->s_root)
> >>                         return true;
> >>                 up_read(&sb->s_umount);
> 
> >   So this is something along the lines I thought but it actually won't work
> >for example if sync(1) is run while the filesystem is frozen (that takes
> >s_umount semaphore in a different place). And generally, I'm not convinced
> >there are not other places that try to do IO while holding s_umount
> >semaphore...
> OK. I understand.
> 
> This code only fixes the case for the following path:
> writeback_inodes_wb
> -> ext4_da_writepages
>    -> ext4_journal_start_sb
>       -> vfs_check_frozen
> But, the code doesn't fix the other cases.
> 
> We must modify the local filesystem part in order to fix all cases...?
  Yes, possibly. But most importantly we should first find clear locking
rules for frozen filesystem that avoid deadlocks like the one above. And
the freezing / unfreezing code might become subtle for that reason, that's
fine, but it would be really good to avoid any complicated things for the
code in the rest of the VFS / filesystems.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
