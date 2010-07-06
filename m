From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: inconsistent file placement
Date: Mon, 5 Jul 2010 18:49:34 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam1.wdc.com ([129.253.170.130]:18756 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0GFB7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jul 2010 21:59:03 -0400
Content-class: urn:content-classes:message
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I realize that it is enerally not a good idea to tune
an operating system, or subsystem, for benchmarking, but
there's something that I don't understand about ext[234]
that is badly affecting our product.  File placement on
newly-created file systems is inconsistent.  I can't,
yet, call it a bug, but I really need to understand what
is happening, and I cannot find, in the source code, the
source of the randomization (related to "goal"???).

Disk drive performance for writing/reading large files
is rather sensitive to outer-/inner-diameter cylinder
placement.  When I create the same file multiple times
on newly-created ext[234] file systems on the same disk
partition, I find that it does not consistently occupy
the same blocks.  In fact, there is enough difference in
location to cause real differences in performance from
test to test, which I cannot justify to management.

We are currently on 2.6.32.12, using a 32-bit powerpc.  The
system is booted from tftp and the root file system is NFS
for the test.  The partition used is always the same one,
and it is the only one mounted from the disk.  There is
always exactly one (5G) file created using the same command
"for i in 1 2 3 4 5; do dd if=/hex.txt bs=64K; \
done >>/DataVolume/hex.txt", where /hex.txt is a 1G file
and /DataVolume is the mounted disk partition.

I have tried, as I said, ext[234], and have tinkered with
most of the options, including orlov/oldallocator, and the
behavior doesn't change.  Here's a sample of dumpe2fs
output from three runs, in a diff3:

====
1:51,52c
    44750 free blocks, 65268 free inodes, 2 directories
    Free blocks: 295-45044
2:51,52c
    11990 free blocks, 65268 free inodes, 2 directories
    Free blocks: 295-12284
3:51,52c
    40655 free blocks, 65268 free inodes, 2 directories
    Free blocks: 295-40949
====
1:59,60c
    3794 free blocks, 65280 free inodes, 0 directories
    Free blocks: 65819-65823, 127267-131055
2:59,60c
    36554 free blocks, 65280 free inodes, 0 directories
    Free blocks: 65819-65823, 94507-131055
3:59,60c
    7889 free blocks, 65280 free inodes, 0 directories
    Free blocks: 65819-65823, 123172-131055

Thanks for any help,

Dan
