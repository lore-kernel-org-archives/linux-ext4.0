From: Avantika Mathur LTC <mathur@us.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Nov. 17, 2006)
Date: Fri, 17 Nov 2006 13:59:24 -0800
Message-ID: <455E30BC.9070705@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56550 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1755956AbWKQV7j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Nov 2006 16:59:39 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAHLxchA013834
	for <linux-ext4@vger.kernel.org>; Fri, 17 Nov 2006 16:59:38 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAHLxRSj180500
	for <linux-ext4@vger.kernel.org>; Fri, 17 Nov 2006 16:59:34 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAHLxR69023581
	for <linux-ext4@vger.kernel.org>; Fri, 17 Nov 2006 16:59:27 -0500
Received: from [127.0.0.1] (IBM-DD6E2EC41B8.beaverton.ibm.com [9.47.16.74])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kAHLxQE5023493
	for <linux-ext4@vger.kernel.org>; Fri, 17 Nov 2006 16:59:27 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sorry they are a little late!  Here are minutes from the interlock call=
=20
on Wednesday.

Thanks,
Avantika
----

Ext4 Developer Interlock Call: 11/15/06 Minutes

Attendees: Dave Kleikamp, Ted Ts'o, Jean-Pierre Dion, Val=E9rie Cl=E9me=
nt,=20
Jean-Noel Cordenner, Mingming Cao, Suparna Bhattacharya, Eric Sandeen,=20
Avantika Mathur

- WIKI: Decided that we need to maintain one Wiki for Ext4. Ted will=20
request a new wiki on kernel.org.

- Shaggy had sent out an Ext4 roadmap after the last call, but need to=20
continue to plan when each feature will be stable and when the disk=20
format can be freezed. This should be kept up to date on the Wiki.

- Ted is reviewing extents patches to e2fsprogs. There have been many=20
changes to mercurial in the past week.

- Defrag Schemes: Detailed discussion of the different defrag schemes=20
being discussed on the mailing list, and what requirements are needed=20
for Ext4.  A summary of this discussion is below:


DEFRAG DISCUSSION
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

(Ted and Eric, this is what I remembered from the discussion, please=20
fill in any gaps or correct any mistakes in the summary.)

Trying to establish a clear direction for defrag, there has been a lot=20
of discussion on the mailing list. =20
The issues discussed were:

-- How the interface to the defrag should be implemented. Current ideas=
=20
are using ioctls, system calls, or implementing as a filesystem.  Using=
=20
ioctls was the method generally favored by Ted and Eric in the discussi=
on.

-- Whether the implementation should be extent based or block based. Te=
d=20
feels that this should be extent based, using indirect blocks if necess=
ary

-- Should the block allocation policy be driven by user space or kernel=
=20
space?

Prefer a user space driven policy, so that files that are accessed=20
concurrently during system boot, can be put close together to speed up=20
the boot process.  In this design the user space interface can specify=20
an inode and logical block sequence to be put in a certain block=20
location; if the space is available, the kernel will copy data and inod=
e=20
pointers.   =20
The user space interface will access bitmaps to locate free space.  It=20
should also have the interface to specify a certain region to be=20
reserved, and that region would be freed on the disk, so user space can=
=20
move other files to that space.

-- Implementation

Ted believes the defrag should be implemented by specifying a region=20
space for a file on disk, storing file data in page cache and copying=20
the data from the page cache to the new physical blocks.  Then changing=
=20
the mappings from the logical blocks to these new physical blocks.

Eric's approach is to identify the region on disk, generate a secondary=
=20
inode for the file and allocate this space to the secondary inode.  The=
n=20
copy the data from the original file to the new blocks, and replace the=
=20
inode.  All file writes will need to be restricted during this process.
Ted's concerns with this approach is possible inconsistencies in the=20
journal if the system crashes during this process, and also the=20
inability to defrag files while they are being written to.
