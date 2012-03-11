From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Sun, 11 Mar 2012 12:13:20 -0400
Message-ID: <20120311161320.GC1048@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <9709DE62-CE25-41C4-A33C-63336B51DC5E@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59135 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab2CKQN1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 12:13:27 -0400
Content-Disposition: inline
In-Reply-To: <9709DE62-CE25-41C4-A33C-63336B51DC5E@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 11, 2012 at 04:30:37AM -0600, Andreas Dilger wrote:
> > if the userspace process could
> > feed us the exact set of filenames that will be used in the directory,
> > plus the exact file sizes for each of the file names...
> 
> Except POSIX doesn't allow anything close to this at all.  Something like
> fallocate() for directories would at least give the kernel a hint about
> how large the directory is, but fewer userspace tools have this information
> than the file size (e.g. tar doesn't really store a "directory", just a
> bunch of pathnames that happen to have largely the same components).

Yes, this was purely a thought experiment idea (although if we could
try to extend the interface if it really neted enough gains).  My
point was that even if we could do this, we really are trading off
write performance for read performance (since you would now be doing
the extra seeking on the tar extraction phase).

Ultimately, while I believe it makes sense to optimize the "readdir +
seek" case, I don't believe it makes sense to optimize the "copy out
the directory using tar" benchmark --- since I believe this is much
more of a benchmark workload than something that happens a huge amount
in real life, and even for people who do backups (which unfortunately
as we know is a too-small percentage of the ext4 user base), they
generally will prefer than the "real" use case for the file system be
fast rather than the backup phase, and in point of fact as the file
system gets more fragmented, even if some file systems can offer
perfect name -> block correlation, over time I'll bet their
correlation breaks down and so ext4's disadvantage over those file
systems will disappear in real life usages.  So I don't believe it
makes that much sense to worry overly about the "name -> block"
correlation for freshly formatted file systems.  It's a nice-to-have,
but I really think that's more of a benchmark game than anything else.

> In the cases where size IS known in advance, or at least if the directory
> is going to be large, an allocation policy like mine would essentially
> "predict" where a uniformly distributed hash function will allocate the
> inodes for better reading order.

Well, yes; if we knew in advance how many files (roughly) would be
stored in a directory, there are some optimizations we could do.  The
simplest of which is preallocating the directory blocks so they are
contiguous on disk.  I'm not pursuaded yet that the optimizations are
worth the effort of trying to define a new interface and then trying
to convince application programers to use a hypothetical interface
extension *just* for this purpose, though.

> The unfortunate part is that this will help small directories, where the
> problem is already largely hidden by readahead and the page cache, but it
> doesn't help at all for huge directories that do not fit into cache.  That
> is where my approach would do well, but the difficulty is in knowing at
> create time how large the directory will be.

Well, my goal in proposing this optimization is that helps for the
"medium size" directories in the cold cache case.  The ext4 user who
first kicked off this thread was using his file system for an SVN
server, as I recall.  I could easily believe that he has thousands of
files; maybe even tens of thousands of files in a directory.  But that
probably still fits in 256k, or at best 512k worth of directory blocks.

It definitely won't help for the really lage directories, yes; but how
common are they?  The most common case I can think of is squid caches,
but you can configure a larger number of 1st and 2nd level
subdirectories to keep the actual directory size smaller.

> > for directories which are less than
> > this threshold size, the entire directory is sucked in after the first
> > readdir() after an opendir() or rewinddir().  The directory contents
> > are then sorted by inode number (or loaded into an rbtree ordered by
> > inode number), and returned back to userspace in the inode order via
> > readdir().  The directory contents will be released on a closedir() or
> > rewinddir().
> 
> What would the telldir() cookie be in this case?  The inode number, or
> the file descriptor?  What happens if the directory size crosses the
> threshold while the cache is in use?  I guess in that case the cache
> could still be used (according to POSIX) because readdir() doesn't need
> to report entries added after it started.

The telldir() cookie can simply be an ordinal -- so "7" means the 7th
directory entry in the rbtree.  And all we need to do, which obeys
POSIX as you've noted, is that we instantiate the rbtree during the
first readdir() after an opendir() or rewinddir(), and free the old
rbtree() when we get the rewinddir(), reach the end of the directory
stream, or get the closedir().

> > 3) If we want do to better than that, we could create new flag
> > O_NOTELLDIR, which can be set via fcntl.  (This way programs can use
> > do something like "dir = opendir(..); fd = dirfd(dir); fcntl(fd,
> > SETFL, O_NOTELLDIR);").  For files who know they don't need to use
> > telldir/seekdir, they can set this flag, which will allow the above
> > optimization to be used on large files.
> 
> Probably a bit messy.  Since telldir() is rarely used outside NFS (AFAIK,
> though I recall something dumb happening in GNU libc at one point that
> was doing a telldir() and seekdir() for every entry) we could assume no
> telldir() users until it actually was used on the filesystem, and that
> could set a hint in the superblock EXT2_FLAGS section.  The only userspace
> programs I could find that call telldir() are smbd and nmbd (and related
> tools) and perl (not sure when or why).

By the time a process uses telldir(), we're midway through a readdir()
stream, and so by that point it's too late to switch back to a
seekdir-friendly order.  So what do we do at that point?  If we
continue returning directory entries where we read in each directory
256kb at a time, sorting by inode number, and then returning dirents
in inode number order, then anytime there was a telldir() during a
256kb chuck, we wouldn't be able to discard that rbtree, but rather we
would have to keep it in memory until the next rewinddir().  So a
process which opens a large directory(), and then calls telldir() a
huge number of times could end up pinning a large amount of kernel
memory.

We could, of course, set some kind of resource limit on this, and if a
process behaves too badly by calling telldir in a way that it has
pinned too much kernel memory, we could potentially kill the process.
We could then tell application programmers that if they really want to
use telldir() a huge amount, they need to tell us in advance via some
kind of process flag.  That is, we could default to being
telldir-unfriendly instead of defaulting to telldir-friendly.  If we
really think it's only Samba and Perl, and that we can convince them
to give us this hint, then that we might get away with it.

I had been assuming though that we would have to default to
telldir-friendly, which is why I suggested the O_NOTELLDIR flag.

		  	       	 	   - Ted
