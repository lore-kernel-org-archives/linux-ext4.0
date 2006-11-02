From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Defragmentation interface
Date: Fri, 3 Nov 2006 09:59:53 +1100
Message-ID: <20061102225953.GF8394166@melbourne.sgi.com>
References: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061102143929.GA8607@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 02, 2006 at 03:39:29PM +0100, Jan Kara wrote:
>   Hi,
> 
>   from the thread after my patch implementing ext3 online
> defragmentation I found out that probably the only (and definitely the
> biggest) issue is the interface. Someone wants is common enough so that
> we can profit from common tools for several filesystems, others object
> that some applications, e.g. defragmenter, need to know something about
> ext3 internals to work reasonably well. Moreover ioctl() is ugly and has
> some compatibility issues, on the other hand ext2meta is too lowlevel,
> fs-specific and it would be hard to do any reasonable application
> crash-safe...
>   So in this email I try to propose some interface which should hopefully
> address most of the concerns. The type of the interface is sysfs like
> (idea taken from ext2meta) - that has a few advantages:
>  - no 32/64-bit compatibility issues
>  - easily extensible
>  - generally nice ;)

- complex
- over-engineered
- little common code between filesystems

BTW, does use of sysfs mean ASCII encoding of all the data
passing between kernel and userspace?

>   Each filesystem willing to support this interface implements special
> filesystem (e.g. ext3meta, XFSmeta, ...) and admin/defrag-tool mounts it
> to some directory.

- not useful for wider audiences like applications that would like
  to direct allocation

> There are parts of this interface which should be
> common for all filesystems (so that tools don't have to care about
> particular filesystem and still get some useful results), other parts
> are fs-specific. Here is basic structure I propose:
> 
> meta/features
>   - bitmap of features supported by the interface (ext2/3-like) so that
>     the tool can verify whether it understands the interface and don't
>     mess with it otherwise

- grow very large, very quickly if it has to support all the
  different quirks of different filesystems.

> meta/allocation/free_blocks
>   - RO file - if you read from fpos F, you'll get a list of extents
>     describing areas with free blocks (as many as fits into supplied
>     buffer) starting from block F. Fpos of your file descriptor is
>     shifted to the first unreported free block.

- linear search properties == Bad. (think fs sizes of hundreds of
  terabytes - XFS is already deployed with filesystems of this size)
- cannot use smart requests like given me free blocks near X,
  in AG Y or Z, etc.
- some filesystems have more than one data area - e.g. XFS has the
  realtime volume.
- every time you fail an allocation, you need to reread this file.

> meta/super/blocksize
>   - filesystem block size

fcntl(FIGETBSZ).

Also:

- some filesystems can use different block sizes for different
  structures (e.g XFs directory blocks canbe larger than the fsb)
- stripe unit and stripe width need to be exposed so defrag too
  can make correct placement decisions.
- extent size hints, etc.

Hence this will require the spuer/ directory to be extensible
in a filesystem specific interface.

> meta/super/id
>   - filesystem ID (for paranoid tools to verify that they are accessing
>     really the right meta-filesystem)

- UUID, please.

> meta/nodes/<ident>
>   - this should be a directory containing things specific for a fs-object
>     with identification <ident>. In case of ext3 these would be inode
>     numbers, I guess this should be plausible also for XFS and others
>     but I'm open to suggestions...
>   - directory contains the following:
>   alloc_goal
>     - block number with current allocation goal

The kernel has to store this across syscalls until you write into
data/alloc? That sounds dangerous...

>   data/extents
>     - if you read from this file, you get a list of extents describing
>       data blocks (and holes) of the file. The listing starts at logical
>       block fpos. Fpos is shifted to the first unreported data block.

fcntl(FIBMAP)

>   data/alloc
>     - you write there a number L and fs allocates L blocks to a file
>       (preferable from alloc_goal) starting from file-block fpos. Fpos
>       is shifted after the last block allocated in this call.

You seek to the position you want (in blocks or bytes?), then write
a number into the file (in blocks or bytes)? That's messy compared
to a function call with an offset and length in it....

>   data/reloc
>     - you write there <ident> and relocation of data happens as follows:
>       All blocks that are allocated both in original file and <ident>
>       are relocated to <ident>. Write returns number of relocated
>       blocks.

You can only relocate to a new inode (which in XFS will change
the inode number)? What happens if there are blocks in duplicate
offsets in both inodes? What happens if all the blocks aren't
relocated - how do you handle this?

Let me get this straight - the interface you propose for
moving data about is:

	read and process extents into an internal structure
	find range where you want to relocate
	find free space you want to relocate into
	write desired block to alloc_goal
	seek to allocation offset in data/alloc
	write length into data/alloc
	allocate new inode
	write new inode number into data/reloc to relocate blocks

What I proposed:

	fcntl(src, FIBMAP);
	/* find range to relocate */
	open(tmp, O_CREATE);
	funlink(tmp);
	fs_get_free_list(src, policy, list);
	/* select free extent to use */
	fs_allocate_space(tmp, list[X], off, len);
	fs_move_data(src, tmp, off, len);
	close(tmp);
	close(src);

So the process is pretty close to the same except the interface I
proposed does not change the location of the inode holding the data.
The major difference is that one implementation requires 3 new
generically useful syscalls, and the other requires every filesystem
to implement a metadata filesystem and require root priviledges
to use.

>   metadata/
>     - this directory is fs-specific, contains fs block pointers and
>       similar. Here I describe what I'd like to have for ext3.

Nothing really useful for XFS here unless we start talking
about btree defragmentation and attribute fork optimisation,
etc. We really don't need a sysfs interface for this, just
an additional fs_move_metadata() type of call....

hmmm - how do you support objects in the filesystem not attached
to inodes (e.g. the freespace and inode btrees in XFS)? What sort
interface would they use?

>   This is all that is needed for my purposes. Any comments welcome.

Then your purpose is explicitly data defragmentation? If that is
the case, I still fail to see any need for a new metadata fs for
every filesystem to support this.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
