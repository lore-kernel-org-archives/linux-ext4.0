From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 17/74] debugfs: don't leak mmp_s memory
Date: Thu, 12 Dec 2013 15:33:12 -0700
Message-ID: <7848C189-25A5-43FA-9F55-12299217E3A6@dilger.ca>
References: <20131211011813.30655.39624.stgit@birch.djwong.org> <20131211012014.30655.58647.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: multipart/signed; boundary="Apple-Mail=_11F70E16-4401-44CC-A270-760EBF1AC0EF"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63998 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3LLWdT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Dec 2013 17:33:19 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so1327882pbb.3
        for <linux-ext4@vger.kernel.org>; Thu, 12 Dec 2013 14:33:18 -0800 (PST)
In-Reply-To: <20131211012014.30655.58647.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_11F70E16-4401-44CC-A270-760EBF1AC0EF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 10, 2013, at 6:20 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> ext2fs_free_mem() takes a pointer to a pointer, similar to
> ext2fs_get_mem().  Improve the documentation, and fix debugfs.
>=20
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 64e498f..0624350 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1608,7 +1608,7 @@ _INLINE_ void ext2fs_init_csum_seed(ext2_filsys =
fs)
> #ifndef EXT2_CUSTOM_MEMORY_ROUTINES
> #include <string.h>
> /*
> - *  Allocate memory
> + *  Allocate memory.  The 'ptr' arg must point to a pointer.
>  */
> _INLINE_ errcode_t ext2fs_get_mem(unsigned long size, void *ptr)
> {

Would that imply the second argument in all of these functions is "void =
**ptr"?
Does GCC handle that correctly?  Do other compilers?  Am I just =
clueless?

Cheers, Andreas

> @@ -1655,7 +1655,7 @@ _INLINE_ errcode_t ext2fs_get_arrayzero(unsigned =
long count,
> }
>=20
> /*
> - * Free memory
> + * Free memory.  The 'ptr' arg must point to a pointer.
>  */
> _INLINE_ errcode_t ext2fs_free_mem(void *ptr)
> {
> @@ -1669,7 +1669,7 @@ _INLINE_ errcode_t ext2fs_free_mem(void *ptr)
> }
>=20
> /*
> - *  Resize memory
> + *  Resize memory.  The 'ptr' arg must point to a pointer.
>  */
> _INLINE_ errcode_t ext2fs_resize_mem(unsigned long =
EXT2FS_ATTR((unused)) old_size,
> 				     unsigned long size, void *ptr)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_11F70E16-4401-44CC-A270-760EBF1AC0EF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUqo5qXKl2rkXzB/gAQK5QRAAuMEzZSTeyVwtaJdhn7aKFdGLk3DPg1vh
GXWKMN3tHC0knFlXLBK8ZFw4hd0tg77uq10epRkUsgJPgZ0/7WmYO0AGCfV04ATu
XDJF0HQYqD9V5mK6EXUIdrV87snlF3mbi2AOW+oDU2t1+XMYTr+wjV9iu+28/FnK
gXXiQuN2sHAh/wuQzWysCTlJkNzMgIvWUnkAtogFW1PBk/T9jCBi7rszL367gYEd
vYowb4YKdXD0nxJpRKSE3+MXDh+1gLy3k6igPE3q07m9fM5eg3vHdmU9Nb0VBMke
KFJSfcoDbvmsSgWpeuFvA+jDMdsPvK77e1ieh70CIyHA5TLS8WtgkcMd/SJm6zjg
GnPmgl/ISoBLDox6L/lTGta3lP+v4PidUkSTLKVaW8zeO+bjpKSjjRZy+dESk1sh
ODuLVDpkJu4yvKmWVTgX9Aw6YmXIlXvD43sxMsgc9QBITLVINVIFHzZ79BW7ysdn
BnyAu68qjZXOzNpLHQPyK6KqLbvt1MuaPBctm4uLT1ZOG0ZL0G9dUrmMeW+NIbGV
O9oW2jxl+a/MPyeSPResmi9wTV/K3pIiZ9tuae6Be1XeBg0QB2OGkMA0bT+wyT8D
2ycJ7XRKtiww/GJ8Jt4CR3DPnybVgcsjzgJuAjTbY/tAlY6WFvkNb42Ahh8Q+wgb
+2VVEYMyafk=
=SOBR
-----END PGP SIGNATURE-----

--Apple-Mail=_11F70E16-4401-44CC-A270-760EBF1AC0EF--
