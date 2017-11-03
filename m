From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsck: Fix access after free for dx_db structure
Date: Fri, 3 Nov 2017 14:00:10 -0600
Message-ID: <6E06EFEE-D043-4E81-9D2D-FA44EDE73D73@dilger.ca>
References: <20171030133214.24279-1-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_01240141-8D4A-455F-A7E6-9AC50A37C570";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:49367 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbdKCUAQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Nov 2017 16:00:16 -0400
Received: by mail-io0-f172.google.com with SMTP id n137so8722720iod.6
        for <linux-ext4@vger.kernel.org>; Fri, 03 Nov 2017 13:00:16 -0700 (PDT)
In-Reply-To: <20171030133214.24279-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_01240141-8D4A-455F-A7E6-9AC50A37C570
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Oct 30, 2017, at 7:32 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> dx_db structure is freed after fixing of PR_2_HTREE_BAD_ROOT
> problem. Next code block use this structure to unerstand if leaf
> is beeng processed.
>=20
> If dx_db is freed, then root block is being processed and if_leaf
> need to be set to 0.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> e2fsck/pass2.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 09c16179..7bda37a7 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -1109,7 +1109,7 @@ inline_read_fail:
> 			    ((fs->blocksize - (8 + dx_csum_size)) /
> 			     sizeof(struct ext2_dx_entry))))
> 			dx_db->type =3D DX_DIRBLOCK_NODE;
> -		is_leaf =3D (dx_db->type =3D=3D DX_DIRBLOCK_LEAF);
> +		is_leaf =3D dx_db ? (dx_db->type =3D=3D =
DX_DIRBLOCK_LEAF) : 0;

Ah, this code is a bit confusing.  =46rom looking at this patch, and =
even
looking at the code directly, I thought "the previous line is also
accessing dx_db, so what is the problem?"  However, there really IS a
problem, because the previous line is part of a different if/else block.

It would be good to add braces around the "else" part of the condition
to make it clear that this is a separate block of code, which is why we
typically ask for matching braces for both legs of an if/else block.  It
would also be good to set "dx_db =3D NULL" instead of setting it to "0".

Cheers, Andreas






--Apple-Mail=_01240141-8D4A-455F-A7E6-9AC50A37C570
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ/MrLpIg59Q01vtYRArUSAJ4vY5cyROT5PN6p0SOwF1UhNKXUEQCffhTT
eZXtntzsYeUcdc+pPWp1gc4=
=6uxl
-----END PGP SIGNATURE-----

--Apple-Mail=_01240141-8D4A-455F-A7E6-9AC50A37C570--
