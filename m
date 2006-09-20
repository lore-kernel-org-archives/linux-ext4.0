From: Avantika Mathur LTC <mathur@us.ibm.com>
Subject: ext4 devel interlock meeting minutes (Sept. 20, 2006)
Date: Wed, 20 Sep 2006 10:03:51 -0700
Message-ID: <45117477.1030000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:49616 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751136AbWITRDx
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Sep 2006 13:03:53 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8KH3qvR005621
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 13:03:52 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8KH3q8l249854
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 11:03:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8KH3pUh017827
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 11:03:51 -0600
Received: from [127.0.0.1] (IBM-DD6E2EC41B8.beaverton.ibm.com [9.47.16.82])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k8KH3oUC017773
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 11:03:51 -0600
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 9/20/06 Minutes

Attendees: Shaggy (Dave Kleikamp), Jean-Pierre Dion, Alexandre Ratchov,=
=20
Val=E9rie Cl=E9ment, Eric Sandeen, Avantika Mathur

- Shaggy has ported the patch set to 2.6.18-rc7-mm1, and will post the=20
patches today.  Some of the patches are redundant and should be merged=20
together, Shaggy and Alexandre will be working on this.  These patches=20
have only been compile tested, and need more thorough testing. =20
Alexandre has been running ext4 on a 20 TB sparse disk for a month and=20
has not encountered any problems.

- Shaggy and Alexandre will also look back at all of the comments on th=
e=20
original post, to verify they have been addressed in the updated series=
=2E

- Now that 2.6.18 is up, We assume Andrew Morton will be pushing curren=
t=20
ext3 patches in the -mm tree to 2.6.19-rc1.  At that point we will try=20
to merge ext4 patches.

- Alexandre is waiting for feedback from Ted on e2fsprogs patches.  Pla=
n=20
to discuss and review through the mailing list.

- A bug in the JBD patches was found last week; JBD and JBD2 use the=20
same slab. The kernel crashes if ext3 and ext4 are both loaded. This=20
problem is probably still present in current set. Easily reproduced by=20
loading ext3 and ext4 modules, the second one will crash because of=20
duplicate slab name.

-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
