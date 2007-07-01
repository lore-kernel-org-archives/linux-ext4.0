From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Sat, 30 Jun 2007 23:40:11 -0500
Message-ID: <20070630234011.38b4bb22@gara>
References: <20070629170958.13b7700c@gara>
	<D5D3223C-4EB0-413B-A81A-05F6DDC0FEEB@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:55763 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbXGAElX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2007 00:41:23 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l614fMZf013143
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jul 2007 00:41:23 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l614fMJK205820
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 22:41:22 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l614fMMc029324
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 22:41:22 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l614fMRU029321
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jun 2007 22:41:22 -0600
In-Reply-To: <D5D3223C-4EB0-413B-A81A-05F6DDC0FEEB@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 30 Jun 2007 11:06:16 -0400
Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Le 29 juin 07 =C3=A0 18:09, Jose R. Santos a =C3=A9crit :
> Hi Jose,

Hi Laurent,

Seems like your emails are not making it to the mailing list.  I got
them fine though.

> Thank you for the question ;-)
>=20
> BIG_BG allows to limit the number of groups (at least in the group =20
> counter).
> IMHO, I think it could be important in some cases.

Yes, I think bigger block groups will benefit extents a great deal
since not only can we have larger extents, but I believe that as the
filesystem ages the chances of getting large number contiguous block ca=
n
be reduce with small block groups.
=20
> For instance, if we keep the same inode table allocation politic, we =
=20
> divide the total number of inode in the FS by the total number of =20
> groups.
> For the moment, number of inode < 2^32 and if we have number of block=
 =20
> group > 2^32 the number of inode per group is 0.... is META_BG able =20
> to manage this case ?

Good point.  It is a scenario that needs to be looked, although I
sincerely hope that we get 64-bit inodes implemented by the time
storage devices get that big. ;)
=20
> With META_BG, a 2^48 blocks FS will have 2^48 / 2^12 =3D 2^36 groups.=
 =20
> Perhaps it could be interesting to have less groups ?

Agree...
=20
> With less groups, we load less group descriptors in memory, we have =20
> less I/O to read bitmap and inode array (because we manage less group=
 =20
> descriptors again, because we load bigger bitmap and array in one tim=
e)

Presumably, we would still need to access the same amount data but
latencies should be reduce since we could do larger IO's and less seeks
to read the bitmaps.  I also wonder if there are benefits in terms of
locality to having the bitmaps closer to its blocks vs having them far
away like in xMETA_BG.

> Regards,
> Laurent

-JRS
