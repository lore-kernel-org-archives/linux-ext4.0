From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests-bld: add exclude file for ext3 tests
Date: Sun, 21 Feb 2016 17:23:56 +1100
Message-ID: <20160221062356.GA14668@dastard>
References: <20160220155157.GA19420@localhost.localdomain>
 <20160221003411.GZ14668@dastard>
 <20160221025754.GA15641@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32232 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbcBUUvS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 15:51:18 -0500
Content-Disposition: inline
In-Reply-To: <20160221025754.GA15641@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 20, 2016 at 09:57:54PM -0500, Theodore Ts'o wrote:
> On Sun, Feb 21, 2016 at 11:34:11AM +1100, Dave Chinner wrote:
> > On Sat, Feb 20, 2016 at 10:51:57AM -0500, Eric Whitney wrote:
> > > Add an exclude file for the ext3 test case to prevent failure reports
> > > from tests that exercise unsupported online defrag functionality.
> > 
> > ext3 should not run these tests because of the _requires_defrag
> > check in these tests results in a _notrun command being run
> > when FSTYP=ext3.
> 
> In this particular case, the test is being run with
> 
> FSTYP=ext4
> MKFS_OPTIONS="-q -O ^extents,^flex_bg,^uninit_bg,^64bit,^metadata_csum,^huge_file,^dir_nlink,^extra_isize"
> EXT_MOUNT_OPTIONS="nodelalloc"
> 
> This is why _requires_defrag is passing and so ext4/307 and ext4/308
> is allowed to run.

Ok, I suspected that this was the reason for it occurring, but
that's not really testing "ext3" in the true sense - it's a modified
ext4 on-disk variant that happens to match the ext3 configuration.

> > > Two online defrag tests - ext4/307 and /308 - are not included because
> > > they contain explicit requirements for fallocate support that prevents
> > > them from running on an emulated ext3 file system.
> > 
> > Same here.
> 
> So probably the right answer here is to change _require_defrag so that
> for EXT4, to also add the assertion:
> 
> _require_xfs_io_command "falloc"
> 
> I'll note this is a not quite guaranteed to be correct because
> _require_xfs_io_command tests to see whether or not falloc works on
> TEST_DEV, and these tests are actually create a test file system on
> SCRATCH_DEV, and in theory TEST_DEV and SCRATCH_DEV could have
> different file system features.  That's because xfstests never runs
> mkfs on TEST_DEV, but SCRATCH_DEV does get mkfs'ed and in theory the
> file system features set by MKFS_OPTIONS could be different from what
> exists on TEST_DEV.

Right - that's normally why we have "_require_scratch_foo" so that
it's specific which device requires that functionality. Seems easy
enough to fix that problem.

back to the ext4-as-ext3, defrag requires extents to be enabled in
the ext4 filesystem, right?  So you could check whether than flag is
set easily enough with something like this:

dumpe2fs -h $dev |grep features |grep -q extent
if [ $? -ne 0 ]; then
	_notrun "Filesystem does not support defrag operations"
fi

That would work for everything with a fstyp of ext4, wouldn't it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
