From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Thu, 25 Sep 2008 16:09:36 -0600
Message-ID: <20080925220936.GL10950@webber.adilger.int>
References: <48DA28B0.2020207@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50697 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYIYWKA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 18:10:00 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8PM9vOG013420
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 15:10:00 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7R00A01UGOE600@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 25 Sep 2008 15:09:57 -0700 (PDT)
Received: from webber.adilger.int ([68.147.167.155])
 by fe-sfbay-09.sun.com (Sun Java System Messaging Server 6.2-8.04 (built Feb
 28 2007)) with ESMTPSA id <0K7R00LPXUWJZ170@fe-sfbay-09.sun.com> for
 linux-ext4@vger.kernel.org; Thu, 25 Sep 2008 15:09:57 -0700 (PDT)
In-reply-to: <48DA28B0.2020207@sun.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sadly this was sitting in my outbox overnight, and might be obsolete
already (explanation in a follow-up email), but I'm sending it as food
for thought...

On Sep 24, 2008  15:46 +0400, Alex Tomas wrote:
> another idea how to achieve more (dynamic) inodes:
>   * new dir_entry format with 64bit inum

Yes, that is a requirement in all cases.

I've always thought that we should also implement inode-in-dirent when
we need to change the dirent format and make dynamic inodes, but that
may be too much to chew on at one time.

>   * ino space is 64bit:
>     * 2^48 phys. 4K blocks
>     * 2^5  inodes in 4K block

The 2^5 inodes/4kB block would actually depend on the blocksize/inodesize,
lets just call this inodes-per-block-bits (IPBB).  It will be a power-of-2
between 0 and 8 (i.e. between 1 and 256 inodes per block), which is fine.
For common ext4 filesystems this would be 2^4 = 16 inodes/block, because
the default is 256-byte inodes today.

>     * highest bit is used to choose addressing schema: static or dynamic

Alternately, any inode >= 2^32 would be dynamic?  One clear benefit of
putting the dynamic inodes at the end of the number space is that they
will only be used if the static inodes are full, which reduces risk due
to corruption and overhead due to dynamic allocations.

>   * each block is covered by two bits: in inode (I) and block (B) bitmaps:
>     I: 0, B: 0 - block is just free
>     I: 0, B: 1 - block is used, but not contains inodes
>     I: 1, B: 0 - block is full of inodes
>     I: 1, B: 1 - block contains few inodes, has free space

Storing B:0 for an in-use block seems very dangerous to me.  This also
doesn't really address the need to be able to quickly locate free inodes,
because it means "I:1" _might_ mean the inode is free or it might not,
so EVERY "in-use" inode would need to be checked to see if it is free.


We need to start with a "dynamic inode bitmap" (DIB) that is mapped from
an "inode table file" (possibly only for the dynamic inode table blocks).
Free inodes can be scanned using the normal ext4_find_next_zero_bit()
in each of the bitmaps.

Each such DIB block holds an array of bits indicating dynamic inode
use, as well as an array of block numbers which map IPBB inode bits to
dynamic inode table blocks.  The DIBB should also have a header which
contains space for a magic, a checksum, and the count of free and total
inodes, like a GDT has, as well as a count of in-use itable blocks.

The dynamic inode table blocks (DITB) should also hold a header with
magic, checksum, back-pointer to DIBB.  The back-pointer to the DIBB
allows efficient clearing of in-use bit and location of the DIBB if the
dynamic inode itself is corrupted, and possibly freeing the DITB if
the last in-use inode is freed.

For common 256-byte inodes and 4kB blocks we need 8 bytes/block for the
block addresses, and 1 bit/inode, so

4096 bytes/block / 256 bytes/inode = 16 inodes(bits)/block = 2 byte bitmap

(4096 bytes - 64-byte header) / (8 byte address + 2 byte bitmap) =
	400 itable blocks per DIBB = 400 * 16 = 6400 inodes/DIBB

65536 bytes/block / 256 bytes/inode = 256 inodes(bits)/block = 8 byte bitmap
(65536 bytes - 64-byte header) / (8 byte address + 8 byte bitmap) =
	4092 itable blocks per DIBB = 4092 * 16 = 1048576 inodes/DIBB


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

