From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: storing a value larger than UINT_MAX
Date: Mon, 27 Feb 2017 14:16:05 -0700
Message-ID: <0DECD40F-A8E0-4D26-9CD6-EC720A823206@dilger.ca>
References: <b7e4d5b8-cf1c-96df-a488-57660c36b7dd@cacholong.nl>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_57EA2F27-87F2-4550-B5D0-51B49C27D09B";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?Q?Matthijs_M=C3=B6hlmann?= <matthijs@cacholong.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34695 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdB1Cbx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2017 21:31:53 -0500
Received: by mail-it0-f66.google.com with SMTP id r141so172103ita.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2017 18:31:53 -0800 (PST)
In-Reply-To: <b7e4d5b8-cf1c-96df-a488-57660c36b7dd@cacholong.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_57EA2F27-87F2-4550-B5D0-51B49C27D09B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Feb 24, 2017, at 3:38 AM, Matthijs M=C3=B6hlmann =
<matthijs@cacholong.nl> wrote:
>=20
> Hello ext4 developers,
>=20
> I am trying to run a kernel with grsecurity with the size overflow
> protection and am getting the following warnings / errors:
>=20
> dmesg: http://pastebin.com/wr3UGLS9
> config: http://pastebin.com/sr8M9bP0
> mballoc.* (make fs/ext4/mballoc.o EXTRA_CFLAGS=3D"-fdump-tree-all
> -fdump-ipa-all") http://filebin.ca/3DMIChVw9lQM/mballoc.tgz
>=20
> According to the grsecurity developers it seems to be a bug in ext4:
> https://forums.grsecurity.net/viewtopic.php?f=3D1&t=3D4678&p=3D16971

        pa->pa_pstart =3D ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
        pa->pa_lstart =3D pa->pa_pstart;

pa_pstart is 64-bit, pa_lstart is 32-bit.  It isn't clear why pa_lstart =
isn't:

	pa->pa_lstart =3D ac->ac_b_ex.fe_logical;

as elsewhere in the code, but this _may_ be because the group prealloc =
is
for allocating multiple small files in the same group, so pa_lstart may =
not
make any sense as a per-file logical offset.

Cheers, Andreas

> The response from ephox (PAX team / grsecurity developer):
> --
> Thanks for the report. I think this is an upstream bug. Based on the
> runtime values provided by you, ext4_mb_new_group_pa() tries to store =
a
> value into pa->pa_lstart which larger than UINT_MAX which comes from
> ext4_group_first_block_no().
> Could you please report it to the ext4 developers?
> --
>=20
> I'll try to answer all the questions but I'm not an expert in this =
area.
>=20
> I am also not subscribed to this mailinglist so please keep me in the =
CC.
>=20
> Regards,
>=20
> Matthijs M=C3=B6hlmann
>=20


Cheers, Andreas






--Apple-Mail=_57EA2F27-87F2-4550-B5D0-51B49C27D09B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYtJcVpIg59Q01vtYRAgQxAKCJt/6ZQMePAntc7+0M3z8lzyBiKwCfY4vF
DjYyhqPmbTDv6QpxOTsVCuI=
=VwDy
-----END PGP SIGNATURE-----

--Apple-Mail=_57EA2F27-87F2-4550-B5D0-51B49C27D09B--
