From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Mon, 27 Feb 2012 15:00:12 -0700
Message-ID: <E74F7AC0-20B9-4F5C-835B-79C9C9233F4A@dilger.ca>
References: <20120227090901.GA13953@gmail.com> <4F4BA33C.1050303@redhat.com> <20120227174441.GC1651@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:51870 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2B0WAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2012 17:00:14 -0500
In-Reply-To: <20120227174441.GC1651@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-27, at 10:44 AM, Ted Ts'o wrote:
> On Mon, Feb 27, 2012 at 09:37:32AM -0600, Eric Sandeen wrote:
>> 
>> Essentially this would move allocation decisions to userspace, and I don't
>> think that sounds like a good idea.  If nothing else, the application shouldn't
>> assume that it "knows" anything at all about which regions of a filesystem may
>> be faster or slower...
> 
> What I *can* imagine is passing hints to the file system:
> 
> 	* This file will be accessed a lot --- vs --- this file will
> 	  be written once and then will be mostly cold storage
> 
> 	* This file won't be extended once originally written --- vs
>          --- this file will be extended often (i.e., it is a log file
>          or a unix mail directory file)
> 
> 	* This file is mostly emphemeral --- vs --- this file will be
>          sticking around for a long time.
> 
> 	* This file will be read mostly sequentially --- vs --- this
>          file will be read mostly via random access.

I definitely think that this is Zheng's real goal - to be able to give
application-level hints to the underlying filesystem.  While Lukas and
Eric may disagree with the _mechanism_ that Zheng proposed, I definitely
think the _goal_ is useful.

Often when working at the filesystem level the kernel has to try and
guess the intent of the application instead of being told what the
application actually wants.  A prime example is delalloc vs. fallocate(),
where the kernel is guessing (via delalloc) that the application may be
writing more data to the filesystem so it should delay flushing that
data to disk in the hope of making a better decision, while fallocate()
allows the application to specify exactly what file data will be written
and the kernel can make a good allocation decision immediately.

> Obviously, these can be combined in various interesting ways; consider
> for example an application journal file which is rarely read (except
> in recovery circumstances, after a system crash, where speed might not
> be the most important thing), and so even though the file is being
> appended to regularly, contiguous block allocations might not matter
> that much --- especially if the file is also being regularly fsync'ed,
> so it would be more important if the blocks are located close to the
> inode table.  This isn't a hypothetical situation, by the way; I once
> saw a performance regression of ext4 vs. ext2 that was traced down to
> the fact that ext2 would greedily allocate the block closest to the
> inode table, whereas ext4 would optimize for reading the file later,
> and so allocating a large contiguous block far, far away from the
> inode table was what ext4 choose to do.  However, in this particular
> case, optimizing for the frequent small write/fsync case would have
> been a better choice.
> 
> 
> In some cases the file system can infer some of these characteristics
> (e.g. if the file was opened O_APPEND, it's probably a file that will
> be extended often).
> 
> In other cases it makes sense for this sort of thing to be declared
> via an fcntl or fadvise when the file is first opened.  Indeed we have
> some of this already via fadvise's FADV_RANDOM vs. FADV_SEQUENTIAL,
> although currently the expectation of this interface is that it's
> mostly used for applications declare how they plan to read a
> particular file from the perspective of enabling or disabling
> readahead, and not from the perspective of influencing how the file
> system should handle its allocation policy.

Yes, using FADV_* for files during write is exactly the kind of hint
that the kernel could use.  I expect that the current FADV_* flags are
not rich enough, but at least could form a starting point for this.

> I definitely agree that we don't want to go down the path of having
> applications try to directly decide where block should be placed on
> the disk.  That way lies madness.  However, having some way of
> specifying the behaviour of how the file is going to be used can be
> very useful indeed.

> 
> There are still some interesting policy/security questions, though.
> Do you trust any application or any user id to be able to declare that
> "this file is going to be used a lot"?  After, all if everyone
> declares that their file is accessed a lot, and thus deserving of
> being in the beginning third of the HDD (which can be significantly
> faster than the rest of the disk), then the whole scheme falls apart.

In some sense, in the rare case where all applications are ill behaved
then it is no worse than not having any interface in the first place.
In general, however, I don't expect applications to abuse this any more
than they abuse fallocate() to reserve huge amounts of space that they
don't need to use.

> Do we simply not care?  Do we reserve the ability to set certain file
> usage declarations only to root, or via some cgroup?  The answers are
> not obvious....  For some parameters it probably won't matter if we
> let unprivileged users declare whether or not their file is mostly
> accessed sequentially or random access.  But for others, it might
> matter a lot if you have bad actors, or worse, bad application writers
> who assume that their web browser or GUI file system navigator, or
> chat program should have the very best and highest priority blocks for
> their sqlite files.

Sure, and the users can stop using badly-written applications, but that
is no reason to deny the ability for well written applications from
helping the kernel make better decisions.

Cheers, Andreas





