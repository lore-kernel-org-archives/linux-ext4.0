From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Defragmentation interface
Date: Mon, 6 Nov 2006 13:54:27 +1100
Message-ID: <20061106025427.GG11034@melbourne.sgi.com>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz> <20061102225953.GF8394166@melbourne.sgi.com> <20061103143030.GB17306@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061103143030.GB17306@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 03, 2006 at 03:30:30PM +0100, Jan Kara wrote:
> > >   So in this email I try to propose some interface which should hopefully
> > > address most of the concerns. The type of the interface is sysfs like
> > > (idea taken from ext2meta) - that has a few advantages:
> > >  - no 32/64-bit compatibility issues
> > >  - easily extensible
> > >  - generally nice ;)
> > 
> > - complex
> > - over-engineered
> > - little common code between filesystems
>   The first two may be but actually I don't think you'll have too much
> common code among fs anyway whatever interface you choose.
> 
> > BTW, does use of sysfs mean ASCII encoding of all the data
> > passing between kernel and userspace?
>   Not necessarify but mostly yes. At least I intend to have all the
> files I have proposed in ASCII.

Ok - that's how you're looking to avoid 32/64bit compatibility issues?
It will make the interface quite verbose, though, and entail significant
encoding and decoding costs....

> > >   Each filesystem willing to support this interface implements special
> > > filesystem (e.g. ext3meta, XFSmeta, ...) and admin/defrag-tool mounts it
> > > to some directory.
> > 
> > - not useful for wider audiences like applications that would like
> >   to direct allocation
>   Why not? A simple tool could stat file, get ino, put some number in
> alloc_goal...

- Root permissions.
- multiple files need to be opened, read, written, closed
- high overhead of searching for free blocks in the area you want
- difficult to control alloc_goal with multi-threaded programs
- potential for each filesystem to have a different meta structures....
  
> > > There are parts of this interface which should be
> > > common for all filesystems (so that tools don't have to care about
> > > particular filesystem and still get some useful results), other parts
> > > are fs-specific. Here is basic structure I propose:
> > > 
> > > meta/features
> > >   - bitmap of features supported by the interface (ext2/3-like) so that
> > >     the tool can verify whether it understands the interface and don't
> > >     mess with it otherwise
> > 
> > - grow very large, very quickly if it has to support all the
> >   different quirks of different filesystems.
>   Yes, that may be a problem...
> 
> > > meta/allocation/free_blocks
> > >   - RO file - if you read from fpos F, you'll get a list of extents
> > >     describing areas with free blocks (as many as fits into supplied
> > >     buffer) starting from block F. Fpos of your file descriptor is
> > >     shifted to the first unreported free block.
> > 
> > - linear search properties == Bad. (think fs sizes of hundreds of
> >   terabytes - XFS is already deployed with filesystems of this size)
>   OK, so what do you propose? You want syscall find_free_blocks() and
> my idea of it was that it will do basically the same think as my
> interface.

Using the above interface I guess you'd have to seek and read
until you found records with block numbers near to what you'd
require. It is effectively:

find_free_blocks(fd, policy, &list, nblocks)

struct policy {
	__u64	version;
	__u64	blkno;
	__u64	len;
	__u64	group;
	__u64	policy;
	__u64	fallback_policy;
}

#define ALLOC_POLICY_EXACT_LEN		(1<<0)ULL
#define ALLOC_POLICY_EXACT_BLOCK	(1<<1)ULL
#define ALLOC_POLICY_EXACT_GROUP	(1<<2)ULL
#define ALLOC_POLICY_MIN_LEN		(1<<3)ULL
#define ALLOC_POLICY_NEAR_BLOCK		(1<<4)ULL
#define ALLOC_POLICY_NEAR_GROUP		(1<<5)ULL
#define ALLOC_POLICY_NEXT_BLOCK		(1<<6)ULL
#define ALLOC_POLICY_NEXT_GROUP		(1<<7)ULL

The sysfs interface you propose is effectively:

	memset(&policy, 0, sizeof(policy));
	policy.policy = ALLOC_POLICY_NEXT_BLOCK;
	do {
		find_free_blocks(fd, &policy, &list, nblocks);
		/* process free block list */
		.....
		/* get next blocks */
		policy.blkno = list[nblocks - 1].blkno
	} while (policy.blkno != EOF);

However, this can be optimised for a given search where
the location is known beforehand to:

	memset(&policy, 0, sizeof(policy));
	policy.policy = ALLOC_POLICY_NEAR_BLOCK;
	policy.blkno = X;
	find_free_blocks(fd, &policy, &list, nblocks);

If you then chose to allocate from this list and it fails, you
simply redo the above.

With the sysfs interface, if you want to find a single contiguous
run of blocks, you'd probably just have to read the entire file and
search it for the pattern of blocks you want. With XFS, we already
have this information indexed in btrees, so we don't want to
have to read the entire btree just to find something we could
with a single btree lookup. i.e:

	memset(&policy, 0, sizeof(policy));
	policy.policy = ALLOC_POLICY_EXACT_LEN;
	policy.len = X;
	find_free_blocks(fd, &policy, &list, nblocks);

Or indeed, something close to the block we want, of size
big enough:

	memset(&policy, 0, sizeof(policy));
	policy.policy = ALLOC_POLICY_MIN_LEN | ALLOC_POLICY_NEAR_BLOCK;
	policy.blkno = X;
	policy.len = Y;
	find_free_blocks(fd, &policy, &list, nblocks);

And so on. The advantage of this is the filesytem is free
to search for the blocks in any manner it chooses, rather than
having a fixed, linear seek/read interfaces to searches.

> > - cannot use smart requests like given me free blocks near X,
> >   in AG Y or Z, etc.
>   It supports "give me free block after block X". I agree that more
> complicated requests may be sometimes useful but I believe doing some
> syscall interface for them would be even worse.

Right. More complicated requests are something that we need to
support in XFS in the short-medium term. We _need_ an interface to
XFS that allows complex, compound allocation policies to be
accessible from userspace - and this is not just for defrag
programs.

I think a set of well defined allocation primitives suits a syscall
interface far better than a per-filesystem sysfs interface.

> > - some filesystems have more than one data area - e.g. XFS has the
> >   realtime volume.
>   Interesting, I didn't know that. But anything that wants to mess with
> volumes has to know that it uses XFS anyway so this handling should be
> probably fs-specific...

It's a flag on the inode (i.e. an extended inode attribute) that
indicates where the data lies for that inode. Once again, this can
be handled implicitly by the syscall interface because the
filesystem is aware of this flag and should return blocks associated
with the inode's data device...

> > - every time you fail an allocation, you need to reread this file.
>   Yes, that's the most serious disadvantage I see. Do you see any way
> out of it in any interface?

I haven't really thought about solutions for this interface - the
syscall interface doesn't have this problem because of the way you
can specify where you want free blocks from....

> > > meta/super/blocksize
> > >   - filesystem block size
> > 
> > fcntl(FIGETBSZ).
>   I know but can be also in the interface...
> 
> > Also:
> > 
> > - some filesystems can use different block sizes for different
> >   structures (e.g XFs directory blocks canbe larger than the fsb)
>   The block size was meant as an allocation unit size. So basically it
> really was just another interface to FIGETBSZ.

That's still a problem - XFS doesn't always use the filesystem block
size as it's allocation unit.....

> > - extent size hints, etc.
>   Umm, I don't understand what you mean by this.

.... because we have per-inode extent size allocation hints. That
is, the allocator will always try to allocate extsize bytes (and
extsize aligned) extents for any file with this hint. If it can't
get a chunk large enough for this, then ENOSPC....

> > - stripe unit and stripe width need to be exposed so defrag too
> >   can make correct placement decisions.
>   fs-specific thing...

As Andreas said, this isn't fs-specific. XFS takes sunit and swidth
as mkfs parameters so it can align both metadata and data optimally
for RAID devices. Other fileystems have different methods of
specifying this (ext2/3/4 use -E stride-size for this), but it would
need to be exposed in some way....

> > > meta/nodes/<ident>
> > >   - this should be a directory containing things specific for a fs-object
> > >     with identification <ident>. In case of ext3 these would be inode
> > >     numbers, I guess this should be plausible also for XFS and others
> > >     but I'm open to suggestions...
> > >   - directory contains the following:
> > >   alloc_goal
> > >     - block number with current allocation goal
> > 
> > The kernel has to store this across syscalls until you write into
> > data/alloc? That sounds dangerous...
>   This is persistent until kernel decides to remove inode from memory.
> So while you have the file open, you are guaranteed that kernel keeps
> the information.

But the inode hangs around long after the file is closed. How
do you guarantee that this gets cleared when it needs to be?

I just don't like the principle of this interface when we are
talking about moving data around online - it's inherently unsafe
when you consider mutli-threaded or -process access to an inode.

> > >   data/reloc
> > >     - you write there <ident> and relocation of data happens as follows:
> > >       All blocks that are allocated both in original file and <ident>
> > >       are relocated to <ident>. Write returns number of relocated
> > >       blocks.
> > 
> > You can only relocate to a new inode (which in XFS will change
> > the inode number)? What happens if there are blocks in duplicate
> > offsets in both inodes? What happens if all the blocks aren't
> > relocated - how do you handle this?
>   Inode does not change. Only block pointers are changed. Let <orig> be
> original inode and <blocks> the temporary inode. If block at offset O is
> allocated in both <orig> and <blocks>, then we copy data for the block
> from <orig> to <blocks> and swap block pointers to the block of <orig>
> and <blocks>.

OK, understood - I was a bit confused about the "original file and
<ident> are relocated to <ident>" bit. Thanks for the clarification.

> > The major difference is that one implementation requires 3 new
> > generically useful syscalls, and the other requires every filesystem
> > to implement a metadata filesystem and require root priviledges
> > to use.
>   Yes. IMO the complexity of implementation is almost the same in the
> syscall case and in my sysfs case. What syscall would do is just do some
> basic checks and redirect everything into fs-specific call anyway...

Sure, but you don't need to implement a new filesystem in every
filesystem to support it....

> In sysfs you just hook the same fs-specific routines to the files I
> describe. Regarding the priviledges, I don't believe non-root (or user
> without proper capability) should be allowed to do these operations.

Why not? As long as the user has permissions to write to the
filesystem and has quota left, they can create files however
they want.

> I
> can imagine all kinds of DoS attacks using these interfaces (e.g.
> forcing fs into worst-cases of file placement etc...)

They could only do that to files they have write access to. IOWs,
if they screw up their own files, let them. If they have root,
then it doesn't matter what interface we provide, it can be used
to do this.

And if you're really paranoid, with a generic syscall interface
we can introduce a "(no)useralloc" mount option that specifcally
prevents this interface form being used on a given filesystem...

> > hmmm - how do you support objects in the filesystem not attached
> > to inodes (e.g. the freespace and inode btrees in XFS)? What sort
> > interface would they use?
>   You could have fs-specific hooks manipulating with your B-tree..

Yes, I realise that - my question is how do you think that they
should be enumerated in the metafs heirachy? What standard would apply?

> > >   This is all that is needed for my purposes. Any comments welcome.
> > 
> > Then your purpose is explicitly data defragmentation? If that is
> > the case, I still fail to see any need for a new metadata fs for
> > every filesystem to support this.
>   What I want is to implement defrag for ext3. For that I need some new
> interfaces so I'm trying to design them in such a way that further
> extension for other needs is possible.

Understood. However, I'm looking past the immediate problem and
trying to find a common set of fileystem independent features that
will serve us well for the next few years. Allocation policies 
and data relocation are just some of the issues that _all_
filesystems are going to have to face in the near future.

It is far easier to tell the application dev to "use this allocation
interface because you know exactly what you want" than to try to
develop filesystem heuristics to detect their pathological workload
and try to do something smart in the filesystem to stop the problem
from occurring.

Hence I'd like to have a common, well defined interface thought out
in advance rather than having to get applicaitons to explicitly
support one filesystem or another.

[ Simple example: posix_fallocate() syscall implementation, rather
than having to get applications to detect libxfs at build time and
use xfsctl() instead of posix_fallocate() to get a fast, efficient
preallocation method). ]

> That's all. Now if the interface
> has some common parts for several filesystems, then making userspace
> tool work for all of them should be easier. So I don't require anybody
> to implement it. Just if it's implemented, userspace tool can work for
> it too...

Hmmm - that sounds like you have already decided that this is the
interface that you are going to implement for ext3. ....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
