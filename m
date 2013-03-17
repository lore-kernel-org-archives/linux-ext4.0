From: "George Spelvin" <linux@horizon.com>
Subject: Re: Sign, more experimentation and broken features...
Date: 17 Mar 2013 13:51:54 -0400
Message-ID: <20130317175154.17375.qmail@science.horizon.com>
References: <20130312040649.GD18595@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:15476 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755751Ab3CQRv4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Mar 2013 13:51:56 -0400
In-Reply-To: <20130312040649.GD18595@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> It may be worth mounting the file system read-only and copying all of
> your data off before you do anything else....

Okay, I managed to borrow enough drives (and SATA ports) to do that.
(The while issue started after I consolidated several separate
drives onto one RAID, then added the source drives to the RAID and
tried to grow the file system.  So the FS corruption was discovered
just a bit too late to go back to the originals.)

> Also, it looks like there may be some problems with the metadata_csum
> option when resizing, either alone or in combination with bigalloc.
> Please note that I have ___not___ really done a lot of exhaustive
> testing with metadata_csum, since it's not in a released final state
> in e2fsprogs, and I've had lots of other things I've been busy trying
> to make sure is stablized.  For example, we are still working on
> fixing various test failures with bigalloc.  It's probably good enough
> for fairly simple workloads (mostly using fallocate and direct I/O),
> but there are corner cases which we are still working on fixing.

I think the big issue is with resizing bigalloc file systems.
Which, as the ext4 wiki page says, currently Doesn't Work.

(One random question I'm curious about is how a larger cluster size
differs from just having a larger block size and why you bothered
creating a new superblock field.  There's probably some discussion
on a mailing list if I search hard enough.)

Anyway, I *think* I have all the drives I intend to add to my big
RAID for a while.  (This is yet another "personal media server" box.)
I now have (borrowed) disjoint source data drives, so I can just create
the RAID and file system in its "final" size.

But it might grow in future.  What I'm trying to decide is if it's worth
risking using bigalloc and relying on resizing becoming reliable in 6
months or so.


With the 2 TB drives that are the best GB/$ these days, it's possible to
break the the 2^32 block limit I ran into last time I complained about
a file system corrupted by resizing.  Even one or two extra bits of
addressing pushes that limit comfortably far away.  (An 8-data-drive
array is practical, a 16-drive array is not really, 32x2 TB would just
be perverse.)

So a large cluster size lets me avoid a 64-bit file system (*another*
new and not-so-well-tested feature).

This RAID probably won't grow beyond 16 TB (it's at 10 TB right now)
before it's time to switch to larger disks, which will probably involve
rebuilding the FS.  But a slightly larger cluster size would make sure
I wouldn't need to start with a 64-bit FS.  (Bigger in-kernel data
structures, and it's *another* not-so-thoroughly-tested feature.)


Any guidance on this question (or general mke2fs parameter suggestions)
is greatly appreciated!
