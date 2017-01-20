From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: Fri, 20 Jan 2017 09:40:26 -0500
Message-ID: <20170120144026.bvg2mpe3uvb5yspi@thunk.org>
References: <20170119231931.bxnltnlwinjdzvxa@thunk.org>
 <20170119233824.10435.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37442 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752109AbdATOkp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 20 Jan 2017 09:40:45 -0500
Content-Disposition: inline
In-Reply-To: <20170119233824.10435.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 19, 2017 at 06:38:24PM -0500, George Spelvin wrote:
> > I think the inline_data patches I posted should have taken care of
> > George's initial set of bug reports?
> 
> Er, the two I posted most recently were on a kernel with your 4-patch
> deadlock series applied:
> 
> 98a9e36a ext4: propagate error values from ext4_inline_data_truncate()
> 50c39f0d ext4: avoid calling ext4_mark_inode_dirty() under unneeded semaphores
> f321034b ext4: fix deadlock between inline_data and ext4_expand_extra_isize_ea()
> 5283ac14 ext4: add debug_want_extra_isize mount option

Yes, I know that's why I said, it takes care of the _initial_ set of
bug reports (not your recently reported ones).  Jan's comments
indicated he was lookig at the initial set, and I to avoid him redoing
work that i had already done.

Those bugs look like they are very separate in that they have nothing
to do with locking, but rather in e2fsck and the kernel not properly
dealing with certain types of inconsistencies on disk.  On my list to
deal with.  As a workaround, you can just clri the offending corrupted
inode from lost+found and then run e2fsck.

> > (And George, the reason why you're seeing lots of problems is because
> > inline_data isn't enabled by default yet, and as the old joke goes,
> > the Early Christians get the best Lions.  :-)
> 
> Yes, I know I'm tempting fate by keeping data I actaully care about (I
> have backups of most of it, but reassembling it from those backups would
> be most unpleasant) on a file system with experimental features enabled.
> 
> But *somebody* has to debug new features, and I've noticed that the fickle
> goddess Glitch is most likely to make an appearance when She sees such
> an offering.

Indeed, the reason why we didn't see this earlier is because we don't
have a test which tests the case of expanding i_extra_size with inline
data, and the introduction of project quota was the first time we've
expanded the extra inode fields in a while.  Since you were using
inline_data, you very graciously exposed these bugs and a shortcoming
in our testing.  :-)

On my todo list is to add some i_extra_isize testing to xfstsests.

      	   	      	       		     - Ted
