From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 14:58:17 -0700
Message-ID: <1219269497.7895.48.camel@mingming-laptop>
References: <20080820054339.GB6381@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39773 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYHTV6e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Aug 2008 17:58:34 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KLwNuA032115
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:58:23 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KLwHWg213670
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:58:17 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KLwHEs027626
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 17:58:17 -0400
In-Reply-To: <20080820054339.GB6381@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 11:13 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> Hi,
>=20
> I am getting this even with the latest patch queue. The test program =
is
> a modified fsstress with fallocate support.
>=20

Hi Aneesh,=20

Is this a regression with the latest patch queue? I wonder when do we
start to seeing this problem?

Also,  are the failure inodes  the ones with fallocated blocks?

Mingming
> mpage_da_map_blocks block allocation failed for inode 377954 at logic=
al
> offset 313 with max blocks 4 with error -28
> mpage_da_map_blocks block allocation failed for inode 336367 at logic=
al
> offset 74 with max blocks 9 with error -28
> mpage_da_map_blocks block allocation failed for inode 345560 at logic=
al
> offset 542 with max blocks 7 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 355317 at logic=
al
> offset 152 with max blocks 10 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 395261 at logic=
al
> offset 462 with max blocks 1 with error -28
> This should not happen.!! Data will be lost
> mpage_da_map_blocks block allocation failed for inode 323784 at logic=
al
> offset 313 with max blocks 11 with error -28
> This should not happen.!! Data will be lost
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
