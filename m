From: "AVANTIKA R. MATHUR" <mathur@linux.vnet.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Dec. 13 2006)
Date: Wed, 13 Dec 2006 15:42:59 -0800
Message-ID: <45809003.5060403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46720 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbWLMXm7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Dec 2006 18:42:59 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBDNgwB9029299
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 18:42:58 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBDNgxXu153726
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 18:42:59 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBDNgwMF004747
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 18:42:58 -0500
Received: from [9.47.16.74] (IBM-DD6E2EC41B8.beaverton.ibm.com [9.47.16.74])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kBDNgwDJ004742
	for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2006 18:42:58 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 12-13-06 Minutes

Attendees: Mingming Cao, Dave Kleikamp(Shaggy), Andreas Dilger, Eric=20
Sandeen, Ted Ts'o, Takashi Sato, Badari Pulavarty, Jean-Pierre Dion,=20
Jean Noel Cordenner, Val=E9rie Cl=E9ment, Avantika Mathur

Minutes can be accessed at:=20
http://ext4.wiki.kernel.org/index.php/Ext4_Developer%27s_Conference_Cal=
l

- The next interlock call will be in January

- Delayed Allocation and Multiple Block Allocation: Alex Tomas' patches=
=20
for delayed improves performance since it batches all writes to one are=
a=20
of the disks, reducing number of seeks.  =20
  -- Online defragmention depends on delalloc and mballoc, these two=20
should be the priority to be pushed first.
  -- Delalloc is not currently implemented on data=3Dordered mode; This=
 is=20
a desired feature, but adding this support should not delay merging the=
=20
current patch.

- Preallocation: Mingming posted comment to the preallocation patches,=20
asking if preallocation should be implemented for block based files so=20
ext3 users could also use it.  It was decided that it will be a rare=20
case where a user will want to add preallocation on existing block base=
d=20
files, but might be a nice feature to have.  Since zero-ing out the=20
blocks can take time and block applications, the ideal method would be=20
to first convert files to extents. If this was implemented, we would=20
want an in kernel converter utility that can convert from ext3 to have=20
all ext4 features and back.

- Backwards compatibility:  Eric asked if maintaining ext3 features in=20
ext4 and format compatibility is necessary.  Ted believes that up until=
=20
now it has not been too much work to maintain.  With 64bit and extents=20
it may be more work, but also might be useful for some people.  In the=20
future, if it is too much work or has a great impact on performance,=20
then backwards compatibility may be eliminated.

- Finer Timestamp:  Ted will propose to the mailing list that nanosecon=
d=20
timestamps are only supported in large inodes.

- Change Attribute:  =20
  -- Andreas asked the bull team why a new field in the inode is=20
necessary rather than using the i_version field, and also mentioned tha=
t=20
all code changes can be in mark_inode_dirty.  =20
  -- The ctime cannot be used for the change attribute because if the=20
server clock is incorrect, the ctime can go backwards in time.
  -- semantics needed: nfsv4 and bull team require 32 bits, clusterfs=20
needs 64 bits.
