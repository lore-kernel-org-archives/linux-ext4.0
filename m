From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests-bld: add exclude file for ext3 tests
Date: Mon, 22 Feb 2016 11:26:51 +1100
Message-ID: <20160222002651.GE25832@dastard>
References: <20160220155157.GA19420@localhost.localdomain>
 <20160221003411.GZ14668@dastard>
 <20160221025754.GA15641@thunk.org>
 <20160221062356.GA14668@dastard>
 <20160221165851.GA1934@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7993 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbcBVA1H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 19:27:07 -0500
Content-Disposition: inline
In-Reply-To: <20160221165851.GA1934@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 21, 2016 at 11:58:51AM -0500, Theodore Ts'o wrote:
> On Sun, Feb 21, 2016 at 05:23:56PM +1100, Dave Chinner wrote:
> > > I'll note this is a not quite guaranteed to be correct because
> > > _require_xfs_io_command tests to see whether or not falloc works on
> > > TEST_DEV, and these tests are actually create a test file system on
> > > SCRATCH_DEV, and in theory TEST_DEV and SCRATCH_DEV could have
> > > different file system features.  That's because xfstests never runs
> > > mkfs on TEST_DEV, but SCRATCH_DEV does get mkfs'ed and in theory the
> > > file system features set by MKFS_OPTIONS could be different from what
> > > exists on TEST_DEV.
> > 
> > Right - that's normally why we have "_require_scratch_foo" so that
> > it's specific which device requires that functionality. Seems easy
> > enough to fix that problem.
> 
> For what it's worth here are the list of generic tests that (a) have
> _require_scratch and (b) have _require_xfs_io_command "falloc":
> 
> 032 038 042 071 094 103 223 250 252 274 299 300 312 324
> 
> So it probably does make sense to have a _require_scratch_falloc
> helper macro, although in practice I rather doubt folks have been
> tripped up by this until now.  Still, it would be more correct.

Well, that's a different problem, unrealted to the fact that
_require_defrag is giving the wrong answer to certain ext4
configurations.

As it is, I'm not sure that it's at all common that two filesystems
of the same type on the same kernel will give different answers to
fallocate. That seems like a corner case of ext4's  whacky feature
matrix, and so is is not something we typically need to care about,
nor is it something anyone should have to remember when writing or
reviewing a new test....

> Alternative, it might be interesting to consider would be a test at
> the beginning of the xfstests run where the feature set for the
> TEST_DEV is compared against SCRATCH_DEV when created using
> _scratch_mkfs and if they differ, to issue a warning.  This would be
> an ext4-specific thing, and I'm not sure if you would consider this
> within scope of xfstests, or whether this is something that belongs in
> a test-runner framework such as gce-xfstests.  I can see arguments for
> this either way, although I would lean towards putting such a sanity
> check in kvm-xfstests/gce-xfstests.  What is your preference?

I don't think it's particularly sane to make xfstests try to support
ext3 configurations with FSTYP=ext4 when you can just use
FSTYP=ext3 and everything just works.

> > back to the ext4-as-ext3, defrag requires extents to be enabled in
> > the ext4 filesystem, right?  So you could check whether than flag is
> > set easily enough with something like this:
> > 
> > dumpe2fs -h $dev |grep features |grep -q extent
> > if [ $? -ne 0 ]; then
> > 	_notrun "Filesystem does not support defrag operations"
> > fi
> > 
> > That would work for everything with a fstyp of ext4, wouldn't it?
> 
> Yes, or use something like a _require_scratch_falloc helper.

I'd much prefer that we fix the _require_defrag helper to correctly
determine if an ext4 filesystem can support defrag rather than
overload some other helper with undocumented behaviour that may be
completely unrelated to the test at hand and rely on people to
remember that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
