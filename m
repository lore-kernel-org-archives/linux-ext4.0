From: Chris Naunton <chris@naunton.name>
Subject: Filesystem corrupted by offline resize
Date: Thu, 21 Feb 2013 16:40:42 +1100
Message-ID: <CACqGdtvfi9a9z4F7KpOQmcqNkptdfWXyTTwgxH66RHNqcTAPSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55729 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3BUFlF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2013 00:41:05 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so4267519eek.38
        for <linux-ext4@vger.kernel.org>; Wed, 20 Feb 2013 21:41:03 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think I'm the victim of a resize2fs bug that was addressed in
1.42.7: http://e2fsprogs.sourceforge.net/e2fsprogs-release.html#1.42.7

"Fix resize2fs so that it can handle off-line resizes of file systems
with the flex_bg feature but without a resize_inode (or if we run out
of reserved gdt blocks). This also fixes a problem where if the user
creates a filesystem with a restricted number of reserved gdt blocks,
an off-line resize which grows the file system could potentially
result in file system corruption."

My senario:

* Running Ubuntu 12.10 with the latest x64 e2fsprogs package, which is 1.47.5

* I have a 3.6T ext4 filesystem that had been created with the "resize" option:

  mkfs -t ext4 -T ext4 -E stripe-width=64,resize=20T -i 1048576 -L
data -m 0 /dev/raid5/data

  (This was three years ago. I think at the time I assumed if I didn't
specify this option my ability to resize would be limited.)

* Added an extra disk to the mdadm RAID5 array and extended the LVM
logical volume.

* Decided to perform resize offline as I assumed it would be the safer option.

* Offline fsck and resize completed successfully. No errors reported.
Didn't immediately perform a fsck after resize, just rebooted.

* Upon boot, filesytem errors detected and manual fsck is required. It
reports what looks like massive and serious corruption.


I've placed dumps of relevant output here as it's quite a few
megabytes, even compressed:

http://members.optusnet.com.au/~naunivans/ext4/


So far I've left the corrupted filesystem untouched in the hope
something can be done to repair it or recover data. I'm worried that
not many (any?) usable files will be left after a "fsck -y".

Is it likely that the bug was the cause of the corruption and if so,
what is the likely extent of data loss?

Thanks very much.
Chris Naunton
