From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 23:33:16 -0400
Message-ID: <20061026033316.GC27858@thunk.org>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org> <20061025081137.GB8394166@melbourne.sgi.com> <20061025170052.GA19513@havoc.gtf.org> <20061026014020.GC8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	'Dave Kleikamp' <shaggy@austin.ibm.com>,
	'Alex Tomas' <alex@clusterfs.com>, 'Jan Kara' <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061026014020.GC8394166@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 26, 2006 at 11:40:20AM +1000, David Chinner wrote:
> We don't need to expose anything filesystem specific to userspace to
> implement this.  Online data movement (i.e. the defrag mechanism)
> becomes something like:
> 
> 	do {
> 		get_free_list(dst_fd, location, len, list)
> 		/* select extent to use */
> 		alloc_from_list(dst_fd, list[X], off, len)
> 	} while (ENOALLOC)
> 	move_data(src_fd, dst_fd, off, len);
> 
> And this would work on any filesystem type that implemented these
> interfaces. Hence tools like a startup file optimiser would
> only need to be written once, rather than needing a different
> tool for every different filesystem type.....

Yeah, but that's simply not enough.  A good defragger needs to know
about a filesystem's allocation policies, and move files so they are
optimally located, given the filesystem layout.  For example, in
ext2/3/4 we will want to move blocks so they in the same block group
as the inode.  That's filesystem specific information; other
filesystems will require different policies.

> Remember, I'm not just talking about defrag - I'm talking about
> an interface that is actually useful to apps that might care
> about how data is laid out on disk but the applications writers
> don't know anyhting about how filesystem X or Y or Z is
> implemented. Putting the burden of learning about fileystem
> internals on application developers is not the correct solution.

Unfortunately, if you want to do a good job, a defragger *has* to know
about some very low-level filesystem specific information, if it wants
to do a good job.

						- Ted
