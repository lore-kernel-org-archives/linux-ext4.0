From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 09/11] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Thu, 28 Aug 2008 14:57:49 -0700
Message-ID: <1219960669.6384.58.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57178 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbYH1V6H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2008 17:58:07 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7SM0WLd009796
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 18:00:32 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7SLvnmZ189264
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:57:50 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7SLvnd9032156
	for <linux-ext4@vger.kernel.org>; Thu, 28 Aug 2008 17:57:49 -0400
In-Reply-To: <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-27=E4=B8=89=E7=9A=84 20:58 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> Make sure we  set windowsize to zero if the free
> blocks left is less that window size. Otherwise
> we skip some group with low freeblock count during
> block allocation
>=20

Current code has a way to try to prevent early ENOSPC with old ext3
block reservation. After searching for all block groups and can't do
block reservation and allocation, it will fall back to no block
reservation and scan the block groups from the beginning again.=20

But this doesn't work in the case the reservation was turned off in the
first goal block group allocation due to 0 free blocks, and the rest
block groups are skipped due to the check of "free_blocks < windowsz/2"=
,
I think this causes the ENOSPC error you saw.

There are two issues. I am attaching the  fix for two issues here.=20

Thanks,

=46rom: Mingming Cao <cmm@us.ibm.com>

ext4: Fix ext4 nomballoc allocator for ENOSPC
   =20
We run into ENOSPC error on nonmballoc ext4, even when there is free bl=
ocks
on the filesystem.

The problem is triggered in the case the goal block group has 0 free bl=
ocks
, and the rest block groups are skipped due to the check of "free_block=
s=20
< windowsz/2". Current code could fall back to non reservation allocati=
on
to prevent early ENOSPC after examing all the block groups with reserva=
tion on
, but this code was  bypassed if the reservation window is turned off a=
lready,
which is true in this case.

This patch fixed two issues:
1) We don't need to turn off block reservation if the goal block group =
has=20
0 free blocks left and continue search for the rest of block groups.

Current code the intention is to turn off the block reservation if the
 goal allocation group has a few (some) free blocks left (not enough=20
for make the desired reservation window),to try to allocation in the
 goal block group, to get better locality. But if the goal blocks have=20
0 free blocks,  it should leave the block reservation on, and continues
search for the next block groups,rather than turn off block reservation
completely.

2) we don't need to check the window size if the block reservation is o=
ff.=20

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

Index: linux-2.6.27-rc3/fs/ext4/balloc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc3.orig/fs/ext4/balloc.c	2008-08-28 12:41:55.00000000=
0 -0700
+++ linux-2.6.27-rc3/fs/ext4/balloc.c	2008-08-28 14:40:43.000000000 -07=
00
@@ -1807,6 +1807,7 @@
 	 * turn off reservation for this allocation
 	 */
 	if (my_rsv && (free_blocks < windowsz)
+		&& (free_blocks > 0)
 		&& (rsv_is_empty(&my_rsv->rsv_window)))
 		my_rsv =3D NULL;
=20
@@ -1843,7 +1844,7 @@
 		 * free blocks is less than half of the reservation
 		 * window size.
 		 */
-		if (free_blocks <=3D (windowsz/2))
+		if (my_rsv && (free_blocks <=3D (windowsz/2)))
 			continue;
=20
 		brelse(bitmap_bh);


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
