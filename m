From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V3 09/11] ext4: Fix ext4 nomballoc allocator for ENOSPC
Date: Fri, 29 Aug 2008 13:55:00 +0530
Message-ID: <20080829082500.GC6447@skywalker>
References: <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219960669.6384.58.camel@mingming-laptop> <20080829034451.GA6444@skywalker> <1219986374.16004.9.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:42243 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYH2I0z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Aug 2008 04:26:55 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7T8PQDW019316
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 18:25:26 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7T8PCs54685948
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 18:25:12 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7T8PBAU004859
	for <linux-ext4@vger.kernel.org>; Fri, 29 Aug 2008 18:25:12 +1000
Content-Disposition: inline
In-Reply-To: <1219986374.16004.9.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2008 at 10:06:14PM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-08-29=E4=BA=94=E7=9A=84 09:14 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > On Thu, Aug 28, 2008 at 02:57:49PM -0700, Mingming Cao wrote:
> > >=20
> > > From: Mingming Cao <cmm@us.ibm.com>
> > >=20
> > > ext4: Fix ext4 nomballoc allocator for ENOSPC
> > >    =20
> > > We run into ENOSPC error on nonmballoc ext4, even when there is f=
ree blocks
> > > on the filesystem.
> > >=20
> > > The problem is triggered in the case the goal block group has 0 f=
ree blocks
> > > , and the rest block groups are skipped due to the check of "free=
_blocks=20
> > > < windowsz/2".
> >=20
> > The goal block group had free blocks < windowsz .
> >=20
> Hmm, if the goal block group had free blocks, why allocation failed
> (reservation is turned off by setting my_rsv as NULL)? I wonder if th=
ere
> is other threads trying to allocating in the same goal block group at
> the same time, steal the last free blocks?
>=20

We are trying block allocation with a grp_target_blk there and even if
reservation is turned off it can return ENOSPC.

-aneesh

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
