From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH -V3 09/11] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Thu, 28 Aug 2008 22:06:14 -0700
Message-ID: <1219986374.16004.9.camel@mingming-laptop>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219960669.6384.58.camel@mingming-laptop>
	 <20080829034451.GA6444@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53304 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYH2FGT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2008 01:06:19 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7T56J1u031933
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 01:06:19 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7T56JJ9183494
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 01:06:19 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7T56IOa004574
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 01:06:18 -0400
In-Reply-To: <20080829034451.GA6444@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-08-29=E4=BA=94=E7=9A=84 09:14 +0530=EF=BC=8CAneesh Kumar=
 K.V=E5=86=99=E9=81=93=EF=BC=9A
> On Thu, Aug 28, 2008 at 02:57:49PM -0700, Mingming Cao wrote:
> >=20
> > From: Mingming Cao <cmm@us.ibm.com>
> >=20
> > ext4: Fix ext4 nomballoc allocator for ENOSPC
> >    =20
> > We run into ENOSPC error on nonmballoc ext4, even when there is fre=
e blocks
> > on the filesystem.
> >=20
> > The problem is triggered in the case the goal block group has 0 fre=
e blocks
> > , and the rest block groups are skipped due to the check of "free_b=
locks=20
> > < windowsz/2".
>=20
> The goal block group had free blocks < windowsz .
>=20
Hmm, if the goal block group had free blocks, why allocation failed
(reservation is turned off by setting my_rsv as NULL)? I wonder if ther=
e
is other threads trying to allocating in the same goal block group at
the same time, steal the last free blocks?

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
