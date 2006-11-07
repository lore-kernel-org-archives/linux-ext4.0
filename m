From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Defragmentation interface
Date: Tue, 7 Nov 2006 14:03:16 +1100
Message-ID: <20061107030316.GL11034@melbourne.sgi.com>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz> <20061102225953.GF8394166@melbourne.sgi.com> <20061103143030.GB17306@atrey.karlin.mff.cuni.cz> <20061106025427.GG11034@melbourne.sgi.com> <20061106174458.GH16986@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061106174458.GH16986@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 06, 2006 at 06:44:58PM +0100, Jan Kara wrote:
> > On Fri, Nov 03, 2006 at 03:30:30PM +0100, Jan Kara wrote:
> > > > BTW, does use of sysfs mean ASCII encoding of all the data
> > > > passing between kernel and userspace?
> > >   Not necessarify but mostly yes. At least I intend to have all the
> > > files I have proposed in ASCII.
> > 
> > Ok - that's how you're looking to avoid 32/64bit compatibility issues?
>   Yes.
> 
> > It will make the interface quite verbose, though, and entail significant
> > encoding and decoding costs....
>   It would be verbose. On the other hand for most things it should not
> matter (not too much data goes through the interface and it's not too
> performance critical).

Except when you have a filesystem with fragmented free space.
That could be a lot of information (think searching through 
terabytes of fragmetned free space before finding a contiguous
block big enough).....

> > Right. More complicated requests are something that we need to
> > support in XFS in the short-medium term. We _need_ an interface to
> > XFS that allows complex, compound allocation policies to be
> > accessible from userspace - and this is not just for defrag
> > programs.
> > 
> > I think a set of well defined allocation primitives suits a syscall
> > interface far better than a per-filesystem sysfs interface.
>   I'm only afraid of one thing: Once you define a syscall it's hard to
> change anything and for this kind of thing I'm not sure we are able to
> tell what we'll need in two years... That is basically my main
> concern with implementing this interface as a syscall.

True, but there's only so many ways you can ask for free space to be
found or allocated. And there's a version number in the policy
structure so that interface is extensible. Also, for the limited scope
of the interfaces I don't see much change being needed over time
but the change tht is needed can be handled by the strucutre
version.

For the sysfs interface, it needs to be very flexible and extensible
because of the amount of filesystem specific information it can
expose and would need to expose to be usable by multiple filesystems
in a generic manner...

Hence I think different criteria apply here - the syscalls implement
single mechanisms, whereas the sysfs interface allows deeper, more
intrusive delving into filesystem internals while at the same time
providing mechanisms for modification of the filesystem. If we are
going to provide simple mechanisms to do certain operations, then
I'd  prefer to see it done as specific, targeted syscalls rather
than buried within a multi-purpose, cross-filesystem sysfs
interface.

> > > > - every time you fail an allocation, you need to reread this file.
> > >   Yes, that's the most serious disadvantage I see. Do you see any way
> > > out of it in any interface?
> > 
> > I haven't really thought about solutions for this interface - the
> > syscall interface doesn't have this problem because of the way you
> > can specify where you want free blocks from....
>   But that does not solve the problem with having to repeat the search,
> does it? Only with the syscall interface filesystem can possibly search
> for free blocks more efficiently..

Right - the repeat search is not a problem because the overhead is
far lower with the syscall interface.

> > > > - stripe unit and stripe width need to be exposed so defrag too
> > > >   can make correct placement decisions.
> > >   fs-specific thing...
> > 
> > As Andreas said, this isn't fs-specific. XFS takes sunit and swidth
> > as mkfs parameters so it can align both metadata and data optimally
> > for RAID devices. Other fileystems have different methods of
> > specifying this (ext2/3/4 use -E stride-size for this), but it would
> > need to be exposed in some way....
>   I see. But then shouldn't we expose it regardless the interface
> (sysfs/syscall) we choose so that userspace can take it into account
> when picking where to allocate?

Yes. In terms of the syscall interface, it is simple to do without
having to tell the application about alignment

#define POLICY_ALLOC_ALIGN_SUNIT
#define POLICY_ALLOC_ALIGN_SWIDTH

Now the kernel only returns blocks that are correctly aligned. If the
fileystem can't find any aligned blocks, set the fallback policy to
do the same search but without the alignment restriction.....

So, the interface doesn't need to expose the actual values, just a
method to support aligned allocations. Once again, leverage the
smarts the existing fiesystem allocator already has rather than
requiring alignment calculations to be done by the applicaiton.

Come to think of it, it would probably be better to do aligned
allocation by default and to have flags to turn off alignment.
Either way, the application doesn't need to know what the alignment
restrictions are with the syscall interface - it's just another
policy decision....

> > > > > meta/nodes/<ident>
> > > > >   - this should be a directory containing things specific for a fs-object
> > > > >     with identification <ident>. In case of ext3 these would be inode
> > > > >     numbers, I guess this should be plausible also for XFS and others
> > > > >     but I'm open to suggestions...
> > > > >   - directory contains the following:
> > > > >   alloc_goal
> > > > >     - block number with current allocation goal
> > > > 
> > > > The kernel has to store this across syscalls until you write into
> > > > data/alloc? That sounds dangerous...
> > >   This is persistent until kernel decides to remove inode from memory.
> > > So while you have the file open, you are guaranteed that kernel keeps
> > > the information.
> > 
> > But the inode hangs around long after the file is closed. How
> > do you guarantee that this gets cleared when it needs to be?
>   It gets cleared (or rewritten) as soon as alloc_goal is used for
> allocation or when inode gets removed from memory. Ext3 currently has
> such thing (settable via ioctl()) and it seems to work reasonably well.

So alloc_goal is a one-shot? that still doesn't work in
multi-threaded or multi-process workloads - you've got no guarantee
that your allocation actually used the alloc_goal you set and so you
might get back an extent that is nowhere near what you wanted....

> > I just don't like the principle of this interface when we are
> > talking about moving data around online - it's inherently unsafe
> > when you consider mutli-threaded or -process access to an inode.
>   Yes, we certainly have to make sure we don't do something destructive
> in such case. On the other hand if several processes try to guide
> allocation in the same file, results are uncertain and that's IMHO ok.

IMO, parallel allocation to the one file is a use-case that any new
interface must support. Right now we use tricks in XFS like
speculative pre-allocation, extent size hints, very large I/Os, etc
to minimise the fragmetnation that occurs when multiple processes
write to the one file. This is one of the workloads that causes us
fragmentation problems.

The problem is that these mitigation techniques are all reactive and
need to be set up once a problem has been observed.  IOWs, we've got
to notice the probelm before we can take action to fix it.

If the application knows that the entire file will be filled
eventually, it can do much smarter things like allocate blocks in
the file such that when all the holes get filled we end up with a
contiguous file. That requires safe, multithreaded access to the
interface but it would avoid the need for admin intervention at
every location that the application is deployed like we currently
have to do...

> > > > The major difference is that one implementation requires 3 new
> > > > generically useful syscalls, and the other requires every filesystem
> > > > to implement a metadata filesystem and require root priviledges
> > > > to use.
> > >   Yes. IMO the complexity of implementation is almost the same in the
> > > syscall case and in my sysfs case. What syscall would do is just do some
> > > basic checks and redirect everything into fs-specific call anyway...
> > 
> > Sure, but you don't need to implement a new filesystem in every
> > filesystem to support it....
>   But the cost of this "meta filesystem implementation" is just something
> like having a file metafs.c that contains read_super() in which it
> sets up those metafs files/directories and their handling functions. So
> I imagine that setting up most of the files should be like:
>   create_metafs_file("super/uuid", RW, foo_return_uuid, foo_set_uuid)
> 
> Where create_metafs_file() is some generic VFS helper. So I think that
> sysfs interface has it's problems but implementation complexity is not
> one of them..

True - you can wrap some of the functionality in generic helpers,
but every object that needs to be decoded, discovered or modified
requires file system specific code.

Hmm - out of curiousity - how do you populate the metafs with
objects (say inodes)?  i.e. if you want to control the allocation of
inode 325, how does the sysfs directory get populated with the meta
directory for inode 325? Is it dynamic?

> > > In sysfs you just hook the same fs-specific routines to the files I
> > > describe. Regarding the priviledges, I don't believe non-root (or user
> > > without proper capability) should be allowed to do these operations.
> > 
> > Why not? As long as the user has permissions to write to the
> > filesystem and has quota left, they can create files however
> > they want.
> > 
> > > I
> > > can imagine all kinds of DoS attacks using these interfaces (e.g.
> > > forcing fs into worst-cases of file placement etc...)
> > 
> > They could only do that to files they have write access to. IOWs,
> > if they screw up their own files, let them. If they have root,
> > then it doesn't matter what interface we provide, it can be used
> > to do this.
>   But by cleverly choosing blocks to allocate, you can for example quite
> fragment free space and by that you make sure that access for others
> will be slow too.

Sure, but I can intentionally fragment free space on any filesystem
with mkdir, dd and rm....

> Also making extent tree grow really large (because you
> force each extent to have one block) and then burning CPU cycles in
> kernel by forcing it to do various tree operations with it is also not
> a pleasant thing. 

dd is all I need for this one - large sparse file, write single
bytes into random offsets.

What I'm sayin gis that these potential issues already exist and
anyone can do stuff up a filesystem right now with simple tools and
no special permissions. AFAICT, adding an interface to direct allocation
does introduce any new problems.

> > And if you're really paranoid, with a generic syscall interface
> > we can introduce a "(no)useralloc" mount option that specifcally
> > prevents this interface form being used on a given filesystem...
>   Of course that's possible. I don't count myself among paranoid but
> certainly I would not allow users to guide allocation on my server
> because of above reasons ;).

Your choice ;)

> > > That's all. Now if the interface
> > > has some common parts for several filesystems, then making userspace
> > > tool work for all of them should be easier. So I don't require anybody
> > > to implement it. Just if it's implemented, userspace tool can work for
> > > it too...
> > 
> > Hmmm - that sounds like you have already decided that this is the
> > interface that you are going to implement for ext3. ....
>   No, I have not decided yet. 

Sorry - I was jumping to conclusions.

>   And actually as I've got feedback mostly
> from you and that was negative I'll probably also try syscall approach
> and see who won't like that one ;)

Ok, sounds good.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
