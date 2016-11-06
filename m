From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Mon, 7 Nov 2016 10:57:22 +1100
Message-ID: <20161106235722.GG28177@dastard>
References: <20161103172842.q7avc7rztny3zndd@thunk.org>
 <E33408BD-68CC-49E4-9B32-EC06DB057509@dilger.ca>
 <20161104215105.waabpcf7zganrdbr@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        guy@linux.com, jra@google.com, drosen@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:7801 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751146AbcKFX5x (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2016 18:57:53 -0500
Content-Disposition: inline
In-Reply-To: <20161104215105.waabpcf7zganrdbr@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 04, 2016 at 05:51:05PM -0400, Theodore Ts'o wrote:
> On Fri, Nov 04, 2016 at 10:14:03AM -0600, Andreas Dilger wrote:
> > > 2.  In ext4_lookup(), if case insensitivity is enabled, and the
> > > directory lookup does not succeed, fall back to a linear search of the
> > > directory using using a case insensitive compare.  (This is slow, but
> > > it's faster compared to doing this in userspace).
> > 
> > Does it make sense to flag directories with whether entries are inserted
> > with the case-insensitive hash?  That allows the common case of having
> > case insensitivity always enabled or disabled working optimally.  Falling
> > back to linear search for every negative lookup would be prohibitive for
> > large directories.
> 
> I'm proposing that we not make any on-disk format changes for now.
> It's true that this means that we need to degrade to a O(N) brute
> force search, and that it is undefined if there are two files that are
> the same when case folding is enabled (e.g., if there is both a
> Makefile and makefile in the directory).

FYI, avoiding having to degrade to brute-force searches is why XFS
added a mkfs option for ascii-ci support.  It is there to indicate
that the directory name hashes are lower-case, case-insensitive
hashes on disk. This means that all case versions of the filename
hash to the same value and collisions can be resolved without
changing any of the existing search code.

We did this with a simple abstraction:

static struct xfs_nameops xfs_ascii_ci_nameops = {
        .hashname       = xfs_ascii_ci_hashname,
	.compname       = xfs_ascii_ci_compname,
};

Where ->hashname() calculates the hash, and ->compname() compares
the hash on disk for a match during lookup.

Otherwise, the only difference is the lookup path to instantiate the
dentry differently depending on whether it was an exact match or CI
match (see xfs_vn_ci_lookup()).

As on-disk changes go, this one should be relatively simple as
there is no actual structural change. :P

> If someone wants to do something "right", which means e2fsprogs and
> kernel changes, getting the Unicode translation code into the kernel
> (and dealing with the bikeshedding that will probably happen when we
> try to get generic Unicode support into the kernel), and that someone

Already happened once with an attempt to get unicode case folding
into XFS. Unfortunately, SGI disappeared before review was completed
and so it never got finalised and merged. However, the code is out
there and so we have pretty much a full implementation of unicode
case folding code out there. The v3 RFC (which contains links back
to the previous two versions and discussions) can be found here:

http://oss.sgi.com/archives/xfs/2014-10/msg00067.html

That's the place to start if people want to pick this up - I'd
suggest a generic interface similar to what has been done with the
fs encryption code is the way to proceed with this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
