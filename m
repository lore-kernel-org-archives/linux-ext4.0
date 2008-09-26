From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] dynamic inodes
Date: Thu, 25 Sep 2008 20:10:39 -0500
Message-ID: <20080925201039.454bf742@gara>
References: <48DA28B0.2020207@sun.com>
	<20080925223731.GM10950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35753 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYIZBK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Sep 2008 21:10:29 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8Q1ASRS009556
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 21:10:28 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8Q1AS0X210964
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 19:10:28 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8Q1ARwd022263
	for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 19:10:27 -0600
In-Reply-To: <20080925223731.GM10950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 25 Sep 2008 16:37:31 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Sep 24, 2008  15:46 +0400, Alex Tomas wrote:
> > another idea how to achieve more (dynamic) inodes:
>=20
> Actually, Jos=C3=A9 propsed a _very_ simple idea that would allow dyn=
amic
> inodes with relatively low code complexity or risk due to dynamic
> placement of inode tables.
>=20
> The basic idea is to extend the FLEX_BG feature so that (essentially)
> "blockless groups" can be added to the filesystem when the inodes are
> all gone.  The core idea of FLEX_BG is that the "group metadata" (ino=
de
> and block bitmaps, inode table) can be placed anywhere in the filesys=
tem.
> This implies that a "block group" is strictly just a contiguous range=
 of
> blocks, and somewhere in the filesystem is the metadata that describe=
s its
> usage.
>=20
> If one adds a new group (ostensibly "at the end of the filesystem") t=
hat
> has a flag which indicates there are no blocks available in the group=
,
> then what we get is the inode bitmap and inode table, with a 1-block
> "excess baggage" of the block bitmap and a new group descriptor.  The
> "baggage" is small considering any overhead needed to locate and desc=
ribe
> fully dynamic inode tables.
>=20
> A big plus is that there are very few changes needed to the kernel or
> e2fsck (the "dynamic inode table" is just a group which has no space
> for data).  Some quick checks on 10 filesystems (some local, some
> server) shows that there is enough contiguous space in the filesystem=
s
> to allocate a full inode table (between 1-4MB for most filesystems), =
and
> mballoc can help with this.  This makes sense because the cases where
> there is a shortage of inodes also means there is an excess of space,
> and if the inodes were under-provisioned it also (usually) means the
> itable is on the smaller side.
>=20
> Another important benefit is that the 32-bit inode space is used full=
y
> before there is any need to grow to 64-bit inodes.  This avoids the
> compatibility issues with userspace to the maximum possible extent,
> without any complex remapping of inode numbers.
>=20
> We could hedge our bets for finding large enough contiguous itable sp=
ace
> and allow the itable to be smaller than normal, and mark the end inod=
es
> as in-use.  e2fsck will in fact consider any blocks under the rest of
> the inode table as "shared blocks" and do duplicate block processing =
to
> remap the data blocks.  We could also leverage online defrag to remap
> the blocks before allocating the itable if there isn't enough space.
>=20
> Another major benefit of this approach is that the "dynamic" inode ta=
ble
> is actually relatively static in location, and we don't need a tree t=
o
> find it.  We would continue to use the "normal" group inodes first, a=
nd
> only add dynamic groups if there are no free inodes.  It would also b=
e
> possible to remove the last dynamic group if all its inodes are freed=
=2E
>=20
> The itable location would be replicated to all of the group descripto=
r
> backups for safety, though we would need to find a way for "META_BG"
> to store a backup of the GDT in blocks that don't exist, in the case
> where increasing the GDT size in-place isn't possible.

One way to get around this is to implement the exact opposite of what I
proposed earlier and have a block group with no inode tables.  If we do
a 1:1 distribution of inode per block and don't allocate inodes tables
for a series of block groups within a flexbg we could later on attempt
to allocate new inode tables when we run out of inodes.  If we leave
holes in the inode numbers for the missing inode tables, adding new
inode tables in these block groups would not require any inode
renumbering.  This also does not break the current inode allocator
which would be a good thing.  This should be even simpler to implement
than the previous proposal.  The drawbacks are that when allocating a
new inode table, the 1:1 distribution of inode per block would mean
that we need to find a bigger chunk on contiguous blocks to since we
have bigger inode tables per block group.  Since the current inode
allocator tries to keep a 10% of blocks in a flexbg free, finding
contiguous blocks may not be a really big issue.  Another issue is 64bi=
t
filesystem if we use a 1:1 scheme.

This would be like uninitialized inode tables with the added steps of
finding free blocks, allocating a new inode and zeroing the newly
created inode table.  Since we could chose to allocate a new inode
table on a flexbg with the most free blocks, this could keep filesystem
meta-data/data layout consistently close together to maintain
predictable performance.  This option also has no overhead compared to
the previous proposal.

>=20
> The drawbacks of the approach is relatively coarse-grained itable
> allocation, which would fail if the filesystem is highly fragmented,
> but we don't _have_ to succeed either.  The coarse-grained approach i=
s
> also a benefit because we don't need complex data structures to find =
the
> itable, it reduces seeking during e2fsck, and we can keep some hyster=
esis
> in adding/removing dynamic groups to reduce overhead (updates of many
> GDT backups).
>=20
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>=20
> --

-JRS
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
