From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Sun, 11 Mar 2012 04:30:37 -0600
Message-ID: <9709DE62-CE25-41C4-A33C-63336B51DC5E@whamcloud.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120310044804.GB5652@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2012-03-09, at 9:48 PM, Ted Ts'o wrote:
> On Fri, Mar 09, 2012 at 04:09:43PM -0800, Andreas Dilger wrote:
>> 
>> Just reading this on the plane, so I can't find the exact reference
>> that I want, but a solution to this problem with htree was discussed
>> a few years ago between myself and Coly Li.
>> 
>> The basic idea is that for large directories the inode allocator
>> starts by selecting a range of (relatively) free inodes based on the
>> current directory size, and then piecewise maps the hash value for
>> the filename into this inode range and uses that as the goal inode.
> 
> I've heard you sketch out this idea before, but it's not been clean to
> me how well it would work in practice.  The potential downside is that
> it fragments the inode table, such that a single inode table block
> might not have as many inodes stored in it as we might otherwise
> would.  (Ideally, with 256 byte inodes, there would 16 of them in each
> 4k block.)  This is something I'd definitely recommend modelling in
> simulation to see how well it works first.

Very true, I was thinking this as I wrote the email.

> I'd observe that if we knew in advance how many files would be in a
> particular directory (i.e., via a hint from userspace at mkdir time),
> then it would be possible to optimize this case much more easily.  In
> fact, if we had perfect knowledge --- if the userspace process could
> feed us the exact set of filenames that will be used in the directory,
> plus the exact file sizes for each of the file names --- then it would
> be possible to allocate inode numbers and starting block numbers such
> that when the files are read in readdir() order, the inode numbers and
> block numbers would line up perfectly into sequential writes.  

Except POSIX doesn't allow anything close to this at all.  Something like
fallocate() for directories would at least give the kernel a hint about
how large the directory is, but fewer userspace tools have this information
than the file size (e.g. tar doesn't really store a "directory", just a
bunch of pathnames that happen to have largely the same components).

In the cases where size IS known in advance, or at least if the directory
is going to be large, an allocation policy like mine would essentially
"predict" where a uniformly distributed hash function will allocate the
inodes for better reading order.

> Of course, the trade off is that by optimizing for read order, the
> write order will tend to get painful as well!  So there's a tension
> here; making the read part of the benchmark faster will make the
> process of writing the directory hierarchy require more seeks --- and
> this assuming that you know file names and sizes ahead of time.
> 
> (Unless, of course, you play the same game that Hans Reiser did when
> he cooked his "tar" benchmark by constructing a kernel source tarball
> where the file order in the tarball was perfectly ordered to guarantee
> the desired result given Reiser4's hash!  :-)

No, I definitely don't want to go down that path...  Optimization for the
sake of benchmarks is broken.

> I suspect the best optimization for now is probably something like
> this:
> 
> 1) Since the vast majority of directories are less than (say) 256k
> (this would be a tunable value),

Yes, this would be reasonable, and I suspect could be a lot larger than
256kB.  Probably variable based on the amount of RAM is reasonable.
Looking at http://www.pdsi-scidac.org/fsstats/ (which is listed as HPC,
but is a bit old and the filesystems aren't much larger than large SATA
drives today :-) having a 1MB cache would handle virtually every directory
in that survey (99.999%).

The unfortunate part is that this will help small directories, where the
problem is already largely hidden by readahead and the page cache, but it
doesn't help at all for huge directories that do not fit into cache.  That
is where my approach would do well, but the difficulty is in knowing at
create time how large the directory will be.

> for directories which are less than
> this threshold size, the entire directory is sucked in after the first
> readdir() after an opendir() or rewinddir().  The directory contents
> are then sorted by inode number (or loaded into an rbtree ordered by
> inode number), and returned back to userspace in the inode order via
> readdir().  The directory contents will be released on a closedir() or
> rewinddir().

What would the telldir() cookie be in this case?  The inode number, or
the file descriptor?  What happens if the directory size crosses the
threshold while the cache is in use?  I guess in that case the cache
could still be used (according to POSIX) because readdir() doesn't need
to report entries added after it started.

> 2) For files larger than this size, we don't want to hold that much
> kernel memory during an opendir(), so fall back to ext4's current
> scheme.   
> 
> 3) If we want do to better than that, we could create new flag
> O_NOTELLDIR, which can be set via fcntl.  (This way programs can use
> do something like "dir = opendir(..); fd = dirfd(dir); fcntl(fd,
> SETFL, O_NOTELLDIR);").  For files who know they don't need to use
> telldir/seekdir, they can set this flag, which will allow the above
> optimization to be used on large files.

Probably a bit messy.  Since telldir() is rarely used outside NFS (AFAIK,
though I recall something dumb happening in GNU libc at one point that
was doing a telldir() and seekdir() for every entry) we could assume no
telldir() users until it actually was used on the filesystem, and that
could set a hint in the superblock EXT2_FLAGS section.  The only userspace
programs I could find that call telldir() are smbd and nmbd (and related
tools) and perl (not sure when or why).

> The other thing we could potentially do, if we really cared about this
> issue in ext3/4, would be to define whole new (incompatible) storing
> the directory indexing format which avoided this problem.  It would be
> an INCOMPAT feature, so it would be a while before it could get used
> in practice, which is why I'm not entirely convinced it's worth it ---
> especially since I suspect just doing (1) would solve the problem for
> the vast majority of ext4's users.

Agreed.  I don't know that we need to go to these extremes.

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




