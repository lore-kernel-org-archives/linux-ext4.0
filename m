From: Dai Xiang <xiangx.dai@intel.com>
Subject: Re: How to enable CONFIG_EXT4_ENCRYPTION
Date: Tue, 8 Aug 2017 09:27:38 +0800
Message-ID: <20170808012738.6rlknzovmyhjn4rg@linux>
References: <20170807032502.2tiyjybtqrn6odab@linux>
 <20170807095126.hyhrrnr4vrj3ne4k@linux>
 <20170807134942.u3ep5ivfq4ublueb@thunk.org>
 <20170807193138.GA46084@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Xiang Dai <xiangx.dai@intel.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:11214 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751828AbdHHB1k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Aug 2017 21:27:40 -0400
Content-Disposition: inline
In-Reply-To: <20170807193138.GA46084@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 07, 2017 at 12:31:38PM -0700, Eric Biggers wrote:
> On Mon, Aug 07, 2017 at 09:49:42AM -0400, Theodore Ts'o wrote:
> > On Mon, Aug 07, 2017 at 05:51:26PM +0800, Dai Xiang wrote:
> > > On Mon, Aug 07, 2017 at 11:25:02AM +0800, Dai Xiang wrote:
> > > > Hi!
> > > > 
> > > > I use xfstests with ext4 fs to test, and i found a skip:
> > > > 
> > > > ext4/024         [not run] kernel does not support ext4 encryption
> > 
> > Yeah, the message printed is misleading, and should be fixed.
> > Checking to see whether the kernel supports encryption can be done by
> > checking for the existence of the file:
> > 
> > /sys/fs/ext4/features/encryption
> > 
> > > i print the cmd:
> > > /usr/sbin/xfs_io -i -c set_encpolicy /fs/scratch/tmpdir
> > > /fs/scratch/tmpdir: failed to set encryption policy: Inappropriate
> > > ioctl for device <===
> > > 
> > > Seems do not related to kconfig?
> > 
> > Yes, the issue is that you need to create the file system (or set via
> > tune2fs) the feature flag "encrypt".  To best test the read/write
> > paths, you should set the mount option test_dummy_encryption.  The
> > kvm-xfstests and gce-xfstests framework do all of this automatically.
> > From xfstests-bld/kvm-xfstests/test-appliance/files/root/cfg/fs/ext4/encrypt:
> > 
> > SIZE=small
> > export EXT_MKFS_OPTIONS="-O encrypt"
> > export EXT_MOUNT_OPTIONS="test_dummy_encryption"
> > REQUIRE_FEATURE=encryption
> > TESTNAME="Ext4 encryption"
> > 
> > There are a number tests that are known to fail; primarily having to
> > do with quota support, which doesn't play well with
> > test_dummy_encryption (that's more of a test problem than anything
> > else).  See the encrypt.exclude file in that directory for more
> > details.
> > 
> 
> Actually, this is one of the tests in the "encrypt" group, which format the
> scratch device with "-O encrypt".  So I believe the printed message is correct.
> Are you 100% sure that CONFIG_EXT4_ENCRYPTION is enabled in your kernel config
> and that you are running the correct kernel?

I use v4.13-rc3 kernerl, and i find this info refer to https://wiki.archlinux.org/index.php/ext4#Using_file-based_encryption:

Ext4 forbids encrypting the root (/) directory and will produce an error on kernel 4.13 and later

Does it impact?

> 
> Eric
