From: Jan Kara <jack@suse.cz>
Subject: Re: Ext4 developers get together planning
Date: Mon, 2 Mar 2015 22:20:32 +0100
Message-ID: <20150302212032.GD19575@quack.suse.cz>
References: <nsxbnkb9z0f.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jun He <jhe@cs.wisc.edu>,
	Peter Desnoyers <pjd@ccs.neu.edu>,
	Abutalib Aghayev <agayev@gmail.com>,
	Daeho Jeong <daeho.jeong@samsung.com>,
	Jin-Soo Kim <jinsookim@skku.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Timothy R Feldman <timothy.r.feldman@seagate.com>,
	Adrian Palmer <adrian.palmer@seagate.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbbCBVUo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2015 16:20:44 -0500
Content-Disposition: inline
In-Reply-To: <nsxbnkb9z0f.fsf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-03-15 10:53:36, Ted Tso wrote:
> 
> Looking at the Vault schedule, it looks like the best time to schedule
> the ext4 developer's workshop will be Wednesday from noon to 3pm (we'll
> meet for lunch and then continue until Jan Kara's ext4 file system
> scalaing talk.
> 
> And then we can pick up Thursday morning starting at 10am and go on
> until Lunch.  (Or we could start at 9am and skip the Sasha Levin's file
> system fuzzing talk, but I suspect some people wouldn't want to miss
> Sasha's talk.)
> 
> Does that work for everyone?
> 
> Things which I expect will be on the schedule include:
> 
> * ext4 encryption progress report (Michael Halcrow, Ted)
> * making ext4 smr friendly (Abutalib, Peter, Ted, Tim, Adrian)
> * improving the ext4 block allocator (Jun He)
> 
> Since Jaeguk probably would only be interested in the encryption
> discussions, I'm going to suggest that we schedule the encryption
> discussions for Thursday morning, and the SMR discussions for Wednesday
> afternoon, since our minds will be fresh immediately after the SMR
> discussions on Thursday morning.
> 
> What other topics would people like to include?  Please suggest them on
> this e-mail thread.
  I have about 4 bugs we have in ext4 that I didn't get to fixing because
the fix isn't immediately obvious. Maybe some discussion on these would be
useful. The issues I'm aware of are:
1) filling of hole from ext4_page_mkwrite() in nodelalloc mode (or when we
   are running out of space) can race with DIO read of the same location
   resulting in DIO read returning uninitialized block data (possible
   security issue).

   I think using uninitialized extents is the right solution here if we can
   but what about indirect mapped files (think of ext2 / ext3 compatibility
   modes)?

2) When doing AIO DIO write we store pointer to ioend structure in the
   inode. However in dioread_nolock mode, we can run two AIO DIO overwrites
   in parallel and thus one ioend just overwrites the other resulting in
   nasty issues. No idea how to best fix this (but I didn't think much
   about it).

3) inode->i_writecount >= 1 doesn't actually guarantee that ->release()
   method will be called (as there are places that increase / decrease
   i_writecount without actually opening the file). Thus we can leave
   preallocated blocks in an inode.

   Truncating blocks in ext4_clear_inode() isn't completely reliable since
   filesystem may be remounted R/O by then. We can create our own writer
   count but that seems like a bit of an overkill...

4) There's the longstanding issue with punch hole racing with page fault
   that can lead to stale data exposure or fs corruption. Proper fix in mm
   is tricky and won't happen soon so should we go the way XFS recently
   went and just create special locking for that withing ext4?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
