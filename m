From: Dmitry Monakhov <dmonlist@gmail.com>
Subject: Re: [PATCH] ext4: refuse O_DIRECT opens for mode where DIO doesn't work
Date: Mon, 25 Apr 2016 12:35:02 +0300
Message-ID: <877ffmhvzt.fsf@openvz.org>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34377 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbcDYJfK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2016 05:35:10 -0400
Received: by mail-lf0-f66.google.com with SMTP id m101so2596078lfi.1
        for <linux-ext4@vger.kernel.org>; Mon, 25 Apr 2016 02:35:09 -0700 (PDT)
In-Reply-To: <1461472078-20104-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> Certain ext4 modes (encryption, data=3Djournal, inline data) cause
> Direct I/O to be a no-op.  Instead of making DIO fail silently, make
> the open with the O_DIRECT flag fail with EINVAL.
>
> This will avoid surprises to application programs, and also signal to
> xfstests not to try O_DIRECT tests for file system modes where it
> doesn't work (and could result in test failures).
>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/ext4/file.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index fa2208b..4113676 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -372,7 +372,12 @@ static int ext4_file_open(struct inode * inode, stru=
ct file * filp)
>  			return -EACCES;
>  		if (ext4_encryption_info(inode) =3D=3D NULL)
>  			return -ENOKEY;
> +		if (filp->f_flags & O_DIRECT)
> +			return -EINVAL;
>  	}
> +	if ((ext4_should_journal_data(inode) || ext4_has_inline_data(inode)) &&
> +	    (filp->f_flags & O_DIRECT))
Hmm...
__ext4_new_inode set EXT4_STATE_MAY_INLINE_DATA for each inode if
ext4_has_feature_inline_data(sb) is true.
So this may result in complain from user who want inline data
optimization for small files, but also want O_DIRECT to works.
IMHO it is reasonable to convert inline inodes to regular ones if user
open it for WRITE with O_DIRECT
> +		return -EINVAL;
>=20=20
>  	dir =3D dget_parent(file_dentry(filp));
>  	if (ext4_encrypted_inode(d_inode(dir)) &&
> --=20
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJXHeTGAAoJELhyPTmIL6kBsxsH/0KqaoRe5aYxgpzQy3t4aV93
i6g1BCo4HYKiGkJSyApRjkyzWqopEp0aW5Z6JcysYKH/2KgoWmJK4qzifSWC/F6P
ihmt1xBbsBO7Swtey5VBvtnSYDdBdXfl5I9P7AuCnkUxZ/KI1sAuFv9XcOqjrheH
GoUa7GV0+owgP1REzw3YGEnbG586Tj3H4m3g+WMJCIjGWFR56+KIHt1IcUTlxaH0
07D4euCricaBI9Y8aFTOFBW535g6MR4aU00yB45kt7b4bt8ox83UIsbaBYbDCYw9
0p8z2sR84mpsIyqNCW4LzOvGNatGyy180ZfvQ1ClUWKcVcJHjAI9V/HteaeVL8A=
=Vcre
-----END PGP SIGNATURE-----
--=-=-=--
