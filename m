From: Avantika Mathur <mathur@us.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Nov. 22 2006)
Date: Wed, 22 Nov 2006 13:53:48 -0800
Message-ID: <1164232428.29430.27.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:27090 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1757061AbWKVVzJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Nov 2006 16:55:09 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAMLt82u001116
	for <linux-ext4@vger.kernel.org>; Wed, 22 Nov 2006 16:55:08 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAMLt6rD221320
	for <linux-ext4@vger.kernel.org>; Wed, 22 Nov 2006 16:55:07 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAMLt63J029742
	for <linux-ext4@vger.kernel.org>; Wed, 22 Nov 2006 16:55:06 -0500
Received: from dyn9047017105.beaverton.ibm.com (dyn9047017105.beaverton.ibm.com [9.47.17.105])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kAMLt6et029684
	for <linux-ext4@vger.kernel.org>; Wed, 22 Nov 2006 16:55:06 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Ext4 Developer Interlock Call: 11/22/06 minutes

Attendees: Mingming Cao, Eric Sandeen, Suparna Bhattacharya, Takashi Sa=
to, Jean-Pierre Dion, Val=C3=A9rie Cl=C3=A9ment, Avantika Mathur

- Online Defrag:
 -- Last week we determined that ioctl was the preferred=20
interface for the online defrag.
 -- Eric will send out an ovreview of the steps completed by XFS for fi=
le defragmentation.
 -- Last week Eric said that in XFS defrag implementation, you can't de=
frag a file that is open/being written to.  This was an incorrect assum=
ption. There will be more explanation in his mail.

- Preallocation:
 -- We need to decide which interface to use in the implementation
   * ioctl: simple solution preferred method for defrag and user in res=
ervation
   * posix_fallocate: writes zero to the first byte of every block; pro=
bably preferred solution
   * ftruncate: consistency across platforms may be an issue
 -- Possible parameters that would be used for preallocation would be f=
ile descriptor, number of blocks, and offset within file where blocks w=
ill be preallocated (if defrag and preallocation are implemented togeth=
er
 -- Suparna will send an email detailing all of the options, and some t=
houghts on implementation details to the list.
 -- Eric will send details on XFS's preallocation implementation to the=
 list
 -- Multiple block allocation patches will be used in preallocation imp=
lementation

- Features we'd like to see in Ext4 before code freeze:
 -- online defragmentation
 -- multiple block allocation
 -- big block group: Valerie has ported this to 2.6.19-rc6 and will sen=
d patches to the list tomorrow, and put updated e2fsprogs patches on Bu=
ll web site.
 -- large inode default for ext4
 -- large file support: Current max file size is 2 TB. Increase limit t=
o 16 TB by changing i_block ( patches have been sent by Takashi), then =
increase to more than 16 TB.  Changing the i_block to break 2TB limit m=
ay cause some application to break.

- We would like to document all features for Ext4 and sort dependencies=
 and priorities on the mailing list.
