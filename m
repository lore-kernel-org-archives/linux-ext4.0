From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix data corruption when writing to prealloc area
Date: Fri, 18 Jul 2008 12:03:40 -0700
Message-ID: <1216407820.8232.1.camel@mingming-laptop>
References: <1216387021-26384-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1216400553.6869.11.camel@mingming-laptop>
	 <1216401767.6869.19.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59337 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbYGRTDn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 15:03:43 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6IJ3g7Z030767
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:03:42 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6IJ3gTo159748
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:03:42 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6IJ3f9m000926
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:03:42 -0400
In-Reply-To: <1216401767.6869.19.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-18=E4=BA=94=E7=9A=84 10:22 -0700=EF=BC=8CMingming Cao=
=E5=86=99=E9=81=93=EF=BC=9A
> =E5=9C=A8 2008-07-18=E4=BA=94=E7=9A=84 10:02 -0700=EF=BC=8CMingming C=
ao=E5=86=99=E9=81=93=EF=BC=9A
> > I tried this patch, with nodelalloc, the kernel did not crash! Prev=
ious
> > it crashes in a few minutes.
> >=20
> >  but the test did not stop after fill the file by specified 2G size
> >=20
> >=20
> > I noticed the write() to write to the last fallocate extent(up to 2=
G)
> > returns junk value.
> >=20
> >=20
> > The testcase I got from Shehjart (who originally reported the probl=
em)
> > is =20
> >=20
> > http://www.gelato.unsw.edu.au/~shehjart/writefallocate.c
> >=20
>=20
> I forget to mention that I modify the test slight to call fallocate()
> with default mode (expnd size) instead of keep size.
>=20

Oh, it's the file size problem for the 2 GB barrier, the latest test
source git tree  has fixed this,.  With the patch ext4 runs fine with
both KEEP_SIZE mode and ALLOCATE mode.

Mingming

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
