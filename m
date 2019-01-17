Return-Path: <SRS0=xLGb=PZ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38603 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfAQRj6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2019 12:39:58 -0500
Received: by mail-pg1-f196.google.com with SMTP id g189so4742485pgc.5
        for <linux-ext4@vger.kernel.org>; Thu, 17 Jan 2019 09:39:57 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <AA89ABC5-E584-4E1B-A446-FA358FAB16F5@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3CEE76E5-543F-4C96-AD6E-683E09880B53";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 2/2] ext4: annotate implicit fall throughs
Date: Thu, 17 Jan 2019 10:40:16 -0700
In-Reply-To: <20190114203945.20233-2-malat@debian.org>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Mathieu Malaterre <malat@debian.org>
References: <20190114203945.20233-1-malat@debian.org>
 <20190114203945.20233-2-malat@debian.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3CEE76E5-543F-4C96-AD6E-683E09880B53
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Jan 14, 2019, at 1:39 PM, Mathieu Malaterre <malat@debian.org> =
wrote:
>=20
> There is a plan to build the kernel with -Wimplicit-fallthrough and
> these places in the code produced warnings (W=3D1). Fix them up.
>=20
> This commit remove the following warnings:
>=20
>  fs/ext4/indirect.c:1182:6: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>  fs/ext4/indirect.c:1188:6: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>  fs/ext4/indirect.c:1432:6: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>  fs/ext4/indirect.c:1440:6: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
>=20
> Signed-off-by: Mathieu Malaterre <malat@debian.org>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/indirect.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>=20
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index bf7fa1507e81..c2225f0d31b5 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -1183,18 +1183,21 @@ void ext4_ind_truncate(handle_t *handle, =
struct inode *inode)
> 			ext4_free_branches(handle, inode, NULL, &nr, =
&nr+1, 1);
> 			i_data[EXT4_IND_BLOCK] =3D 0;
> 		}
> +		/* fall through */
> 	case EXT4_IND_BLOCK:
> 		nr =3D i_data[EXT4_DIND_BLOCK];
> 		if (nr) {
> 			ext4_free_branches(handle, inode, NULL, &nr, =
&nr+1, 2);
> 			i_data[EXT4_DIND_BLOCK] =3D 0;
> 		}
> +		/* fall through */
> 	case EXT4_DIND_BLOCK:
> 		nr =3D i_data[EXT4_TIND_BLOCK];
> 		if (nr) {
> 			ext4_free_branches(handle, inode, NULL, &nr, =
&nr+1, 3);
> 			i_data[EXT4_TIND_BLOCK] =3D 0;
> 		}
> +		/* fall through */
> 	case EXT4_TIND_BLOCK:
> 		;
> 	}
> @@ -1433,6 +1436,7 @@ int ext4_ind_remove_space(handle_t *handle, =
struct inode *inode,
> 			ext4_free_branches(handle, inode, NULL, &nr, =
&nr+1, 1);
> 			i_data[EXT4_IND_BLOCK] =3D 0;
> 		}
> +		/* fall through */
> 	case EXT4_IND_BLOCK:
> 		if (++n >=3D n2)
> 			return 0;
> @@ -1441,6 +1445,7 @@ int ext4_ind_remove_space(handle_t *handle, =
struct inode *inode,
> 			ext4_free_branches(handle, inode, NULL, &nr, =
&nr+1, 2);
> 			i_data[EXT4_DIND_BLOCK] =3D 0;
> 		}
> +		/* fall through */
> 	case EXT4_DIND_BLOCK:
> 		if (++n >=3D n2)
> 			return 0;
> @@ -1449,6 +1454,7 @@ int ext4_ind_remove_space(handle_t *handle, =
struct inode *inode,
> 			ext4_free_branches(handle, inode, NULL, &nr, =
&nr+1, 3);
> 			i_data[EXT4_TIND_BLOCK] =3D 0;
> 		}
> +		/* fall through */
> 	case EXT4_TIND_BLOCK:
> 		;
> 	}
> --
> 2.19.2
>=20


Cheers, Andreas






--Apple-Mail=_3CEE76E5-543F-4C96-AD6E-683E09880B53
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlxAvgEACgkQcqXauRfM
H+BP9A/8DbKt+WfBFRnHtNjx9+PBz8yHUWwBEUhYKNgsjK5cJwFFl94UTyQRvptJ
vbzf34zg/Sig0aOs3atB6abBHPHAeklnpcSGnTUNZFN2FqvKgu4yqdkTRHHm0l6t
Wb4o+RGm1kTiOh85Ap4ubhof2476lhgBH2wxsSZ4CzKr5BdJfaC60ODPHIW37yx0
Ey0YdQ+HhR2ciepCkfAamayd7H2YRdF0aGELD9wzhIwzD2rXNk7ye7wZ1U24EBnm
iXSq8UG/EZafaXey6bHbc8PR98watqp2SOOXPn0Uaz2co8wLEbwaTkUtgGzqweyz
b8eS3fmQEaeK+a3DdVIlZgWt0dllWjohRXiXVoMpYPehVPPxbnQ8bMNfH0u17tn+
KkEK7iJVaXcFpganNXk8wvyYs6ZIjeJDpWGH6UpLGlrcrKXP2w8xWMkzoElAPbog
kHVr2qQ+R1Nw0pCmoVd8Y2emeqv+WLhI9WQD2P9mWjxZqPcFamcgET/Z+rKS0e9l
u7KR4HLu+jjVc38Rzyqh5suYmYRjMWBK6xOOpF4ZNXIHFDzM2O4b7aWwOdCtnpz5
k/QPbZnf5eSTBlvuO6VkIhlSKOTP8gQYNyIEfcLQiM6xPVgGkkWGtWHQLFkxpRGj
R0eTfYxfshT/RPZY/K88X12EXPPfa19VC1yX3g8M1TRbkE+wdTQ=
=5WcX
-----END PGP SIGNATURE-----

--Apple-Mail=_3CEE76E5-543F-4C96-AD6E-683E09880B53--
