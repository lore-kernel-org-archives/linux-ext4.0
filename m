From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] EXT_MAX_BLOCK for >= 16TB fs
Date: Tue, 08 Jul 2008 16:56:39 -0700
Message-ID: <1215561399.6820.18.camel@mingming-laptop>
References: <1215449732.1167.11.camel@alpha.linsyssoft.com>
	 <1215521471.3249.15.camel@alpha.linsyssoft.com>
	 <1215523338.3249.18.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>, adilger@Sun.COM,
	Theodore Tso <tytso@mit.edu>
To: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59612 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbYGHX4l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2008 19:56:41 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m68NueiZ016881
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 19:56:40 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m68NueOv174890
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 19:56:40 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m68NudJk017870
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 19:56:40 -0400
In-Reply-To: <1215523338.3249.18.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Girish, thanks for sending out the patch. Looks like it's agains ext3,
could you please port it to ext4?

Thanks,
Mingming
=E5=9C=A8 2008-07-08=E4=BA=8C=E7=9A=84 18:52 +0530=EF=BC=8CGirish Shila=
mkar=E5=86=99=E9=81=93=EF=BC=9A
> Oops ...
>=20
> On Tue, 2008-07-08 at 18:21 +0530, Girish Shilamkar wrote:
> > Hi,=09
> > 	Here is the patch for same.
> >=20
> > Thanks,
> > Girish
> >=20
> > On Mon, 2008-07-07 at 22:25 +0530, Girish Shilamkar wrote:
> > > Hi,
> > > 	The magic constant EXT_MAX_BLOCK =3D 0xffffffff in extents code =
is used
> > > in some places to return "invalid block number", and to set the e=
xtent
> > > length =3D "whole file" in other places.
> > > 	So with >=3D 16 TB fs we would prefer to use it differently. We =
can have
> > > EXT_UNSET_BLOCK =3D 1 to indicate "invalid block number" as it wi=
ll never
> > > be valid block for allocation. And for "whole file" usecase we ca=
n
> > > continue using current EXT_MAX_BLOCK
> > >=20
> > > Regards,
> > > Girish
> > >=20
> > >=20
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-e=
xt4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
