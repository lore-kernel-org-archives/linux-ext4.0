From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC] A better solution to the HTree telldir problem
Date: Mon, 21 Jul 2008 22:56:39 -0400
Message-ID: <20080722025638.GK28839@mit.edu>
References: <200807211411.52007.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, ext2-devel@lists.sourceforge.net
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33653 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852AbYGVDAQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2008 23:00:16 -0400
Content-Disposition: inline
In-Reply-To: <200807211411.52007.phillips@phunq.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2008 at 02:11:51PM -0700, Daniel Phillips wrote:
> This is something of a duh: if HTree refrains from splitting leaves 
> while a directory traversal is in progress then a simple linear 
> traversal can be used in classic Ext2/UFS fashion, with the logical 
> file address of each directory entry serving as the telldir cookie.

The problem here is the phrase "while a directory traversal is in
progress".  What does that mean?  While a file descriptor is open on a
directory?  An application could call opendir(), and then go to sleep
for a week.  Or, a user could type control-Z while an "ls -lR" is in
progress, and then forget to resume it.  So any scheme has to be
prepared to not split leaves for a *long* time.

You later say that we only need to do this if the user calls
telldir(); although of course the kernel doesn't know if the user has
called telldir().  We only know if the lseek() system call has been
called.  So it becomes impossible for us to distinguish between an
application calling telldir() or rewinddir().  So we would end up
needing to do this more often than might be strictly necessary.

The problem becomes even worse with NFS, because we have absolutely no
idea whether or not lseek() has been called.  Even worse, because NFS
is a stateless protocol, we don't even know when a file handle is
closed!  So we can't even detect a closedir()!  Or of course, an
opendir()!  With NFS all you get is an NFS getattr RPC, which could be
used to service either a stat(2) call or an open(2) call.  The net is
that while NFS mount is in progress, we would never be able to split a
leaf.

So your optimization of only doing this if there is a telldir()
operation may not make the operation be as rare as we might like,
especially if there are some user programs that keep file descriptors
open over long periods for inotify purposes, and then use rewinddir().
We would need to check out the behavior of programs such as trackerd
and the GNome VFS library routines to see whether this could
potentially be a problem.

It might be possible to make some assumptions that if userspace calls
lseek(fd, 0, SEEK_SET), that this really is a rewinddir(), and not a
telldir(), but this could be a potentially dangerous assumption since
there is no way to know for sure whether userspace is paying attention
to the return value of lseek(fd, 0, SEEK_SET) or not.

> The idea is to disable leaf splitting during directory traversal and use 
> an alternate leaf overflow mechanism in its place.  To handle a create 
> into a full leaf when splitting is disabled, a new leaf block is 
> created having the same hash index as the current one and inserted 
> before the full leaf in the hash tree to hold the new entry and any 
> subsequent creates into the same hash bucket.  The lookup probe has to 
> be modified slightly to traverse all leaves with the same hash index.
> Or maybe this already works.

The lookup probe would indeed need to be modified, but that's not a
major deal.  The bigger deal is that lookups are less efficient, since
we it effectively looks like a hash bucket overflow.

> HTree could opportunistically re-distribute the entries later when no 
> directory listing is in progress, or it could just leave things as they 
> are.  The fallback is quite unlikely to occur in practice, and the 
> alternative storage format is only very slightly less efficient to 
> process on lookup, and does not consume any extra space.

How likely it takes place depends on how often an opendir()/readdir()
cycle is held for a long period of time.  It will depend on your
application workload.  And if NFS is enabled, all bets are off.

> If the new semantics are acceptable, the payoff for adopting this simpler
> method is:
> 
>   * Can use a more efficient HTree hash because we do not need to be so
>     paranoid about bucket levelling to avoid rare cases that might break
>     the RB tree approach.

Yes we do, because the biggest problem we have right now is your
original implementation hard codes us to a tree which is at most two
levels deep.  Clusterfs/Sun has more general code which allows an
arbitrary deep tree, but we would need to integrate that into the
kernel, and also get support for that into e2fsck.

>   * We get to use the nice shiny alternative hash mechanism that we put
>     considerable effort into building but so far have never used.

We are using alternative hash algorithms already....

>   * Delete will now happen in physical create order and therefore not
>     thrash the inode table, which is a problem that HTree can currently
>     hit with large directories ant tight cache.

Not just deletes, but any kind of readdir followed by stat operation.
This includes "ls -sF", find, sendmail/exim queue operations, etc., in
addition to "rm -rf".

>   * Several hundred lines of special purpose code removed.  (Replaced by
>     maybe 50 different lines of special purpose code.)

If you mean the rbtree fill code, I suspect the special purpose code
you are referring to will be roughly end up being roughly the same
size, plus or minus 20%.  That's because in order to do what you are
suggesting, after we finish looking at one leaf node, we will need to
go back to the interior node, and find the next leaf node to see if
the hash is the same.  And if we are at the end of the interior node,
we may need to recursively go up one level, and then back down to find
the subsequent leaf node.

Even worse, since if NFS is enabled in any way, shape or form, this
scheme is totally and completely screwed.  So we have to the old way
of doing things if NFS is turned on.

							- Ted
