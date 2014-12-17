From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents traversial
Date: Wed, 17 Dec 2014 18:06:27 +0300
Message-ID: <87y4q6joy4.fsf@openvz.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org> <1417518054-21733-4-git-send-email-dmonakhov@openvz.org> <20141211200540.GE31008@thunk.org> <878uidgshe.fsf@openvz.org> <20141217035713.GW17575@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39895 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaLQPHI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2014 10:07:08 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so20541705wgg.39
        for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2014 07:07:06 -0800 (PST)
In-Reply-To: <20141217035713.GW17575@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Dec 12, 2014 at 11:52:29AM +0300, Dmitry Monakhov wrote:
>> Oh. Indeed That is my mistake.
>>=20
>> ret =3D ext4_fiemap(inode, &fie, offset, maxsize - offset);
>> /* No extents found, EOF */
>> if (!fie.fi_extents_mapped) {
>>      ret =3D -ENXIO;
>>      break;
>>   }=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20
>> Delalloc case handled incorrectly. Will fix that ASAP.
>
> Hi Dmitry, how are things going with a fix?  It would be great if I
> can get something which I can test and push to Linus before he
> releases -rc1.
I'm working on that. Sorry for delay. Delay is caused by confusion of
existing seek_xxx implementation (even w/o my changes)
For example: it is not obvious to believe that if bh is (bh_unwritten |
bh_uptodate) then it contains valid data. IMHO it is just a fallocated
area.  I already have simple fix for actual regression. But I try to
review,optimize and retest all related logic.

FYI: Currently test failed only on EXT4 w/o extents but w/ -odelalloc enabl=
ed.
This configuration is absent in xfstest-bld where conf/ext3 is EXT4 w/o
extents and w/ nodelalloc. That is why we oversee this from very beginning.=
=20
>
> Thanks!!
>
> 					- Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUkZvzAAoJELhyPTmIL6kBmfQH/0HG3t6QHreb7SYJgTM1tap2
95x9WucreZ8DNL4fGAcyov9+wZuowS5TUz/g/ThoyM7nRa9UJ+/pwn8S3Sa9v9kg
EXBXRh0+sinbyIzywEBKK4IM5rsv/QWhI4uh8feZ29Pkw0+rQMOgHV1UspaOnB+F
GK32TCoe/zk8D0VMRj3vfk950Z2EORJIYB+bVCuyU3NewS7sLF0bh8jdb/v0nOKw
ANNMMUMWbFco5oP6v42cuzq4tBNnXq0Ah3zQN0rqHC5BXSH0kSJe32FeTrLp76L6
QF9MpCDvet+8/sqMsOlRER0TMFMsubG/d/dLV0yXN011R8flBgb0yS5aTn6Jhsw=
=EqP8
-----END PGP SIGNATURE-----
--=-=-=--
