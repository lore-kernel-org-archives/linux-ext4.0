From: =?ISO-8859-1?Q?Jos=E9?= Bollo <jobol@nonadev.net>
Subject: Re: [PATCH 1/2] ext4: use XATTR_*_PREFIX_LEN instead sizeof(...)
Date: Wed, 06 Jan 2016 10:14:58 +0100
Message-ID: <1452071698.3035.0.camel@nonadev.net>
References: <1451850998-28639-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1a.lautre.net ([80.67.160.71]:35244 "EHLO mx1a.lautre.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbcAFJU6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jan 2016 04:20:58 -0500
In-Reply-To: <1451850998-28639-1-git-send-email-toralf.foerster@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I prefer the use of sizeof that can't be faked even by error but why no=
t

Le dimanche 03 janvier 2016 =C3=A0 20:56 +0100, Toralf F=C3=B6rster a =C3=
=A9crit :
> use the definition in include/uapi/linux/xattr.h
>=20
> Signed-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
> ---
>  fs/ext4/xattr_security.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
> index 36f4c1a..1a3d629 100644
> --- a/fs/ext4/xattr_security.c
> +++ b/fs/ext4/xattr_security.c
> @@ -16,7 +16,7 @@ ext4_xattr_security_list(const struct xattr_handler=
 *handler,
>  			 struct dentry *dentry, char *list, size_t list_size,
>  			 const char *name, size_t name_len)
>  {
> -	const size_t prefix_len =3D sizeof(XATTR_SECURITY_PREFIX)-1;
> +	const size_t prefix_len =3D XATTR_SECURITY_PREFIX_LEN;
>  	const size_t total_len =3D prefix_len + name_len + 1;
> =20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
