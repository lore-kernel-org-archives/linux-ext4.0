From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC returned during writepages
Date: Thu, 21 Aug 2008 20:39:28 +0530
Message-ID: <20080821150928.GA6509@skywalker>
References: <20080820054339.GB6381@skywalker> <1219269497.7895.48.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:44203 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYHUPKS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Aug 2008 11:10:18 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7LF9LIZ015461
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:09:21 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7LFA4UL4046938
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:10:04 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7LFA4fs007183
	for <linux-ext4@vger.kernel.org>; Fri, 22 Aug 2008 01:10:04 +1000
Content-Disposition: inline
In-Reply-To: <1219269497.7895.48.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 20, 2008 at 02:58:17PM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-08-20=E4=B8=89=E7=9A=84 11:13 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > Hi,
> >=20
> > I am getting this even with the latest patch queue. The test progra=
m is
> > a modified fsstress with fallocate support.
> >=20
>=20
> Hi Aneesh,=20
>=20
> Is this a regression with the latest patch queue? I wonder when do we
> start to seeing this problem?

We started logging the error recently. So the problem is not recently
introduced.

>=20
> Also,  are the failure inodes  the ones with fallocated blocks?

No i get the problem even without fallocate

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
