From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Defragmentation interface
Date: Fri, 3 Nov 2006 15:30:30 +0100
Message-ID: <20061103143030.GB17306@atrey.karlin.mff.cuni.cz>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz> <20061102225953.GF8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061102225953.GF8394166@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  Thanks for your comments.

> >   from the thread after my patch implementing ext3 online
> > defragmentation I found out that probably the only (and definitely the
> > biggest) issue is the interface. Someone wants is common enough so that
> > we can profit from common tools for several filesystems, others object
> > that some applications, e.g. defragmenter, need to know something about
> > ext3 internals to work reasonably well. Moreover ioctl() is ugly and has
> > some compatibility issues, on the other hand ext2meta is too lowlevel,
> > fs-specific and it would be hard to do any reasonable application
> > crash-safe...
> >   So in this email I try to propose some interface which should hopefully
> > address most of the concerns. The type of the interface is sysfs like
> > (idea taken from ext2meta) - that has a few advantages:
> >  - no 32/64-bit compatibility issues
> >  - easily extensible
> >  - generally nice ;)
> 
> - complex
> - over-engineered
> - little common code between filesystems
  The first two may be but actually I don't think you'll have too much
common code among fs anyway whatever interface you choose.

> BTW, does use of sysfs mean ASCII encoding of all the data
> passing between kernel and userspace?
  Not necessarify but mostly yes. At least I intend to have all the
files I have proposed in ASCII.

> >   Each filesystem willing to support this interface implements special
> > filesystem (e.g. ext3meta, XFSmeta, ...) and admin/defrag-tool mounts it
> > to some directory.
> 
> - not useful for wider audiences like applications that would like
>   to direct allocation
  Why not? A simple tool could stat file, get ino, put some number in
alloc_goal...

> > There are parts of this interface which should be
> > common for all filesystems (so that tools don't have to care about
> > particular filesystem and still get some useful results), other parts
> > are fs-specific. Here is basic structure I propose:
> > 
> > meta/features
> >   - bitmap of features supported by the interface (ext2/3-like) so that
> >     the tool can verify whether it understands the interface and don't
> >     mess with it otherwise
> 
> - grow very large, very quickly if it has to support all the
>   different quirks of different filesystems.
  Yes, that may be a problem...

> > meta/allocation/free_blocks
> >   - RO file - if you read from fpos F, you'll get a list of extents
> >     describing areas with free blocks (as many as fits into supplied
> >     buffer) starting from block F. Fpos of your file descriptor is
> >     shifted to the first unreported free block.
> 
> - linear search properties == Bad. (think fs sizes of hundreds of
>   terabytes - XFS is already deployed with filesystems of this size)
  OK, so what do you propose? You want syscall find_free_blocks() and
my idea of it was that it will do basically the same think as my
interface.

> - cannot use smart requests like given me free blocks near X,
>   in AG Y or Z, etc.
  It supports "give me free block after block X". I agree that more
complicated requests may be sometimes useful but I believe doing some
syscall interface for them would be even worse.

> - some filesystems have more than one data area - e.g. XFS has the
>   realtime volume.
  Interesting, I didn't know that. But anything that wants to mess with
volumes has to know that it uses XFS anyway so this handling should be
probably fs-specific...

> - every time you fail an allocation, you need to reread this file.
  Yes, that's the most serious disadvantage I see. Do you see any way
out of it in any interface?

> > meta/super/blocksize
> >   - filesystem block size
> 
> fcntl(FIGETBSZ).
  I know but can be also in the interface...

> Also:
> 
> - some filesystems can use different block sizes for different
>   structures (e.g XFs directory blocks canbe larger than the fsb)
  The block size was meant as an allocation unit size. So basically it
really was just another interface to FIGETBSZ.

> - stripe unit and stripe width need to be exposed so defrag too
>   can make correct placement decisions.
  fs-specific thing...

> - extent size hints, etc.
  Umm, I don't understand what you mean by this.

> Hence this will require the spuer/ directory to be extensible
> in a filesystem specific interface.
  Definitely. My mistake I did not say that.

> > meta/super/id
> >   - filesystem ID (for paranoid tools to verify that they are accessing
> >     really the right meta-filesystem)
> 
> - UUID, please.
  Yes, I meant UUID.

> > meta/nodes/<ident>
> >   - this should be a directory containing things specific for a fs-object
> >     with identification <ident>. In case of ext3 these would be inode
> >     numbers, I guess this should be plausible also for XFS and others
> >     but I'm open to suggestions...
> >   - directory contains the following:
> >   alloc_goal
> >     - block number with current allocation goal
> 
> The kernel has to store this across syscalls until you write into
> data/alloc? That sounds dangerous...
  This is persistent until kernel decides to remove inode from memory.
So while you have the file open, you are guaranteed that kernel keeps
the information.

> >   data/extents
> >     - if you read from this file, you get a list of extents describing
> >       data blocks (and holes) of the file. The listing starts at logical
> >       block fpos. Fpos is shifted to the first unreported data block.
> 
> fcntl(FIBMAP)
  Yes. Only data/extents is a bit more effective and it fits the
interface nicely.

> >   data/alloc
> >     - you write there a number L and fs allocates L blocks to a file
> >       (preferable from alloc_goal) starting from file-block fpos. Fpos
> >       is shifted after the last block allocated in this call.
> 
> You seek to the position you want (in blocks or bytes?), then write
> a number into the file (in blocks or bytes)? That's messy compared
> to a function call with an offset and length in it....
  I meant that everything is in blocks. On the other hand we may well
define it in bytes. I don't have a strong opinion.

> >   data/reloc
> >     - you write there <ident> and relocation of data happens as follows:
> >       All blocks that are allocated both in original file and <ident>
> >       are relocated to <ident>. Write returns number of relocated
> >       blocks.
> 
> You can only relocate to a new inode (which in XFS will change
> the inode number)? What happens if there are blocks in duplicate
> offsets in both inodes? What happens if all the blocks aren't
> relocated - how do you handle this?
  Inode does not change. Only block pointers are changed. Let <orig> be
original inode and <blocks> the temporary inode. If block at offset O is
allocated in both <orig> and <blocks>, then we copy data for the block
from <orig> to <blocks> and swap block pointers to the block of <orig>
and <blocks>.

> Let me get this straight - the interface you propose for
> moving data about is:
> 
> 	read and process extents into an internal structure
> 	find range where you want to relocate
> 	find free space you want to relocate into
> 	write desired block to alloc_goal
> 	seek to allocation offset in data/alloc
> 	write length into data/alloc
> 	allocate new inode
> 	write new inode number into data/reloc to relocate blocks
> 
> What I proposed:
> 
> 	fcntl(src, FIBMAP);
> 	/* find range to relocate */
> 	open(tmp, O_CREATE);
> 	funlink(tmp);
> 	fs_get_free_list(src, policy, list);
> 	/* select free extent to use */
> 	fs_allocate_space(tmp, list[X], off, len);
> 	fs_move_data(src, tmp, off, len);
> 	close(tmp);
> 	close(src);
> 
> So the process is pretty close to the same except the interface I
> proposed does not change the location of the inode holding the data.
  Yes, what we propose is almost exactly the same in the effect (the
inode move is misunderstanding, it does not happen in my case either).

> The major difference is that one implementation requires 3 new
> generically useful syscalls, and the other requires every filesystem
> to implement a metadata filesystem and require root priviledges
> to use.
  Yes. IMO the complexity of implementation is almost the same in the
syscall case and in my sysfs case. What syscall would do is just do some
basic checks and redirect everything into fs-specific call anyway...
In sysfs you just hook the same fs-specific routines to the files I
describe. Regarding the priviledges, I don't believe non-root (or user
without proper capability) should be allowed to do these operations. I
can imagine all kinds of DoS attacks using these interfaces (e.g.
forcing fs into worst-cases of file placement etc...)

> >   metadata/
> >     - this directory is fs-specific, contains fs block pointers and
> >       similar. Here I describe what I'd like to have for ext3.
> 
> Nothing really useful for XFS here unless we start talking
> about btree defragmentation and attribute fork optimisation,
> etc. We really don't need a sysfs interface for this, just
> an additional fs_move_metadata() type of call....
  Either a new syscall or new files in metafs - I find the second nicer
;).

> hmmm - how do you support objects in the filesystem not attached
> to inodes (e.g. the freespace and inode btrees in XFS)? What sort
> interface would they use?
  You could have fs-specific hooks manipulating with your B-tree..

> >   This is all that is needed for my purposes. Any comments welcome.
> 
> Then your purpose is explicitly data defragmentation? If that is
> the case, I still fail to see any need for a new metadata fs for
> every filesystem to support this.
  What I want is to implement defrag for ext3. For that I need some new
interfaces so I'm trying to design them in such a way that further
extension for other needs is possible. That's all. Now if the interface
has some common parts for several filesystems, then making userspace
tool work for all of them should be easier. So I don't require anybody
to implement it. Just if it's implemented, userspace tool can work for
it too...
							Bye
								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
