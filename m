From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3] e2fsprogs: clean up codes for adding new quota type
Date: Thu, 23 Jan 2014 14:35:37 -0700
Message-ID: <69C4EE3D-D63E-4E4C-9189-D003B3B23B47@dilger.ca>
References: <CAPTn0cBMDht60MBKmiuuLFsitXti-JzoehALfmMqwSL9+42z4g@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_7311105A-821E-43EE-9550-379DD0BDCB2E"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <sihara@ddn.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37224 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaAWVfp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jan 2014 16:35:45 -0500
Received: by mail-pa0-f42.google.com with SMTP id kl14so2410641pab.1
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jan 2014 13:35:45 -0800 (PST)
In-Reply-To: <CAPTn0cBMDht60MBKmiuuLFsitXti-JzoehALfmMqwSL9+42z4g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_7311105A-821E-43EE-9550-379DD0BDCB2E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jan 22, 2014, at 5:20 AM, Li Xi <pkuelelixi@gmail.com> wrote:
> Changelog:
> * V3:
>  - Add check of MAXQUOTAS <=3D 32
>  - Change iterator from "i"/"type" to "qtype".
>  - Add assertion of qtype range in quota_type2* funtions
>  - Rename quota_type2ino to quota_type2inum
>  - Change get_qid()
>  - Replace quota_type2offset() with quota_sb_inump()

The patch content itself looks good, but it might make sense to split
the "qtype" parameter changes into a first patch, and then the rest
of the original patch into a second patch so that it is easier to
see what is going on.

I'm not sure how Ted feels about adding quota_type_t typedef (that is
against kernel coding style).  If he doesn't like it, then it would
also be possible to use:

enum quota_type {
        USRQUOTA =3D 0,
        GRPQUOTA =3D 1,
}

and then "enum quota_type" as the function arguments.

In either case, you can add:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

going forward.

Cheers, Andreas

> * V2:
>  - Change type2* functions to quota_type2*
>  - Use uncontinuous array of s_quota_inum
>  - Add quota_type_t
>  - Fix a problem of quota_write_inode() in the first patch
>  - Rename USRQUOTA_BIT/GRPQUOTA_BIT/ALLQUOTA_BIT to QUOTA_*_BIT
>  - Code style change
>=20
> Signed-off-by: Li Xi <lixi <at> ddn.com>
> --
> Index: e2fsprogs.git/lib/e2p/ls.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/e2p/ls.c
> +++ e2fsprogs.git/lib/e2p/ls.c
> @@ -23,6 +23,7 @@
> #include <time.h>
>=20
> #include "e2p.h"
> +#include "quota/quotaio.h"
>=20
> static void print_user (unsigned short uid, FILE *f)
> {
> @@ -206,11 +207,27 @@ static const char *checksum_type(__u8 ty
>     }
> }
>=20
> +static const char const *quota_prefix[MAXQUOTAS] =3D {
> +        [USRQUOTA] =3D "User quota inode:",
> +        [GRPQUOTA] =3D "Group quota inode:",
> +};
> +
> +/**
> + * Convert type of quota to written representation
> + */
> +const char *quota_type2prefix(quota_type_t qtype)
> +{
> +    assert(qtype >=3D 0);
> +    assert(qtype < MAXQUOTAS);
> +    return quota_prefix[qtype];
> +}
> +
> void list_super2(struct ext2_super_block * sb, FILE *f)
> {
>     int inode_blocks_per_group;
>     char buf[80], *str;
>     time_t    tm;
> +    quota_type_t qtype;
>=20
>     inode_blocks_per_group =3D (((sb->s_inodes_per_group *
>                     EXT2_INODE_SIZE(sb)) +
> @@ -426,13 +443,12 @@ void list_super2(struct ext2_super_block
>         fprintf(f, "MMP update interval:      %u\n",
>             sb->s_mmp_update_interval);
>     }
> -    if (sb->s_usr_quota_inum)
> -        fprintf(f, "User quota inode:         %u\n",
> -            sb->s_usr_quota_inum);
> -    if (sb->s_grp_quota_inum)
> -        fprintf(f, "Group quota inode:        %u\n",
> -            sb->s_grp_quota_inum);
> -
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        if (*quota_sb_inump(sb, qtype) !=3D 0)
> +            fprintf(f, "%-26s%u\n",
> +                quota_type2prefix(qtype),
> +                *quota_sb_inump(sb, qtype));
> +    }
>     if (sb->s_feature_ro_compat & =
EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
>         fprintf(f, "Checksum type:            %s\n",
>             checksum_type(sb->s_checksum_type));
> Index: e2fsprogs.git/lib/ext2fs/ext2_fs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/ext2fs/ext2_fs.h
> +++ e2fsprogs.git/lib/ext2fs/ext2_fs.h
> @@ -666,8 +666,7 @@ struct ext2_super_block {
>     __u8    s_last_error_func[32];    /* function where the error =
happened */
> #define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, =
s_mount_opts)
>     __u8    s_mount_opts[64];
> -    __u32    s_usr_quota_inum;    /* inode number of user quota file =
*/
> -    __u32    s_grp_quota_inum;    /* inode number of group quota file =
*/
> +    __u32    s_quota_inum[2];    /* inode numbers of quota files */
>     __u32    s_overhead_blocks;    /* overhead blocks/clusters in fs =
*/
>     __u32   s_reserved[108];        /* Padding to the end of the block =
*/
>     __u32    s_checksum;        /* crc32c(superblock) */
> Index: e2fsprogs.git/lib/quota/mkquota.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/mkquota.c
> +++ e2fsprogs.git/lib/quota/mkquota.c
> @@ -51,7 +51,7 @@ static void print_inode(struct ext2_inod
>  * Returns 0 if not able to find the quota file, otherwise returns its
>  * inode number.
>  */
> -int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
> +int quota_file_exists(ext2_filsys fs, quota_type_t qtype, int fmt)
> {
>     char qf_name[256];
>     errcode_t ret;
> @@ -73,12 +73,11 @@ int quota_file_exists(ext2_filsys fs, in
> /*
>  * Set the value for reserved quota inode number field in superblock.
>  */
> -void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
> +void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, quota_type_t =
qtype)
> {
>     ext2_ino_t *inump;
>=20
> -    inump =3D (qtype =3D=3D USRQUOTA) ? &fs->super->s_usr_quota_inum =
:
> -        &fs->super->s_grp_quota_inum;
> +    inump =3D quota_sb_inump(fs->super, qtype);
>=20
>     log_debug("setting quota ino in superblock: ino=3D%u, type=3D%d", =
ino,
>          qtype);
> @@ -86,13 +85,12 @@ void quota_set_sb_inum(ext2_filsys fs, e
>     ext2fs_mark_super_dirty(fs);
> }
>=20
> -errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
> +errcode_t quota_remove_inode(ext2_filsys fs, quota_type_t qtype)
> {
>     ext2_ino_t qf_ino;
>=20
>     ext2fs_read_bitmaps(fs);
> -    qf_ino =3D (qtype =3D=3D USRQUOTA) ? fs->super->s_usr_quota_inum =
:
> -        fs->super->s_grp_quota_inum;
> +    qf_ino =3D *quota_sb_inump(fs->super, qtype);
>     quota_set_sb_inum(fs, 0, qtype);
>     /* Truncate the inode only if its a reserved one. */
>     if (qf_ino < EXT2_FIRST_INODE(fs->super))
> @@ -119,9 +117,10 @@ static void write_dquots(dict_t *dict, s
>     }
> }
>=20
> -errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
> +errcode_t quota_write_inode(quota_ctx_t qctx, unsigned int =
qtype_bits)
> {
> -    int        retval =3D 0, i;
> +    int        retval =3D 0;
> +    quota_type_t    qtype;
>     dict_t        *dict;
>     ext2_filsys    fs;
>     struct quota_handle *h =3D NULL;
> @@ -139,15 +138,15 @@ errcode_t quota_write_inode(quota_ctx_t
>=20
>     ext2fs_read_bitmaps(fs);
>=20
> -    for (i =3D 0; i < MAXQUOTAS; i++) {
> -        if ((qtype !=3D -1) && (i !=3D qtype))
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        if (((1 << qtype) & qtype_bits) =3D=3D 0)
>             continue;
>=20
> -        dict =3D qctx->quota_dict[i];
> +        dict =3D qctx->quota_dict[qtype];
>         if (!dict)
>             continue;
>=20
> -        retval =3D quota_file_create(h, fs, i, fmt);
> +        retval =3D quota_file_create(h, fs, qtype, fmt);
>         if (retval < 0) {
>             log_err("Cannot initialize io on quotafile");
>             continue;
> @@ -165,7 +164,7 @@ errcode_t quota_write_inode(quota_ctx_t
>         }
>=20
>         /* Set quota inode numbers in superblock. */
> -        quota_set_sb_inum(fs, h->qh_qf.ino, i);
> +        quota_set_sb_inum(fs, h->qh_qf.ino, qtype);
>         ext2fs_mark_super_dirty(fs);
>         ext2fs_mark_bb_dirty(fs);
>         fs->flags &=3D ~EXT2_FLAG_SUPER_ONLY;
> @@ -192,11 +191,20 @@ static int dict_uint_cmp(const void *a,
>     return c - d;
> }
>=20
> -static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
> +static inline qid_t get_qid(struct ext2_inode *inode, quota_type_t =
qtype)
> {
> -    if (qtype =3D=3D USRQUOTA)
> -        return inode_uid(*inode);
> -    return inode_gid(*inode);
> +    assert(qtype >=3D 0);
> +    assert(qtype < MAXQUOTAS);
> +    switch (qtype) {
> +        case USRQUOTA:
> +            return inode_uid(*inode);
> +        case GRPQUOTA:
> +            return inode_gid(*inode);
> +        default:
> +            return 0;
> +    }
> +
> +    return 0;
> }
>=20
> static void quota_dnode_free(dnode_t *node,
> @@ -211,9 +219,11 @@ static void quota_dnode_free(dnode_t *no
> /*
>  * Set up the quota tracking data structures.
>  */
> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int =
qtype)
> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
> +                 unsigned int qtype_bits)
> {
> -    int    i, err =3D 0;
> +    int        err =3D 0;
> +    quota_type_t    qtype;
>     dict_t    *dict;
>     quota_ctx_t ctx;
>=20
> @@ -224,8 +234,8 @@ errcode_t quota_init_context(quota_ctx_t
>     }
>=20
>     memset(ctx, 0, sizeof(struct quota_ctx));
> -    for (i =3D 0; i < MAXQUOTAS; i++) {
> -        if ((qtype !=3D -1) && (i !=3D qtype))
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        if (((1 << qtype) & qtype_bits) =3D=3D 0)
>             continue;
>         err =3D ext2fs_get_mem(sizeof(dict_t), &dict);
>         if (err) {
> @@ -233,7 +243,7 @@ errcode_t quota_init_context(quota_ctx_t
>             quota_release_context(&ctx);
>             return err;
>         }
> -        ctx->quota_dict[i] =3D dict;
> +        ctx->quota_dict[qtype] =3D dict;
>         dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
>         dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
>     }
> @@ -246,16 +256,16 @@ errcode_t quota_init_context(quota_ctx_t
> void quota_release_context(quota_ctx_t *qctx)
> {
>     dict_t    *dict;
> -    int    i;
> +    quota_type_t    qtype;
>     quota_ctx_t ctx;
>=20
>     if (!qctx)
>         return;
>=20
>     ctx =3D *qctx;
> -    for (i =3D 0; i < MAXQUOTAS; i++) {
> -        dict =3D ctx->quota_dict[i];
> -        ctx->quota_dict[i] =3D 0;
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        dict =3D ctx->quota_dict[qtype];
> +        ctx->quota_dict[qtype] =3D 0;
>         if (dict) {
>             dict_free_nodes(dict);
>             free(dict);
> @@ -294,7 +304,7 @@ void quota_data_add(quota_ctx_t qctx, st
> {
>     struct dquot    *dq;
>     dict_t        *dict;
> -    int        i;
> +    quota_type_t    qtype;
>=20
>     if (!qctx)
>         return;
> @@ -302,10 +312,10 @@ void quota_data_add(quota_ctx_t qctx, st
>     log_debug("ADD_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
>             inode_uid(*inode),
>             inode_gid(*inode), space);
> -    for (i =3D 0; i < MAXQUOTAS; i++) {
> -        dict =3D qctx->quota_dict[i];
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        dict =3D qctx->quota_dict[qtype];
>         if (dict) {
> -            dq =3D get_dq(dict, get_qid(inode, i));
> +            dq =3D get_dq(dict, get_qid(inode, qtype));
>             if (dq)
>                 dq->dq_dqb.dqb_curspace +=3D space;
>         }
> @@ -320,7 +330,7 @@ void quota_data_sub(quota_ctx_t qctx, st
> {
>     struct dquot    *dq;
>     dict_t        *dict;
> -    int        i;
> +    quota_type_t    qtype;
>=20
>     if (!qctx)
>         return;
> @@ -328,10 +338,10 @@ void quota_data_sub(quota_ctx_t qctx, st
>     log_debug("SUB_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
>             inode_uid(*inode),
>             inode_gid(*inode), space);
> -    for (i =3D 0; i < MAXQUOTAS; i++) {
> -        dict =3D qctx->quota_dict[i];
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        dict =3D qctx->quota_dict[qtype];
>         if (dict) {
> -            dq =3D get_dq(dict, get_qid(inode, i));
> +            dq =3D get_dq(dict, get_qid(inode, qtype));
>             dq->dq_dqb.dqb_curspace -=3D space;
>         }
>     }
> @@ -345,7 +355,7 @@ void quota_data_inodes(quota_ctx_t qctx,
> {
>     struct dquot    *dq;
>     dict_t        *dict;
> -    int        i;
> +    quota_type_t    qtype;
>=20
>     if (!qctx)
>         return;
> @@ -353,10 +363,10 @@ void quota_data_inodes(quota_ctx_t qctx,
>     log_debug("ADJ_INODE: Inode: %u, UID/GID: %u/%u, adjust: %d", ino,
>             inode_uid(*inode),
>             inode_gid(*inode), adjust);
> -    for (i =3D 0; i < MAXQUOTAS; i++) {
> -        dict =3D qctx->quota_dict[i];
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        dict =3D qctx->quota_dict[qtype];
>         if (dict) {
> -            dq =3D get_dq(dict, get_qid(inode, i));
> +            dq =3D get_dq(dict, get_qid(inode, qtype));
>             dq->dq_dqb.dqb_curinodes +=3D adjust;
>         }
>     }
> @@ -486,7 +496,8 @@ static errcode_t quota_write_all_dquots(
> /*
>  * Updates the in-memory quota limits from the given quota inode.
>  */
> -errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, =
int type)
> +errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
> +                  quota_type_t qtype)
> {
>     struct quota_handle *qh;
>     errcode_t err;
> @@ -500,7 +511,7 @@ errcode_t quota_update_limits(quota_ctx_
>         return err;
>     }
>=20
> -    err =3D quota_file_open(qh, qctx->fs, qf_ino, type, -1, 0);
> +    err =3D quota_file_open(qh, qctx->fs, qf_ino, qtype, -1, 0);
>     if (err) {
>         log_err("Open quota file failed");
>         goto out;
> @@ -525,7 +536,7 @@ out:
>  * on disk and updates the limits in qctx->quota_dict. =
'usage_inconsistent' is
>  * set to 1 if the supplied and on-disk quota usage values are not =
identical.
>  */
> -errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
> +errcode_t quota_compare_and_update(quota_ctx_t qctx, quota_type_t =
qtype,
>                    int *usage_inconsistent)
> {
>     ext2_filsys fs =3D qctx->fs;
> @@ -537,8 +548,7 @@ errcode_t quota_compare_and_update(quota
>     if (!qctx->quota_dict[qtype])
>         goto out;
>=20
> -    qf_ino =3D qtype =3D=3D USRQUOTA ? fs->super->s_usr_quota_inum :
> -                     fs->super->s_grp_quota_inum;
> +    qf_ino =3D *quota_sb_inump(fs->super, qtype);
>     err =3D quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
>     if (err) {
>         log_err("Open quota file failed");
> Index: e2fsprogs.git/e2fsck/pass1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/e2fsck/pass1.c
> +++ e2fsprogs.git/e2fsck/pass1.c
> @@ -574,6 +574,28 @@ static errcode_t recheck_bad_inode_check
>     return 0;
> }
>=20
> +static int quota_inum_is_super(struct ext2_super_block *sb, =
ext2_ino_t ino)
> +{
> +    quota_type_t qtype;
> +
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +        if (*quota_sb_inump(sb, qtype) =3D=3D ino)
> +            return 1;
> +
> +    return 0;
> +}
> +
> +static int quota_inum_is_reserved(ext2_ino_t ino)
> +{
> +    quota_type_t qtype;
> +
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +        if (quota_type2inum(qtype) =3D=3D ino)
> +            return 1;
> +
> +    return 0;
> +}
> +
> void e2fsck_pass1(e2fsck_t ctx)
> {
>     int    i;
> @@ -970,13 +992,11 @@ void e2fsck_pass1(e2fsck_t ctx)
>                 e2fsck_write_inode_full(ctx, ino, inode,
>                             inode_size, "pass1");
>             }
> -        } else if ((ino =3D=3D EXT4_USR_QUOTA_INO) ||
> -               (ino =3D=3D EXT4_GRP_QUOTA_INO)) {
> +        } else if (quota_inum_is_reserved(ino)) {
>             ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
>             if ((fs->super->s_feature_ro_compat &
>                     EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> -                ((fs->super->s_usr_quota_inum =3D=3D ino) ||
> -                 (fs->super->s_grp_quota_inum =3D=3D ino))) {
> +                quota_inum_is_super(fs->super, ino)) {
>                 if (!LINUX_S_ISREG(inode->i_mode) &&
>                     fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
>                             &pctx)) {
> Index: e2fsprogs.git/e2fsck/quota.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/e2fsck/quota.c
> +++ e2fsprogs.git/e2fsck/quota.c
> @@ -19,7 +19,7 @@
> #include "quota/quotaio.h"
>=20
> static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
> -                 ext2_ino_t to_ino, int qtype)
> +                 ext2_ino_t to_ino, quota_type_t qtype)
> {
>     struct ext2_inode    inode;
>     errcode_t        retval;
> @@ -63,6 +63,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
>     struct ext2_super_block *sb =3D ctx->fs->super;
>     struct problem_context    pctx;
>     ext2_filsys        fs =3D ctx->fs;
> +    quota_type_t qtype;
> +    ext2_ino_t quota_ino;
>=20
>     clear_problem_context(&pctx);
>=20
> @@ -70,22 +72,14 @@ void e2fsck_hide_quota(e2fsck_t ctx)
>         !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
>         return;
>=20
> -    pctx.ino =3D sb->s_usr_quota_inum;
> -    if (sb->s_usr_quota_inum &&
> -        (sb->s_usr_quota_inum !=3D EXT4_USR_QUOTA_INO) &&
> -        fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
> -        move_quota_inode(fs, sb->s_usr_quota_inum, =
EXT4_USR_QUOTA_INO,
> -                 USRQUOTA);
> -        sb->s_usr_quota_inum =3D EXT4_USR_QUOTA_INO;
> -    }
> -
> -    pctx.ino =3D sb->s_grp_quota_inum;
> -    if (sb->s_grp_quota_inum &&
> -        (sb->s_grp_quota_inum !=3D EXT4_GRP_QUOTA_INO) &&
> -        fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
> -        move_quota_inode(fs, sb->s_grp_quota_inum, =
EXT4_GRP_QUOTA_INO,
> -                 GRPQUOTA);
> -        sb->s_grp_quota_inum =3D EXT4_GRP_QUOTA_INO;
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +        pctx.ino =3D *quota_sb_inump(sb, qtype);
> +        quota_ino =3D quota_type2inum(qtype);
> +        if (pctx.ino && (pctx.ino !=3D quota_ino) &&
> +            fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
> +            move_quota_inode(fs, pctx.ino, quota_ino, qtype);
> +            *quota_sb_inump(sb, qtype) =3D quota_ino;
> +        }
>     }
>=20
>     return;
> Index: e2fsprogs.git/e2fsck/unix.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/e2fsck/unix.c
> +++ e2fsprogs.git/e2fsck/unix.c
> @@ -1180,7 +1180,8 @@ int main (int argc, char *argv[])
>     int old_bitmaps;
>     __u32 features[3];
>     char *cp;
> -    int qtype =3D -99;  /* quota type */
> +    unsigned int qtype_bits =3D 0;
> +    quota_type_t qtype;
>=20
>     clear_problem_context(&pctx);
>     sigcatcher_setup();
> @@ -1624,13 +1625,12 @@ print_unsupp_features:
>=20
>     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
>         /* Quotas were enabled. Do quota accounting during fsck. */
> -        if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
> -            (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
> -            qtype =3D -1;
> -        else
> -            qtype =3D sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
> +        for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +            if (*quota_sb_inump(sb, qtype) !=3D 0)
> +                qtype_bits |=3D 1 << qtype;
> +        }
>=20
> -        quota_init_context(&ctx->qctx, ctx->fs, qtype);
> +        quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
>     }
>=20
>     run_result =3D e2fsck_run(ctx);
> @@ -1667,17 +1667,17 @@ print_unsupp_features:
> no_journal:
>=20
>     if (ctx->qctx) {
> -        int i, needs_writeout;
> -        for (i =3D 0; i < MAXQUOTAS; i++) {
> -            if (qtype !=3D -1 && qtype !=3D i)
> +        int needs_writeout;
> +        for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +            if (((1 << qtype) & qtype_bits) =3D=3D 0)
>                 continue;
>             needs_writeout =3D 0;
> -            pctx.num =3D i;
> -            retval =3D quota_compare_and_update(ctx->qctx, i,
> +            pctx.num =3D qtype;
> +            retval =3D quota_compare_and_update(ctx->qctx, qtype,
>                               &needs_writeout);
>             if ((retval || needs_writeout) &&
>                 fix_problem(ctx, PR_6_UPDATE_QUOTAS, &pctx))
> -                quota_write_inode(ctx->qctx, i);
> +                quota_write_inode(ctx->qctx, 1 << qtype);
>         }
>         quota_release_context(&ctx->qctx);
>     }
> Index: e2fsprogs.git/lib/quota/mkquota.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/mkquota.h
> +++ e2fsprogs.git/lib/quota/mkquota.h
> @@ -10,14 +10,13 @@
>  * {
>  *    quota_ctx_t qctx;
>  *
> - *    quota_init_context(&qctx, fs, -1);
> + *    quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
>  *    {
>  *        quota_compute_usage(qctx, -1);
>  *        AND/OR
>  *        quota_data_add/quota_data_sub/quota_data_inodes();
>  *    }
> - *    quota_write_inode(qctx, USRQUOTA);
> - *    quota_write_inode(qctx, GRPQUOTA);
> + *    quota_write_inode(qctx, QUOTA_ALL_BIT);
>  *    quota_release_context(&qctx);
>  * }
>  *
> @@ -43,22 +42,24 @@ struct quota_ctx {
> };
>=20
> /* In mkquota.c */
> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int =
qtype);
> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
> +                 unsigned int qtype_bits);
> void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
> ext2_ino_t ino,
>         int adjust);
> void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, =
ext2_ino_t ino,
>         qsize_t space);
> void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, =
ext2_ino_t ino,
>         qsize_t space);
> -errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
> -errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, =
int type);
> +errcode_t quota_write_inode(quota_ctx_t qctx, unsigned int =
qtype_bits);
> +errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
> +                  quota_type_t qtype);
> errcode_t quota_compute_usage(quota_ctx_t qctx);
> void quota_release_context(quota_ctx_t *qctx);
>=20
> -errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
> -int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
> -void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
> -errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
> +errcode_t quota_remove_inode(ext2_filsys fs, quota_type_t qtype);
> +int quota_file_exists(ext2_filsys fs, quota_type_t qtype, int fmt);
> +void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, quota_type_t =
qtype);
> +errcode_t quota_compare_and_update(quota_ctx_t qctx, quota_type_t =
qtype,
>                    int *usage_inconsistent);
>=20
> #endif  /* __QUOTA_QUOTAIO_H__ */
> Index: e2fsprogs.git/lib/quota/quotaio.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/quotaio.c
> +++ e2fsprogs.git/lib/quota/quotaio.c
> @@ -15,6 +15,7 @@
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/file.h>
> +#include <assert.h>
>=20
> #include "common.h"
> #include "quotaio.h"
> @@ -37,15 +38,35 @@ struct disk_dqheader {
> /**
>  * Convert type of quota to written representation
>  */
> -const char *type2name(int type)
> +const char *quota_type2name(quota_type_t qtype)
> {
> -    return extensions[type];
> +    assert(qtype >=3D 0);
> +    assert(qtype < MAXQUOTAS);
> +    return extensions[qtype];
> +}
> +
> +ext2_ino_t quota_type2inum(quota_type_t qtype)
> +{
> +    assert(qtype >=3D 0);
> +    assert(qtype < MAXQUOTAS);
> +    switch (qtype) {
> +    case USRQUOTA:
> +        return EXT4_USR_QUOTA_INO;
> +        break;
> +    case GRPQUOTA:
> +        return EXT4_GRP_QUOTA_INO;
> +        break;
> +    default:
> +        return 0;
> +        break;
> +    }
> +    return 0;
> }
>=20
> /**
>  * Creates a quota file name for given type and format.
>  */
> -const char *quota_get_qf_name(int type, int fmt, char *buf)
> +const char *quota_get_qf_name(quota_type_t type, int fmt, char *buf)
> {
>     if (!buf)
>         return NULL;
> @@ -55,7 +76,7 @@ const char *quota_get_qf_name(int type,
>     return buf;
> }
>=20
> -const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
> +const char *quota_get_qf_path(const char *mntpt, quota_type_t qtype, =
int fmt,
>                   char *path_buf, size_t path_buf_size)
> {
>     char qf_name[QUOTA_NAME_LEN];
> @@ -114,11 +135,16 @@ errcode_t quota_inode_truncate(ext2_fils
> {
>     struct ext2_inode inode;
>     errcode_t err;
> +    quota_type_t qtype;
>=20
>     if ((err =3D ext2fs_read_inode(fs, ino, &inode)))
>         return err;
>=20
> -    if ((ino =3D=3D EXT4_USR_QUOTA_INO) || (ino =3D=3D =
EXT4_GRP_QUOTA_INO)) {
> +    for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +        if (ino =3D=3D quota_type2inum(qtype))
> +            break;
> +
> +    if (qtype !=3D MAXQUOTAS) {
>         inode.i_dtime =3D fs->now ? fs->now : time(0);
>         if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
>             return 0;
> @@ -198,7 +224,8 @@ static unsigned int quota_read_nomount(s
>  * Detect quota format and initialize quota IO
>  */
> errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
> -              ext2_ino_t qf_ino, int type, int fmt, int flags)
> +              ext2_ino_t qf_ino, quota_type_t qtype, int fmt,
> +              int flags)
> {
>     ext2_file_t e2_file;
>     errcode_t err;
> @@ -223,13 +250,13 @@ errcode_t quota_file_open(struct quota_h
>     h->e2fs_write =3D quota_write_nomount;
>     h->e2fs_read =3D quota_read_nomount;
>     h->qh_io_flags =3D 0;
> -    h->qh_type =3D type;
> +    h->qh_type =3D qtype;
>     h->qh_fmt =3D fmt;
>     memset(&h->qh_info, 0, sizeof(h->qh_info));
>     h->qh_ops =3D &quotafile_ops_2;
>=20
>     if (h->qh_ops->check_file &&
> -        (h->qh_ops->check_file(h, type, fmt) =3D=3D 0)) {
> +        (h->qh_ops->check_file(h, qtype, fmt) =3D=3D 0)) {
>         log_err("qh_ops->check_file failed");
>         ext2fs_file_close(e2_file);
>         return -1;
> @@ -280,7 +307,8 @@ static errcode_t quota_inode_init_new(ex
> /*
>  * Create new quotafile of specified format on given filesystem
>  */
> -errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
> int type, int fmt)
> +errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
> +                quota_type_t qtype, int fmt)
> {
>     ext2_file_t e2_file;
>     int err;
> @@ -290,11 +318,8 @@ errcode_t quota_file_create(struct quota
>         fmt =3D QFMT_VFS_V1;
>=20
>     h->qh_qf.fs =3D fs;
> -    if (type =3D=3D USRQUOTA)
> -        qf_inum =3D EXT4_USR_QUOTA_INO;
> -    else if (type =3D=3D GRPQUOTA)
> -        qf_inum =3D EXT4_GRP_QUOTA_INO;
> -    else
> +    qf_inum =3D quota_type2inum(qtype);
> +    if (qf_inum =3D=3D 0)
>         return -1;
>=20
>     err =3D ext2fs_read_bitmaps(fs);
> @@ -310,7 +335,7 @@ errcode_t quota_file_create(struct quota
>     h->e2fs_write =3D quota_write_nomount;
>     h->e2fs_read =3D quota_read_nomount;
>=20
> -    log_debug("Creating quota ino=3D%lu, type=3D%d", qf_inum, type);
> +    log_debug("Creating quota ino=3D%lu, type=3D%d", qf_inum, qtype);
>     err =3D ext2fs_file_open(fs, qf_inum,
>             EXT2_FILE_WRITE | EXT2_FILE_CREATE, &e2_file);
>     if (err) {
> @@ -320,7 +345,7 @@ errcode_t quota_file_create(struct quota
>     h->qh_qf.e2_file =3D e2_file;
>=20
>     h->qh_io_flags =3D 0;
> -    h->qh_type =3D type;
> +    h->qh_type =3D qtype;
>     h->qh_fmt =3D fmt;
>     memset(&h->qh_info, 0, sizeof(h->qh_info));
>     h->qh_ops =3D &quotafile_ops_2;
> Index: e2fsprogs.git/lib/quota/quotaio.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/quotaio.h
> +++ e2fsprogs.git/lib/quota/quotaio.h
> @@ -16,9 +16,20 @@
>=20
> typedef int64_t qsize_t;    /* Type in which we store size limitations =
*/
>=20
> +typedef enum {
> +    USRQUOTA =3D 0,
> +    GRPQUOTA =3D 1,
> +} quota_type_t;
> +
> #define MAXQUOTAS 2
> -#define USRQUOTA 0
> -#define GRPQUOTA 1
> +
> +#if MAXQUOTAS > 32
> +#error "cannot have more than 32 quota types to fit in qtype_bits"
> +#endif
> +
> +#define QUOTA_USR_BIT (1 << USRQUOTA)
> +#define QUOTA_GRP_BIT (1 << GRPQUOTA)
> +#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT)
>=20
> /*
>  * Definitions of magics and versions of current quota files
> @@ -68,7 +79,7 @@ struct quota_file {
>=20
> /* Structure for one opened quota file */
> struct quota_handle {
> -    int qh_type;        /* Type of quotafile */
> +    quota_type_t qh_type;    /* Type of quotafile */
>     int qh_fmt;        /* Quotafile format */
>     int qh_io_flags;    /* IO flags for file */
>     struct quota_file qh_qf;
> @@ -135,12 +146,13 @@ extern struct quotafile_ops quotafile_op
> /* Open existing quotafile of given type (and verify its format) on =
given
>  * filesystem. */
> errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
> -              ext2_ino_t qf_ino, int type, int fmt, int flags);
> +              ext2_ino_t qf_ino, quota_type_t type, int fmt,
> +              int flags);
>=20
>=20
> /* Create new quotafile of specified format on given filesystem */
> errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
> -                int type, int fmt);
> +                quota_type_t qtype, int fmt);
>=20
> /* Close quotafile */
> errcode_t quota_file_close(struct quota_handle *h);
> @@ -150,7 +162,8 @@ struct dquot *get_empty_dquot(void);
>=20
> errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
>=20
> -const char *type2name(int type);
> +const char *quota_type2name(quota_type_t qtype);
> +ext2_ino_t quota_type2inum(quota_type_t qtype);
>=20
> void update_grace_times(struct dquot *q);
>=20
> @@ -158,8 +171,31 @@ void update_grace_times(struct dquot *q)
>    than maxlen of extensions[] and fmtnames[] (plus 2) found in =
quotaio.c */
> #define QUOTA_NAME_LEN 16
>=20
> -const char *quota_get_qf_name(int type, int fmt, char *buf);
> -const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
> +const char *quota_get_qf_name(quota_type_t type, int fmt, char *buf);
> +const char *quota_get_qf_path(const char *mntpt, quota_type_t qtype, =
int fmt,
>                   char *path_buf, size_t path_buf_size);
>=20
> +#include <assert.h>
> +
> +static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb,
> quota_type_t qtype)
> +{
> +    assert(qtype >=3D 0);
> +    assert(qtype < MAXQUOTAS);
> +    switch (qtype) {
> +        case USRQUOTA:
> +            return &sb->s_quota_inum[0];
> +        case GRPQUOTA:
> +            return &sb->s_quota_inum[1];
> +        /* Skip s_overhead_blocks like this */
> +        /*
> +        case PRJQUOTA:
> +            return &sb->s_quota_inum[3];
> +        */
> +        default:
> +            return NULL;
> +    }
> +
> +    return NULL;
> +}
> +
> #endif /* GUARD_QUOTAIO_H */
> Index: e2fsprogs.git/misc/tune2fs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/misc/tune2fs.c
> +++ e2fsprogs.git/misc/tune2fs.c
> @@ -94,7 +94,7 @@ static int stride_set, stripe_width_set;
> static char *extended_cmd;
> static unsigned long new_inode_size;
> static char *ext_mount_opts;
> -static int usrquota, grpquota;
> +static int quota_enable[MAXQUOTAS];
> static int rewrite_checksums;
>=20
> int journal_size, journal_flags;
> @@ -862,6 +862,7 @@ static int update_feature_set(ext2_filsy
>     __u32        old_features[3];
>     int        type_err;
>     unsigned int    mask_err;
> +    quota_type_t    qtype;
>=20
> #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
>                 ((&sb->s_feature_compat)[(type)] & (mask)))
> @@ -1094,9 +1095,9 @@ mmp_error:
>          */
>         if (!Q_flag) {
>             Q_flag =3D 1;
> -            /* Enable both user quota and group quota by default */
> -            usrquota =3D QOPT_ENABLE;
> -            grpquota =3D QOPT_ENABLE;
> +            /* Enable all quota by default */
> +            for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +                quota_enable[qtype] =3D QOPT_ENABLE;
>         }
>         sb->s_feature_ro_compat &=3D ~EXT4_FEATURE_RO_COMPAT_QUOTA;
>     }
> @@ -1111,9 +1112,9 @@ mmp_error:
>             fputs(_("\nWarning: '^quota' option overrides '-Q'"
>                 "arguments.\n"), stderr);
>         Q_flag =3D 1;
> -        /* Disable both user quota and group quota by default */
> -        usrquota =3D QOPT_DISABLE;
> -        grpquota =3D QOPT_DISABLE;
> +        /* Disable all quota by default */
> +        for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +            quota_enable[qtype] =3D QOPT_DISABLE;
>     }
>=20
>     if (sb->s_rev_level =3D=3D EXT2_GOOD_OLD_REV &&
> @@ -1222,47 +1223,55 @@ static void handle_quota_options(ext2_fi
> {
>     quota_ctx_t qctx;
>     ext2_ino_t qf_ino;
> +    quota_type_t qtype;
> +    int enable =3D 0;
>=20
> -    if (!usrquota && !grpquota)
> +    for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++)
> +        if (quota_enable[qtype] !=3D 0)
> +            break;
> +    if (qtype =3D=3D MAXQUOTAS)
>         /* Nothing to do. */
>         return;
>=20
> -    quota_init_context(&qctx, fs, -1);
> -
> -    if (usrquota =3D=3D QOPT_ENABLE || grpquota =3D=3D QOPT_ENABLE)
> +    quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
> +    for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++) {
> +        if (quota_enable[qtype] =3D=3D QOPT_ENABLE) {
> +            enable =3D 1;
> +            break;
> +        }
> +    }
> +    if (enable)
>         quota_compute_usage(qctx);
>=20
> -    if (usrquota =3D=3D QOPT_ENABLE && !fs->super->s_usr_quota_inum) =
{
> -        if ((qf_ino =3D quota_file_exists(fs, USRQUOTA,
> -                        QFMT_VFS_V1)) > 0)
> -            quota_update_limits(qctx, qf_ino, USRQUOTA);
> -        quota_write_inode(qctx, USRQUOTA);
> -    } else if (usrquota =3D=3D QOPT_DISABLE) {
> -        quota_remove_inode(fs, USRQUOTA);
> -    }
> -
> -    if (grpquota =3D=3D QOPT_ENABLE && !fs->super->s_grp_quota_inum) =
{
> -        if ((qf_ino =3D quota_file_exists(fs, GRPQUOTA,
> -                        QFMT_VFS_V1)) > 0)
> -            quota_update_limits(qctx, qf_ino, GRPQUOTA);
> -        quota_write_inode(qctx, GRPQUOTA);
> -    } else if (grpquota =3D=3D QOPT_DISABLE) {
> -        quota_remove_inode(fs, GRPQUOTA);
> +    for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++) {
> +        if (quota_enable[qtype] =3D=3D QOPT_ENABLE &&
> +            *quota_sb_inump(fs->super, qtype) !=3D 0) {
> +            if ((qf_ino =3D quota_file_exists(fs, qtype,
> +                            QFMT_VFS_V1)) > 0)
> +                quota_update_limits(qctx, qf_ino, qtype);
> +            quota_write_inode(qctx, 1 << qtype);
> +        } else if (quota_enable[qtype] =3D=3D QOPT_DISABLE) {
> +            quota_remove_inode(fs, qtype);
> +        }
>     }
>=20
>     quota_release_context(&qctx);
>=20
> -    if ((usrquota =3D=3D QOPT_ENABLE) || (grpquota =3D=3D =
QOPT_ENABLE)) {
> +    if (enable) {
>         fprintf(stderr, "%s", _("\nWarning: the quota feature is still =
"
>                   "under development\n"
>                   "See https://ext4.wiki.kernel.org/"
>                   "index.php/Quota for more information\n\n"));
>         fs->super->s_feature_ro_compat |=3D =
EXT4_FEATURE_RO_COMPAT_QUOTA;
>         ext2fs_mark_super_dirty(fs);
> -    } else if (!fs->super->s_usr_quota_inum &&
> -           !fs->super->s_grp_quota_inum) {
> -        fs->super->s_feature_ro_compat &=3D =
~EXT4_FEATURE_RO_COMPAT_QUOTA;
> -        ext2fs_mark_super_dirty(fs);
> +    } else {
> +        for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++)
> +            if (*quota_sb_inump(fs->super, qtype) !=3D 0)
> +                break;
> +        if (qtype =3D=3D MAXQUOTAS) {
> +            fs->super->s_feature_ro_compat &=3D =
~EXT4_FEATURE_RO_COMPAT_QUOTA;
> +            ext2fs_mark_super_dirty(fs);
> +        }
>     }
>=20
>     return;
> @@ -1291,13 +1300,13 @@ static void parse_quota_opts(const char
>         }
>=20
>         if (strcmp(token, "usrquota") =3D=3D 0) {
> -            usrquota =3D QOPT_ENABLE;
> +            quota_enable[USRQUOTA] =3D QOPT_ENABLE;
>         } else if (strcmp(token, "^usrquota") =3D=3D 0) {
> -            usrquota =3D QOPT_DISABLE;
> +            quota_enable[USRQUOTA] =3D QOPT_DISABLE;
>         } else if (strcmp(token, "grpquota") =3D=3D 0) {
> -            grpquota =3D QOPT_ENABLE;
> +            quota_enable[GRPQUOTA] =3D QOPT_ENABLE;
>         } else if (strcmp(token, "^grpquota") =3D=3D 0) {
> -            grpquota =3D QOPT_DISABLE;
> +            quota_enable[GRPQUOTA] =3D QOPT_DISABLE;
>         } else {
>             fputs(_("\nBad quota options specified.\n\n"
>                 "Following valid quota options are available "
> Index: e2fsprogs.git/debugfs/set_fields.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/debugfs/set_fields.c
> +++ e2fsprogs.git/debugfs/set_fields.c
> @@ -39,6 +39,7 @@
> #include "debugfs.h"
> #include "uuid/uuid.h"
> #include "e2p/e2p.h"
> +#include "quota/quotaio.h"
>=20
> static struct ext2_super_block set_sb;
> static struct ext2_inode_large set_inode;
> @@ -147,8 +148,8 @@ static struct field_set_info super_field
>       NULL, 8, parse_uint },
>     { "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint },
>     { "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
> -    { "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint =
},
> -    { "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint =
},
> +    { "usr_quota_inum", &set_sb.s_quota_inum[0], NULL, 4, parse_uint =
},
> +    { "grp_quota_inum", &set_sb.s_quota_inum[1], NULL, 4, parse_uint =
},
>     { "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, =
parse_uint },
>     { "checksum", &set_sb.s_checksum, NULL, 4, parse_uint },
>     { "checksum_type", &set_sb.s_checksum_type, NULL, 1, parse_uint },
> Index: e2fsprogs.git/lib/ext2fs/tst_super_size.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/ext2fs/tst_super_size.c
> +++ e2fsprogs.git/lib/ext2fs/tst_super_size.c
> @@ -132,8 +132,7 @@ int main(int argc, char **argv)
>     check_field(s_last_error_block, 8);
>     check_field(s_last_error_func, 32);
>     check_field(s_mount_opts, 64);
> -    check_field(s_usr_quota_inum, 4);
> -    check_field(s_grp_quota_inum, 4);
> +    check_field(s_quota_inum, 4 * 2);
>     check_field(s_overhead_blocks, 4);
>     check_field(s_reserved, 108 * 4);
>     check_field(s_checksum, 4);
> Index: e2fsprogs.git/lib/quota/quotaio_tree.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/quotaio_tree.c
> +++ e2fsprogs.git/lib/quota/quotaio_tree.c
> @@ -586,7 +586,7 @@ static void check_reference(struct quota
>             "Please run e2fsck (8) to fix it.",
>             blk,
>             h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
> -            type2name(h->qh_type));
> +            quota_type2name(h->qh_type));
> }
>=20
> static int report_tree(struct dquot *dquot, unsigned int blk, int =
depth,
> Index: e2fsprogs.git/misc/mke2fs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/misc/mke2fs.c
> +++ e2fsprogs.git/misc/mke2fs.c
> @@ -95,7 +95,7 @@ int    journal_flags;
> static int    lazy_itable_init;
> static char    *bad_blocks_filename =3D NULL;
> static __u32    fs_stride;
> -static int    quotatype =3D -1;  /* Initialize both user and group
> quotas by default */
> +static unsigned int quotatype_bits =3D QUOTA_ALL_BIT;  /* Initialize
> all quotas by default */
> static __u64    offset;
>=20
> static struct ext2_super_block fs_param;
> @@ -916,9 +916,9 @@ static void parse_extended_opts(struct e
>                 continue;
>             }
>             if (!strncmp(arg, "usr", 3)) {
> -                quotatype =3D 0;
> +                quotatype_bits =3D QUOTA_USR_BIT;
>             } else if (!strncmp(arg, "grp", 3)) {
> -                quotatype =3D 1;
> +                quotatype_bits =3D QUOTA_GRP_BIT;
>             } else {
>                 fprintf(stderr,
>                     _("Invalid quotatype parameter: %s\n"),
> @@ -2444,7 +2444,7 @@ static int create_quota_inodes(ext2_fils
>=20
>     quota_init_context(&qctx, fs, -1);
>     quota_compute_usage(qctx);
> -    quota_write_inode(qctx, quotatype);
> +    quota_write_inode(qctx, quotatype_bits);
>     quota_release_context(&qctx);
>=20
>     return 0;


Cheers, Andreas






--Apple-Mail=_7311105A-821E-43EE-9550-379DD0BDCB2E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUuGLKnKl2rkXzB/gAQI3lQ//RKUZB++efKobtk6/TLkKSVelJfXm3wHk
/v/b25Rq2ZFstJh31IKW2y969Q6emF/jmfBG2wHGLpH0i38iFEV3rKOyeINBDrL5
78/CXlCTwNzRITvFhY33/qjU8MvLEwBjCBHY4lHR6Dk7wKsRp3pTt48V/tucdLet
a2gUIZHgpK8h9V9UZwRWT7eBFY8B0TvQ03lnGESs9I7kA72w2aJEkrdT7JQYZRoX
KBiLqTl4LP/XUZ0i5zl4xhCbZbTBnPxzRbiEqDUPJVMawaEoi53giB61SIzUDb1D
SWgKXuQImr7iq/gLXicDlDHYXG5vG6cy6AlzxWAVix9LKrynXQ2GqsNp/00ALlyg
W8yuyKWFZ0sJ1Bu1DO4RtMMrUgsm5pRbnN60r3rrSHZhDOo4pqLUbwewTm2DKUWF
+KAv6FhrDWTrCziCQWqGiIYR754MKlU604NHKMQqq3S4+t3Gcfx945FtOTI10PpU
D29FPYwfg8ceOKdIl6Q87BmrLJDViXGJ+7oq+SFy9ZX3QQg4fFnj4qY2VQG+M7YJ
8wHU2C2m23ZFJgEXRnWmPMmwycjL1IBjIcnXSnKvgXPWrrvK/14n7lGRLLI3EidN
bW67idzV+Dj2aAHFWO0BxsXoXiRZ2yhohUn6ARa42V+dna4sSuuP1dUTMdfSfOS0
5uMFXrCcnSw=
=gunE
-----END PGP SIGNATURE-----

--Apple-Mail=_7311105A-821E-43EE-9550-379DD0BDCB2E--
