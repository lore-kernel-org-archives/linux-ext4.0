From: Dave Chinner <david@fromorbit.com>
Subject: Re: IO error semantics
Date: Tue, 19 Jan 2010 09:51:05 +1100
Message-ID: <20100118225105.GH7264@discord.disaster>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com> <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz> <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop> <20100118122437.GF7264@discord.disaster> <20100118140039.GA13909@laptop>
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
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100118140039.GA13909@laptop>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 19, 2010 at 01:00:39AM +1100, Nick Piggin wrote:
> On Mon, Jan 18, 2010 at 11:24:37PM +1100, Dave Chinner wrote:
> > On Mon, Jan 18, 2010 at 05:05:18PM +1100, Nick Piggin wrote:
> > > The problem we have now is that IO error semantics are not well defined.
> > > It is hard to even enumerate all the issues.
> > > 
> > > read IOs
> > >   how to retry? appropriate defaults should happen at the block layer I
> > >   think. Should retry behaviour be tunable by the mm/fs, or should that
> > >   be coded explicitly as submission retry loops? Either way does imply
> > >   there is either similar defaults for all types (or maybe classes) of
> > >   drivers, or some way to query/set this.
> > 
> > It's more complex than that - there are classes of errors to
> > consider as well. e.g transient vs permanent.
> > 
> > Transient is from stuff like FC path failures - failover can take up
> > to 240s to occur, and then the IO will generally complete
> > successfully.  Permanent errors are those that involve data loss e.g
> > bad sectors on single disks or on degraded RAID devices.
> 
> Yes. Is this something that should be visible above the block layer
> though? If it is known transient, should it remain uncompleted until it
> is successful?

I think it needs to be exposed because if the filesystem has
multiple copies of the data it can read from the other location
immediately and not hang the read for tens of seconds.

> Known permanent errors yes could avoid any need for retries. Leaving
> cases where the lower layers don't really know (in which case we'd
> maybe want to leave it to userspace or a userspace-set policy).

Personally I don't think users aren't going to be able to make
intelligent decisions about what do with such a knob. I'd prefer to
just make it a fixed policy first, and only provide tunables if
that is proved to be insufficient.

> > >   It would be nice to be able to set fs/driver behaviour from userspace
> > >   too, in a generic (not driver or fs specific way). But defaults should
> > >   be reasonable and similar between all, I guess.
> > 
> > I don't think generic handling is really possible - filesystems may
> > have different ways of recovering e.g. duplicate copies of data or
> 
> For write errors, you could also do block re-allocation, which would be
> fun.
> 
> > metadata or internal ECC that can be used to recovery the bad
> > region. Also, depending where the error occurs, the filesystem might
> > need to shutdown to be repaired....
> 
> Definitely there will be filesystem specific issues. But I mean that
> some common things could be specified (like how long / how many times
> to retry failed requests).

Agreed - there will be some common things fall out, but I'd like to
see an analysis done first before we try to extract the common
elements from the mess....

> > > write IOs
> > >   This is more interesting. How to handle write IO errors. In my opinion
> > >   we must not invalidate the data before an IO error is returned to
> > >   somebody (whether it be fsync or a synchronous write syscall).
> > 
> > We already pass the error via mapping_set_error() calls when the
> > error occurs and checking in it filemap_fdatawait_range().  However,
> > where we check the error we've lost all context and what range the
> > error occurred on. I don't see any easy way to track such an
> > error for later invalidation except maybe by a new radix tree tag.
> > That would allow later invalidation of only the specific range the
> > error was reported from.
> 
> If we always leave the error pages / buffers as dirty and uptodate,
> then we can walk the radix tree dirty bits. IO errors are only really
> reported by syncing calls anyway which walk dirty bits already.
> 
> If we wanted a purely querying syscall, it probably doesn't need to so
> so performance critical as to require a new tag rather than just
> checking PageError on the dirty pages.

The drive for the document I was writing was big, high performance
filesystems (think petabyte scale) and machines that might cache a
TB or two of a single file in memory. At that point, finding a
handful of error pages is like finding a needle in a haystack....

> > >   Any
> > >   earlier and the app just gets RAW consistency randomly violated. And I
> > >   think it is important to treat IO errors as transparently as possible
> > >   until the error can be detected.
> > > 
> > >   I happen to think that actually we should go further and not
> > >   invalidate the data at all. This makes implementation simpler, and
> > >   also allows us to retry writes like we can retry reads. It's also
> > >   problematic to throw out errors at that point because *sync syscalls
> > >   coming from elsewhere could result in loss of error reporting (think,
> > >   sys_sync).
> > 
> > The worst problem with this is what happens when you can't write
> > back to the filesystem because of IO errors, but you still allow more
> > incoming writes? It's not far from IO error to running out of memory
> > and deadlocking....
> 
> Again, keeping pages dirty so we'll start synchronous dirty pagecache
> throttling eventually.

write_cache_pages() decrements nr_to_write even if there was a write
error on that page. Hence the throttling in balance_dirty_pages
won't kick in if lots of errors occur during synchronous writeback
because it will think the number of pages it asked to be written
were written. Hence IO errors for written data often lead to OOM.

> That could cause problems of its own as well, but I don't know what else
> we can do. I don't think we can throw out the dirty data by default (the
> errors might be transient). It could be a policy, maybe.

A certain number of retries is certainly worth attempting for
errors that we can't directly report (background writeback), but
whether that should be done for sync/fsync is an open question in my
mind...

> > >   If we go this way, we probably need another syscall and fs helper call
> > >   to invalidate the dirty data when we give up on retries. truncate_range
> > >   probably not appropriate because it is much harder to implement and
> > >   maybe we want to try to get at the most recent data that is on disk.
> > 
> > First we need to track what needs invalidating...
> 
> Well by this I just mean the dirty, unwritten pagecache and its associated
> fs private structures. For errors in filesystem metadata yes it is a lot
> harder. I guess filesystems simply need to check and handle errors on a
> case by case basis.

Nothing simple about that. ;)

> > >   Also do we need to think about O_SYNC or -o sync type of writes that
> > >   are implemented via writeback cache? We could invalidate the dirtied
> > >   cache ASAP, which would leave a window where a concurrent read can see
> > >   first new, then old data. It would also kind of break the above scheme
> > >   in case the pagecache was already dirty via a descriptor without
> > >   O_SYNC. It might just make sense to leave the pagecache dirty. Either
> > >   way it should be documented I think.
> > 
> > How to handle this comes down to the type of error that occurred. In
> > the case of permanent error, the second read after the invalidation
> > probably should return EIO because you have no idea whether what is on
> > disk is the old, the new, some combination of the two or some other
> > random or stale garbage....
> 
> I'm not sure if that is important because you would have the same
> problems if the read was not preceded by a write (or if the write came
> from previous boot, or a different machine etc).

If the filesystem has been unmounted, then we have to assume that
corrective action has been taken (i.e. we've reported a problem,
it's been fixed) or the filesystem has marked the region bad.

> If we want to catch IO errors not detected by the block layer, it really
> needs a complete solution, in the fs.

Yes, though there are plenty of different types of errors the block
layer detects but report simply as "EIO". e.g. on Irix, the block
layer would report EXDEV rather than EIO for transient path-failure
errors so that it could be handled differently by the filesystem....

> > FWIW, I started to document some of what I've just been talking
> > (from a XFS metadata reliability context) about a year and a half
> > ago. The relevant section is here:
> > 
> > http://xfs.org/index.php/Reliable_Detection_and_Repair_of_Metadata_Corruption#Exception_Handling
> 
> OK, interesting. Yes a document is needed.
> 
>  
> > Though the entire page is probably somewhat relevant.  I only got as
> > far as documenting methods for handling transient and permanent read
> > errors, and the TODO includes handling:
> > 
> > 	- Transient write error
> > 	- Permanent write error
> > 	- Corrupted data on read
> > 	- Corrupted data on write (detected during guard calculation)
> 
> We do want to start by making this as _simple_ as possible. Even the
> existing rudimentary error reporting by the block layer is not used in a
> consistent way (or at all, in many cases).
> 
> So I think squashing corrupted data errors into transient/permanent
> errors (at least to start with) could be a good idea.

True. My main point is, though, we can't really make that
classification without understanding the whole scope of errors that
can occur and ensuring that we get the correct errors reported from
the lower layers first. i.e. this is not just a pagecache/filesystem
level problem - the lower layers have to do the right thing before we
can even hope to get it right at the FS level...

> > 	- I/O timeouts
> 
> Different from transient/permanent error cases?

Yeah - a week rarely goes by when we don't get a report of an XFS
filesystem hung due to something below it just stopping mid-IO
(DM, md, drivers, and/or hardware). e.g what appears to be a 
DM-related hang reported last night on #xfs:

http://www.pastebin.org/78102

And there was one last week where DM was stuck waiting for a barrier
write to complete and another where a raid controller was just hanging
mid IO.

IOWs, having the IO subsystem just stop completely dead and being
unrecoverable happens far too regularly to ignore when talking about
reliability engineering. These events almost always result in
filesystem corruption of some sort, even though what we have in
memory is consistent. That's because we have to reboot to get the IO
subsystem back and that loses the consistent in-memory state. Being
able to detect such hangs, re-initialise the complete stack below
the filesystem and then re-issue all the IO that was in flight would
make a large number of these problems go away.

> > 	- Memory corruption
> 
> Yes this needs support, which I've talked about in hwpoison discussions.
> Currently (or last time I checked) it just causes corrupted dirty
> pagecache to appear as an IO error. IMO this is wrong -- the fs or the
> app might retry the write, or try to re-allocate things and write that
> data elsewhere in the case of EIO, which is totally wrong for memory
> corruption.

Yes, and it's a hard one to detect (think bit errors in non-ECC memory)
without end-to-end data CRCs. On reads it can be treated as a
transient error, but I'm not sure how you'd classify it. I hadn't
got that far...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
