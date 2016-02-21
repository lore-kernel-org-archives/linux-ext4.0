From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: add exclude file for ext3 tests
Date: Sun, 21 Feb 2016 11:58:51 -0500
Message-ID: <20160221165851.GA1934@thunk.org>
References: <20160220155157.GA19420@localhost.localdomain>
 <20160221003411.GZ14668@dastard>
 <20160221025754.GA15641@thunk.org>
 <20160221062356.GA14668@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33352 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbcBUVMm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 16:12:42 -0500
Content-Disposition: inline
In-Reply-To: <20160221062356.GA14668@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 21, 2016 at 05:23:56PM +1100, Dave Chinner wrote:
> 
> Ok, I suspected that this was the reason for it occurring, but
> that's not really testing "ext3" in the true sense - it's a modified
> ext4 on-disk variant that happens to match the ext3 configuration.

Yes, although this is also how ext4 emulates fs/ext3 behavior --
either because fs/ext3 has been removed, as it has in newer kernels,
or because (as most distributions have been shipping for a while)
fs/ext3 has been disabled via Kconfig, and CONFIG_EXT4_USE_FOR_EXT23
is enabled.  I'm not doing this any more, but for a while I had been
using an ext3 file system for the root file system in the KVM images
so I could do things with ext4 for testing purposes without
interfering with the ability of the KVM image to boot.  So in practice
it is effectively the same as testing "ext3" using some white-box
knowledge of how ext4 emulates ext3 under the covers.


> > I'll note this is a not quite guaranteed to be correct because
> > _require_xfs_io_command tests to see whether or not falloc works on
> > TEST_DEV, and these tests are actually create a test file system on
> > SCRATCH_DEV, and in theory TEST_DEV and SCRATCH_DEV could have
> > different file system features.  That's because xfstests never runs
> > mkfs on TEST_DEV, but SCRATCH_DEV does get mkfs'ed and in theory the
> > file system features set by MKFS_OPTIONS could be different from what
> > exists on TEST_DEV.
> 
> Right - that's normally why we have "_require_scratch_foo" so that
> it's specific which device requires that functionality. Seems easy
> enough to fix that problem.

For what it's worth here are the list of generic tests that (a) have
_require_scratch and (b) have _require_xfs_io_command "falloc":

032 038 042 071 094 103 223 250 252 274 299 300 312 324

So it probably does make sense to have a _require_scratch_falloc
helper macro, although in practice I rather doubt folks have been
tripped up by this until now.  Still, it would be more correct.

Alternative, it might be interesting to consider would be a test at
the beginning of the xfstests run where the feature set for the
TEST_DEV is compared against SCRATCH_DEV when created using
_scratch_mkfs and if they differ, to issue a warning.  This would be
an ext4-specific thing, and I'm not sure if you would consider this
within scope of xfstests, or whether this is something that belongs in
a test-runner framework such as gce-xfstests.  I can see arguments for
this either way, although I would lean towards putting such a sanity
check in kvm-xfstests/gce-xfstests.  What is your preference?

> back to the ext4-as-ext3, defrag requires extents to be enabled in
> the ext4 filesystem, right?  So you could check whether than flag is
> set easily enough with something like this:
> 
> dumpe2fs -h $dev |grep features |grep -q extent
> if [ $? -ne 0 ]; then
> 	_notrun "Filesystem does not support defrag operations"
> fi
> 
> That would work for everything with a fstyp of ext4, wouldn't it?

Yes, or use something like a _require_scratch_falloc helper.

     	    	      	     			     - Ted
