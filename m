From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Fri, 27 Oct 2006 11:32:52 +1000
Message-ID: <20061027013252.GP8394166@melbourne.sgi.com>
References: <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org> <20061025081137.GB8394166@melbourne.sgi.com> <20061025170052.GA19513@havoc.gtf.org> <20061026014020.GC8394166@melbourne.sgi.com> <20061026113722.GA23610@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061026113722.GA23610@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 26, 2006 at 01:37:22PM +0200, Jan Kara wrote:
> > On Wed, Oct 25, 2006 at 01:00:52PM -0400, Jeff Garzik wrote:
> > We don't need to expose anything filesystem specific to userspace to
> > implement this.  Online data movement (i.e. the defrag mechanism)
> > becomes something like:
> > 
> > 	do {
> > 		get_free_list(dst_fd, location, len, list)
> > 		/* select extent to use */
>   Upto this point I can imagine we can be perfectly generic.
> 
> > 		alloc_from_list(dst_fd, list[X], off, len)
> > 	} while (ENOALLOC)
> > 	move_data(src_fd, dst_fd, off, len);
>   With these two it's not clear how well can we do with just a generic
> interface. Every filesystem needs to have some additional metadata to
> keep list of data blocks. In case of ext2/ext3/reiserfs this is not
> a negligible amount of space and placement of these metadata is important
> for performance.

Yes, the same can be said for XFS. However, XFS's extent btree implementation
uses readahead to hide a lot of the latency involved with reading extent
map, and it only needs to read it once per inode lifecycle

> So either we focus only on data blocks and let
> implementation of alloc_from_list() allocate metadata wherever it wants
> (but then we get suboptimal performace because there need not be space
> for indirect blocks close before our provided extent)

I think the first step would be to focus on data blocks using something
like the above. There are many steps to full filesystem defragmentation,
but data fragmetnation is typically the most common symptom of
fragmentation that we see.

> or we allocate
> metadata from the provided list, but then we need some knowledge of fs
> to know how much should we expect to spend on metadata and where these
> metadata should be placed.

That's the second step, I think. For example, we could count the metadata blocks
used in metadata structure (say an block list), allocate a new chunk
like above, and then execute a "move_metadata()" type of operation,
which the filesystem does internally in a transactionally  safe
manner. Once again, generic interface, filesystem specific implementations.

> For example if you know that indirect block
> for your interval is at block B, then you'd like to allocate somewhere
> close after this point or to relocate that indirect block (and all the
> data it references to). But for that you need to know you have something
> like indirect blocks => filesystem knowledge.

*nod*

This is far less of a problem with extent based filesystems -
coalescing all the fragments into a single extent removes the need
for indirect blocks and you get the extent list for free when you
read the inode.  When we do have a fragmented file, XFS uses
readahead to speed btree searching and reading, so it hides a lot of
the latency overhead that fragmented metadata can cause.

Either way, these lists can still be optimised by allocating a
set of contiguous blocks and copying the metadata into them and
updating the pointers to the new blocks. It can be done separately
to the data moving and really should be done after the data has
been defragmented....

>   So I think that to get this working, we also need some way to tell
> the program that if it wants to allocate some data, it also needs to
> count with this amount of metadata and some of it is already allocated
> in given blocks...

If you want to do it all in one step.

However, it's not quite that simple for something like XFS. An
allocation may require a btree split (or three, actually) and the
number of blocks required is dependent on the height of the btrees.
So we don't know how many blocks we'll need ahead of time, and we'd
have to reach deep into the allocator and abuse it badly to do
anything like this. It's not something I want to even contemplate
doing. :/

Also, we don't want to be mingling global metadata with inode
specific metadata so we don't want to put most of the new metadata
blocks near the extent we are putting the data into.

That means I'd prefer to be able to optimise metadata objects
separately. e.g. rewrite a btree into a single contiguous extent
with the btree blocks laid out so the readahead patterns result
in sequential I/O. The kernel would need to do this in XFS because
we'd have to lock the entire btree a block at a time, copy it
and then issue a "swap btree" transaction. most other journalling
filesystems will have similar requirements, I think, for doing
this online....

That's a very similar concept to the move_data() interface...

> > I see substantial benefit moving forward from having filesystem
> > independent interfaces. Many features that  filesystems implement
> > are common, and as time goes on the common feature set of the
> > different filesystems gets larger. So why shouldn't we be
> > trying to make common operations generic so that every filesystem
> > can benefit from the latest and greatest tool?
>   So you prefer to handle only "data blocks" part of the problem and let
> filesystem sort out metadata?

The filesystem should already be attempting to do the right thing
with the metadata blocks. If it can't then I don't think we should
complicate the interface to do this as a spearate metadata
optmisation pass can do it for us.  Also, it would make the
interface harder to use for general applications that really only
need to guarantee that their datafiles are unfragmented (e.g
bittorrent).

FWIW, the only user of metadata optmisation that I can see is defrag
applications. Hence I think it is best to keep it separate and let
the filesystem do best effort metadata placement on all allocations
whether they are directed by userspace or not. the block/extent
lists can be further optimised as a separate phase of a defrag
application if the fs isn't able to do it right the first time....

No, wait, I just thought of another - online shrinking of a
filesystem requires you to move lots of metadata in a similarly
safe manner.... :)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
