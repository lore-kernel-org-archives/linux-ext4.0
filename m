From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Fri, 3 Apr 2009 20:47:29 +0200
Message-ID: <20090403184729.GC5178@kernel.dk>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:36859 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbZDCSrc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 14:47:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 03 2009, Linus Torvalds wrote:
> 
> 
> On Fri, 3 Apr 2009, Theodore Ts'o wrote:
> > 
> > Please pull from:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes
> 
> Thanks, pulled. I'll be interested to see how it feels. Will report back 
> after I've rebuild and gone through a few more emails.

I have one question, didn't see this series before... Ted, what kind of
tests did you run with this and on what? Currently one has to be careful
with WRITE_SYNC, as it also implies an immediate unplug of the device.
So not only does it flag the priority as sync, it'll also kick things
off immediately. We had a nasty regression in performance in a few
revisions of the kernel due to this, sqlite performance was basically 4
times as bad as before we did WRITE_SYNC in sync_dirty_buffer(). So I'd
be curious what kind of testing was done with the patch series before
submitting it.

We should probably just dump the unplug bit from WRITE_SYNC and make
sure we do those explicitly after submission instead.

> One thing I started wondering about in your changes to start using 
> WRITE_SYNC is that I'm getting closer to thinking that we did the whole 
> WRITE-vs-WRITE_SYNC thing the wrong way around.
> 
> Now, it's clearly true that non-synchronous writes are hopefully always 
> the common case, so in that sense it makes sense to think of "WRITE" as 
> the default non-critical case, and then make the (fewer) WRITE_SYNC cases 
> be the special case.
> 
> But at the same time, I now suspect that we could actually have solved 
> this problem more easily by just doing things the other way around: make 
> the default "WRITE" be the high-priority one (to match "READ"), and then 
> just explicitly marking the data writes with "WRITE_ASYNC".
> 
> Why? Because I think that with all the writes sprinkled around in random 
> places, it's probably _easier_ to find the bulk writes that cause the 
> biggest issues, and just fix _those_ to be WRITE_ASYNC. They may be bulk, 
> they may be the common case, but they also tend to be the case where we 
> write with generic routines (eg the whole "do_writepages()" thing).
> 
> So the VFS layer tends to already do much of the bulk writeout, and maybe 
> we would have been better off just changing those to ASYNC and leaving any 
> more specialized cases as the SYNC case? That would have avoided a lot of 
> this effort at the filesystem level. We'd just assume that the default 
> filesystem-specific writes tend to all be SYNC.

Makes some sense, but we have to be really careful with SYNC writes.
It's important that it really be things that are immediately waited upon
and not "important" writes, since otherwise it'll wreak havoc with the
responsiveness of our reads.

-- 
Jens Axboe

