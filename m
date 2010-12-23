From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Atomic non-durable file write API
Date: Thu, 23 Dec 2010 17:22:06 -0500
Message-ID: <20101223222206.GD12763@thunk.org>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
 <AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com>
 <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
 <4D0A7278.3080506@gmail.com>
 <1292710543.17128.14.camel@nayuki>
 <AANLkTimbkstru_nUxnd7R8Zg=ioB3skTntedq_dLxpZm@mail.gmail.com>
 <AANLkTi=BW85d6VpGAt0KaGES+4dRQmsvRyFamE=ChEXE@mail.gmail.com>
 <20101224085126.2a7ff187@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35237 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0LWWWL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Dec 2010 17:22:11 -0500
Content-Disposition: inline
In-Reply-To: <20101224085126.2a7ff187@notabene.brown>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 24, 2010 at 08:51:26AM +1100, Neil Brown wrote:
> You are asking for something that doesn't exist, which is why no-one can tell
> you want the answer is.

Basically, file systems are not databases, and databases are not file
systems.  There seems to be an unfortunate tendency for application
programmers to want to use file systems as databases, and they suffer
as a result.

Among other things, file systems have to be fast a very wide variety
of operations, including compiles, and we don't have ways for people
to explicitly delineate transaction boundaries.  And of course,
everyone else has different ideas of what kind of consistency
guarantees they want.

You may *say* that you don't care which version of the file you get
after a rename, but only that one or the other is valid, but what if
some other program reads from the file, gets the second file, and
sends out a network message saying the rename was successful, but then
a crash happens and the rename is undone?  There's a reason why
databases block reads of a modified row until the transaction is
completed or rolled back.

> The only mechanism for synchronising different filesystem operations is
> fsync.  You should use that.
> 
> If it is too slow, use data journalling, and place your journal on a
> small low-latency device (NVRAM??)

Or use a real database, and don't try to assume you will get database
semantics when you try to write to multiple small files.

Or you can use various compromise solutions which provide lesser or
greater guarantees: for example:

1.	sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WRITE);

2.	sync_file_range(fd, 0, 0, SYNC_FILE_RANGE_WRITE |
			          SYNC_FILE_RANGE_WAIT_AFTER);

3.	fdatasync(fd);

4.	fsync(fd);

are four different things you can do, listed in order of increasing
cost, and also increasing guarantees that you will survive a system
crash, or a power cut (only the last two will guarantee data survival
after a power cut).

If you don't care about the mod-time, fdatasync() could be less costly
than fsync().

If you only care about a 3D game crashing the system when it exits
(which some Ubuntu users using Nvidia drivers think is normal;
sigh...), but not what happens on a power cut, then maybe option #2 is
enough.

The implementors of a number of mainstream file systems (i.e., ext4,
btrfs, XFS) have agreed to do the equivalent of #1 (i.e., initiating
writeback, but not necessarily waiting for the writeback to complete)
in the case of a rename that replaces an existing file.  Some file
systems may do chose to do more (i.e., either waiting for the
writeback to complete: #2) or actually issuing a barrier operation
(#3, which is way more expensive), but some of these will slow down
source tree builds, where in truth people *really* don't care if a
file is trashed on a crash or power failure, since you can always
regenerate a file by rerunning "make".

But for the crazy kids who want to write several hundred small files
when an GNOME or KDE application exits (one file for the X coordinate
for the window, another file for the Y coordinate, another file for
the height of the window, another file for the width of the window,
etc....) --- cut it out.  That way just lies insanity; use something
like sqlite instead and batch all of your updates into a single atomic
update.  Or don't use crappy proprietary drivers that will crash your
system at arbitrary (and commonplace) times.

						- Ted
 
