From: Jim Meyering <jim@meyering.net>
Subject: with -b N and block count, should mkfs.ext4 fail with dev-too-big?
Date: Wed, 11 Feb 2009 13:50:39 +0100
Message-ID: <87ab8ti1cw.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>
To: ext <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:45196 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbZBKMv7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Feb 2009 07:51:59 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 0F029D13729
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 13:51:52 +0100 (CET)
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 2227E4C81CC
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 13:50:41 +0100 (CET)
Received: from mx.meyering.net (mx.meyering.net [82.230.74.64])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 415684C81E8
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 13:50:39 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

[this is on rawhide: mke2fs 1.41.4 (27-Jan-2009)
        Using EXT2FS Library version 1.41.4 ]

FWIW, I was trying to create an ext4 file system with more than 2^32
blocks to demonstrate a parted bug fix, but with the particular device
I was using, I couldn't even create one with 2^31-1 blocks.

When I try to create an ext4 file system specifying both block size and
the number of blocks, the size of the underlying device should not matter,
as long as it is large enough.

However, when the underlying device too large, it fails like this:

Set-up: Create a 10TB sparse device called /dev/mapper/s1 with
/dev/sdb6 (just ~20GB) for backing store:

  N=$(echo '10*2*1024^3'|bc)
  echo "0 $N zero" | dmsetup create zero1
  echo "0 $N snapshot /dev/mapper/zero1 /dev/sdb6 p 128" | dmsetup create s1

Try to create an ext4 file system with 2^31-1 1024-byte blocks:
(note that I specify an explicit number of blocks)

  # mkfs.ext4 -b 1024 /dev/mapper/s1 $(echo '2*1024^3-1'|bc|tee /dev/tty)
  2147483647
  mke2fs 1.41.4 (27-Jan-2009)
  mkfs.ext4: Size of device /dev/mapper/s1 too big to be expressed in 32 bits
          using a blocksize of 4096.
  [Exit 1]

I can understand failing like that when the "blocks-count" argument
is omitted, because then we're asking mkfs.ext4 to use the entire
device.

Regards,

Jim

PS. let me know if you'd like a BZ for this, and I'll fill out the form
