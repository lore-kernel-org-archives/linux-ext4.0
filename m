From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] e2fsck: Fix access after free for dx_db structure
Date: Sun, 5 Nov 2017 22:49:55 -0700
Message-ID: <E7D16B41-815E-4A97-9FF0-02BA3B46C892@dilger.ca>
References: <20171104172218.79017-1-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_CAC0C020-BCA7-43C6-BFF2-66884C6CD64E";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:53311 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdKFFuQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Nov 2017 00:50:16 -0500
Received: by mail-it0-f49.google.com with SMTP id n195so3772956itg.2
        for <linux-ext4@vger.kernel.org>; Sun, 05 Nov 2017 21:50:16 -0800 (PST)
In-Reply-To: <20171104172218.79017-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_CAC0C020-BCA7-43C6-BFF2-66884C6CD64E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 4, 2017, at 11:22 AM, Artem Blagodarenko =
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

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> e2fsck/pass2.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 09c16179..1b0504c8 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -1095,7 +1095,7 @@ inline_read_fail:
> 			    fix_problem(ctx, PR_2_HTREE_BAD_ROOT, =
&cd->pctx)) {
> 				clear_htree(ctx, ino);
> 				dx_dir->numblocks =3D 0;
> -				dx_db =3D 0;
> +				dx_db =3D NULL;
> 			}
> 			dx_dir->hashversion =3D root->hash_version;
> 			if ((dx_dir->hashversion <=3D EXT2_HASH_TEA) &&
> @@ -1107,9 +1107,10 @@ inline_read_fail:
> 			   (ext2fs_dirent_name_len(dirent) =3D=3D 0) &&
> 			   (ext2fs_le16_to_cpu(limit->limit) =3D=3D
> 			    ((fs->blocksize - (8 + dx_csum_size)) /
> -			     sizeof(struct ext2_dx_entry))))
> +			     sizeof(struct ext2_dx_entry)))) {
> 			dx_db->type =3D DX_DIRBLOCK_NODE;
> -		is_leaf =3D (dx_db->type =3D=3D DX_DIRBLOCK_LEAF);
> +		}
> +		is_leaf =3D dx_db ? (dx_db->type =3D=3D =
DX_DIRBLOCK_LEAF) : 0;
> 	}
> out_htree:
>=20
> --
> 2.13.5 (Apple Git-94)
>=20


Cheers, Andreas






--Apple-Mail=_CAC0C020-BCA7-43C6-BFF2-66884C6CD64E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZ//gKpIg59Q01vtYRAtudAJ0dp8AIcRotnP2jDTewFWvJ4RPqjQCePb9/
3OrD9EjLbtr+2W2+Er97nCs=
=GtoL
-----END PGP SIGNATURE-----

--Apple-Mail=_CAC0C020-BCA7-43C6-BFF2-66884C6CD64E--
