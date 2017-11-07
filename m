From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH v2 2/2] ext4: Add 64-bit inode number support
Date: Tue, 7 Nov 2017 16:37:51 -0700
Message-ID: <4E14A891-9196-47E9-A0BA-7E495A73C4BD@dilger.ca>
References: <20171101212455.47964-1-artem.blagodarenko@gmail.com>
 <20171101212455.47964-3-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_05C446A5-D09A-4BAC-BB50-12851E77D15F";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Artem Blagodarenko <artem.blagodarenko@google.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:44227 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753348AbdKGXh4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Nov 2017 18:37:56 -0500
Received: by mail-io0-f196.google.com with SMTP id m16so4039661iod.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Nov 2017 15:37:55 -0800 (PST)
In-Reply-To: <20171101212455.47964-3-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_05C446A5-D09A-4BAC-BB50-12851E77D15F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 1, 2017, at 3:24 PM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Use dirdata to store high bits of 64bit inode
> number.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@google.com>
> ---
> fs/ext2/super.c  |  6 ++---
>=20
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 1458706bd2ec..f6437f559d0a 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1232,7 +1232,7 @@ void ext2_sync_super(struct super_block *sb, =
struct ext2_super_block *es,
> 	ext2_clear_super_error(sb);
> 	spin_lock(&EXT2_SB(sb)->s_lock);
> 	es->s_free_blocks_count =3D =
cpu_to_le32(ext2_count_free_blocks(sb));
> -	es->s_free_inodes_count =3D =
cpu_to_le32(ext2_count_free_inodes(sb));
> +	ext4_set_free_inodes_count(es, ext4_get_free_inodes_count(sb));
> 	es->s_wtime =3D cpu_to_le32(get_seconds());
> 	/* unlock before we do IO */
> 	spin_unlock(&EXT2_SB(sb)->s_lock);
> @@ -1459,9 +1459,9 @@ static int ext2_statfs (struct dentry * dentry, =
struct kstatfs * buf)
> 	buf->f_bavail =3D buf->f_bfree - =
le32_to_cpu(es->s_r_blocks_count);
> 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
> 		buf->f_bavail =3D 0;
> -	buf->f_files =3D le32_to_cpu(es->s_inodes_count);
> +	buf->f_files =3D ext4_get_inodes_count(sb);
> 	buf->f_ffree =3D ext2_count_free_inodes(sb);
> -	es->s_free_inodes_count =3D cpu_to_le32(buf->f_ffree);
> +	ext4_set_free_inodes_count(sb, buf->f_ffree);
> 	buf->f_namelen =3D EXT2_NAME_LEN;
> 	fsid =3D le64_to_cpup((void *)es->s_uuid) ^
> 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));

I just noticed here that this is changing ext2 instead of ext4.
This part of the patch should be dropped.

Cheers, Andreas





--Apple-Mail=_05C446A5-D09A-4BAC-BB50-12851E77D15F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaAkPPpIg59Q01vtYRAmwgAJ4yHdBh6KwRwX/8MUVCr8pXZ8js1wCfW3tm
QCisTUNuhxs17Jb+lD5xTW0=
=TzbK
-----END PGP SIGNATURE-----

--Apple-Mail=_05C446A5-D09A-4BAC-BB50-12851E77D15F--
