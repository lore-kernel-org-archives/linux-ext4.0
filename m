From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/3] Fix resize2fs data/filesystem corruption bugs
Date: Sat, 18 Apr 2009 23:03:45 -0400
Message-ID: <1240110228-22781-1-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51487 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbZDSDDz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 23:03:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


These patches fix some nasty resize2fs bugs when growing or shrinking
ext4 filesystems off-line.  Eric, you'll probably want get these
patches into Fedora's e2fsprogs before F11 goes live.

The test case I've been using for these patches are as follows.

#!/bin/sh
mke2fs -i 8192 -b 1024 -t ext4 /dev/closure/testext4 1048576
mount /dev/closure/testext4 /mnt
cd /mnt
mkdir 1 2 3 4
cd 1; tar xjf /usr/projects/uml/shars/linux-2.6.11.tar.bz2; cd ..
cd 2; tar xjf /usr/projects/uml/shars/linux-2.6.11.tar.bz2; cd ..
cd 3; tar xjf /usr/projects/uml/shars/linux-2.6.11.tar.bz2; cd ..
cd 4; tar xjf /usr/projects/uml/shars/linux-2.6.11.tar.bz2; cd ..
cd /
umount /mnt
e2fsck -f /dev/closure/testext4

Then try resizing the filesystem smaller or larger.  With e2fsprogs
1.41.4, "resize2fs -M -p /dev/closure/testext4" will just plain fail in
the middle with the resize operation:

# /sbin/resize2fs  -M -p /dev/closure/testext4
resize2fs 1.41.4 (27-Jan-2009)
Resizing the filesystem on /dev/closure/textext4 to 863610 (1k) blocks.
Begin pass 2 (max = 116149)
Relocating blocks             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 128)
Scanning inode table          XXXXXXXXXXXXXXXXXXXX/sbin/resize2fs: No space left on device while trying to resize /dev/closure/textext4

The bugs fixed include potentially overwriting part of the existing
inode table when shrinking the filesystem, and potentially overwriting
in-use data blocks when growing the filesystem.  So these are pretty
serious errors, and means an e2fsprogs 1.41.5 will be coming out real
soon now.

With these patches, I've resized the filesystem and then run a CRC
checksum test across the unpacked 2.6.11 source tree.  (Why 2.6.11?
Because it was what I happened to have handy on my laptop at the time. :-)

						- Ted


