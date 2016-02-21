From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests-bld: add exclude file for ext3 tests
Date: Sat, 20 Feb 2016 21:57:54 -0500
Message-ID: <20160221025754.GA15641@thunk.org>
References: <20160220155157.GA19420@localhost.localdomain>
 <20160221003411.GZ14668@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60310 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbcBUC55 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Feb 2016 21:57:57 -0500
Content-Disposition: inline
In-Reply-To: <20160221003411.GZ14668@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 21, 2016 at 11:34:11AM +1100, Dave Chinner wrote:
> On Sat, Feb 20, 2016 at 10:51:57AM -0500, Eric Whitney wrote:
> > Add an exclude file for the ext3 test case to prevent failure reports
> > from tests that exercise unsupported online defrag functionality.
> 
> ext3 should not run these tests because of the _requires_defrag
> check in these tests results in a _notrun command being run
> when FSTYP=ext3.

In this particular case, the test is being run with

FSTYP=ext4
MKFS_OPTIONS="-q -O ^extents,^flex_bg,^uninit_bg,^64bit,^metadata_csum,^huge_file,^dir_nlink,^extra_isize"
EXT_MOUNT_OPTIONS="nodelalloc"

This is why _requires_defrag is passing and so ext4/307 and ext4/308
is allowed to run.

Historically, this test was set up in this fashion because I wanted to
make sure the ext4 kernel code would be used, and not the code found
in fs/ext3 (this was before fs/ext3 was removed from the kernel).
Since we want to support testing on ancient kernels (either 3.10
android kernels or 2.6.34 RHEL6 kernels), using this strategy for
testing ext4's support for file systems with ext3 features is
something that still makes sense to do, and so I would want to keep
running tests using this setup.

> > Two online defrag tests - ext4/307 and /308 - are not included because
> > they contain explicit requirements for fallocate support that prevents
> > them from running on an emulated ext3 file system.
> 
> Same here.

So probably the right answer here is to change _require_defrag so that
for EXT4, to also add the assertion:

_require_xfs_io_command "falloc"

I'll note this is a not quite guaranteed to be correct because
_require_xfs_io_command tests to see whether or not falloc works on
TEST_DEV, and these tests are actually create a test file system on
SCRATCH_DEV, and in theory TEST_DEV and SCRATCH_DEV could have
different file system features.  That's because xfstests never runs
mkfs on TEST_DEV, but SCRATCH_DEV does get mkfs'ed and in theory the
file system features set by MKFS_OPTIONS could be different from what
exists on TEST_DEV.

I'm willing to consider this a test configuration error, and certainly
kvm-xfstests doesn't ever set up such a arguably non-sensible test
configuration.

						- Ted
