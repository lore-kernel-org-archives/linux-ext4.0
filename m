From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Automatic fsck behavior
Date: Wed, 16 Jul 2014 21:41:12 -0600
Message-ID: <2C9CD996-D4E0-44EE-9907-0986A02D2296@dilger.ca>
References: <loom.20140717T043842-31@post.gmane.org> <53C73F91.8040301@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_01D71643-558C-4486-BADD-FF2B1DC5C8D9"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Daniel <dnlfrm@immunepc.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:65419 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaGQDlK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2014 23:41:10 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so2302527pdj.8
        for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2014 20:41:10 -0700 (PDT)
In-Reply-To: <53C73F91.8040301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_01D71643-558C-4486-BADD-FF2B1DC5C8D9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jul 16, 2014, at 9:14 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 7/16/14, 9:55 PM, Daniel wrote:
>> Hi,
>>=20
>> Had some questions about automatic boot-time fsck, following a =
power-loss or
>> hard-shutdown, etc.
>> All prior research (web searching, etc) on this has been =
inconclusive.
>>=20
>> 1) Does it do a real fsck or only a journal playback?
>=20
> By default, e2fsck at boot time only replays the journal if
> needed.

To elaborate a bit further - e2fsck will always do a sanity check of
the superblock when it is opening the filesystem to replay the journal.

> A full fsck at boot time is generally only done if:
>=20
> *) The filesystem was marked with an error prior to the fsck due
>   to a runtime metadata error

or if the error was stored in the journal, even if it couldn't be
written to the superblock.

Cheers, Andreas

> *) Mount-count or time-based thresholds have been reached
>   (newer mke2fs doesn't set these threshold by default)
>=20
>> 2) If it's a real fsck, is it done in repair mode or diagnostic mode?
>=20
> Depends on how initscripts invoke it, but most likely
> it is in preen ("repair the easy stuff") mode.
>=20
>> Also, do the answers depend/vary according to ext4 version or =
anything else?
>=20
> yep, see above, w.r.t. initscript behavior, older/newer mke2fs,
> e2fsck.conf, mke2fs.conf, etc ;)
>=20
> -Eric
>=20
>=20
>> Thank you
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_01D71643-558C-4486-BADD-FF2B1DC5C8D9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU8dF2HKl2rkXzB/gAQJ0PA//aiBf/hUyLA0Nxf6EcYm+t1aLr7dmr/Gw
Mn5MsyxWtg3/mR0/y3OmFqgqbGGMaFI2tBj5gdONYiNaUMzx8DioiR4n4Yle6Dfd
mnYXOjPrX0eMdgz1G6fNtkETnjW0CqrAw4HyxpshjeoIMXnQU1zmVA0Hcb/tDCOE
7i2Ycto6WAwoyhp//D4fLW8suvf6WGKHpp/8A42FGwQb02Rj6y48OvWiJ68TUr0X
zEOHPszV4oQw1BLX6DxHOMQQKaDltIyNQHe0/v020NQGsXe64dDwDqZf3RcRkHTG
KuU4mvvBU2RVlVBMvz2e9tE5feKzFkoizNPjth+HPLKVI1coj8Vuvf78cD49ps5c
MHoaQLRmjRELIq0cJ9ajt4QfEwKbm29OwrVSrnlguLC7yh/rNZfNYMv56RdNsyRd
MwWbN6rRTmjQetDR+KEEXp3Gd/4JyTDRHYbrnjYIlvnIE5ZNegGopo/C5ShkzIcu
9XG9jvBEB6lxB0gjW0yajp0gWFtG21+c5Wd15ROZO4E7m/ki2woUJg7mFFCW19dy
fWml6YC8Burhf323Z5VvBK7P5IPNJuF3B6elg1J0FanU/lI13GDBUAYgYYI7A82M
6bI22dul6f911n3OvFRIyNC7xlPMlWq612k0SA0foO2qNajYsR1o7RFIc5HzlNSj
mnw9TmO+8IA=
=rbx6
-----END PGP SIGNATURE-----

--Apple-Mail=_01D71643-558C-4486-BADD-FF2B1DC5C8D9--
