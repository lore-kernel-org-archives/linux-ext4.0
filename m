From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 4/7] debugfs: 64bit inode support
Date: Mon, 20 Nov 2017 13:22:49 -0700
Message-ID: <4C5A042E-350C-4C9A-A2EE-80B571ACD7C1@dilger.ca>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
 <20171114070440.79510-5-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_6E3EC6BB-BC3A-4D9A-832C-CF31E200D101";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:44554 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbdKTUWy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Nov 2017 15:22:54 -0500
Received: by mail-io0-f194.google.com with SMTP id w127so17043693iow.11
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 12:22:53 -0800 (PST)
In-Reply-To: <20171114070440.79510-5-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6E3EC6BB-BC3A-4D9A-832C-CF31E200D101
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 14, 2017, at 12:04 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> New dirdata type EXT2_DIRENT_INODE is added.
>=20
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
> debugfs/ls.c         | 6 ++++--
> lib/ext2fs/ext2_fs.h | 1 +
> 2 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/debugfs/ls.c b/debugfs/ls.c
> index 5655933e..b67c0800 100644
> --- a/debugfs/ls.c
> +++ b/debugfs/ls.c
> @@ -64,11 +64,13 @@ static void list_dirdata(struct list_dir_struct =
*ls,
>=20
> 		dlen =3D data[0];
>=20
> -		if (dirdata_mask =3D=3D EXT2_DIRENT_LUFID) {
> +		if (dirdata_mask =3D=3D EXT2_DIRENT_INODE)
> +			fprintf(ls->f, "ino64:%04\n", *(__u32 *)(data + =
1));
> +		else if (dirdata_mask =3D=3D EXT2_DIRENT_LUFID) {

(style) add {} around first part of if/else if needed on any part.

Looks fine otherwise.  You could add my:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Cheers, Andreas






--Apple-Mail=_6E3EC6BB-BC3A-4D9A-832C-CF31E200D101
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaEzmZpIg59Q01vtYRAosGAJ9BKuU5yX7JvOnazMAE6chpvwfgmACggWF4
6pSJxJX9ufhDt61fRJYaXdI=
=G5ow
-----END PGP SIGNATURE-----

--Apple-Mail=_6E3EC6BB-BC3A-4D9A-832C-CF31E200D101--
