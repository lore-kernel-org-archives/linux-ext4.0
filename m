From: Jim Meyering <jim@meyering.net>
Subject: rawhide's init/nash segfaults in libblkid
Date: Mon, 23 Feb 2009 17:41:28 +0100
Message-ID: <87ab8dds1z.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:57980 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZBWQnG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Feb 2009 11:43:06 -0500
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 367E3D1C757
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 17:42:59 +0100 (CET)
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id D770FE08142
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 17:41:31 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp6-g21.free.fr (Postfix) with ESMTP id 0529CE0806F
	for <linux-ext4@vger.kernel.org>; Mon, 23 Feb 2009 17:41:29 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI, I've just filed this against the kernel:

  http://bugzilla.redhat.com/486997

Perhaps it should be reassigned to e2fsprogs...
---------

Normally I track rawhide pretty closely, but for the last few weeks
new kernels haven't booted on the system I use for that, so I stuck
with the most recent one that worked,

  2.6.29-0.74.rc3.git3.fc11.x86_64

However, now that there are 4 newer kernel images, none of which boots,
it's getting a little precarious, and I investigated.
Note: this is the first that failed to boot:

  2.6.29-0.99.rc4.git1.fc11.x86_64

The most recent, 2.6.29-0.131.rc5.git2.fc11.x86_64
also fails the same way, with a segfault from init/nash.

The traceback I saw had (from memory, sorry)

  glibc's strlen
  ...
  libblkid's blkid_verify
             blkid_get_dev
  nash...

I found that I could boot into any of the recent kernels,
only if I'd either disconnect /dev/hdb physically,
or if I had erased its partition table.  I did save a copy.

The partitions on /dev/hdb were of type ext4 and ext3:
Here's what parted said before I reformatted the xfs partition as ext4,
just to be sure xfs wasn't implicated:

  Model: ATA SAMSUNG HD501LJ (scsi)
  Disk /dev/sdb: 976773168s
  Sector size (logical/physical): 512B/512B
  Partition Table: msdos

  Number  Start       End         Size        Type      File system  Flags
   1      32s         390625279s  390625248s  primary   ext3         boot
   2      390625280s  488282111s  97656832s   primary   ext3
   3      488282112s  625000447s  136718336s  extended
   5      488282144s  585938943s  97656800s   logical   xfs
   6      585938976s  625000447s  39061472s   logical

If you need more detail, I'll be happy to help,
but it may take me a week or so.
