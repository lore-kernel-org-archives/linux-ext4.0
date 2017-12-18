From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [QUESTION] Getting block bitmap
Date: Mon, 18 Dec 2017 15:48:27 -0700
Message-ID: <A4596CEA-D8B5-440B-A3D9-90BC9DD7B26A@dilger.ca>
References: <CAExFE6=Oj27M-6x++VGC6DNhao539CtjiPjmGgfk6LDRRVzufA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_57AD9490-DF7A-4221-B8A5-EF919DAA066E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Sayan Ghosh <sgdgp.2014@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:44755 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936213AbdLRWsi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Dec 2017 17:48:38 -0500
Received: by mail-io0-f181.google.com with SMTP id w127so11545236iow.11
        for <linux-ext4@vger.kernel.org>; Mon, 18 Dec 2017 14:48:38 -0800 (PST)
In-Reply-To: <CAExFE6=Oj27M-6x++VGC6DNhao539CtjiPjmGgfk6LDRRVzufA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_57AD9490-DF7A-4221-B8A5-EF919DAA066E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 18, 2017, at 10:43 AM, Sayan Ghosh <sgdgp.2014@gmail.com> wrote:
>=20
> Hello,
>=20
>     bh =3D ext4_read_block_bitmap(sb,block_group);
>=20
> This function return the buffer head for the block/page with the block =
bitmap
>=20
>     char *block_bmap =3D bh->b_data;
>=20
> Doing this does not give the block bitmap string
>=20
> What is the process to get the block bitmap in string or array form?

What do you mean "block bitmap string"?

It probably makes sense for you to look at how bh->b_data is being used =
in
the places where ext4_read_block_bitmap() is being called.

Cheers, Andreas






--Apple-Mail=_57AD9490-DF7A-4221-B8A5-EF919DAA066E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaOEW9pIg59Q01vtYRAs2fAJ48wmHddRUyOPZbgLdzrr2QlxUTfwCgzNgs
AbVixDkH01xnFtdhEj+XvBg=
=tfsZ
-----END PGP SIGNATURE-----

--Apple-Mail=_57AD9490-DF7A-4221-B8A5-EF919DAA066E--
