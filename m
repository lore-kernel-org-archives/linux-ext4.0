From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Testing Ext4 encryption with fstests
Date: Sat, 2 Dec 2017 21:44:49 -0500
Message-ID: <20171203024449.foyydafswblqceou@thunk.org>
References: <2008991.n3x73QCyP8@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55190 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751878AbdLCCox (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 2 Dec 2017 21:44:53 -0500
Content-Disposition: inline
In-Reply-To: <2008991.n3x73QCyP8@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 02, 2017 at 08:44:29AM +0530, Chandan Rajendra wrote:
> 
> My fstests local.config has,
> 
> export TEST_DEV=/dev/loop0
> export TEST_DIR=/mnt/btrfs-xfstest-test
> export SCRATCH_DEV=/dev/loop1
> export SCRATCH_MNT=/mnt/btrfs-xfstest-scratch
> MKFS_OPTIONS="-O encrypt"
> EXT_MOUNT_OPTIONS="-o test_dummy_encryption"
> export FSTYPE=ext4
>
> With the latest linux-next next-20171201 (i.e. without my changes applied)
> on x86 I see some tests fail and also filesystem consistency almost always 
> fails. E.g.
>
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 localhost 4.13.0-next-20170905-gf165385
> MKFS_OPTIONS  -- -O encrypt /dev/loop1
> MOUNT_OPTIONS -- -o acl,user_xattr -o test_dummy_encryption /dev/loop1 /mnt/btrfs-xfstest-scratch
> 
> <Failures in in generic/011, generic/012, generic/013 elided>
> 
> Please let me know if the test setup described above is incorrect.

I'm not sure what's going on with your test setup, but I'm not seeing
the failures you have cited using my test setup.  And it's available
for download, so I generally recommend that developers use
kvm-xfstests[1] and gce-xfstests[2], or if you really want to use your
own setup, to double check against my setup, just to save your and my
time.

[1] https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
[2] https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md
[3] https://thunk.org/gce-xfstests

Here are my results running "gce-xfstests -c encrypt -g auto" with the
same kernel you were using, next-20171201:

KERNEL:    kernel 4.15.0-rc1-next-20171201-xfstests #547 SMP Sat Dec 2 19:26:17 EST 2017 x86_64
CMDLINE:   -c encrypt -g auto
CPUS:      2
MEM:       7680

ext4/encrypt: 336 tests, 9 failures, 98 skipped, 2144 seconds
  Failures: ext4/022 ext4/026 ext4/028 generic/081 generic/382 
    generic/388 generic/466 generic/468 shared/298 

FSTESTIMG: gce-xfstests/xfstests-201711281634
FSTESTVER: e2fsprogs v1.43.6-85-g7595699d0 (Wed, 6 Sep 2017 22:04:14 -0400)
FSTESTVER: fio  fio-3.2 (Fri, 3 Nov 2017 15:23:49 -0600)
FSTESTVER: quota  4d81e8b (Mon, 16 Oct 2017 09:42:44 +0200)
FSTESTVER: xfsprogs v4.14.0-rc2-1-g19ca9b0b (Mon, 27 Nov 2017 10:56:21 -0600)
FSTESTVER: xfstests-bld 0b27af9 (Tue, 28 Nov 2017 16:28:51 -0500)
FSTESTVER: xfstests linux-v3.8-1797-g4f1eaa02 (Tue, 28 Nov 2017 15:49:06 -0500)

There are some tests which are automatically skipped[4][5], but they
don't include generic/011 or generic/013.  These pass without any
problems for me:

generic/011 1s ...	[19:31:01] [19:31:03] 2s
generic/012		[19:31:03] [19:31:04] [not run]
	generic/012 -- xfs_io fcollapse failed (old kernel/wrong fs?)
generic/013 6s ...	[19:31:04] [19:31:10] 6s

[4] https://github.com/tytso/xfstests-bld/blob/master/kvm-xfstests/test-appliance/files/root/fs/ext4/exclude
[5] https://github.com/tytso/xfstests-bld/blob/master/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude

The generic/012 test should be skipped, since collapse operation is
not supported if encrypt option is enabled.  The fact that it was
*not* skipped in your configuration does seem to imply that something
is screwed up in your xfstests setup.

So you can try debugging your xfstests setup, but why not just use
kvm-xfstests (either the binary test appliance image, or built from
sources; I have set things up so the tests can be reproducibly built
using a hermetic build environment)?  I did all of the work on
{kvm,gce}-xfstests to save time for ext4 developers and researchers.

Cheers,

						- Ted

P.S.  Of the failures I am seeing in the encrypt list, here's the
annotated list:

ext4/022 and ext4/026 failed with "no space" errors; these are xattr
tests, so I'm guessing the tests don't play well with the fact that
encryption uses space for the encryption metadata.  This is probably a
test bug, but it might be simplest to just add these tests to the
ext4/encrypt.exclude list.  I just haven't had the time to dig into it
to be sure before I do that.

ext4/028 is a new test which tries to populate a scratch directory
using among other things, inline files.  This fails for those test
configurations, like ext3 and encrypt, which don't support inline
files.  So this is a test bug.  I'll need to take a look at whether
the proper fix is to make common/populate in xfstests skip inline
files for those configs that don't support inline files, or just to
add ext4/028 to the appropriate config's exclude files.

generic/081 and shared/298 is failing because I need to force the use
of a 4k block size for the encrypt config (e.g., add "-b 4096" to
EXT_MOUNT_OPTIONS in kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt).
Otherwise _scratch_mkfs_sized will create a file system with a 1k
block size, and that's not compatible with encryption feature.  (Yes, with
your patches it will be, but I'll create a separate encrypt-1k config
that forces *all* of the tests to use a 1k block size.)

generic/382 is a quota-related test, and so it needs to be added to
the ext4/encrypt.exclude file, since encryption using
test_dummy_encryption and quota (using external quota files) doesn't
play well together.

generic/388 is a shutdown test that is failing.  That's a known ext4
bug that applies in all configs.  It's been on my todo list to fix but
I haven't gotten around to it.

generic/466 and generic/468 are new tests that are failing on the
standard 4k config as well as the encrypt case.  On my todo list to
look at more closely and triage.
