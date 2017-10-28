From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 1/8] e2fsck Fix access after free for dx_db structure
Date: Sat, 28 Oct 2017 00:05:30 -0600
Message-ID: <C4A81921-AC45-4E77-A0D9-16241A2AD14E@dilger.ca>
References: <20171027172254.14137-1-artem.blagodarenko@gmail.com>
 <20171027172254.14137-2-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_E81FAEF0-86CD-48DA-8C03-8B7471E2999A";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:46262 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdJ1GFf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Oct 2017 02:05:35 -0400
Received: by mail-io0-f177.google.com with SMTP id 101so16966731ioj.3
        for <linux-ext4@vger.kernel.org>; Fri, 27 Oct 2017 23:05:35 -0700 (PDT)
In-Reply-To: <20171027172254.14137-2-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E81FAEF0-86CD-48DA-8C03-8B7471E2999A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 27, 2017, at 11:22 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> dx_db structure is freed after fixing of PR_2_HTREE_BAD_ROOT
> problem. Next code block use this structure to unerstand if leaf
> is beeng processed.
>=20
> if dx_db is freed then root block is beendg processad and if_leaf
> need to be set to 0.

This looks like a generic bugfix and should probably be submitted
separately?

Cheers, Andreas

> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> e2fsck/pass2.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 09b79c3b..f3b49ec8 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -1109,7 +1109,7 @@ inline_read_fail:
> 			    ((fs->blocksize - (8 + dx_csum_size)) /
> 			     sizeof(struct ext2_dx_entry))))
> 			dx_db->type =3D DX_DIRBLOCK_NODE;
> -		is_leaf =3D (dx_db->type =3D=3D DX_DIRBLOCK_LEAF);
> +		is_leaf =3D dx_db ? (dx_db->type =3D=3D =
DX_DIRBLOCK_LEAF) : 0;
> 	}
> out_htree:
>=20
> --
> 2.13.5 (Apple Git-94)
>=20







--Apple-Mail=_E81FAEF0-86CD-48DA-8C03-8B7471E2999A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ9B4qpIg59Q01vtYRAvpoAJ0WzSpnr+h7ZFGojcVImrrv487gewCfVTB/
5F5/c2QgH5qH+uWx0q0K6n4=
=Q/ib
-----END PGP SIGNATURE-----

--Apple-Mail=_E81FAEF0-86CD-48DA-8C03-8B7471E2999A--
