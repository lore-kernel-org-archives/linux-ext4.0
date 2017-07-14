From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: correct comment references to ext4_ext_direct_IO()
Date: Fri, 14 Jul 2017 14:18:00 -0700
Message-ID: <8BDF79B6-C881-40F6-9D2B-E8480F0035D2@dilger.ca>
References: <20170714210426.GB12793@localhost.localdomain>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8B17840C-CFC4-4DFD-95EA-C5778344D6C1";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36446 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdGNVSF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jul 2017 17:18:05 -0400
Received: by mail-io0-f194.google.com with SMTP id h134so3244116iof.3
        for <linux-ext4@vger.kernel.org>; Fri, 14 Jul 2017 14:18:05 -0700 (PDT)
In-Reply-To: <20170714210426.GB12793@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8B17840C-CFC4-4DFD-95EA-C5778344D6C1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 14, 2017, at 2:04 PM, Eric Whitney <enwlinux@gmail.com> wrote:
>=20
> Commit 914f82a32d0268847 "ext4: refactor direct IO code" deleted
> ext4_ext_direct_IO(), but references to that function remain in
> comments.  Update them to refer to ext4_direct_IO_write().
>=20
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/inode.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3c600f0..2e6c022 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -892,7 +892,7 @@ static int =
ext4_dio_get_block_unwritten_async(struct inode *inode,
> /*
>  * Get block function for non-AIO DIO writes when we create unwritten =
extent if
>  * blocks are not allocated yet. The extent will be converted to =
written
> - * after IO is complete from ext4_ext_direct_IO() function.
> + * after IO is complete by ext4_direct_IO_write().
>  */
> static int ext4_dio_get_block_unwritten_sync(struct inode *inode,
> 		sector_t iblock, struct buffer_head *bh_result,	int =
create)
> @@ -907,7 +907,7 @@ static int =
ext4_dio_get_block_unwritten_sync(struct inode *inode,
>=20
> 	/*
> 	 * Mark inode as having pending DIO writes to unwritten extents.
> -	 * ext4_ext_direct_IO() checks this flag and converts extents to
> +	 * ext4_direct_IO_write() checks this flag and converts extents =
to
> 	 * written.
> 	 */
> 	if (!ret && buffer_unwritten(bh_result))
> --
> 2.1.4
>=20


Cheers, Andreas






--Apple-Mail=_8B17840C-CFC4-4DFD-95EA-C5778344D6C1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZaTUJpIg59Q01vtYRAt81AKC9tcgdajDZEBBD951MwEWeNLUfnQCg4oYS
qmQA96p/4RcDCnownj1jom4=
=W7+v
-----END PGP SIGNATURE-----

--Apple-Mail=_8B17840C-CFC4-4DFD-95EA-C5778344D6C1--
