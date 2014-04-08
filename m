From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] libext2fs: fix build errors on bigendian hosts
Date: Tue, 8 Apr 2014 19:36:25 +0800
Message-ID: <20140408113625.GB23533@gmail.com>
References: <1395915444-2225-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38248 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaDHLaU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Apr 2014 07:30:20 -0400
Received: by mail-pb0-f52.google.com with SMTP id rr13so891394pbb.25
        for <linux-ext4@vger.kernel.org>; Tue, 08 Apr 2014 04:30:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1395915444-2225-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 27, 2014 at 06:17:24PM +0800, Eryu Guan wrote:
> Fix the following build errors on bigendian hosts.
>=20
> - ctx is a pointer, use '->' not '.'
> - add missing argument to ext2fs_dirent_swab_in2
>=20
> make[2]: Entering directory `/root/e2fsprogs/lib/ext2fs'
>         CC inline_data.c
> inline_data.c: In function =E2=80=98ext2fs_inline_data_dir_iterate=E2=
=80=99:
> inline_data.c:221:5: error: request for member =E2=80=98errcode=E2=80=
=99 in something not a structure or union
>   ctx.errcode =3D ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, 0=
);
>      ^
> inline_data.c:222:9: error: request for member =E2=80=98errcode=E2=80=
=99 in something not a structure or union
>   if (ctx.errcode) {
>          ^
> inline_data.c: In function =E2=80=98ext2fs_inline_data_dir_expand=E2=80=
=99:
> inline_data.c:364:2: error: too few arguments to function =E2=80=98ex=
t2fs_dirent_swab_in2=E2=80=99
>   retval =3D ext2fs_dirent_swab_in2(fs, buf, size);
>   ^
> In file included from inline_data.c:19:0:
> ext2fs.h:1569:18: note: declared here
>  extern errcode_t ext2fs_dirent_swab_in2(ext2_filsys fs, char *buf, s=
ize_t size,
>                   ^
> make[2]: *** [inline_data.o] Error 1
>=20
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Sorry for the late reply, and thanks for fixing this.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  lib/ext2fs/inline_data.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 7be0f96..7a81da0 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -218,8 +218,8 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs=
, ext2_ino_t ino,
>  	ctx->buf =3D data.ea_data;
>  	ctx->buflen =3D data.ea_size;
>  #ifdef WORDS_BIGENDIAN
> -	ctx.errcode =3D ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, 0=
);
> -	if (ctx.errcode) {
> +	ctx->errcode =3D ext2fs_dirent_swab_in2(fs, ctx->buf, ctx->buflen, =
0);
> +	if (ctx->errcode) {
>  		ret |=3D BLOCK_ABORT;
>  		goto out;
>  	}
> @@ -361,7 +361,7 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext=
2_ino_t ino,
>  		return retval;
> =20
>  #ifdef WORDS_BIGENDIAN
> -	retval =3D ext2fs_dirent_swab_in2(fs, buf, size);
> +	retval =3D ext2fs_dirent_swab_in2(fs, buf, size, 0);
>  	if (retval)
>  		goto errout;
>  #endif
> --=20
> 1.9.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
