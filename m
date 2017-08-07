From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to enable CONFIG_EXT4_ENCRYPTION
Date: Mon, 7 Aug 2017 09:49:42 -0400
Message-ID: <20170807134942.u3ep5ivfq4ublueb@thunk.org>
References: <20170807032502.2tiyjybtqrn6odab@linux>
 <20170807095126.hyhrrnr4vrj3ne4k@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dai Xiang <xiangx.dai@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44834 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750751AbdHGNtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Aug 2017 09:49:46 -0400
Content-Disposition: inline
In-Reply-To: <20170807095126.hyhrrnr4vrj3ne4k@linux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 07, 2017 at 05:51:26PM +0800, Dai Xiang wrote:
> On Mon, Aug 07, 2017 at 11:25:02AM +0800, Dai Xiang wrote:
> > Hi!
> > 
> > I use xfstests with ext4 fs to test, and i found a skip:
> > 
> > ext4/024         [not run] kernel does not support ext4 encryption

Yeah, the message printed is misleading, and should be fixed.
Checking to see whether the kernel supports encryption can be done by
checking for the existence of the file:

/sys/fs/ext4/features/encryption

> i print the cmd:
> /usr/sbin/xfs_io -i -c set_encpolicy /fs/scratch/tmpdir
> /fs/scratch/tmpdir: failed to set encryption policy: Inappropriate
> ioctl for device <===
> 
> Seems do not related to kconfig?

Yes, the issue is that you need to create the file system (or set via
tune2fs) the feature flag "encrypt".  To best test the read/write
paths, you should set the mount option test_dummy_encryption.  The
kvm-xfstests and gce-xfstests framework do all of this automatically.
>From xfstests-bld/kvm-xfstests/test-appliance/files/root/cfg/fs/ext4/encrypt:

SIZE=small
export EXT_MKFS_OPTIONS="-O encrypt"
export EXT_MOUNT_OPTIONS="test_dummy_encryption"
REQUIRE_FEATURE=encryption
TESTNAME="Ext4 encryption"

There are a number tests that are known to fail; primarily having to
do with quota support, which doesn't play well with
test_dummy_encryption (that's more of a test problem than anything
else).  See the encrypt.exclude file in that directory for more
details.

Cheers,

					- Ted
