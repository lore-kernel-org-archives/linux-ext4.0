From: Theodore Tso <tytso@mit.edu>
Subject: Re: tiny e2fsprogs fix, bitmaps question
Date: Wed, 18 Apr 2007 12:46:24 -0400
Message-ID: <20070418164624.GE24963@thunk.org>
References: <20070418065443.GA3438@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53886 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992850AbXDRQq2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2007 12:46:28 -0400
Content-Disposition: inline
In-Reply-To: <20070418065443.GA3438@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 18, 2007 at 12:54:44AM -0600, Andreas Dilger wrote: 

  [ I'm quoting out of order here, and cc'ing the linux-ext4 list with
    permission since I think the topics under discussion have a more
    general interest.  --Ted]

> Just reading the updated e2fsck.conf.5 man page, and noticed in [scratch files]:
> 
> numdirs_threshold:
> s/numbers of directory/number of directories/

Oops, thanks for catching that.  I implemented the in-core memory
reduction patches in somewhat of a hurry because I had a number of
users who had been using BackupPC or other similar hard-link intensive
backup programs, and they were running into massive memory usage
issues.  So this took priority over the extents refactorization work
(which is currently on the top of my e2fsprogs work queue).

> We are also looking to implement something better than raw bitmaps for
> cases where the set bits are expected to be sparse (e.g. block_dup_map,
> inode_bad_map, inode_bb_map, inode_imagic_map), instead of just going
> wholesale to on-disk storage (which is just going to slow things down).

The other type of bitmap implementation which I had been thinking
about asking people to implement is one which works well in the case
where the set bits are expected to be mostly be contiguous --- i.e.,
the block allocation map --- so some kind of extent-based data
structure indexed using an in-memory b-tree would be ideal.

Note that for block_dup_map, inode_bad_map, inode_bb_map,
inode_imagic_map, et. al., they are usually not allocated at all, and
if they are allocated, so while there are usually a very few numbers
of set bits, so using a tree-indexed, extent-based data structure
should work just fine for this sort of implementation.  Yes, it's not
as efficient as a array of integers, but it's much more efficient.

> The current API doesn't match that of the normal bitmap routines,
> but I think that is desirable.  What do you think?  The other
> thing that is lacking is an efficient and generic bitmap iterator
> instead of just walking [0 ... nbits], because in the sparse case
> the full-range walking can be grossly inefficient.

I agree it's desirable, and I had been planning a bitmap API revision
anyway.  The big changes I had been thinking for the new interface were:

	* 64-bit enabled
	* no inline functions
	* pluggable back-ends (for multiple implementations, 
		traditional, tree-based extents, disk-backed, etc.)
	* extent-based set/clear functions (so you can take an extent map
		from an inode and mark the entire extent as allocated in a block 
		bitmap)
	* To provide backwards ABI compatibility, if the magic number
		in the first word of the bitmap indicates an old-style
		bitmap, dispatch to the old inline-style bitmap operators

An iterator makes a lot of sense and I hadn't thought of it, but we
should definitely add it.  It might also be a good idea to add an
extent-based iterator, as well, since that would be even more CPU
efficient for some callers.

> Some things we are targetting with the design:
> - use less RAM for sparsely populated bitmaps
> - be not much worse than bitmaps if they turn out not to be sparse
> - avoid allocating gigantic or many tiny chunks of memory
> - be dynamic in chosing the method for storing "set" bits

Yep, all good things.  I hadn't really considered the requirement of
dynamically choosing a method, but that's because I figured the
tree-indexed extents data structure would hopefully be general purpose
enough to work with a very large range of filesystems, and dynamism
wasn't something I wanted to try to solve the first time around.

My current thinking favors a design like the io_manager, where you can
have one io_manager (test_io) provide services where the actual back
end work is done by another io_manager (i.e., unix_io).  So I could
imagine a "auto" bitmap type which automatically converts bitmap
representations behind the scenes from an in-memory to an on-disk
format, hopefully using a single in-memory format which is generally
applicable to most cases (such as tree-indexed extents), and then once
you go out to disk, it's all about correctness and completing the
task, and only secondarily about performance.  

But part of that is that while your ebitmap implementation has
desirable properties in terms of scaling from in-memory sparse arrays
to full bitmaps, I suspect a tree-indexed extents implementation has a
wider range of applicability, so I was assuming that we wouldn't have
to get to the dynamic switching part of the program for quite some 
time.  (IIRC, all xfs_repair has right now is a simple bit-count
compression scheme, and that seems to have been sufficient for them.)

BTW, If you're interested in implementing an extent-based b-tree,
which will be the next low-hanging fruit in terms of reducing
e2fsprogs's memory usage, not that we already have a red-black tree
implementations in e2fsprogs/dict.[ch].  The code would have to be
moved into libext2fs, and its namespace cleaned up the same way I did
with the tdb code (see tdb.h starting about line 80), but that would
be fairly easy to do.

> It might also be desirable to hook this into your recently-added
> tdb implementation so that it can dynamically scale from the
> in-memory sparse arrays, through full bitmaps (if RAM allows),
> and to tdb if we overflow RAM.

It turns out that tdb probably won't work that well for bitmaps, and
that's because its underlying representation is using extensible
hashing, so we don't have convenient functions such as
dict_lower_bound() (see e2fsprogs/e2fsck/dict.c).  That means that
while you could store an bitmap using an extents-based compression
scheme, there's no good/efficient way to do lookups given that you
only have fetch, store, and iterate as your as your I/O interfaces.

Basically I choise tdb because it was easy to encapulate and include
in the library, not because it was the most flexible and powerful
on-disk database system.  That would have been berkdb, but it's a heck
of a lot bigger, with lots more interfaces, so it would have been
painful to drop into the ext2fs library, and if I had added it as an
external dependency, the fact that there are multiple versions on
different distributions/operating systems would have made it a
portability nightmare.

The version of tdb which I chose does have transaction support (I used
the bigger one from Samba 4, instead of the older Samba 3 version),
and I consciously chose that since that's the version getting
maintenance from upstream, and because transaction support will be
useful for implementating an io_manager that has provides an undo log
functionality --- an often-requested feature for e2fsck, and also
useful for a future program to allow us to rewrite the inode table so
we can change the inode size of an existing filesystem from 128 to 256
bytes without needing to do a restore/backup.

> In that sense, it would be better to have an e2fsck.conf parameter like
> "max_ram_used" instead of "numdirs_threshold" which no user will know
> the correct value for, and varies depending on the system RAM.  I've
> thought for a while that it might make sense to have an e2fsck (and
> concievably all mkfs.* that want to participate) option like
> "--estimate-memory" that fsck can call on each filesystem to see whether
> it can run multiple e2fscks in parallel for the currently free system RAM.

I agree with the concept, although I would probably have e2fsck and
mke2fs try to automatically fetch the information from /proc/meminfo
on Linux machines, and to pull the information from /etc/e2fsck.conf
or /etc/mke2fs.conf on other systems.

For mke2fs this is pretty simple, since users rarely will do two
mke2fs's in parallel.  And arguably, we shouldn't need to do anything
at all, since the block layer should be responsible for doing write
throttling.  But if we need a workaround which periodically forces a
sync, it's not all that clear that we need to be all that accurate.
The current mechanism of flushing every N block groups is probably
plenty.  And since we know that the bitmaps aren't going to be
terribly complicated for mke2fs, it would be simple enough to just use
a fixed bitmap type, and be done with it.

This is a *lot* more complicated for e2fsck, since different e2fsck
jobs will take different amounts of memory, and it may be the right
solution is not to run as many e2fsck's in parallel, but rather to
simply run them one at a time.  So it may be that fsck needs to query
the filesystem checker program via some interface to see how much
resources they need (CPU and memory) as part of its balancing
algorithm, and perhaps not run as many e2fsck's in parallel.  Or maybe
fsck should just pass information to e2fsck about how many sister
e2fscks will be running --- or maybe multiple e2fsck programs should
be coordinating with each other about how much memory each should use
via shared tdb file as a rendezvous point.

Even for the single e2fsck case, sometimes you just don't know how
much memory will be needed.  Some of the superblock fields that we
depend upon for our estimate may be wrong, or we may not necessarily
need as many bitmaps, depending on how badly corrupted the filesystem
might be.  So yes, autotuning is a good concept, but I'm not sure we
can really easily map it to megabytes of memory at least right away.  

I'd definitely like to get there, but I don't think it's a trivial
thing to do; and in the meantime, having individual tuning knobs is
probably a good short-term mechanism for now.  Eventually we can try
to do something which auto-tunes based on available memrory, but I
always pictured that as something we would do after we had gotten some
of the key improvements into ext4/e2fsprogs, such as the extents and
the compact dirinfo, icount, and bitmap implementations.  Then we can
go back and try to get a handle of how much memory a typically large
filesystem might require, and see what kind of auto-tuning/memory
managmeent schemes will really be necessary.

> PS - did you see the "__u32 i_version_hi" field patch to add this after
>      i_crtime_extra?  I didn't see this in the latest e2fsprogs, and we
>      want to make use of that field in the next few months but don't
>      want to start using it if it will not be permenently assigned.

Let me look.  If I can't find it, I'll let you know....

						- Ted
