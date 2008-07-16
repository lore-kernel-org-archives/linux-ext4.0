From: Gary Hawco <ghawco@cox.net>
Subject: Add
  ext4__allow_read-only_mounts_with_corrupted_block_group_checksums patch
Date: Tue, 15 Jul 2008 19:31:26
Message-ID: <3.0.6.32.20080715193126.0242c9a0@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:63808 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYGPCb2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 22:31:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

Just recompiled 2.6.26 with the newest snapshot (15-July 2008/2310GMT).
uninit_bg had been enabled.

To test kernel I did: tune2fs -O ^uninit_bg /dev/sda6 to remove uninit_bg
feature.
Was prompted to run e2fsck on system.

Rebooted and e2fsck saw errors and did a forced fsck without having to
reboot. All is well thus far.

Then I did the reverse: tune2fs -O uninit_bg /dev/sda6 to renable uninit_bg
feature.
Again, I was prompted to run e2fsck on system.

Rebooted. This time I got a kernel panic that started with:
EXT4-fs: ext4_check_descriptors: Checksum for group 2 failed (10368!=32990)
EXT4-fs: group descriptors corrupted!

Then the partitions available are listed followed by
No filesystem could mount root, tried: ext4dev ext2
Kernel panic - not syncing: VFS: Unavle to mount root fs on unknown-block(8,6)

I was under the impression that the newest patch would handle this or am I
mistaken?

Thanks,
Gary

