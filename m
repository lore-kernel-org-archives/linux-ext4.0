From: Nick Piggin <npiggin@suse.de>
Subject: Re: IO error semantics
Date: Tue, 19 Jan 2010 01:00:39 +1100
Message-ID: <20100118140039.GA13909@laptop>
References: <4B4EB5B9.4020809@hitachi.com>
 <4B4EDE5C.8040600@hitachi.com>
 <4B4EEE86.7080807@hitachi.com>
 <20100114141803.GB3146@quack.suse.cz>
 <20100118051847.GA8678@laptop>
 <20100118060518.GA9151@laptop>
 <20100118122437.GF7264@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab0AROAp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jan 2010 09:00:45 -0500
Content-Disposition: inline
In-Reply-To: <20100118122437.GF7264@discord.disaster>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 18, 2010 at 11:24:37PM +1100, Dave Chinner wrote:
> On Mon, Jan 18, 2010 at 05:05:18PM +1100, Nick Piggin wrote:
> > The problem we have now is that IO error semantics are not well defined.
> > It is hard to even enumerate all the issues.
> > 
> > read IOs
> >   how to retry? appropriate defaults should happen at the block layer I
> >   think. Should retry behaviour be tunable by the mm/fs, or should that
> >   be coded explicitly as submission retry loops? Either way does imply
> >   there is either similar defaults for all types (or maybe classes) of
> >   drivers, or some way to query/set this.
> 
> It's more complex than that - there are classes of errors to
> consider as well. e.g transient vs permanent.
> 
> Transient is from stuff like FC path failures - failover can take up
> to 240s to occur, and then the IO will generally complete
> successfully.  Permanent errors are those that involve data loss e.g
> bad sectors on single disks or on degraded RAID devices.

Yes. Is this something that should be visible above the block layer
though? If it is known transient, should it remain uncompleted until it
is successful?

Known permanent errors yes could avoid any need for retries. Leaving
cases where the lower layers don't really know (in which case we'd
maybe want to leave it to userspace or a userspace-set policy).


> >   It would be nice to be able to set fs/driver behaviour from userspace
> >   too, in a generic (not driver or fs specific way). But defaults should
> >   be reasonable and similar between all, I guess.
> 
> I don't think generic handling is really possible - filesystems may
> have different ways of recovering e.g. duplicate copies of data or

For write errors, you could also do block re-allocation, which would be
fun.


> metadata or internal ECC that can be used to recovery the bad
> region. Also, depending where the error occurs, the filesystem might
> need to shutdown to be repaired....

Definitely there will be filesystem specific issues. But I mean that
some common things could be specified (like how long / how many times
to retry failed requests).


> > write IOs
> >   This is more interesting. How to handle write IO errors. In my opinion
> >   we must not invalidate the data before an IO error is returned to
> >   somebody (whether it be fsync or a synchronous write syscall).
> 
> We already pass the error via mapping_set_error() calls when the
> error occurs and checking in it filemap_fdatawait_range().  However,
> where we check the error we've lost all context and what range the
> error occurred on. I don't see any easy way to track such an
> error for later invalidation except maybe by a new radix tree tag.
> That would allow later invalidation of only the specific range the
> error was reported from.

If we always leave the error pages / buffers as dirty and uptodate,
then we can walk the radix tree dirty bits. IO errors are only really
reported by syncing calls anyway which walk dirty bits already.

If we wanted a purely querying syscall, it probably doesn't need to so
so performance critical as to require a new tag rather than just
checking PageError on the dirty pages.


> >   Any
> >   earlier and the app just gets RAW consistency randomly violated. And I
> >   think it is important to treat IO errors as transparently as possible
> >   until the error can be detected.
> > 
> >   I happen to think that actually we should go further and not
> >   invalidate the data at all. This makes implementation simpler, and
> >   also allows us to retry writes like we can retry reads. It's also
> >   problematic to throw out errors at that point because *sync syscalls
> >   coming from elsewhere could result in loss of error reporting (think,
> >   sys_sync).
> 
> The worst problem with this is what happens when you can't write
> back to the filesystem because of IO errors, but you still allow more
> incoming writes? It's not far from IO error to running out of memory
> and deadlocking....

Again, keeping pages dirty so we'll start synchronous dirty pagecache
throttling eventually.

That could cause problems of its own as well, but I don't know what else
we can do. I don't think we can throw out the dirty data by default (the
errors might be transient). It could be a policy, maybe.


> >   If we go this way, we probably need another syscall and fs helper call
> >   to invalidate the dirty data when we give up on retries. truncate_range
> >   probably not appropriate because it is much harder to implement and
> >   maybe we want to try to get at the most recent data that is on disk.
> 
> First we need to track what needs invalidating...

Well by this I just mean the dirty, unwritten pagecache and its associated
fs private structures. For errors in filesystem metadata yes it is a lot
harder. I guess filesystems simply need to check and handle errors on a
case by case basis.


> >   Also do we need to think about O_SYNC or -o sync type of writes that
> >   are implemented via writeback cache? We could invalidate the dirtied
> >   cache ASAP, which would leave a window where a concurrent read can see
> >   first new, then old data. It would also kind of break the above scheme
> >   in case the pagecache was already dirty via a descriptor without
> >   O_SYNC. It might just make sense to leave the pagecache dirty. Either
> >   way it should be documented I think.
> 
> How to handle this comes down to the type of error that occurred. In
> the case of permanent error, the second read after the invalidation
> probably should return EIO because you have no idea whether what is on
> disk is the old, the new, some combination of the two or some other
> random or stale garbage....

I'm not sure if that is important because you would have the same
problems if the read was not preceded by a write (or if the write came
from previous boot, or a different machine etc).

If we want to catch IO errors not detected by the block layer, it really
needs a complete solution, in the fs.

 
> > Do we even care enough to bother thinking about this now? (serious question)
> 
> It's a damn hard problem and many of the details are filesystem
> specific. However, if we want high grade reliability from our
> systems then we have to tackle these problems at some point in time.
> 
> FWIW, I started to document some of what I've just been talking
> (from a XFS metadata reliability context) about a year and a half
> ago. The relevant section is here:
> 
> http://xfs.org/index.php/Reliable_Detection_and_Repair_of_Metadata_Corruption#Exception_Handling

OK, interesting. Yes a document is needed.

 
> Though the entire page is probably somewhat relevant.  I only got as
> far as documenting methods for handling transient and permanent read
> errors, and the TODO includes handling:
> 
> 	- Transient write error
> 	- Permanent write error
> 	- Corrupted data on read
> 	- Corrupted data on write (detected during guard calculation)

We do want to start by making this as _simple_ as possible. Even the
existing rudimentary error reporting by the block layer is not used in a
consistent way (or at all, in many cases).

So I think squashing corrupted data errors into transient/permanent
errors (at least to start with) could be a good idea.

> 	- I/O timeouts

Different from transient/permanent error cases?


> 	- Memory corruption

Yes this needs support, which I've talked about in hwpoison discussions.
Currently (or last time I checked) it just causes corrupted dirty
pagecache to appear as an IO error. IMO this is wrong -- the fs or the
app might retry the write, or try to re-allocate things and write that
data elsewhere in the case of EIO, which is totally wrong for memory
corruption.

