From: Theodore Ts'o <tytso@mit.edu>
Subject: Updated versoin of kvm-xfstests available
Date: Sat, 9 Aug 2014 19:45:56 -0400
Message-ID: <20140809234556.GA11072@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52660 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaHIXp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 19:45:57 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've uploaded a new set of precompiled kvm-xfstests test appliances
at:

   https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

This new version has an updated xfstests, with more of the tests
enabled.  The root_fs image is 40% smaller, and if you want to build
your own root_fs.img, it's much faster and convenient to do so now.

All ext4 developers are strongly encouraged to test their patches
using xfstests before sending them out for review; you are free to use
your own installation of xfstests, but if you want something simple
and turn-key, so there can be no excuses not to test, this is what
kvm-xfstests is for.  :-)

Please do at least "smoke" testing, and if you are working on a major
new feature, doing a full run using "-g auto" is much appreciated.
Once I'm done running my baseline, I'll send out the results for your
convenience; if your patches cause any regressions, *please* take a
look and figure out why, since that will save me a lot of time and
allow your patches to get merged that much more quickly.

					- Ted

Quick start instructions:

0.  Make sure qemu with kvm support is installed on your system.

1.  Run the following commands:

    git clone git://git.kernel.org/pub/scm/fs/ext2/xfstests-bld.git fstests
    cd fstests/kvm-xfstests
    wget -O test_appliance/root_fs.img https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/root_fs.img.i386

Substitute "i386" for "x86_64" in the above URL if you want to test
using a native 64-bit userspace.  It should be possible to use the
32-bit userspace with a 64-bit kernel, although you may run into some
rough spots via-a-vis compat ioctls working correctly.  (If you do,
let me know; those are bugs that should be fixed.  :-)

2.  Take a look at the "config" file and either edit that file in
    place, or put override values in ~/.config/kvm-xfstests or
    config.custom.  The latter is preferred.

3.  Build a kernel with all of the necessary drives for kvm built into
    the kernel (i.e., no modules!).  There are some sample kernel
    configs in the kernel-configs directory.

4.  Run "./kvm-xfstests smoke" to do a quick test.  Or "./kvm-xfstests
    -g auto" to do a full test.  You can also run specific tests on
    specific configurations, i.e., "./kvm-xfstests -c bigalloc
    generic/013 generic/127".  

For more information, please see:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/README

GPL Compliance information can be found here:

https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/README






