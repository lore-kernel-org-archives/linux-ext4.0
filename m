From: "Theodore Ts'o" <tytso@mit.edu>
Subject: e2fsprogs 1.42-WIP-1120 released
Date: Mon, 21 Nov 2011 08:47:06 -0500
Message-ID: <E1RSUDC-0000NC-QH@tytso-glaptop.cam.corp.google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60879 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab1KUNrK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 08:47:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tagged git trees have been pushed out, and tarballs are available on
sourceforge at:

https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs-TEST/1.42-WIP-1120/

I'll upload tarballs to kernel.org later, when I have a chance to
get experience using the new kernel.org uploading tool.

Here's a very quick summary of the changes since the last WIP release,
debian changelog style:

e2fsprogs (1.42~WIP-2011-11-20-1) unstable; urgency=low

  * New upstream release
  * Fix error checking so resize2fs works when using a 32-bit userspace
    and a 64-bit kernel (Closes: #644989)
  * e2fsck now returns additional status bits in its exit code if it
    aborts early in the e2fsck run
  * Fix potential stack overflow in debugfs
  * Avoid an infinite loop in ext2fs_find_block_device() if there are
    symlink loops in /dev caused by a buggy udev
  * Fix test failures on big-endian systems
  * Add a read-only, metadata-only debugfs command called rdebugfs
  * Fix gcc -Wall complaints
  * Add freefrag and e2freefrag commands to debugfs
  * Improve first-class quota support
  * Fix bigalloc support in e2freefrag
  * Clean up mmp handling
  * Fix a regression which caused mke2fs to not work correctly on files
    > 2GB.  (Closes: #647245)
  * Fix a namespace leak in libext2fs (tdb_null)

							- Ted
