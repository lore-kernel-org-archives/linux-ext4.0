From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs-1.39-tyt3
Date: Tue, 1 May 2007 11:05:45 -0400
Message-ID: <20070501150545.GA26093@thunk.org>
References: <E1HiXhp-0002Fi-Mm@candygram.thunk.org> <20070501075641.GB5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49854 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbXEAPFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 May 2007 11:05:49 -0400
Content-Disposition: inline
In-Reply-To: <20070501075641.GB5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 01, 2007 at 01:56:41AM -0600, Andreas Dilger wrote:
> On Apr 30, 2007  11:22 -0400, Theodore Ts'o wrote:
> > One concern I still have is the fact that we're exposing a lot of
> > interfaces in libext2fs.so which are very specifically tied to the
> > current 48-bit physical/32-bit logical on-disk extent data structure.
> > If/when we add support for the 64/64-bit extent data structure, and some
> > kind of compressed/bit-packed extent format, those interfaces will have
> > to be extended.
> 
> Some other comments:
> - it appears you have all of extents.c copied into both "block.c" and
>   in "extent.c"
> - it appears you are missing a couple of extent sanity checks for headers
>   and such that were added more recently, but those might also have been
>   removed by you

Yeah, I know.  That's also part of the patches being in process; it's
why they haven't been merged into the source tree yet.  Your newer
code with the extent sanity checks have been moved into block.c, and
mostly marked as static to prevent the function signatures from
leaking out.  That's what's actually being used for most of e2fsprogs
today.

My revamped abstractions are in extent.c, and it's missing the extent
sanity checks, and the ability to modify the on-disk extents given
changes in the abstract (disk-format-independent) extent structure.
It's not actually _used_ for anything other than debugfs's stat()
structure right now.  The goal is to take the extent functions in
block.c and migrate the functionality over into extent.c, but right
now I'm more focused on making sure the interfaces are right, since
once we commit them, we have to live with them forever.

> - do the patches as they stand actually fix the duplicate block test
>   cases yet?  It seems all of the BLOCK_CHANGED handling was removed
>   from block_iterate_extents().

Yes.  With all of the patches applied in my mercurial tree, only three
tests are failing: f_extents_eh_depth, f_extents_shrd_blk,
f_lotsbad.failed, which are the same as with your most recent
e2fsprogs patchset that I've seen.  There are 8 more tests that fail
in e2fsprogs-1.39-tyt-3, but those seem to be because the diff+patch
approach screwed up with the image.gz files, and I didn't think it was
worth it to fix that up for the interim patchset.

> - it would be easier to read if the patches were generated with "diff -up"
>   (can be set in .quiltrc via 'export QUILT_DIFF_OPTS="-up"'.  I also like
>   "export QUILT_NO_DIFF_TIMESTAMPS=1" to avoid tons of gratuitous changes
>   to patches when they are refreshed.

Thanks for the tip.  I'll do that next time.

> > Another problem is that while external extent blocks are getting byte
> > swapped, there is no byte swapping going on for the extents stored in
> > the inode.  I haven't tried it on a big endian system, such as Power
> > machine, but I'm pretty sure it's going to blow up spectacularly.
> 
> Ah, interesting.  We have 64-bit machines for testing, but no big-endian
> ones.

Three are public Linux/Power systems for development purposes where
anyone who is interested in developing Linux applications for Power
can get accounts at the Open Source Labs at Oregon State University:

	http://powerdev.osuosl.org/

(Guess who's one of the primary sponsors of the OSLOSU. :-)

I haven't tried to use them since I normally use Power machines
available at Debian, but these should be sufficient at least for
running e2fprogs regression tests.  Testing of the ext4 kernel code on
a Power machine is going to be more difficult; there I think we will
have to depend on the IBM team to do testing under ABAT (which
hopefully should be easier anyway).

> > The patches can be found at:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/e2fsprogs-1.39-tyt3
> 
> What else I think is important to get into this patch series is a change
> to "mkfs.ext4" so that the default inode size is increased to 256.  I'm
> not sure how/if this can be done via mke2fs.conf.

I'd probably add code so that certain defaults could be overriden
based on argv[0] in /etc/mke2fs.conf.  Say,

[progname_defaults]
	mkfs.ext4 = {
		inode_size = 256
	}

I'll put it in my todo list, or patches would be welcome.  (This is
one that I'd just commit into the hg SCM since it's a clean change.)

Speaking of SCM's, how wedded is Clustrefs to mercurial?  I've been
considering migrating e2fsprogs development to git, but one of the
reasons I haven't is because I was concerned that might be incovenient
for you folks.

> I also wouldn't object to changing the default inode_ratio on large
> filesystems to be a lot fewer than 1/8192 bytes.  

Yeah, maybe for a new fs_type "big" which is larger than 100GB, the
inode ratio should be 16384, and change the cutoff for "small" to be
under 2GB, perhaps.  Does that sound reasonable?

> At a minimum, allowing an inode_ratio > 1/4MB should be allowed.

Agreed; an average size of 4MB seemed outlandishly large 10 years ago,
but not so much today.  Maybe we should remove the cap altogether.

					- Ted
