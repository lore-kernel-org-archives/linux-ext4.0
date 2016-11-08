From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] EXT4: fixes for recovery mode.
Date: Tue, 8 Nov 2016 08:19:02 -0700
Message-ID: <825E11CF-3FEC-4605-A284-B5C20592A807@dilger.ca>
References: <CAKc4wqfUK+FCo7UgDT3TwSwAjCZq_3gvgst83L479=s2NSHXzg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_5F8233D5-A726-4F40-983C-B9E4D3BB00FF"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Lokesh Jaliminche <lokesh.jaliminche@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35468 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbcKHPTY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Nov 2016 10:19:24 -0500
Received: by mail-it0-f68.google.com with SMTP id b123so11790732itb.2
        for <linux-ext4@vger.kernel.org>; Tue, 08 Nov 2016 07:19:08 -0800 (PST)
In-Reply-To: <CAKc4wqfUK+FCo7UgDT3TwSwAjCZq_3gvgst83L479=s2NSHXzg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5F8233D5-A726-4F40-983C-B9E4D3BB00FF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 8, 2016, at 2:36 AM, Lokesh Jaliminche =
<lokesh.jaliminche@seagate.com> wrote:
>=20
> commit 3fd23caad436c961339ea3866a910354a83849d2
> Author: Lokesh Nagappa Jaliminche <lokesh.jaliminche@seagate.com>
> Date:   Tue Nov 8 14:27:48 2016 +0530
>=20
>     ext4: fixes for recovery mode.
>=20
>     After kernel crash when ext4 runs in recovery mode,
>     with read-only disk, it may loose part of allocation
>     updates and fail while mounting fs due to group
>     descriptor checks before journal replay. So group
>     descriptor check is moved after journal replay.
>=20
>     Signed-off-by: Alexey Lyashkov <alexey_lyashkov@xyratex.com>
>     Signed-off-by: Lokesh Nagappa Jaliminche =
<lokesh.jaliminche@seagate.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 20da99d..3922487 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3820,11 +3820,6 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>                         goto failed_mount2;
>                 }
>         }
> -       if (!ext4_check_descriptors(sb, logical_sb_block, =
&first_not_zeroed)) {
> -               ext4_msg(sb, KERN_ERR, "group descriptors =
corrupted!");
> -               ret =3D -EFSCORRUPTED;
> -               goto failed_mount2;
> -       }
>=20
>         sbi->s_gdb_count =3D db_count;
>         get_random_bytes(&sbi->s_next_generation, sizeof(u32));
> @@ -3957,6 +3952,12 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
>         sbi->s_journal->j_commit_callback =3D =
ext4_journal_commit_callback;
>=20
>  no_journal:
> +
> +       if (!ext4_check_descriptors(sb, logical_sb_block, =
&first_not_zeroed)) {
> +               ext4_msg(sb, KERN_ERR, "group descriptors =
corrupted!");
> +               ret =3D -EFSCORRUPTED;
> +               goto failed_mount2;
> +       }
>         sbi->s_mb_cache =3D ext4_xattr_create_cache();
>         if (!sbi->s_mb_cache) {
>                 ext4_msg(sb, KERN_ERR, "Failed to create an =
mb_cache");


Cheers, Andreas






--Apple-Mail=_5F8233D5-A726-4F40-983C-B9E4D3BB00FF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWCHs6HKl2rkXzB/gAQgi9Q/+Ks0LfoC/cNkbh0KhShhl/ZbaFHmuYv5Y
HkjwpjT6KRo0TR3ltdhqCk2Mn9VjdKIjWnbd5UONV3XlGmF0WKohxZZ9J9fl+T66
dvzLJkI3K7PgVHDWTdV3PbJHEMnfFig1YYZ+DIIreECqf7CxYhN/dK2rg/TIg0RF
rL7gVQvpbTcsUp+plsGxhCZ2WAXd4e9CIubErOmW1PyxXj13+uVHBB9MFTKare3p
WT8X4VZ/V482GbEg9hWGRwuHQvK+naP9BWEnObK6ab34RkmS9XNUTsK65shrG/Qm
ZfkKPWcbEKBp8bQVxPlM8HpN6qTAXbLn5QULAZCjvjoMXECc5OKHhtRnlFbOaaKc
tgXbvUCE5Mv+wPTWTaVB0LS7qSoGeZqqtcNJUol5Jwxcmg+hUhxjMc3n3MgQCy6X
nAIwsKVC1AsAQvbvxrABvdv9bycnkTmKnJsqfxPnIXTwgaBV61rBG8WgEfQo0Qsy
mNzfj1Vt8ibRFlH/ruV0xNzxluYmOVz0brzJJI1/fsM5Q1PlpyG1g2KR/mT9eD/w
3GyBHixd3UhIzyimwMkYei3390tHZFGWcmzf1C/IcFOlBewH6wrFBSQ7FfgG6Xta
XFgCgYHxTOHUnBOpShAXoh1UQBQBs6732HxSNL/nebcVer/J6QUunq8N34xrLaM2
qYvrzgsMVpE=
=cZ0S
-----END PGP SIGNATURE-----

--Apple-Mail=_5F8233D5-A726-4F40-983C-B9E4D3BB00FF--
