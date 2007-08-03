From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (July 30, 2007)
Date: Fri, 03 Aug 2007 15:56:37 -0700
Message-ID: <46B3B2A5.9000307@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:57238 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759486AbXHCW4C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 18:56:02 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l73Mu1bY027089
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 18:56:01 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l73Mu1CQ240802
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 16:56:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l73Mu1Ob024288
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 16:56:01 -0600
Received: from [9.47.16.161] (dyn9047016161.beaverton.ibm.com [9.47.16.161])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l73Mu03U024268
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 16:56:01 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: July 30, 2007 Meeting Minutes

Minutes can be accessed at:=20
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Cal=
l

Attendees: Mingming Cao, Andreas Dilger, Jean-Pierre Dion, Jean-Noel=20
Cordenner, Val=E9rie Clement, Aneesh Veetil, Dave Kleikamp, Jose Santos=
,=20
Ted T'so, Avantika Mathur

PATCH STATUS

Delalloc:
- Alex posted his vfs delayed allocation patches.
- Comments are that there is not sufficient generic support for XFS. =20
The code that Christoph Hellwig had posted which does support XFS is=20
very complex.
- Christoph would be ok to take most of Alex's patch as an ext4 patch. =
=20
In the short term we can put the delalloc support in ext4 and then late=
r=20
work on generic vfs support.
- Mingming will respond to the thread asking what Andrew Morton's=20
preference is.

Multiple Block Allocation:
- Aneesh has been hitting a bug when creating a filesystem with=20
different number of blocks/block group then default.  the problem=20
occurred during online migration with mballoc enabled.
- A possible temporary solution to this problem is to disable mballoc i=
f=20
the filesystem created with not the default blocks/block group ratio.
- Aneesh will write-up the problem he is seeing and send an e-mail to A=
lex.
- Aneesh will split mballoc into more patches, to be added to the=20
ext4-patch-queue.  This will make it easier to review.

Inode Version:
- Jean-Noel sent the mount option patch to linux-ext4.  We had discusse=
d=20
adding a flag to the superblock indicating that i_version is enabled,=20
but there are no bits available in f_flags.
- Mingming will reply to the post saying the overwrite case needs to be=
=20
addressed first

Uninitialized Block Groups:
- Avantika will look into why the checksum is not consistent - and why=20
the check fails even when the feature is not enabled.

=46lexible Block Groups:
- Jose is trying to see why fsck is not working.  once this is resolved=
,=20
the feature will be complete. =20
- He has seen a problem with fsck when meta_bg feature is enabled. =20
Andreas saw a similar problem, and the uninitialized block groups patch=
=20
fixes the issue.  Jose will look back at the fix which is in the series=
=20
of e2fsprogs patches sent by Girish last week.

- Mingming asked about exporting JBD stat info to debugfs; as well as=20
procfs.  The consensus had been to just export to procfs as not everyon=
e=20
uses debugfs.
