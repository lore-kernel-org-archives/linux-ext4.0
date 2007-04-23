From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Mon, 23 Apr 2007 16:35:38 -0700
Message-ID: <462D42CA.50509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52048 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbXDWXfb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Apr 2007 19:35:31 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3NNZLRP006734
	for <linux-ext4@vger.kernel.org>; Mon, 23 Apr 2007 19:35:21 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3NNZLCQ199604
	for <linux-ext4@vger.kernel.org>; Mon, 23 Apr 2007 17:35:21 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3NNZLYE009025
	for <linux-ext4@vger.kernel.org>; Mon, 23 Apr 2007 17:35:21 -0600
Received: from [9.47.16.99] (mathur.beaverton.ibm.com [9.47.16.99])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l3NNZKB9009010
	for <linux-ext4@vger.kernel.org>; Mon, 23 Apr 2007 17:35:20 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 04/23/2007 Meeting Minutes

Attendees: Mingming Cao, Dave Kleikamp, Avantika Mathur, Ted Ts'o,=20
Suparna Bhattacharya,
Jean-Pierre Dion, Jean Noel Cordenner, Val=E9rie Cl=E9ment, Jose Santos

Minutes can be accessed at:=20
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Cal=
l

- Mingming proposed moving back to 8am PST meeting time, since the 6am=20
time is inconvenient for
a few people.  This discussion will be continued through email, to find=
=20
a time which works
for everyone.

- Next week's meeting will be canceled, unless there is anyone who woul=
d=20
like to request a meeting.

PATCH STATUS

git-tree
- Mingming will be updating the git tree with extents-fix patches from=20
Alex, i_flags patch from Honza, i_extra_isize patch from Kalpak.

Uninitialized Block Groups:
- The patch sent out by Andreas is against 2.6.16 and ext3.  Need to=20
port this to current ext4, test and then add to git-tree.  Avantika wil=
l=20
ask Andreas if he needs help with this.

JBD statistics:
- There is a patch to export JDB statistics to /proc.  In order to get=20
this patch to mainline, there needs to be discussion about the correct=20
place for the statistics; /proc or perhaps debugfs.

e2fsprogs:
- Ted will post the current e2fsprogs patches in progress. Ted has been=
=20
working with these patches and making changes.
- Main work areas for making e2fsprogs compatible with extents and 64-b=
it.
    - block iterator: make a block iterator work with both extent and=20
non-extent code. Code that is oblivious to extents will still work with=
=20
the block iterator.  This has been written by Andreas Dilger.
    - extents: in order to preserve ABI compatibility, support for a ne=
w=20
interface for extents which uses 64-bit logical and physical block=20
numbers.  The block iterator then translate from on-disk to in-memory=20
format.  This will allow for possible future increases of physical and=20
logical block sizes in extents, without breaking ABI.
    - bitmaps in e2fsprogs: this will be discussed in more detail at th=
e=20
next meeting, after people have a chance to read related email.

preallocation:
- fallocate syscall interface:  the current plan, based on discussions=20
on the mailing list, is to create a separate wrapper for s390 in glibc.=
 =20
Using regular parameter ordering for all other architectures, but a=20
different order on s390.  Jakub Jelinek has said that the changes in=20
glibc can be made pretty easily.
-  The preallocation patches in the ext4 git-tree are outdated, using=20
the ioctl interface.  Once Amit re-posts the patches with the syscall=20
interface, they will be updated in the git-tree as well.
- Mingming mentioned the need to flush preallocation metadata changes t=
o=20
disk if file size or file content is being tested.  Discussed doing an=20
fsync at Bmap time.

TESTING
- extents testing
    - Discussed methods for testing extents on highly fragmented=20
filesystems.
    - Jose will look into possible tests, including perhaps using the=20
'aged' option in FFSB
    - Ted suggested creating a mountoption that creates a bad block=20
allocator which it jumps to a new block group every 8 blocks.  This=20
would force a very large number of extents, and may be a good test for=20
extents.

- large filesystem
    - We would like to perform more testing on large (>16TB) filesystem=
s
    - currently hardware limitations are preventing this testing.  We=20
have tested 10TB raid dists, and 16TB loopback devices.  Avantika will=20
look into creating very large sparse devices for testing.

- Large file deletion
    - Valerie had recently tested large file deletion on ext3/4, but di=
d=20
not see the expected performance gain with ext4 due to compact metadata=
=20
when using extents.
    - Valerie will try re-running the test.  Jose will also be looking=20
into this test.
