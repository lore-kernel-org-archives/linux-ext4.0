From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: clean up codes for adding new quota type
Date: Thu, 16 Jan 2014 16:52:11 -0700
Message-ID: <5FD9AE93-B8AE-4221-AA43-EFCF6BFB5896@dilger.ca>
References: <CAPTn0cBB=aEunH9sK+DTC=_WsmnaQSdu=ajU0JsXvgfB2fAMew@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3A6250E6-9EA4-445E-8454-84462F1B512B"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <sihara@ddn.com>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38336 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaAPXwS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jan 2014 18:52:18 -0500
Received: by mail-pa0-f51.google.com with SMTP id ld10so1032516pab.38
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jan 2014 15:52:17 -0800 (PST)
In-Reply-To: <CAPTn0cBB=aEunH9sK+DTC=_WsmnaQSdu=ajU0JsXvgfB2fAMew@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3A6250E6-9EA4-445E-8454-84462F1B512B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jan 15, 2014, at 8:29 PM, Li Xi <pkuelelixi@gmail.com> wrote:
> Adding directory/project quota support to ext4 is widely discussed
> these days. E2fsprogs has to be updated if we want that new feature.
> As a preparation for it, this patch cleans up quota codes of e2fsprogs
> so as to make it easier to add new quota type(s).
>=20
> Test suits are all passed when "make rpm". I am trying to avoid
> breaking anything, so please let me know if there is any extra test
> suits we have run to check its correctness. Thanks!
>=20
> Signed-off-by: Li Xi <lixi <at> ddn.com>
> ---
> Index: e2fsprogs.git/lib/e2p/ls.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/e2p/ls.c
> +++ e2fsprogs.git/lib/e2p/ls.c
> @@ -206,11 +206,22 @@ static const char *checksum_type(__u8 ty
>     }
> }
>=20
> +static const char * const names[MAXQUOTAS] =3D {"User", "Group"};

(style) no space after '*'

It would probably be better to declare these one line per entry, like:

static const char const *quota_names[MAXQUOTAS] =3D {
	[USRQUOTA] =3D "User",
	[GRPQUOTA] =3D "Group",
	[PRJQUOTA] =3D "Project",
};

> +/**
> + * Convert type of quota to written representation
> + */
> +const char *type2Name(int type)

(style) no camel-case for function names

> +{
> +    return names[type];
> +}
> +
> void list_super2(struct ext2_super_block * sb, FILE *f)
> {
>     int inode_blocks_per_group;
>     char buf[80], *str;
>     time_t    tm;
> +    int type;
>=20
>     inode_blocks_per_group =3D (((sb->s_inodes_per_group *
>                     EXT2_INODE_SIZE(sb)) +
> @@ -426,13 +437,12 @@ void list_super2(struct ext2_super_block
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
> +    for (type =3D 0; type < MAXQUOTAS; type++) {
> +        if (sb->s_quota_inum[type])
> +            fprintf(f, "%s quota inode:         %u\n",
> +                type2Name(type),
> +                sb->s_quota_inum[type]);
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
> @@ -18,6 +18,8 @@
>=20
> #include <ext2fs/ext2_types.h>        /* Changed from linux/types.h */
>=20
> +#define MAXQUOTAS 2
> +
> /*
>  * The second extended filesystem constants/structures
>  */
> @@ -666,8 +668,7 @@ struct ext2_super_block {
>     __u8    s_last_error_func[32];    /* function where the error =
happened */
> #define EXT4_S_ERR_END ext4_offsetof(struct ext2_super_block, =
s_mount_opts)
>     __u8    s_mount_opts[64];
> -    __u32    s_usr_quota_inum;    /* inode number of user quota file =
*/
> -    __u32    s_grp_quota_inum;    /* inode number of group quota file =
*/
> +    __u32    s_quota_inum[MAXQUOTAS];/* inode numbers of quota files =
*/

Unfortunately, this has the potential for a serious data corruption,
since ext2_super_block is the on-disk superblock and not in-memory.

If MAXQUOTAS is ever changed then this will overflow s_overhead_blocks
on disk and change the size of the superblock, which will also break
the superblock checksum.

Unfortunately, I don't see an easy way to fix this without having some
kind of indirection array or function that records the offsets of these
fields in the superblock, because both s_{usr,grp}_quota_inum and =
s_overhead_blocks have been in use for long enough that it isn't easy
to change them.  The benefit is that with an indirection array there is
no need to reserve contiguous space for all future quota types.

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
> @@ -77,8 +77,7 @@ void quota_set_sb_inum(ext2_filsys fs, e
> {
>     ext2_ino_t *inump;
>=20
> -    inump =3D (qtype =3D=3D USRQUOTA) ? &fs->super->s_usr_quota_inum =
:
> -        &fs->super->s_grp_quota_inum;
> +    inump =3D &fs->super->s_quota_inum[qtype];

This will need to be a helper function instead of an array dereference.
The other alternative would be something like:

	inump =3D =
&fs->super->s_quota_inum[ext2fs_quota_type_offset[qtype]];

and then there is something like the following is done:

int ext2fs_quota_type_offset[] =3D {
	[USRQUOTA] =3D 0,
	[GRPQUOTA] =3D 1,
	[PRJQUOTA] =3D 3,
};

>=20
>     log_debug("setting quota ino in superblock: ino=3D%u, type=3D%d", =
ino,
>          qtype);
> @@ -91,8 +90,7 @@ errcode_t quota_remove_inode(ext2_filsys
>     ext2_ino_t qf_ino;
>=20
>     ext2fs_read_bitmaps(fs);
> -    qf_ino =3D (qtype =3D=3D USRQUOTA) ? fs->super->s_usr_quota_inum =
:
> -        fs->super->s_grp_quota_inum;
> +    qf_ino =3D fs->super->s_quota_inum[qtype];
>     quota_set_sb_inum(fs, 0, qtype);
>     /* Truncate the inode only if its a reserved one. */
>     if (qf_ino < EXT2_FIRST_INODE(fs->super))
> @@ -211,7 +209,7 @@ static void quota_dnode_free(dnode_t *no
> /*
>  * Set up the quota tracking data structures.
>  */
> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int =
qtype)
> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int =
qtype_bits)
> {
>     int    i, err =3D 0;
>     dict_t    *dict;
> @@ -225,7 +223,7 @@ errcode_t quota_init_context(quota_ctx_t
>=20
>     memset(ctx, 0, sizeof(struct quota_ctx));
>     for (i =3D 0; i < MAXQUOTAS; i++) {
> -        if ((qtype !=3D -1) && (i !=3D qtype))
> +        if (((1 << i) & qtype_bits) =3D=3D 0)
>             continue;
>         err =3D ext2fs_get_mem(sizeof(dict_t), &dict);
>         if (err) {
> @@ -537,8 +535,7 @@ errcode_t quota_compare_and_update(quota
>     if (!qctx->quota_dict[qtype])
>         goto out;
>=20
> -    qf_ino =3D qtype =3D=3D USRQUOTA ? fs->super->s_usr_quota_inum :
> -                     fs->super->s_grp_quota_inum;
> +    qf_ino =3D fs->super->s_quota_inum[qtype];
>     err =3D quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
>     if (err) {
>         log_err("Open quota file failed");
> Index: e2fsprogs.git/e2fsck/pass1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/e2fsck/pass1.c
> +++ e2fsprogs.git/e2fsck/pass1.c
> @@ -574,6 +574,24 @@ static errcode_t recheck_bad_inode_check
>     return 0;
> }
>=20
> +static int is_super_quota_inum(struct ext2_super_block *sb, =
ext2_ino_t ino)
> +{
> +    int i;

(style) blank line after variable declaration

> +    for (i =3D 0; i < MAXQUOTAS; i++)
> +        if (sb->s_quota_inum[i] =3D=3D ino)
> +            return 1;

(style) blank line before return

> +    return 0;
> +}
> +
> +static int is_quota_inum(ext2_ino_t ino)

It might be better to name this "is_reserved_quota_inum()" to match
the other function, or even better would be to put "quota" near the
start so they are more easily found, like quota_inum_is_reserved()
and quota_inum_is_super() or similar.

> +{
> +    int i;
> +    for (i =3D 0; i < MAXQUOTAS; i++)
> +        if (type2ino(i) =3D=3D ino)
> +            return 1;
> +    return 0;
> +}
> +
> void e2fsck_pass1(e2fsck_t ctx)
> {
>     int    i;
> @@ -970,13 +988,11 @@ void e2fsck_pass1(e2fsck_t ctx)
>                 e2fsck_write_inode_full(ctx, ino, inode,
>                             inode_size, "pass1");
>             }
> -        } else if ((ino =3D=3D EXT4_USR_QUOTA_INO) ||
> -               (ino =3D=3D EXT4_GRP_QUOTA_INO)) {
> +        } else if (is_quota_inum(ino)) {
>             ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
>             if ((fs->super->s_feature_ro_compat &
>                     EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> -                ((fs->super->s_usr_quota_inum =3D=3D ino) ||
> -                 (fs->super->s_grp_quota_inum =3D=3D ino))) {
> +                is_super_quota_inum(fs->super, ino)) {
>                 if (!LINUX_S_ISREG(inode->i_mode) &&
>                     fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
>                             &pctx)) {
> Index: e2fsprogs.git/e2fsck/quota.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/e2fsck/quota.c
> +++ e2fsprogs.git/e2fsck/quota.c
> @@ -63,6 +63,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
>     struct ext2_super_block *sb =3D ctx->fs->super;
>     struct problem_context    pctx;
>     ext2_filsys        fs =3D ctx->fs;
> +    int i;
> +    ext2_ino_t quota_ino;
>=20
>     clear_problem_context(&pctx);
>=20
> @@ -70,22 +72,17 @@ void e2fsck_hide_quota(e2fsck_t ctx)
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
> +    for (i =3D 0; i < MAXQUOTAS; i++) {
> +        pctx.ino =3D sb->s_quota_inum[i];
> +        quota_ino =3D type2ino(i);
> +        if (sb->s_quota_inum[i] &&
> +            (sb->s_quota_inum[i] !=3D quota_ino) &&

This looks like it could benefit from using quota_inode_is_reserved()?

> +            fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
> +            move_quota_inode(fs, sb->s_quota_inum[i],
> +                     quota_ino,
> +                     i);
> +            sb->s_quota_inum[i] =3D quota_ino;
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
> @@ -1180,7 +1180,7 @@ int main (int argc, char *argv[])
>     int old_bitmaps;
>     __u32 features[3];
>     char *cp;
> -    int qtype =3D -99;  /* quota type */
> +    int qtype_bits =3D 0;  /* quota type */

This should now be an unsigned int.

>     clear_problem_context(&pctx);
>     sigcatcher_setup();
> @@ -1623,14 +1623,14 @@ print_unsupp_features:
>         journal_size =3D -1;
>=20
>     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
> +        int i;
>         /* Quotas were enabled. Do quota accounting during fsck. */
> -        if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
> -            (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
> -            qtype =3D -1;
> -        else
> -            qtype =3D sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
> +        for (i =3D 0; i < MAXQUOTAS; i++) {
> +            if (sb->s_quota_inum[i])
> +                qtype_bits |=3D 1 << i;

Should there be some kind of sanity check that MAXQUOTAS is < 32?
I guess most compilers will complain about << 32 for an unsigned int,
but it would be good to make sure.

> +        }
>=20
> -        quota_init_context(&ctx->qctx, ctx->fs, qtype);
> +        quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
>     }
>=20
>     run_result =3D e2fsck_run(ctx);
> @@ -1669,7 +1669,7 @@ no_journal:
>     if (ctx->qctx) {
>         int i, needs_writeout;
>         for (i =3D 0; i < MAXQUOTAS; i++) {
> -            if (qtype !=3D -1 && qtype !=3D i)
> +            if (((1 << i) & qtype_bits) =3D=3D 0)
>                 continue;
>             needs_writeout =3D 0;
>             pctx.num =3D i;
> Index: e2fsprogs.git/lib/quota/mkquota.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/mkquota.h
> +++ e2fsprogs.git/lib/quota/mkquota.h
> @@ -10,7 +10,7 @@
>  * {
>  *    quota_ctx_t qctx;
>  *
> - *    quota_init_context(&qctx, fs, -1);
> + *    quota_init_context(&qctx, fs, ALLQUOTA_BIT);
>  *    {
>  *        quota_compute_usage(qctx, -1);
>  *        AND/OR
> @@ -43,7 +43,7 @@ struct quota_ctx {
> };
>=20
> /* In mkquota.c */
> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int =
qtype);
> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int
> qtype_bits);
> void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
> ext2_ino_t ino,
>         int adjust);
> void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, =
ext2_ino_t ino,
> Index: e2fsprogs.git/lib/quota/quotaio.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/quotaio.c
> +++ e2fsprogs.git/lib/quota/quotaio.c
> @@ -42,6 +42,22 @@ const char *type2name(int type)
>     return extensions[type];
> }
>=20
> +ext2_ino_t type2ino(int qtype)

"type2ino()" is a very generic function name.  At least using
quota_type2ino() would make it more clear that this relates to
quota.  Secondly, "qtype" should be an enum that declares USRQUOTA
and GRPQUOTA, and then uses this consistently throughout the code.

> +{
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
> +}
> +
> /**
>  * Creates a quota file name for given type and format.
>  */
> @@ -114,11 +130,16 @@ errcode_t quota_inode_truncate(ext2_fils
> {
>     struct ext2_inode inode;
>     errcode_t err;
> +    int i;
>=20
>     if ((err =3D ext2fs_read_inode(fs, ino, &inode)))
>         return err;
>=20
> -    if ((ino =3D=3D EXT4_USR_QUOTA_INO) || (ino =3D=3D =
EXT4_GRP_QUOTA_INO)) {
> +    for (i =3D 0; i < MAXQUOTAS; i++)
> +        if (ino =3D=3D type2ino(i))
> +            break;
> +
> +    if (i !=3D MAXQUOTAS) {
>         inode.i_dtime =3D fs->now ? fs->now : time(0);
>         if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
>             return 0;
> @@ -290,11 +311,8 @@ errcode_t quota_file_create(struct quota
>         fmt =3D QFMT_VFS_V1;
>=20
>     h->qh_qf.fs =3D fs;
> -    if (type =3D=3D USRQUOTA)
> -        qf_inum =3D EXT4_USR_QUOTA_INO;
> -    else if (type =3D=3D GRPQUOTA)
> -        qf_inum =3D EXT4_GRP_QUOTA_INO;
> -    else
> +    qf_inum =3D type2ino(type);
> +    if (qf_inum =3D=3D 0)
>         return -1;
>=20
>     err =3D ext2fs_read_bitmaps(fs);
> Index: e2fsprogs.git/lib/quota/quotaio.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/lib/quota/quotaio.h
> +++ e2fsprogs.git/lib/quota/quotaio.h
> @@ -20,6 +20,10 @@ typedef int64_t qsize_t;    /* Type in whic
> #define USRQUOTA 0
> #define GRPQUOTA 1
>=20
> +#define USRQUOTA_BIT (1 << USRQUOTA)
> +#define GRPQUOTA_BIT (1 << GRPQUOTA)
> +#define ALLQUOTA_BIT (USRQUOTA_BIT | GRPQUOTA_BIT)

It isn't the fault of this patch, but I'd really prefer to see
all of these constants put "QUOTA" at the start, so they sort
together, like QUOTA_USR{,_BIT}, QUOTA_GRP{,_BIT}, QUOTA_ALL_BIT.

Is there some dependency on the upstream kernel or quota-tools
package that would recommend against this change?

It should definitely be in a separate patch from this one.

> /*
>  * Definitions of magics and versions of current quota files
>  */
> @@ -151,6 +155,7 @@ struct dquot *get_empty_dquot(void);
> errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
>=20
> const char *type2name(int type);

This existing type2name() function should also get a quota_ prefix.

> +ext2_ino_t type2ino(int qtype);
>=20
> void update_grace_times(struct dquot *q);
>=20
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
> +static int quota[MAXQUOTAS];

It might be better to name this quota_enable[] or similar.

> static int rewrite_checksums;
>=20
> int journal_size, journal_flags;
> @@ -862,6 +862,7 @@ static int update_feature_set(ext2_filsy
>     __u32        old_features[3];
>     int        type_err;
>     unsigned int    mask_err;
> +    int        i;
>=20
> #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
>                 ((&sb->s_feature_compat)[(type)] & (mask)))
> @@ -1095,8 +1096,8 @@ mmp_error:
>         if (!Q_flag) {
>             Q_flag =3D 1;
>             /* Enable both user quota and group quota by default */
> -            usrquota =3D QOPT_ENABLE;
> -            grpquota =3D QOPT_ENABLE;
> +            for (i =3D 0; i < MAXQUOTAS; i++)
> +                quota[i] =3D QOPT_ENABLE;
>         }
>         sb->s_feature_ro_compat &=3D ~EXT4_FEATURE_RO_COMPAT_QUOTA;
>     }
> @@ -1112,8 +1113,8 @@ mmp_error:
>                 "arguments.\n"), stderr);
>         Q_flag =3D 1;
>         /* Disable both user quota and group quota by default */
> -        usrquota =3D QOPT_DISABLE;
> -        grpquota =3D QOPT_DISABLE;
> +        for (i =3D 0; i < MAXQUOTAS; i++)
> +            quota[i] =3D QOPT_DISABLE;
>     }
>=20
>     if (sb->s_rev_level =3D=3D EXT2_GOOD_OLD_REV &&
> @@ -1222,47 +1223,53 @@ static void handle_quota_options(ext2_fi
> {
>     quota_ctx_t qctx;
>     ext2_ino_t qf_ino;
> +    int i;
> +    int enable =3D 0;
>=20
> -    if (!usrquota && !grpquota)
> +    for (i =3D 0 ; i < MAXQUOTAS; i++)
> +        if (quota[i])

(style) since quota[i] is not boolean, this would be better as:

        if (quota[i] !=3D 0)

> +            break;
> +    if (i =3D=3D MAXQUOTAS)
>         /* Nothing to do. */
>         return;
>=20
> -    quota_init_context(&qctx, fs, -1);
> -
> -    if (usrquota =3D=3D QOPT_ENABLE || grpquota =3D=3D QOPT_ENABLE)
> +    quota_init_context(&qctx, fs, ALLQUOTA_BIT);
> +    for (i =3D 0 ; i < MAXQUOTAS; i++)
> +        if (quota[i] =3D=3D QOPT_ENABLE) {
> +            enable =3D 1;
> +            break;
> +        }
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
> +    for (i =3D 0 ; i < MAXQUOTAS; i++) {
> +        if (quota[i] =3D=3D QOPT_ENABLE && =
!fs->super->s_quota_inum[i]) {
> +            if ((qf_ino =3D quota_file_exists(fs, i,
> +                            QFMT_VFS_V1)) > 0)
> +                quota_update_limits(qctx, qf_ino, i);
> +            quota_write_inode(qctx, i);
> +        } else if (quota[i] =3D=3D QOPT_DISABLE) {
> +            quota_remove_inode(fs, i);
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
> +        for (i =3D 0 ; i < MAXQUOTAS; i++)
> +            if (fs->super->s_quota_inum[i])
> +                break;
> +        if (i =3D=3D MAXQUOTAS) {
> +            fs->super->s_feature_ro_compat &=3D =
~EXT4_FEATURE_RO_COMPAT_QUOTA;
> +            ext2fs_mark_super_dirty(fs);
> +        }
>     }
>=20
>     return;
> @@ -1291,13 +1298,13 @@ static void parse_quota_opts(const char
>         }
>=20
>         if (strcmp(token, "usrquota") =3D=3D 0) {
> -            usrquota =3D QOPT_ENABLE;
> +            quota[USRQUOTA] =3D QOPT_ENABLE;
>         } else if (strcmp(token, "^usrquota") =3D=3D 0) {
> -            usrquota =3D QOPT_DISABLE;
> +            quota[USRQUOTA] =3D QOPT_DISABLE;
>         } else if (strcmp(token, "grpquota") =3D=3D 0) {
> -            grpquota =3D QOPT_ENABLE;
> +            quota[GRPQUOTA] =3D QOPT_ENABLE;
>         } else if (strcmp(token, "^grpquota") =3D=3D 0) {
> -            grpquota =3D QOPT_DISABLE;
> +            quota[GRPQUOTA] =3D QOPT_DISABLE;
>         } else {
>             fputs(_("\nBad quota options specified.\n\n"
>                 "Following valid quota options are available "
> Index: e2fsprogs.git/debugfs/set_fields.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- e2fsprogs.git.orig/debugfs/set_fields.c
> +++ e2fsprogs.git/debugfs/set_fields.c
> @@ -147,8 +147,8 @@ static struct field_set_info super_field
>       NULL, 8, parse_uint },
>     { "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint },
>     { "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
> -    { "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint =
},
> -    { "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint =
},
> +    { "quota_inum", &set_sb.s_quota_inum, NULL, 4, parse_uint, =
FLAG_ARRAY,
> +      MAXQUOTAS },

This will also need to be fixed, to avoid clobbering s_overhead_blocks.

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
> +    check_field(s_quota_inum, 4 * MAXQUOTAS);
>     check_field(s_overhead_blocks, 4);
>     check_field(s_reserved, 108 * 4);
>     check_field(s_checksum, 4);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_3A6250E6-9EA4-445E-8454-84462F1B512B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUthwq3Kl2rkXzB/gAQIhsg/8Ce052WgilhLIVe83GuwuKUAPGMMGg0Tq
vi8wV5u5C5l4l2hBX2UOuZmVFsc8LnYCLqtVBdWj9Ko/fI3zTNj3mYpJ4In8EvKl
967kFwpWzKYpGOmG1B4QoBiMM6bAxdQZpyAjLfrPT9X6XqdRZoyrUjJvAg9YKCB4
RgROYbOugVqApTMgz95wVarun4qnoIwN4qAoJ2EwLjbbXjgEZzeHOTQSle5IGQP0
fiXtclexJixrg40YhWcClvyszS2x7fvj3qRQSsq4sgcHsLW/jtiRqVuyuKULDcHV
IyyCwg0DAs5OwP93/l2nbPBSzn3Xds/Es7AYoMTbztdxyRkTYgNnYgaxkRhJYuVm
Cfgw3ytA7JNLrr4SdvJsNL+D9ipJDO3zEXTZXbZNg9EWg69yf0B3z2sNPHgsrbnl
c3KSQ30Z2l/V7zcIDDFfNiPkb1A8GzQgaUdp+G8mvc6L7dHOkKKdw30LDNbQIZ+X
Pm3t2vm1VI6UTo2FEY10l2zJg0tjg5WyL1Ba2ML8PFlxyRTxF3nNn+esI0v4POo+
fdIz0SBXVZDdZU3+iIKCmpmLUe3O5HWTUkrJ/PG521MDms0YwSWFycy0npuHbE9n
2VCakqnTMjU4bngi+Hiv7j3wGVJb+vxp+VGs1W9gcK3ZNMHvoWvD8Fl9XRUxQbo1
W7PdYI7Q4hg=
=qGla
-----END PGP SIGNATURE-----

--Apple-Mail=_3A6250E6-9EA4-445E-8454-84462F1B512B--
