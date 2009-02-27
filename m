From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Fri, 27 Feb 2009 10:06:16 -0500
Message-ID: <20090227150616.GF6791@mit.edu>
References: <20090218154310.GH3600@mini-me.lan> <20090226182156.GL7227@mit.edu> <20090227091704.GR3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58462 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbZB0PGW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Feb 2009 10:06:22 -0500
Content-Disposition: inline
In-Reply-To: <20090227091704.GR3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 27, 2009 at 02:17:04AM -0700, Andreas Dilger wrote:
> On Feb 26, 2009  13:21 -0500, Theodore Ts'o wrote:
> > I tried adding some of Andreas' suggestions which would tend to pack
> > the inodes less agressively, in the hopes that it might speed up the
> > mkdir operation, but at least for seq_mkdir/mkdirs_mark benchmark, it
> > really didn't help, because we are disk bound, not cpu bound.
> 
> Could you explain in a bit more detail what you tried?  

Sorry, no, that's not something which I tried.  I was thinking more
about your complaints that Orlov was doing too much work to pack
inodes into the beginning of the flexgroup.  So I tried some
experiments that reduced the number of times that we called
get_orlov_stats() (since you complained that we were using it instead
of the flex group statistics --- which involve too many spinlocks for
my taste, and which I want to nuke eventually), and what I found is
that at least for mkdirs_mark, we're not CPU bound, we're disk bound.
Therefore, speinding the extra CPU time to make sure the inode table
is tightly packed is a worth it, since crazy benchmarks like
TPC-C/TPC-H where you spend $$$ to add thousands of spindles so you
can be simultaneously CPU- and disk- bound don't create a large number
of directories or files.  :-)

> In particular, was this the "mapping hash range onto itable range" I
> have proposed in the past?

No, it wasn't that.  One of these days I'm going to have to track down
a formal write up of that idea (I'm trying to remember if you've
written it up fully or whether this is one of those things we've
talked about orally but which hasn't been formally written down to
explore all of the details).

The part which I'm not sure about is how do we take into account the
fact that we don't know how big the directory will when we are
creating the first couple of files, so we don't know how much room to
reserve in each itable range for each leaf directory.  This is
critically important, since if we leave too much space in between
inodes, then we end up losing due to fragmentation, and it doesn't buy
us much.

For mid-sized directories, the optimization we have in ext4 where we
read some additional inode tables blocks (since the diffence between
4k and 32k is negligible) will is more likely to speed up the
readdir+stat workload if the inodes are packed closely together, after
all.  Spreading out the inodes could end up hurting more than it helps.

Now, if we had a way of providing a hint at mkdir time --- I'm
creating this directory, and very shortly thereafter, I will be
populating it with 600 files with an average filename length of 12,
then we could some *really* interesting things; we could preallocate
blocks for the directory, and since we know the initial number of
files that will be dropped into the directory, we could reserve a
range of inodes, and then use the filename hash to determine
approximately what inode number to pick out of that reserved range for
that directory.

Without that hint, we would have to guess how many inodes would be
used by the directory, and it's that guestimate which makes this hard.


Another thought. another way of solving this problem is to have a
structure at the beginning of each directory tracking the minimum and
maximum number inode numbers in the directory, and the number of
directory entries in the directory.  Then, you could have a hueristic
to detect the readdir+stat pattern, and if it is found, and if the
min/max inode range compares favorably to the number of directory
entries, the filesystem could simply arrange to do aggressive
pre-reading of the inodes in the min/max range on the theory that they
will likely be needed in the future.

> > +	int flex_size = ext4_flex_bg_size(EXT4_SB(ac->ac_sb));
> >  
> > +		/* Avoid using the first bg of a flexgroup for data files */
> > +		    (flex_size >= EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME) &&
> 
> Since these are both constants, wouldn't it make more sense to just
> check the sbi->s_log_groups_per_flex against the lg of the threshold:
> 
> 	if (sbi->s_log_groups_per_flex > (2)) (as a #defined constant)

It would mean having two constnats in ext4.h,
EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME and
EXT4_FLEX_SIZE_DIR_ALLOC_SCHEME_LOG, but yeah, that would save an
shift-left instructure.

						- Ted
