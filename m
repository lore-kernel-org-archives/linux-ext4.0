From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Mon, 27 Feb 2012 12:44:41 -0500
Message-ID: <20120227174441.GC1651@thunk.org>
References: <20120227090901.GA13953@gmail.com>
 <4F4BA33C.1050303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45897 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767Ab2B0Ron (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 12:44:43 -0500
Content-Disposition: inline
In-Reply-To: <4F4BA33C.1050303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 27, 2012 at 09:37:32AM -0600, Eric Sandeen wrote:
> 
> Essentially this would move allocation decisions to userspace, and I don't
> think that sounds like a good idea.  If nothing else, the application shouldn't
> assume that it "knows" anything at all about which regions of a filesystem may
> be faster or slower...

What I *can* imagine is passing hints to the file system:

	* This file will be accessed a lot --- vs --- this file will
	  be written once and then will be mostly cold storage

	* This file won't be extended once originally written --- vs
          --- this file will be extended often (i.e., it is a log file
          or a unix mail directory file)

	* This file is mostly emphemeral --- vs --- this file will be
          sticking around for a long time.

	* This file will be read mostly sequentially --- vs --- this
          file will be read mostly via random access.

Obviously, these can be combined in various interesting ways; consider
for example an application journal file which is rarely read (except
in recovery circumstances, after a system crash, where speed might not
be the most important thing), and so even though the file is being
appended to regularly, contiguous block allocations might not matter
that much --- especially if the file is also being regularly fsync'ed,
so it would be more important if the blocks are located close to the
inode table.  This isn't a hypothetical situation, by the way; I once
saw a performance regression of ext4 vs. ext2 that was traced down to
the fact that ext2 would greedily allocate the block closest to the
inode table, whereas ext4 would optimize for reading the file later,
and so allocating a large contiguous block far, far away from the
inode table was what ext4 choose to do.  However, in this particular
case, optimizing for the frequent small write/fsync case would have
been a better choice.


In some cases the file system can infer some of these characteristics
(e.g. if the file was opened O_APPEND, it's probably a file that will
be extended often).

In other cases it makes sense for this sort of thing to be declared
via an fcntl or fadvise when the file is first opened.  Indeed we have
some of this already via fadvise's FADV_RANDOM vs. FADV_SEQUENTIAL,
although currently the expectation of this interface is that it's
mostly used for applications declare how they plan to read a
particular file from the perspective of enabling or disabling
readahead, and not from the perspective of influencing how the file
system should handle its allocation policy.

I definitely agree that we don't want to go down the path of having
applications try to directly decide where block should be placed on
the disk.  That way lies madness.  However, having some way of
specifying the behaviour of how the file is going to be used can be
very useful indeed.

There are still some interesting policy/security questions, though.
Do you trust any application or any user id to be able to declare that
"this file is going to be used a lot"?  After, all if everyone
declares that their file is accessed a lot, and thus deserving of
being in the beginning third of the HDD (which can be significantly
faster than the rest of the disk), then the whole scheme falls apart.

	"That King, although no one denies
	His heart was of abnormal size,
	Yet he'd have acted otherwise
	If he had been acuter.
	The end is easily foretold,
	When every blessed thing you hold
	Is made of silver, or of gold,
	You long for simple pewter.
	When you have nothing else to wear
	But cloth of gold and satins rare,
	For cloth of gold you cease to care--
	Up goes the price of shoddy.

	In short, whoever you may be,
	To this conclusion you'll agree,
	When every one is somebodee,
	Then no one's anybody!"

	     	-- Gilbert and Sullivan, The Gondoliers
		http://lyricsplayground.com/alpha/songs/t/therelivedaking.shtml

Do we simply not care?  Do we reserve the ability to set certain file
usage declarations only to root, or via some cgroup?  The answers are
not obvious....  For some parameters it probably won't matter if we
let unprivileged users declare whether or not their file is mostly
accessed sequentially or random access.  But for others, it might
matter a lot if you have bad actors, or worse, bad application writers
who assume that their web browser or GUI file system navigator, or
chat program should have the very best and highest priority blocks for
their sqlite files.

						- Ted

