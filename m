From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Compile warning fix when enable EXT_DEBUG
Date: Wed, 12 Aug 2009 10:47:43 -0500
Message-ID: <4A82E41F.2050702@redhat.com>
References: <1250091147.18329.10.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45497 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbZHLPrt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2009 11:47:49 -0400
In-Reply-To: <1250091147.18329.10.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming wrote:
> When enable EXT_DEBUG I got the following compile warning on PPC64
>=20
>   CC [M]  fs/ext4/inode.o
>   CC [M]  fs/ext4/extents.o
> fs/ext4/extents.c: In function =E2=80=98ext4_ext_rm_leaf=E2=80=99:
> fs/ext4/extents.c:2097: warning: format =E2=80=98%lu=E2=80=99 expects=
 type =E2=80=98long unsigned int=E2=80=99, but argument 2 has type =E2=80=
=98ext4_lblk_t=E2=80=99
> fs/ext4/extents.c: In function =E2=80=98ext4_ext_get_blocks=E2=80=99:
> fs/ext4/extents.c:2789: warning: format =E2=80=98%u=E2=80=99 expects =
type =E2=80=98unsigned int=E2=80=99, but argument 4 has type =E2=80=98l=
ong unsigned int=E2=80=99
> fs/ext4/extents.c:2852: warning: format =E2=80=98%lu=E2=80=99 expects=
 type =E2=80=98long unsigned int=E2=80=99, but argument 3 has type =E2=80=
=98ext4_lblk_t=E2=80=99
> fs/ext4/extents.c:2953: warning: format =E2=80=98%lu=E2=80=99 expects=
 type =E2=80=98long unsigned int=E2=80=99, but argument 4 has type =E2=80=
=98unsigned int=E2=80=99
>   CC [M]  fs/ext4/migrate.o
>=20
> The patch fixed compile warning.

and a little bit more ... :)

> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
>=20
> Index: linux-2.6.31-rc4/fs/ext4/extents.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31-rc4.orig/fs/ext4/extents.c
> +++ linux-2.6.31-rc4/fs/ext4/extents.c
> @@ -2105,7 +2105,8 @@ ext4_ext_rm_leaf(handle_t *handle, struc
>  		else
>  			uninitialized =3D 0;
> =20
> -		ext_debug("remove ext %lu:%u\n", ex_ee_block, ex_ee_len);
> +		ext_debug("remove ext %u:[%d]%d\n", ex_ee_block,
> +			 ext4_ext_is_uninitialized(ex), ex_ee_len);
>  		path[depth].p_ext =3D ex;

Shouldn't part of this be in your next patch, [PATCH]Show unwritten
extent flag in ext4_ext_show_leaf() ?

Thanks,
-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
