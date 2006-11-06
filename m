From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Defragmentation interface
Date: Mon, 6 Nov 2006 18:44:58 +0100
Message-ID: <20061106174458.GH16986@atrey.karlin.mff.cuni.cz>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz> <20061102225953.GF8394166@melbourne.sgi.com> <20061103143030.GB17306@atrey.karlin.mff.cuni.cz> <20061106025427.GG11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061106025427.GG11034@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Fri, Nov 03, 2006 at 03:30:30PM +0100, Jan Kara wrote:
> > > BTW, does use of sysfs mean ASCII encoding of all the data
> > > passing between kernel and userspace?
> >   Not necessarify but mostly yes. At least I intend to have all the
> > files I have proposed in ASCII.
> 
> Ok - that's how you're looking to avoid 32/64bit compatibility issues?
  Yes.

> It will make the interface quite verbose, though, and entail significant
> encoding and decoding costs....
  It would be verbose. On the other hand for most things it should not
matter (not too much data goes through the interface and it's not too
performance critical).

> > > > meta/allocation/free_blocks
> > > >   - RO file - if you read from fpos F, you'll get a list of extents
> > > >     describing areas with free blocks (as many as fits into supplied
> > > >     buffer) starting from block F. Fpos of your file descriptor is
> > > >     shifted to the first unreported free block.
> > > 
> > > - linear search properties == Bad. (think fs sizes of hundreds of
> > >   terabytes - XFS is already deployed with filesystems of this size)
> >   OK, so what do you propose? You want syscall find_free_blocks() and
> > my idea of it was that it will do basically the same think as my
 <snip>

> Right. More complicated requests are something that we need to
> support in XFS in the short-medium term. We _need_ an interface to
> XFS that allows complex, compound allocation policies to be
> accessible from userspace - and this is not just for defrag
> programs.
> 
> I think a set of well defined allocation primitives suits a syscall
> interface far better than a per-filesystem sysfs interface.
  I'm only afraid of one thing: Once you define a syscall it's hard to
change anything and for this kind of thing I'm not sure we are able to
tell what we'll need in two years... That is basically my main
concern with implementing this interface as a syscall.

> > > - every time you fail an allocation, you need to reread this file.
> >   Yes, that's the most serious disadvantage I see. Do you see any way
> > out of it in any interface?
> 
> I haven't really thought about solutions for this interface - the
> syscall interface doesn't have this problem because of the way you
> can specify where you want free blocks from....
  But that does not solve the problem with having to repeat the search,
does it? Only with the syscall interface filesystem can possibly search
for free blocks more efficiently..

> > > - stripe unit and stripe width need to be exposed so defrag too
> > >   can make correct placement decisions.
> >   fs-specific thing...
> 
> As Andreas said, this isn't fs-specific. XFS takes sunit and swidth
> as mkfs parameters so it can align both metadata and data optimally
> for RAID devices. Other fileystems have different methods of
> specifying this (ext2/3/4 use -E stride-size for this), but it would
> need to be exposed in some way....
  I see. But then shouldn't we expose it regardless the interface
(sysfs/syscall) we choose so that userspace can take it into account
when picking where to allocate?

> > > > meta/nodes/<ident>
> > > >   - this should be a directory containing things specific for a fs-object
> > > >     with identification <ident>. In case of ext3 these would be inode
> > > >     numbers, I guess this should be plausible also for XFS and others
> > > >     but I'm open to suggestions...
> > > >   - directory contains the following:
> > > >   alloc_goal
> > > >     - block number with current allocation goal
> > > 
> > > The kernel has to store this across syscalls until you write into
> > > data/alloc? That sounds dangerous...
> >   This is persistent until kernel decides to remove inode from memory.
> > So while you have the file open, you are guaranteed that kernel keeps
> > the information.
> 
> But the inode hangs around long after the file is closed. How
> do you guarantee that this gets cleared when it needs to be?
  It gets cleared (or rewritten) as soon as alloc_goal is used for
allocation or when inode gets removed from memory. Ext3 currently has
such thing (settable via ioctl()) and it seems to work reasonably well.

> I just don't like the principle of this interface when we are
> talking about moving data around online - it's inherently unsafe
> when you consider mutli-threaded or -process access to an inode.
  Yes, we certainly have to make sure we don't do something destructive
in such case. On the other hand if several processes try to guide
allocation in the same file, results are uncertain and that's IMHO ok.
 
> > > The major difference is that one implementation requires 3 new
> > > generically useful syscalls, and the other requires every filesystem
> > > to implement a metadata filesystem and require root priviledges
> > > to use.
> >   Yes. IMO the complexity of implementation is almost the same in the
> > syscall case and in my sysfs case. What syscall would do is just do some
> > basic checks and redirect everything into fs-specific call anyway...
> 
> Sure, but you don't need to implement a new filesystem in every
> filesystem to support it....
  But the cost of this "meta filesystem implementation" is just something
like having a file metafs.c that contains read_super() in which it
sets up those metafs files/directories and their handling functions. So
I imagine that setting up most of the files should be like:
  create_metafs_file("super/uuid", RW, foo_return_uuid, foo_set_uuid)

Where create_metafs_file() is some generic VFS helper. So I think that
sysfs interface has it's problems but implementation complexity is not
one of them..

> > In sysfs you just hook the same fs-specific routines to the files I
> > describe. Regarding the priviledges, I don't believe non-root (or user
> > without proper capability) should be allowed to do these operations.
> 
> Why not? As long as the user has permissions to write to the
> filesystem and has quota left, they can create files however
> they want.
> 
> > I
> > can imagine all kinds of DoS attacks using these interfaces (e.g.
> > forcing fs into worst-cases of file placement etc...)
> 
> They could only do that to files they have write access to. IOWs,
> if they screw up their own files, let them. If they have root,
> then it doesn't matter what interface we provide, it can be used
> to do this.
  But by cleverly choosing blocks to allocate, you can for example quite
fragment free space and by that you make sure that access for others
will be slow too. Also making extent tree grow really large (because you
force each extent to have one block) and then burning CPU cycles in
kernel by forcing it to do various tree operations with it is also not
a pleasant thing. 

> And if you're really paranoid, with a generic syscall interface
> we can introduce a "(no)useralloc" mount option that specifcally
> prevents this interface form being used on a given filesystem...
  Of course that's possible. I don't count myself among paranoid but
certainly I would not allow users to guide allocation on my server
because of above reasons ;).

> > > hmmm - how do you support objects in the filesystem not attached
> > > to inodes (e.g. the freespace and inode btrees in XFS)? What sort
> > > interface would they use?
> >   You could have fs-specific hooks manipulating with your B-tree..
> 
> Yes, I realise that - my question is how do you think that they
> should be enumerated in the metafs heirachy? What standard would apply?
  Honestly, I don't know. But I believe a sensible enumeration could be
found.

> > > >   This is all that is needed for my purposes. Any comments welcome.
> > > 
> > > Then your purpose is explicitly data defragmentation? If that is
> > > the case, I still fail to see any need for a new metadata fs for
> > > every filesystem to support this.
> >   What I want is to implement defrag for ext3. For that I need some new
> > interfaces so I'm trying to design them in such a way that further
> > extension for other needs is possible.
> 
> Understood. However, I'm looking past the immediate problem and
> trying to find a common set of fileystem independent features that
> will serve us well for the next few years. Allocation policies 
> and data relocation are just some of the issues that _all_
> filesystems are going to have to face in the near future.
>
> It is far easier to tell the application dev to "use this allocation
> interface because you know exactly what you want" than to try to
> develop filesystem heuristics to detect their pathological workload
> and try to do something smart in the filesystem to stop the problem
> from occurring.
> 
> Hence I'd like to have a common, well defined interface thought out
> in advance rather than having to get applicaitons to explicitly
> support one filesystem or another.
  Yes, I think we agree in this matter.

> [ Simple example: posix_fallocate() syscall implementation, rather
> than having to get applications to detect libxfs at build time and
> use xfsctl() instead of posix_fallocate() to get a fast, efficient
> preallocation method). ]
> 
> > That's all. Now if the interface
> > has some common parts for several filesystems, then making userspace
> > tool work for all of them should be easier. So I don't require anybody
> > to implement it. Just if it's implemented, userspace tool can work for
> > it too...
> 
> Hmmm - that sounds like you have already decided that this is the
> interface that you are going to implement for ext3. ....
  No, I have not decided yet. And actually as I've got feedback mostly
from you and that was negative I'll probably also try syscall approach
and see who won't like that one ;)

							Bye
								Honza
