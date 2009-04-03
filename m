From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Fri, 3 Apr 2009 15:54:53 -0400
Message-ID: <20090403195453.GC11661@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59266 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936559AbZDCTzC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 15:55:02 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 03, 2009 at 11:24:50AM -0700, Linus Torvalds wrote:
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

Well, most filesystem-specific writes tend all to be ASYNC; it's only
those related to commits and fsync() which are SYNC.  Ext3 is unusual
in that data=ordered and the physical-block journalling design of the
jbd layer means that we actually have a much larger number of blocks
that need to be written out synchronously than most other filesystems.
But even so, the number of callsites that I needed to change weren't
that large; in fact, over half of them weren't in the filesystem at
all, but in the page writeback code, since fsync() and data=ordered
both need to wait for the inodes's pages to be flushed out to disk,
and that's all done in common code.  The other 40% was in the jbd's
commit code, while we are writing out the journal buffers.

I suspect the more important thing to address is the fact that
WRITE_SYNC unplugs the block device queue, and we would be better off
separating marking a particular I/O as "a user is waiting for this"
from "unplug the device queue now".  That will hopefully improve
things even more.

					- Ted
