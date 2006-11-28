From: Eric Sandeen <sandeen@redhat.com>
Subject: xfs preallocation writeup, for comparison
Date: Tue, 28 Nov 2006 15:04:18 -0600
Message-ID: <456CA452.2040302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43971 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1755532AbWK1VEZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Nov 2006 16:04:25 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kASL4OYb028483
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 16:04:24 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kASL4JDv023225
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 16:04:19 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kASL4IEh020154
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 16:04:19 -0500
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As promised, here is a writeup of xfs preallocation routines.

I don't hold these up as the perfect or best way to do this task, but it
is worth looking at what has been done before, to get ideas, find better
ways, and avoid pitfalls for ext4.

XFS preallocation interfaces.
=============================

The xfs preallocation interfaces are described in the xfsctl(3) manpage.
It's not the best doc, so I'll summarize:

XFS has these ioctl calls for space managment of files:

       XFS_IOC_ALLOCSP
       XFS_IOC_FREESP
       XFS_IOC_RESVSP
       XFS_IOC_UNRESVSP

All of these interfaces take an flock-style argument, and you use it to
specify the range of bytes in the file which should be preallocated,
essentially with an offset and a length.

The real work for all of this is done in xfs_change_file_space() in
xfs_vnodeops.c

The main difference between resvsp and allocsp is that resvsp marks the
blocks as "unwritten" meaning that they are allocated but not yet
written to, and if they are read, they will return zeros.  allocsp
actually writes zeros into the allocated blocks.  We can use the xfs_io
tool to demonstrate.

resvsp example:
==============

[root@magnesium test]# touch resvsp
[root@magnesium test]# xfs_io resvsp
xfs_io> resvsp 0 10g
xfs_io> bmap -vp
resvsp:
 EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET
TOTAL FLAGS
   0: [0..16657327]:        16657456..33314783  1 (64..16657391)
16657328 10000
   1: [16657328..20971519]: 96..4314287         0 (96..4314287)
4314192 10000

so we got 2 extents for this 10g file - those are actual filesystem
blocks allocated.  The file is 0 length, but is using 10g of blocks:

[root@magnesium test]# ls -lh resvsp
-rw-r--r--  1 root root 0 Nov 28 14:11 resvsp
[root@magnesium test]# du -hc resvsp
10G     resvsp
10G     total

The extents are simply flagged as unwritten (0x10000 above), so very
little IO occurs and the space reservation is fast..

allocsp example:
===============
(note there's a bit of a buglet in xfs_io, hence the swapped arguments)

[root@magnesium test]# touch allocsp
[root@magnesium test]# xfs_io allocsp
xfs_io> allocsp 10g 0
<wait for IO...>
xfs_io> bmap -vp
allocsp:
 EXT: FILE-OFFSET           BLOCK-RANGE        AG AG-OFFSET
TOTAL
   0: [0..16657327]:        33314848..49972175  2 (64..16657391)
16657328
   1: [16657328..20971519]: 4314288..8628479    0 (4314288..8628479)
4314192

We also got 2 extents here, but they are not flagged as unwritten -
those filesystem blocks were all actually filled with zeros.

[root@magnesium test]# ls -lh allocsp
-rw-r--r--  1 root root 10G Nov 28 14:19 allocsp
[root@magnesium test]# du -hc allocsp
10G     allocsp
10G     total

It would be very nice to see posix_fallocate hooked up to the underlying
filesystem, so that it can make smart decisions about how to efficiently
reserve space...

-Eric
