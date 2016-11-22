From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: JBD2: Spotted dirty metadata buffer....
Date: Mon, 21 Nov 2016 17:49:36 -0700
Message-ID: <FB4C6A4A-2A9F-4AE2-9CA2-E2C1F881A651@dilger.ca>
References: <1744886.OgPgGFoXj7@stwm.de>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C5C63D01-413B-4B29-8036-C59A341D5188"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Wolfgang Walter <linux@stwm.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35200 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbcKVAtn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2016 19:49:43 -0500
Received: by mail-it0-f51.google.com with SMTP id c20so5361295itb.0
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2016 16:49:42 -0800 (PST)
In-Reply-To: <1744886.OgPgGFoXj7@stwm.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C5C63D01-413B-4B29-8036-C59A341D5188
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Nov 21, 2016, at 8:28 AM, Wolfgang Walter <linux@stwm.de> wrote:
>=20
> Hello,
>=20
> I'm testing EXT4 with an external journal (data=3Djournal). When =
writing I rather often get
>=20
> 	JBD2: Spotted dirty metadata buffer (dev =3D dm-22, blocknr =3D =
1008028301). There's a risk of filesystem corruption in case of system =
crash.

Can you please determine what file this block belongs to and/or what =
kind
of metadata block it is.  You can check "dumpe2fs /dev/dm-22" to list =
all
of the metadata blocks, and if it isn't listed as filesystem metadata, =
you
can run "debugfs -c -R 'icheck 1008028301' /dev/dm-22" to find which =
file
this block belongs to, then "debugfs -c -R 'ncheck <inum>' /dev/dm-22" =
after
you have the inode number.

> No other message is logged. If I unmount the filesystem an do an =
forced fsck, all seems fine.

This is likely a bug in the code, marking a block dirty without setting
up the journaling for it correctly.  A few bugs like this were fixed a
while ago by Eric, but those fixes should be in 4.8.8.

> The filesystem as it's journal are on a LV (which is again backed by =
DRBD). The journal, too.
>=20
> I'm using stable kernel 4.8.8.
>=20
> I created the journal with:
>=20
> 	mkfs.ext4 -O journal_dev -v -b 4096  -L jdyn /dev/export/jdyn
>=20
> I created the filesystem with:
>=20
> 	mkfs.ext4 -J device=3DUUID=3D625d871f-c278-4acb-916d-774dc78dbd8a =
-v -b 4096 -E =
stride=3D$((512/4)),stripe_width=3D$((512/4*3)),lazy_itable_init=3D0,nodis=
card -O inline_data,mmp -L dyn /dev/export/dyn

It may be that inline_data is the culprit, since this is a relatively =
new
feature that isn't widely used yet.

Cheers, Andreas

> I tested it also with data=3Dwriteback. I didn't see these errors =
then.
>=20
> Regards,
> --
> Wolfgang Walter
> Studentenwerk M=FCnchen
> Anstalt des =F6ffentlichen Rechts
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_C5C63D01-413B-4B29-8036-C59A341D5188
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDOWIXKl2rkXzB/gAQj39w/+LJyhyUcJCtMhmxNAE0m8dZ+NnfKgUDuC
cxyOnlU1WvkNx+B647NJYektpz7y/fFv8K+jSpG7D3/8ULmYWvMaL9CpxB8TI5Ne
pCEWSkBKfzqJyzhRF78rpNHWeCjKG9Tt9AINempdDqXBHbViBuSKtvvK3R+fx+lk
AppMt1l/blb5jsLCD7gR1TxLU4B3WFOBV2sYMYJKwkx6Q93WRWtia+x7m0EKNSdd
cy9alYeFW4F5vwm8/p/MwyPnmXGtNLYyilLxjd7bxeMVVuWqB1htX+pAubT6VBDI
HRp14zMwmAyA6Dt/FK9IEoVvazxs0kTQLJnng7hqbbzued30QO81Ic4HRiL2DccJ
RvjYtJCVIGU2hTbjMgN2fTbh3me7ZYs2AK/ZQFIQeJRwnX9jZyMIxZfut511CfdA
eaql5LTI7oPlVAFDwBaQhEW8dwg2ogL4CXYSytMLp5/KGIKLCXki5UBHCFb1UggR
7TjT837wjHibBlMaUZ3qjOYSXio/jd1GyQkTArN498rgwHXK7c4BzhDpTkdxyb2c
5hTnPG2fz61TegPHKiPGyRxa+ghdK8ASwsUrauz6T3Tx+3vTqnLS9Gu88DIJ77kn
o5sZms0JIhAAObOJZuHy2gLZ2v1v5FlvmywaNW0Xj6dQktlfPxBo3mDH1uzGXTA4
h/NeUGEQ8mg=
=1kK2
-----END PGP SIGNATURE-----

--Apple-Mail=_C5C63D01-413B-4B29-8036-C59A341D5188--
