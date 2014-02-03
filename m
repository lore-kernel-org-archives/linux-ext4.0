From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 3/3] e2fsck: read-ahead metadata during pass1 and pass2
Date: Mon, 3 Feb 2014 14:20:01 -0700
Message-ID: <E0EB42E0-44E6-4061-B381-812577C71489@dilger.ca>
References: <20140201103721.9011.5971.stgit@birch.djwong.org> <20140201103741.9011.90207.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_247FA641-CEBB-4BAB-81F8-CD51A8C0F4C9"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44247 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaBCVUF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Feb 2014 16:20:05 -0500
Received: by mail-pd0-f180.google.com with SMTP id x10so7324254pdj.25
        for <linux-ext4@vger.kernel.org>; Mon, 03 Feb 2014 13:20:04 -0800 (PST)
In-Reply-To: <20140201103741.9011.90207.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_247FA641-CEBB-4BAB-81F8-CD51A8C0F4C9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 1, 2014, at 3:37 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 7554f4e..590e1bd 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -574,6 +577,20 @@ static errcode_t =
recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
> 	return 0;
> }
>=20
> +static void *pass1_readahead(void *p)
> +{
> +	errcode_t err;
> +	e2fsck_t ctx =3D (e2fsck_t)p;
> +
> +	printf("%s: START READAHEAD\n", __func__);
> +	err =3D ext2fs_readahead(ctx->fs, EXT2FS_READ_BBITMAP |
> +			       EXT2FS_READ_IBITMAP | EXT2FS_READ_ITABLE,
> +			       0, ctx->fs->group_desc_count);

This is basically launching readahead for the whole filesystem in one
shot.  That might be OK for small filesystems or running a single large
filesystem on a big machine, but could cause memory pressure and cache
eviction for many/large filesystems.

Have you done any tests to see what a limited readahead would do for
performance (say 8-16 groups ahead)?

Also, the bitmaps are not needed until pass 5, but would benefit from
being prefetched along with the inode table for non-flex_bg filesystems.
Probably there is little to no benefit to prefetching them in pass1 for
flex_bg filesystems.

Cheers, Andreas

> +	printf("%s: READAHEAD=3D%d\n", __func__, (int)err);
> +
> +	return NULL;
> +}
> +
> void e2fsck_pass1(e2fsck_t ctx)
> {
> 	int	i;
> @@ -600,6 +617,15 @@ void e2fsck_pass1(e2fsck_t ctx)
> 	init_resource_track(&rtrack, ctx->fs->io);
> 	clear_problem_context(&pctx);
>=20
> +	if (getenv("READAHEAD")) {
> +#ifdef HAVE_PTHREAD_H
> +		pthread_t tid;
> +		pthread_create(&tid, NULL, pass1_readahead, ctx);
> +#else
> +		pass1_readahead(ctx);
> +#endif
> +	}
> +
> 	if (!(ctx->options & E2F_OPT_PREEN))
> 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
>=20
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 5a2745a..bd7323f 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> @@ -44,6 +44,9 @@
> #define _GNU_SOURCE 1 /* get strnlen() */
> #include "config.h"
> #include <string.h>
> +#ifdef HAVE_PTHREAD_H
> +#include <pthread.h>
> +#endif
>=20
> #include "e2fsck.h"
> #include "problem.h"
> @@ -79,6 +82,29 @@ struct check_dir_struct {
> 	e2fsck_t ctx;
> };
>=20
> +struct pass2_readahead_data {
> +	ext2_filsys fs;
> +	ext2_dblist dblist;
> +};
> +
> +static int readahead_dir_block(ext2_filsys fs, struct ext2_db_entry2 =
*db,
> +			       void *priv_data)
> +{
> +	db->blockcnt =3D 1;
> +}
> +
> +static void *pass2_readahead(void *p)
> +{
> +	errcode_t err;
> +	struct pass2_readahead_data *pr =3D p;
> +
> +	printf("%s: START READAHEAD\n", __func__);
> +	err =3D ext2fs_readahead_dblist(pr->fs, pr->dblist);
> +	ext2fs_free_dblist(pr->dblist);
> +	ext2fs_free_mem(&pr);
> +	printf("%s: END READAHEAD %d\n", __func__, (int)err);
> +}
> +
> void e2fsck_pass2(e2fsck_t ctx)
> {
> 	struct ext2_super_block *sb =3D ctx->fs->super;
> @@ -146,6 +172,41 @@ void e2fsck_pass2(e2fsck_t ctx)
> 	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX)
> 		ext2fs_dblist_sort2(fs->dblist, special_dir_block_cmp);
>=20
> +	if (getenv("READAHEAD")) {
> +#ifdef HAVE_PTHREAD_H
> +		pthread_t tid;
> +#endif
> +		struct pass2_readahead_data *pr;
> +		errcode_t err;
> +
> +		err =3D ext2fs_get_mem(sizeof(*pr), &pr);
> +		if (err)
> +			goto no_readahead;
> +		pr->fs =3D fs;
> +		err =3D ext2fs_copy_dblist(fs->dblist, &pr->dblist);
> +		if (err) {
> +			ext2fs_free_mem(&pr);
> +			goto no_readahead;
> +		}
> +		err =3D ext2fs_dblist_iterate2(pr->dblist, =
readahead_dir_block,
> +					     NULL);
> +		if (err) {
> +			ext2fs_free_dblist(pr->dblist);
> +			ext2fs_free_mem(&pr);
> +			goto no_readahead;
> +		}
> +#ifdef HAVE_PTHREAD_H
> +		err =3D pthread_create(&tid, NULL, pass2_readahead, pr);
> +#else
> +		pass2_readahead(pr);
> +#endif
> +		if (err) {
> +			ext2fs_free_dblist(pr->dblist);
> +			ext2fs_free_mem(&pr);
> +		}
> +	}
> +
> +no_readahead:
> 	cd.pctx.errcode =3D ext2fs_dblist_iterate2(fs->dblist, =
check_dir_block,
> 						 &cd);
> 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & =
E2F_FLAG_RESTART)
> diff --git a/lib/config.h.in b/lib/config.h.in
> index 35ece01..1dd33b4 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -206,6 +206,9 @@
> /* Define if your <locale.h> file defines LC_MESSAGES. */
> #undef HAVE_LC_MESSAGES
>=20
> +/* Define to 1 if you have the `pthread' library (-lpthread). */
> +#undef HAVE_LIBPTHREAD
> +
> /* Define to 1 if you have the <limits.h> header file. */
> #undef HAVE_LIMITS_H
>=20
> @@ -314,6 +317,9 @@
> /* Define to 1 if you have the `prctl' function. */
> #undef HAVE_PRCTL
>=20
> +/* Define to 1 if you have the <pthread.h> header file. */
> +#undef HAVE_PTHREAD_H
> +
> /* Define to 1 if you have the `putenv' function. */
> #undef HAVE_PUTENV
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_247FA641-CEBB-4BAB-81F8-CD51A8C0F4C9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUvAIAXKl2rkXzB/gAQIZDBAAiM+t2lTbZs08IaDCN+D/sWNpAnuxmUyn
Znn2JyAJguq569YcKaoLcYdvIbrLYjogBvU5slbH6ir6a0J2iKE5rKwx2jOsPvVh
M5pr3MPVGGCHIPU8z32vQ4x38u33pd1fftCbAv6Q2hfUr1bEsNAm6J9mvVvzVtie
q/XGHtXYJw5eBiTZJqaPKyANRs5wedpMk5Z2fIw09l8RV+XfqGy6okQp7ZP2uhfL
imN9qCcNgh+l2dOJTs5P9sUq0JmT1d2zOvx+tf+Sky5A+MgpA+nDRbN9AU7SOdAZ
s1AGjNo9lqV5nTUnUZuJXT8eOF5QFZLIqNOViIf4nEa/V5x1apgEN2gvV7IRYB2V
KufKiJLfciYQS8hlgLyxIRfvHBnItA30tmR2RwURYfju09JCgV4m69Q3/swh6eAS
UfTL2cHQdEciUlIcawRuN7HA8JUvcsX9GhTtkJ2eOp5Mimf660BsJZddDmXTj1RA
enkiLnoHDh26UO69sMGfUVJazTi3IgIpXyPA+RfnW0l8kxj2U8I0oGZ2CsOqklfY
pM9CYq0mJ+0NMvQzKqiRJwHDBBWrLFDngLS+eKxH5jOnzTpqfV24AYYbgoJWloo3
NTSOFKginR2/XP0RezxVVemsXy5zWekSVXwGwei/W0HzEHQYmyUW2AvSzXYuQYeL
Pkzq5fYlJ5E=
=XHTP
-----END PGP SIGNATURE-----

--Apple-Mail=_247FA641-CEBB-4BAB-81F8-CD51A8C0F4C9--
