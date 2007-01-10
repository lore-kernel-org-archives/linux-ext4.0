From: "AVANTIKA R. MATHUR" <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Jan. 10 2007)
Date: Wed, 10 Jan 2007 14:08:11 -0800
Message-ID: <45A563CB.2090507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52271 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132AbXAJWIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jan 2007 17:08:14 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0AM70P1015733
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2007 17:07:00 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0AM8991548524
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2007 15:08:09 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0AM89Q5010903
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2007 15:08:09 -0700
Received: from [9.47.16.74] (mathur.beaverton.ibm.com [9.47.16.74])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l0AM88e1010883
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jan 2007 15:08:09 -0700
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Ext4 Developer Interlock Call: 1-10-07 Meeting Minutes
Attendees: Mingming Cao, Dave Kleikamp, Takashi Sato, Suparna=20
Bhattacharya, Jean-Pierre Dion, Jean-Noel Cordenner, Val=E9rie Cl=E9men=
t,=20
Ted Ts'o, Avantika Mathur

Minutes can be accessed at:=20
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Cal=
l

- Conferences:
-- The Linux filesystem and storage workshop is coming up in February
-- OLS: deadline to submit abstracts is Feb 5th. Ted is thinking about =
a=20
paper on e2fsprogs.  Encouraging writing in-depth technical papers on=20
ext4 work.

- Ted will set up a git tree on kernel.org with all of the ext4 patches=
;=20
so it is easy to access and test all of the patch sets.
- Mingming will send an email requesting everyone to resend latest=20
versions of ext4 patches to the mailing list, with a short description=20
and status including 'to dos' and outstanding issues.

Ext4 Roadmap - an update on ext4 features in progress:
These updates will also be added to the wiki page:=20
http://ext4.wiki.kernel.org/index.php/New_ext4_features

- Multiple Block Allocation
-- status: Patches are available and there are no format or e2fsprogs=20
changes. given that there are no dependencies, this feature should be=20
pushed to mainline soon.
-- outstanding issues: none

- Delayed Allocation
-- status: Patches are available, and have been commented on -- need=20
more work.
-- outstanding issues:  lack of plan for 1k,2k block size and default=20
data=3Dorder mode, and Andrew asked for more comments.

- Preallocation
-- status: Kernel implementation and e2fsprogs changes are complete, an=
d=20
have been thoroughly reviewed by Mingming and Alex Tomas.
-- outstanding issues:  Need consensus on what interface should be used=
=20
(ioctl, fcntl..). What should the return value be on success, zero or=20
number of block allocated. Suparna will post a comment for a case where=
=20
the extent is allocated far off on the disk. Once the interface is=20
decided, this feature will be ready to add to the git tree.
-- Andrew Morton has mentioned adding preallocation to directories. Ted=
=20
and Mingming discussed adding readahead and reservation to directories=20
rather than better than preallocatin.

- Online Defragmentation:
-- status:  Takashi sent updated patches last month. He will repost mos=
t=20
recent version to the list.
-- outstanding issues: unknown

- Break 32000 directory limit:
-- status:  Andreas Dilger posted this patch. It is a simple patch with=
=20
minor e2fsrogs changes.  Ask Andreas to repost patches on ext4.
-- outstanding issues: unknown

- Nanosecond Timestamps
-- status: Patches have been posted by Andreas Dilger, shouldn't need=20
much rework once issues are resolved.
-- outstanding issues:  Should be available in 128 bit inodes, or only=20
in larger inodes.  What effect updating the nanosecond timestamp has on=
=20
performance, excessive atime updates. Should atime be kept at ~1 second=
=20
granularity.

- Change Attribute
-- status: use i_version rather than change_attribute field for this=20
feature.  Jean-Noel will resend out latest patch with summary and statu=
s
-- outstanding issues: unknown

- Uninitialized Groups
-- status: Feature will reduce fsck time on a large filesystem. =20
Currently this features is very premature and in prototype mode.  Basic=
=20
functionality for testing on 64 bit is in place, but not yet useful in=20
production.  There are no dependencies on this feature, for safety the=20
feature depnds on checksumming block groups. Ask Andreas to resend patc=
hes.
-- outstanding issues:  prototype mode

- Journal Checksumming
-- status: feature will speed up journaling.  The feature was proposed,=
=20
but there is no status on patches.
-- outstanding issues: n/a

- Undelete Feature for Ext4
-- status: Idea was proposed on the mailing list, still need more=20
thought on the feature.
-- outstanding issues: Should the kernel be involved with undelete

- Large file support
-- status: Increase 2Tb limit on filesize. Takashi has begun working on=
=20
this.
-- outstanding issues: unknown

- E2fsprogs work
-- Ted is working on a user issue handling > 375 million directories on=
 =20
a 32 bit machine
-- Correct interfaces for extents
-- adding 64 bit API without causing ABI breakages. Might need a major=20
version change with the ABI breakage.

- Supporting Trillions of Files in Ext4
-- Mingming and Avantika are looking into this
-- Issues and Constraints: difficult to support more than 32 bits of=20
inodes, filsystem format and compatibility issues, stat interface is=20
only 32 bits, memory utilization of inode cache will affect performance
