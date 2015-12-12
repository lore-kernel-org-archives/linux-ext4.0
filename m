From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [v1 1/4] clean up codes for adding new quota type
Date: Sat, 12 Dec 2015 02:32:33 -0700
Message-ID: <A685F1B1-2006-4E24-BD88-E47A5A597618@dilger.ca>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com> <1446046933-26571-2-git-send-email-lixi@ddn.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_E2E06F89-589F-4D65-BD91-E5B8C54CD0FC"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35395 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbLLJcl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Dec 2015 04:32:41 -0500
Received: by ioc74 with SMTP id 74so150144360ioc.2
        for <linux-ext4@vger.kernel.org>; Sat, 12 Dec 2015 01:32:40 -0800 (PST)
In-Reply-To: <1446046933-26571-2-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_E2E06F89-589F-4D65-BD91-E5B8C54CD0FC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 28, 2015, at 9:42 AM, Li Xi <pkuelelixi@gmail.com> wrote:
>=20
> Adding directory/project quota support to ext4 is widely discussed
> these days. E2fsprogs has to be updated if we want that new feature.
> As a preparation for it, this patch cleans up quota codes of e2fsprogs
> so as to make it easier to add new quota type(s).

Some minor issues I just noticed.

> Signed-off-by: Li Xi <lixi@ddn.com>
> Change-Id: I330cebc0e95aa8d81477a63932381bcc84eea3c1
> ---
> debugfs/quota.c            |    2 +-
> debugfs/set_fields.c       |    1 +
> e2fsck/pass1.c             |   28 ++++++++++--
> e2fsck/quota.c             |   28 +++++-------
> e2fsck/unix.c              |   26 ++++++------
> lib/e2p/ls.c               |   28 +++++++++---
> lib/support/mkquota.c      |  100 =
++++++++++++++++++++++++--------------------
> lib/support/quotaio.c      |   71 ++++++++++++++++++++-----------
> lib/support/quotaio.h      |   65 ++++++++++++++++++++--------
> lib/support/quotaio_tree.c |    2 +-
> misc/mke2fs.c              |   10 ++--
> misc/tune2fs.c             |   82 ++++++++++++++++++++----------------
> 12 files changed, 269 insertions(+), 174 deletions(-)
>=20
> diff --git a/debugfs/quota.c b/debugfs/quota.c
> index 7aa0f3b..d0f6bff 100644
> --- a/debugfs/quota.c
> +++ b/debugfs/quota.c
> @@ -43,7 +43,7 @@ static int load_quota_ctx(char *progname)
> 	if (current_qctx)
> 		return 0;
>=20
> -	retval =3D quota_init_context(&current_qctx, current_fs, -1);
> +	retval =3D quota_init_context(&current_qctx, current_fs, =
QUOTA_ALL_BIT);
> 	if (retval) {
> 		com_err(current_fs->device_name, retval,
> 			"while trying to load quota information");
> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
> index b14fec9..57ef871 100644
> --- a/debugfs/set_fields.c
> +++ b/debugfs/set_fields.c
> @@ -40,6 +40,7 @@
> #include "debugfs.h"
> #include "uuid/uuid.h"
> #include "e2p/e2p.h"
> +#include "support/quotaio.h"
>=20
> static struct ext2_super_block set_sb;
> static struct ext2_inode_large set_inode;
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index 61ae2d9..23d15bd 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -954,6 +954,28 @@ out:
> 	}
> }
>=20
> +static int quota_inum_is_super(struct ext2_super_block *sb, =
ext2_ino_t ino)
> +{
> +	enum quota_type qtype;
> +
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +		if (*quota_sb_inump(sb, qtype) =3D=3D ino)
> +			return 1;
> +
> +	return 0;
> +}
> +
> +static int quota_inum_is_reserved(ext2_ino_t ino)
> +{
> +	enum quota_type qtype;
> +
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +		if (quota_type2inum(qtype) =3D=3D ino)
> +			return 1;
> +
> +	return 0;
> +}
> +
> void e2fsck_pass1(e2fsck_t ctx)
> {
> 	int	i;
> @@ -1504,13 +1526,11 @@ void e2fsck_pass1(e2fsck_t ctx)
> 							inode_size, =
"pass1");
> 				failed_csum =3D 0;
> 			}
> -		} else if ((ino =3D=3D EXT4_USR_QUOTA_INO) ||
> -			   (ino =3D=3D EXT4_GRP_QUOTA_INO)) {
> +		} else if (quota_inum_is_reserved(ino)) {
> 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, =
ino);
> 			if ((fs->super->s_feature_ro_compat &
> 					EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> -			    ((fs->super->s_usr_quota_inum =3D=3D ino) ||
> -			     (fs->super->s_grp_quota_inum =3D=3D ino))) =
{
> +			    quota_inum_is_super(fs->super, ino)) {
> 				if (!LINUX_S_ISREG(inode->i_mode) &&
> 				    fix_problem(ctx, =
PR_1_QUOTA_BAD_MODE,
> 							&pctx)) {
> diff --git a/e2fsck/quota.c b/e2fsck/quota.c
> index 2293aad..5050b69 100644
> --- a/e2fsck/quota.c
> +++ b/e2fsck/quota.c
> @@ -17,7 +17,7 @@
> #include "problem.h"
>=20
> static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
> -			     ext2_ino_t to_ino, int qtype)
> +			     ext2_ino_t to_ino, enum quota_type qtype)
> {
> 	struct ext2_inode	inode;
> 	errcode_t		retval;
> @@ -62,6 +62,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
> 	struct ext2_super_block *sb =3D ctx->fs->super;
> 	struct problem_context	pctx;
> 	ext2_filsys		fs =3D ctx->fs;
> +	enum quota_type qtype;
> +	ext2_ino_t quota_ino;
>=20
> 	clear_problem_context(&pctx);
>=20
> @@ -69,22 +71,14 @@ void e2fsck_hide_quota(e2fsck_t ctx)
> 	    !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
> 		return;
>=20
> -	pctx.ino =3D sb->s_usr_quota_inum;
> -	if (sb->s_usr_quota_inum &&
> -	    (sb->s_usr_quota_inum !=3D EXT4_USR_QUOTA_INO) &&
> -	    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
> -		move_quota_inode(fs, sb->s_usr_quota_inum, =
EXT4_USR_QUOTA_INO,
> -				 USRQUOTA);
> -		sb->s_usr_quota_inum =3D EXT4_USR_QUOTA_INO;
> -	}
> -
> -	pctx.ino =3D sb->s_grp_quota_inum;
> -	if (sb->s_grp_quota_inum &&
> -	    (sb->s_grp_quota_inum !=3D EXT4_GRP_QUOTA_INO) &&
> -	    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
> -		move_quota_inode(fs, sb->s_grp_quota_inum, =
EXT4_GRP_QUOTA_INO,
> -				 GRPQUOTA);
> -		sb->s_grp_quota_inum =3D EXT4_GRP_QUOTA_INO;
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		pctx.ino =3D *quota_sb_inump(sb, qtype);
> +		quota_ino =3D quota_type2inum(qtype);
> +		if (pctx.ino && (pctx.ino !=3D quota_ino) &&
> +		    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
> +			move_quota_inode(fs, pctx.ino, quota_ino, =
qtype);
> +			*quota_sb_inump(sb, qtype) =3D quota_ino;
> +		}
> 	}
>=20
> 	return;
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 9d49a0e..553c188 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1338,7 +1338,8 @@ int main (int argc, char *argv[])
> 	int old_bitmaps;
> 	__u32 features[3];
> 	char *cp;
> -	int qtype =3D -99;  /* quota type */
> +	unsigned int qtype_bits =3D 0;

> +	enum quota_type qtype;
>=20
> 	clear_problem_context(&pctx);
> 	sigcatcher_setup();
> @@ -1778,13 +1779,12 @@ print_unsupp_features:
>=20
> 	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
> 		/* Quotas were enabled. Do quota accounting during fsck. =
*/
> -		if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
> -		    (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
> -			qtype =3D -1;
> -		else
> -			qtype =3D sb->s_usr_quota_inum ? USRQUOTA : =
GRPQUOTA;
> +		for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +			if (*quota_sb_inump(sb, qtype) !=3D 0)
> +				qtype_bits |=3D 1 << qtype;
> +		}
>=20
> -		quota_init_context(&ctx->qctx, ctx->fs, qtype);
> +		quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
> 	}
>=20
> 	run_result =3D e2fsck_run(ctx);
> @@ -1821,17 +1821,17 @@ print_unsupp_features:
> no_journal:
>=20
> 	if (ctx->qctx) {
> -		int i, needs_writeout;
> -		for (i =3D 0; i < MAXQUOTAS; i++) {
> -			if (qtype !=3D -1 && qtype !=3D i)
> +		int needs_writeout;
> +		for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +			if (((1 << qtype) & qtype_bits) =3D=3D 0)
> 				continue;
> 			needs_writeout =3D 0;
> -			pctx.num =3D i;
> -			retval =3D quota_compare_and_update(ctx->qctx, =
i,
> +			pctx.num =3D qtype;
> +			retval =3D quota_compare_and_update(ctx->qctx, =
qtype,
> 							  =
&needs_writeout);
> 			if ((retval || needs_writeout) &&
> 			    fix_problem(ctx, PR_6_UPDATE_QUOTAS, &pctx))
> -				quota_write_inode(ctx->qctx, i);
> +				quota_write_inode(ctx->qctx, 1 << =
qtype);
> 		}
> 		quota_release_context(&ctx->qctx);
> 	}
> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
> index 2e98c14..4e80372 100644
> --- a/lib/e2p/ls.c
> +++ b/lib/e2p/ls.c
> @@ -23,6 +23,7 @@
> #include <time.h>
>=20
> #include "e2p.h"
> +#include "support/quotaio.h"
>=20
> static void print_user (unsigned short uid, FILE *f)
> {
> @@ -206,11 +207,25 @@ static const char *checksum_type(__u8 type)
> 	}
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
> +const char *quota_type2prefix(enum quota_type qtype)

This function should be static.

> +{
> +	return quota_prefix[qtype];
> +}
> +
> void list_super2(struct ext2_super_block * sb, FILE *f)
> {
> 	int inode_blocks_per_group;
> 	char buf[80], *str;
> 	time_t	tm;
> +	enum quota_type qtype;
>=20
> 	inode_blocks_per_group =3D (((sb->s_inodes_per_group *
> 				    EXT2_INODE_SIZE(sb)) +
> @@ -434,13 +449,12 @@ void list_super2(struct ext2_super_block * sb, =
FILE *f)
> 		fprintf(f, "MMP update interval:      %u\n",
> 			sb->s_mmp_update_interval);
> 	}
> -	if (sb->s_usr_quota_inum)
> -		fprintf(f, "User quota inode:         %u\n",
> -			sb->s_usr_quota_inum);
> -	if (sb->s_grp_quota_inum)
> -		fprintf(f, "Group quota inode:        %u\n",
> -			sb->s_grp_quota_inum);
> -
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		if (*quota_sb_inump(sb, qtype) !=3D 0)
> +			fprintf(f, "%-26s%u\n",
> +				quota_type2prefix(qtype),
> +				*quota_sb_inump(sb, qtype));
> +	}
> 	if (sb->s_feature_ro_compat & =
EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
> 		fprintf(f, "Checksum type:            %s\n",
> 			checksum_type(sb->s_checksum_type));
> diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
> index 00e96f8..b74c885 100644
> --- a/lib/support/mkquota.c
> +++ b/lib/support/mkquota.c
> @@ -67,7 +67,7 @@ static void print_dquot(const char *desc =
EXT2FS_ATTR((unused)),
>  * Returns 0 if not able to find the quota file, otherwise returns its
>  * inode number.
>  */
> -int quota_file_exists(ext2_filsys fs, int qtype)
> +int quota_file_exists(ext2_filsys fs, enum quota_type qtype)
> {
> 	char qf_name[256];
> 	errcode_t ret;
> @@ -89,12 +89,11 @@ int quota_file_exists(ext2_filsys fs, int qtype)
> /*
>  * Set the value for reserved quota inode number field in superblock.
>  */
> -void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
> +void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, enum =
quota_type qtype)
> {
> 	ext2_ino_t *inump;
>=20
> -	inump =3D (qtype =3D=3D USRQUOTA) ? &fs->super->s_usr_quota_inum =
:
> -		&fs->super->s_grp_quota_inum;
> +	inump =3D quota_sb_inump(fs->super, qtype);
>=20
> 	log_debug("setting quota ino in superblock: ino=3D%u, type=3D%d", =
ino,
> 		 qtype);
> @@ -102,7 +101,7 @@ void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t =
ino, int qtype)
> 	ext2fs_mark_super_dirty(fs);
> }
>=20
> -errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
> +errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype)
> {
> 	ext2_ino_t qf_ino;
> 	errcode_t	retval;
> @@ -112,8 +111,7 @@ errcode_t quota_remove_inode(ext2_filsys fs, int =
qtype)
> 		log_err("Couldn't read bitmaps: %s", =
error_message(retval));
> 		return retval;
> 	}
> -	qf_ino =3D (qtype =3D=3D USRQUOTA) ? fs->super->s_usr_quota_inum =
:
> -		fs->super->s_grp_quota_inum;
> +	qf_ino =3D *quota_sb_inump(fs->super, qtype);
> 	quota_set_sb_inum(fs, 0, qtype);
> 	/* Truncate the inode only if its a reserved one. */
> 	if (qf_ino < EXT2_FIRST_INODE(fs->super))
> @@ -145,9 +143,10 @@ static void write_dquots(dict_t *dict, struct =
quota_handle *qh)
> 	}
> }
>=20
> -errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
> +errcode_t quota_write_inode(quota_ctx_t qctx, unsigned int =
qtype_bits)
> {
> -	int		retval =3D 0, i;
> +	int		retval =3D 0;
> +	enum quota_type	qtype;
> 	dict_t		*dict;
> 	ext2_filsys	fs;
> 	struct quota_handle *h =3D NULL;
> @@ -170,15 +169,15 @@ errcode_t quota_write_inode(quota_ctx_t qctx, =
int qtype)
> 		goto out;
> 	}
>=20
> -	for (i =3D 0; i < MAXQUOTAS; i++) {
> -		if ((qtype !=3D -1) && (i !=3D qtype))
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		if (((1 << qtype) & qtype_bits) =3D=3D 0)
> 			continue;
>=20
> -		dict =3D qctx->quota_dict[i];
> +		dict =3D qctx->quota_dict[qtype];
> 		if (!dict)
> 			continue;
>=20
> -		retval =3D quota_file_create(h, fs, i, fmt);
> +		retval =3D quota_file_create(h, fs, qtype, fmt);
> 		if (retval < 0) {
> 			log_err("Cannot initialize io on quotafile");
> 			continue;
> @@ -196,7 +195,7 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int =
qtype)
> 		}
>=20
> 		/* Set quota inode numbers in superblock. */
> -		quota_set_sb_inum(fs, h->qh_qf.ino, i);
> +		quota_set_sb_inum(fs, h->qh_qf.ino, qtype);
> 		ext2fs_mark_super_dirty(fs);
> 		ext2fs_mark_bb_dirty(fs);
> 		fs->flags &=3D ~EXT2_FLAG_SUPER_ONLY;
> @@ -232,11 +231,18 @@ static int dict_uint_cmp(const void *a, const =
void *b)
> 		return -1;
> }
>=20
> -static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
> +static inline qid_t get_qid(struct ext2_inode *inode, enum quota_type =
qtype)
> {
> -	if (qtype =3D=3D USRQUOTA)
> -		return inode_uid(*inode);
> -	return inode_gid(*inode);
> +	switch (qtype) {
> +		case USRQUOTA:
> +			return inode_uid(*inode);
> +		case GRPQUOTA:
> +			return inode_gid(*inode);
> +		default:
> +			return 0;
> +	}
> +
> +	return 0;
> }
>=20
> static void quota_dnode_free(dnode_t *node,
> @@ -251,12 +257,13 @@ static void quota_dnode_free(dnode_t *node,
> /*
>  * Set up the quota tracking data structures.
>  */
> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int =
qtype)
> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
> +			     unsigned int qtype_bits)
> {
> 	errcode_t err;
> 	dict_t	*dict;
> 	quota_ctx_t ctx;
> -	int	i;
> +	enum quota_type	qtype;
>=20
> 	err =3D ext2fs_get_mem(sizeof(struct quota_ctx), &ctx);
> 	if (err) {
> @@ -265,9 +272,9 @@ errcode_t quota_init_context(quota_ctx_t *qctx, =
ext2_filsys fs, int qtype)
> 	}
>=20
> 	memset(ctx, 0, sizeof(struct quota_ctx));
> -	for (i =3D 0; i < MAXQUOTAS; i++) {
> -		ctx->quota_file[i] =3D NULL;
> -		if ((qtype !=3D -1) && (i !=3D qtype))
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		ctx->quota_file[qtype] =3D NULL;
> +		if (((1 << qtype) & qtype_bits) =3D=3D 0)
> 			continue;
> 		err =3D ext2fs_get_mem(sizeof(dict_t), &dict);
> 		if (err) {
> @@ -275,7 +282,7 @@ errcode_t quota_init_context(quota_ctx_t *qctx, =
ext2_filsys fs, int qtype)
> 			quota_release_context(&ctx);
> 			return err;
> 		}
> -		ctx->quota_dict[i] =3D dict;
> +		ctx->quota_dict[qtype] =3D dict;
> 		dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
> 		dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
> 	}
> @@ -289,26 +296,26 @@ void quota_release_context(quota_ctx_t *qctx)
> {
> 	errcode_t err;
> 	dict_t	*dict;
> -	int	i;
> +	enum quota_type	qtype;
> 	quota_ctx_t ctx;
>=20
> 	if (!qctx)
> 		return;
>=20
> 	ctx =3D *qctx;
> -	for (i =3D 0; i < MAXQUOTAS; i++) {
> -		dict =3D ctx->quota_dict[i];
> -		ctx->quota_dict[i] =3D 0;
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		dict =3D ctx->quota_dict[qtype];
> +		ctx->quota_dict[qtype] =3D 0;
> 		if (dict) {
> 			dict_free_nodes(dict);
> 			free(dict);
> 		}
> -		if (ctx->quota_file[i]) {
> -			err =3D quota_file_close(ctx, =
ctx->quota_file[i]);
> +		if (ctx->quota_file[qtype]) {
> +			err =3D quota_file_close(ctx, =
ctx->quota_file[qtype]);
> 			if (err) {
> 				log_err("Cannot close quotafile: %s",
> 					strerror(errno));
> -				ext2fs_free_mem(&ctx->quota_file[i]);
> +				=
ext2fs_free_mem(&ctx->quota_file[qtype]);
> 			}
> 		}
> 	}
> @@ -346,7 +353,7 @@ void quota_data_add(quota_ctx_t qctx, struct =
ext2_inode *inode,
> {
> 	struct dquot	*dq;
> 	dict_t		*dict;
> -	int		i;
> +	enum quota_type	qtype;
>=20
> 	if (!qctx)
> 		return;
> @@ -354,10 +361,10 @@ void quota_data_add(quota_ctx_t qctx, struct =
ext2_inode *inode,
> 	log_debug("ADD_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", =
ino,
> 			inode_uid(*inode),
> 			inode_gid(*inode), space);
> -	for (i =3D 0; i < MAXQUOTAS; i++) {
> -		dict =3D qctx->quota_dict[i];
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		dict =3D qctx->quota_dict[qtype];
> 		if (dict) {
> -			dq =3D get_dq(dict, get_qid(inode, i));
> +			dq =3D get_dq(dict, get_qid(inode, qtype));
> 			if (dq)
> 				dq->dq_dqb.dqb_curspace +=3D space;
> 		}
> @@ -373,7 +380,7 @@ void quota_data_sub(quota_ctx_t qctx, struct =
ext2_inode *inode,
> {
> 	struct dquot	*dq;
> 	dict_t		*dict;
> -	int		i;
> +	enum quota_type	qtype;
>=20
> 	if (!qctx)
> 		return;
> @@ -381,10 +388,10 @@ void quota_data_sub(quota_ctx_t qctx, struct =
ext2_inode *inode,
> 	log_debug("SUB_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", =
ino,
> 			inode_uid(*inode),
> 			inode_gid(*inode), space);
> -	for (i =3D 0; i < MAXQUOTAS; i++) {
> -		dict =3D qctx->quota_dict[i];
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		dict =3D qctx->quota_dict[qtype];
> 		if (dict) {
> -			dq =3D get_dq(dict, get_qid(inode, i));
> +			dq =3D get_dq(dict, get_qid(inode, qtype));
> 			dq->dq_dqb.dqb_curspace -=3D space;
> 		}
> 	}
> @@ -398,7 +405,7 @@ void quota_data_inodes(quota_ctx_t qctx, struct =
ext2_inode *inode,
> {
> 	struct dquot	*dq;
> 	dict_t		*dict;
> -	int		i;
> +	enum quota_type	qtype;
>=20
> 	if (!qctx)
> 		return;
> @@ -406,10 +413,10 @@ void quota_data_inodes(quota_ctx_t qctx, struct =
ext2_inode *inode,
> 	log_debug("ADJ_INODE: Inode: %u, UID/GID: %u/%u, adjust: %d", =
ino,
> 			inode_uid(*inode),
> 			inode_gid(*inode), adjust);
> -	for (i =3D 0; i < MAXQUOTAS; i++) {
> -		dict =3D qctx->quota_dict[i];
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++) {
> +		dict =3D qctx->quota_dict[qtype];
> 		if (dict) {
> -			dq =3D get_dq(dict, get_qid(inode, i));
> +			dq =3D get_dq(dict, get_qid(inode, qtype));
> 			dq->dq_dqb.dqb_curinodes +=3D adjust;
> 		}
> 	}
> @@ -542,7 +549,8 @@ static errcode_t quota_write_all_dquots(struct =
quota_handle *qh,
> /*
>  * Updates the in-memory quota limits from the given quota inode.
>  */
> -errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, =
int type)
> +errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
> +			      enum quota_type qtype)
> {
> 	struct quota_handle *qh;
> 	errcode_t err;
> @@ -556,7 +564,7 @@ errcode_t quota_update_limits(quota_ctx_t qctx, =
ext2_ino_t qf_ino, int type)
> 		return err;
> 	}
>=20
> -	err =3D quota_file_open(qctx, qh, qf_ino, type, -1, 0);
> +	err =3D quota_file_open(qctx, qh, qf_ino, qtype, -1, 0);
> 	if (err) {
> 		log_err("Open quota file failed");
> 		goto out;
> @@ -581,7 +589,7 @@ out:
>  * on disk and updates the limits in qctx->quota_dict. =
'usage_inconsistent' is
>  * set to 1 if the supplied and on-disk quota usage values are not =
identical.
>  */
> -errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
> +errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type =
qtype,
> 				   int *usage_inconsistent)
> {
> 	struct quota_handle qh;
> diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
> index 3af82f7..bd8123e 100644
> --- a/lib/support/quotaio.c
> +++ b/lib/support/quotaio.c
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
> +const char *quota_type2name(enum quota_type qtype)
> {
> -	return extensions[type];
> +	assert(qtype >=3D 0);
> +	assert(qtype < MAXQUOTAS);

These asserts might fail if there are ever callers that pass in the =
wrong
values (e.g. from disk, or from user code that links to e2fsprogs.  It
would be better to just handle invalid input more robustly, like:


const char *quota_type2name(enum quota_type qtype)
{
        if (qtype >=3D MAXQUOTAS || qtype < 0)
                return "unknown";

        return extensions[qtype];
}

> +	return extensions[qtype];
> +}
> +
> +ext2_ino_t quota_type2inum(enum quota_type qtype)
> +{
> +	assert(qtype >=3D 0);
> +	assert(qtype < MAXQUOTAS);

Since this is already returning 0 for invalid values and the callers are
already checking for that, these assert() checks could just be removed.

> +	switch (qtype) {
> +	case USRQUOTA:
> +		return EXT4_USR_QUOTA_INO;
> +		break;
> +	case GRPQUOTA:
> +		return EXT4_GRP_QUOTA_INO;
> +		break;
> +	default:
> +		return 0;
> +		break;
> +	}
> +	return 0;
> }
>=20
> /**
>  * Creates a quota file name for given type and format.
>  */
> -const char *quota_get_qf_name(int type, int fmt, char *buf)
> +const char *quota_get_qf_name(enum quota_type type, int fmt, char =
*buf)
> {
> 	if (!buf)
> 		return NULL;
> @@ -99,11 +120,16 @@ errcode_t quota_inode_truncate(ext2_filsys fs, =
ext2_ino_t ino)
> {
> 	struct ext2_inode inode;
> 	errcode_t err;
> +	enum quota_type qtype;
>=20
> 	if ((err =3D ext2fs_read_inode(fs, ino, &inode)))
> 		return err;
>=20
> -	if ((ino =3D=3D EXT4_USR_QUOTA_INO) || (ino =3D=3D =
EXT4_GRP_QUOTA_INO)) {
> +	for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +		if (ino =3D=3D quota_type2inum(qtype))
> +			break;
> +
> +	if (qtype !=3D MAXQUOTAS) {
> 		inode.i_dtime =3D fs->now ? fs->now : time(0);
> 		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
> 			return 0;
> @@ -183,14 +209,15 @@ static unsigned int quota_read_nomount(struct =
quota_file *qf,
>  * Detect quota format and initialize quota IO
>  */
> errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
> -			  ext2_ino_t qf_ino, int type, int fmt, int =
flags)
> +			  ext2_ino_t qf_ino, enum quota_type qtype,
> +			  int fmt, int flags)
> {
> 	ext2_filsys fs =3D qctx->fs;
> 	ext2_file_t e2_file;
> 	errcode_t err;
> 	int allocated_handle =3D 0;
>=20
> -	if (type >=3D MAXQUOTAS)
> +	if (qtype >=3D MAXQUOTAS)
> 		return EINVAL;
>=20
> 	if (fmt =3D=3D -1)
> @@ -200,14 +227,10 @@ errcode_t quota_file_open(quota_ctx_t qctx, =
struct quota_handle *h,
> 	if (err)
> 		return err;
>=20
> -	if (qf_ino =3D=3D 0) {
> -		if (type =3D=3D USRQUOTA)
> -			qf_ino =3D fs->super->s_usr_quota_inum;
> -		else
> -			qf_ino =3D fs->super->s_grp_quota_inum;
> -	}
> +	if (qf_ino =3D=3D 0)
> +		qf_ino =3D *quota_sb_inump(fs->super, qtype)
>=20
> -	log_debug("Opening quota ino=3D%lu, type=3D%d", qf_ino, type);
> +	log_debug("Opening quota ino=3D%lu, type=3D%d", qf_ino, qtype);
> 	err =3D ext2fs_file_open(fs, qf_ino, flags, &e2_file);
> 	if (err) {
> 		log_err("ext2fs_file_open failed: %s", =
error_message(err));
> @@ -215,8 +238,8 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct =
quota_handle *h,
> 	}
>=20
> 	if (!h) {
> -		if (qctx->quota_file[type]) {
> -			h =3D qctx->quota_file[type];
> +		if (qctx->quota_file[qtype]) {
> +			h =3D qctx->quota_file[qtype];
> 			if (((flags & EXT2_FILE_WRITE) =3D=3D 0) ||
> 			    (h->qh_file_flags & EXT2_FILE_WRITE))
> 				return 0;
> @@ -237,13 +260,13 @@ errcode_t quota_file_open(quota_ctx_t qctx, =
struct quota_handle *h,
> 	h->e2fs_read =3D quota_read_nomount;
> 	h->qh_file_flags =3D flags;
> 	h->qh_io_flags =3D 0;
> -	h->qh_type =3D type;
> +	h->qh_type =3D qtype;
> 	h->qh_fmt =3D fmt;
> 	memset(&h->qh_info, 0, sizeof(h->qh_info));
> 	h->qh_ops =3D &quotafile_ops_2;
>=20
> 	if (h->qh_ops->check_file &&
> -	    (h->qh_ops->check_file(h, type, fmt) =3D=3D 0)) {
> +	    (h->qh_ops->check_file(h, qtype, fmt) =3D=3D 0)) {
> 		log_err("qh_ops->check_file failed");
> 		goto errout;
> 	}
> @@ -253,7 +276,7 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct =
quota_handle *h,
> 		goto errout;
> 	}
> 	if (allocated_handle)
> -		qctx->quota_file[type] =3D h;
> +		qctx->quota_file[qtype] =3D h;
>=20
> 	return 0;
> errout:
> @@ -299,7 +322,8 @@ static errcode_t quota_inode_init_new(ext2_filsys =
fs, ext2_ino_t ino)
> /*
>  * Create new quotafile of specified format on given filesystem
>  */
> -errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, =
int type, int fmt)
> +errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
> +			    enum quota_type qtype, int fmt)
> {
> 	ext2_file_t e2_file;
> 	int err;
> @@ -309,11 +333,8 @@ errcode_t quota_file_create(struct quota_handle =
*h, ext2_filsys fs, int type, in
> 		fmt =3D QFMT_VFS_V1;
>=20
> 	h->qh_qf.fs =3D fs;
> -	if (type =3D=3D USRQUOTA)
> -		qf_inum =3D EXT4_USR_QUOTA_INO;
> -	else if (type =3D=3D GRPQUOTA)
> -		qf_inum =3D EXT4_GRP_QUOTA_INO;
> -	else
> +	qf_inum =3D quota_type2inum(qtype);
> +	if (qf_inum =3D=3D 0)
> 		return -1;
>=20
> 	err =3D ext2fs_read_bitmaps(fs);
> @@ -339,7 +360,7 @@ errcode_t quota_file_create(struct quota_handle =
*h, ext2_filsys fs, int type, in
> 	h->qh_qf.e2_file =3D e2_file;
>=20
> 	h->qh_io_flags =3D 0;
> -	h->qh_type =3D type;
> +	h->qh_type =3D qtype;
> 	h->qh_fmt =3D fmt;
> 	memset(&h->qh_info, 0, sizeof(h->qh_info));
> 	h->qh_ops =3D &quotafile_ops_2;
> diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
> index 9d580ae..fc114e2 100644
> --- a/lib/support/quotaio.h
> +++ b/lib/support/quotaio.h
> @@ -10,9 +10,9 @@
>  * {
>  *	quota_ctx_t qctx;
>  *
> - *	quota_init_context(&qctx, fs, -1);
> + *	quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
>  *	{
> - *		quota_compute_usage(qctx, -1);
> + *		quota_compute_usage(qctx, QUOTA_ALL_BIT);
>  *		AND/OR
>  *		quota_data_add/quota_data_sub/quota_data_inodes();
>  *	}
> @@ -43,9 +43,20 @@
>=20
> typedef int64_t qsize_t;	/* Type in which we store size =
limitations */
>=20
> +enum quota_type {
> +	USRQUOTA =3D 0,
> +	GRPQUOTA =3D 1,
> +};
> +
> #define MAXQUOTAS 2

This should be part of the enum quota_type so that it is always correct =
if
new quota types are added.

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
> typedef struct quota_ctx *quota_ctx_t;
> struct dict_t;
> @@ -104,7 +115,7 @@ struct quota_file {
>=20
> /* Structure for one opened quota file */
> struct quota_handle {
> -	int qh_type;		/* Type of quotafile */
> +	enum quota_type qh_type;	/* Type of quotafile */
> 	int qh_fmt;		/* Quotafile format */
> 	int qh_file_flags;
> 	int qh_io_flags;	/* IO flags for file */
> @@ -174,12 +185,13 @@ extern struct quotafile_ops quotafile_ops_meta;
> /* Open existing quotafile of given type (and verify its format) on =
given
>  * filesystem. */
> errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
> -			  ext2_ino_t qf_ino, int type, int fmt, int =
flags);
> +			  ext2_ino_t qf_ino, enum quota_type type,
> +			  int fmt, int flags);
>=20
>=20
> /* Create new quotafile of specified format on given filesystem */
> errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
> -			    int type, int fmt);
> +			    enum quota_type qtype, int fmt);
>=20
> /* Close quotafile */
> errcode_t quota_file_close(quota_ctx_t qctx, struct quota_handle *h);
> @@ -189,7 +201,8 @@ struct dquot *get_empty_dquot(void);
>=20
> errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
>=20
> -const char *type2name(int type);
> +const char *quota_type2name(enum quota_type qtype);
> +ext2_ino_t quota_type2inum(enum quota_type qtype);
>=20
> void update_grace_times(struct dquot *q);
>=20
> @@ -197,27 +210,41 @@ void update_grace_times(struct dquot *q);
>    than maxlen of extensions[] and fmtnames[] (plus 2) found in =
quotaio.c */
> #define QUOTA_NAME_LEN 16
>=20
> -const char *quota_get_qf_name(int type, int fmt, char *buf);
> +const char *quota_get_qf_name(enum quota_type qtype, int fmt, char =
*buf);
>=20
> /* In mkquota.c */
> -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int =
qtype);
> +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
> +			     unsigned int qtype_bits);
> void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, =
ext2_ino_t ino,
> 		int adjust);
> void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, =
ext2_ino_t ino,
> 		qsize_t space);
> void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, =
ext2_ino_t ino,
> 		qsize_t space);
> -errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
> -errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, =
int type);
> +errcode_t quota_write_inode(quota_ctx_t qctx, enum quota_type qtype);
> +errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
> +			      enum quota_type type);
> errcode_t quota_compute_usage(quota_ctx_t qctx);
> void quota_release_context(quota_ctx_t *qctx);
>=20
> -errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
> -int quota_file_exists(ext2_filsys fs, int qtype);
> -void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
> -errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
> -				   int *usage_inconsistent);
> -
> -
> +errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype);
> +int quota_file_exists(ext2_filsys fs, enum quota_type qtype);
> +void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, enum =
quota_type qtype);
> +errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type =
qtype,
> + 				   int *usage_inconsistent);
> +
> +static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb, =
enum quota_type qtype)

Wrap line at 80 columns.
> +{
> +	switch (qtype) {
> +		case USRQUOTA:
> +			return &sb->s_usr_quota_inum;
> +		case GRPQUOTA:
> +			return &sb->s_grp_quota_inum;
> +		default:
> +			return NULL;
> +	}
> +
> +	return NULL;
> +}
>=20
> #endif /* GUARD_QUOTAIO_H */
> diff --git a/lib/support/quotaio_tree.c b/lib/support/quotaio_tree.c
> index e7f3e95..2a85698 100644
> --- a/lib/support/quotaio_tree.c
> +++ b/lib/support/quotaio_tree.c
> @@ -587,7 +587,7 @@ static void check_reference(struct quota_handle =
*h, unsigned int blk)
> 			"Please run e2fsck (8) to fix it.",
> 			blk,
> 			h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
> -			type2name(h->qh_type));
> +			quota_type2name(h->qh_type));
> }
>=20
> static int report_tree(struct dquot *dquot, unsigned int blk, int =
depth,
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 179a4d1..5ead18e 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -95,7 +95,7 @@ static int	lazy_itable_init;
> static int	packed_meta_blocks;
> static char	*bad_blocks_filename =3D NULL;
> static __u32	fs_stride;
> -static int	quotatype =3D -1;  /* Initialize both user and group =
quotas by default */
> +static unsigned int quotatype_bits =3D QUOTA_ALL_BIT;  /* Initialize =
all quotas by default */

Wrap at 80 columns or move comment to previous line.

> static __u64	offset;
> static blk64_t journal_location =3D ~0LL;
> static int	proceed_delay =3D -1;
> @@ -1014,9 +1014,9 @@ static void parse_extended_opts(struct =
ext2_super_block *param,
> 				continue;
> 			}
> 			if (!strncmp(arg, "usr", 3)) {
> -				quotatype =3D 0;
> +				quotatype_bits =3D QUOTA_USR_BIT;
> 			} else if (!strncmp(arg, "grp", 3)) {
> -				quotatype =3D 1;
> +				quotatype_bits =3D QUOTA_GRP_BIT;

This works OK if there are only two types of quota, but not if there are
three types in the next patch, since it isn't possible for two of the
three different quota types to be enabled.

Either this needs to have a loop to parse a comma-separated list of =
values
like tune2fs.c:parse_quota_opts(), or use "strstr(arg, <type>);" for =
each
quota type ("usr", "grp", "prj"), so that it can appear anywhere in the
argument string.  This should reset quotatype_bits =3D 0 if this option =
is
given, and then find each option and "|=3D" the QUOTA_GRP_* bit in.

I don't think that there will be so many different quota types that =
there
is a danger of name collisions if strstr() is used.

> 			} else {
> 				fprintf(stderr,
> 					_("Invalid quotatype parameter: =
%s\n"),
> @@ -2669,9 +2669,9 @@ static int create_quota_inodes(ext2_filsys fs)
> {
> 	quota_ctx_t qctx;
>=20
> -	quota_init_context(&qctx, fs, -1);
> +	quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
> 	quota_compute_usage(qctx);
> -	quota_write_inode(qctx, quotatype);
> +	quota_write_inode(qctx, quotatype_bits);
> 	quota_release_context(&qctx);
>=20
> 	return 0;
> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> index f9ce38c..1684225 100644
> --- a/misc/tune2fs.c
> +++ b/misc/tune2fs.c
> @@ -95,7 +95,7 @@ static int stride_set, stripe_width_set;
> static char *extended_cmd;
> static unsigned long new_inode_size;
> static char *ext_mount_opts;
> -static int usrquota, grpquota;
> +static int quota_enable[MAXQUOTAS];
> static int rewrite_checksums;
> static int feature_64bit;
> static int fsck_requested;
> @@ -963,6 +963,7 @@ static int update_feature_set(ext2_filsys fs, char =
*features)
> 	int		type_err;
> 	unsigned int	mask_err;
> 	errcode_t	err;
> +	enum quota_type qtype;
>=20
> #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
> 				((&sb->s_feature_compat)[(type)] & =
(mask)))
> @@ -1279,9 +1280,9 @@ mmp_error:
> 		 */
> 		if (!Q_flag) {
> 			Q_flag =3D 1;
> -			/* Enable both user quota and group quota by =
default */
> -			usrquota =3D QOPT_ENABLE;
> -			grpquota =3D QOPT_ENABLE;
> +			/* Enable all quota by default */
> +			for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +				quota_enable[qtype] =3D QOPT_ENABLE;
> 		}
> 		sb->s_feature_ro_compat &=3D =
~EXT4_FEATURE_RO_COMPAT_QUOTA;
> 	}
> @@ -1296,9 +1297,9 @@ mmp_error:
> 			fputs(_("\nWarning: '^quota' option overrides =
'-Q'"
> 				"arguments.\n"), stderr);
> 		Q_flag =3D 1;
> -		/* Disable both user quota and group quota by default */
> -		usrquota =3D QOPT_DISABLE;
> -		grpquota =3D QOPT_DISABLE;
> +		/* Disable all quota by default */
> +		for (qtype =3D 0; qtype < MAXQUOTAS; qtype++)
> +			quota_enable[qtype] =3D QOPT_DISABLE;
> 	}
>=20
> 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, =
EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
> @@ -1421,42 +1422,51 @@ static void handle_quota_options(ext2_filsys =
fs)
> {
> 	quota_ctx_t qctx;
> 	ext2_ino_t qf_ino;
> +	enum quota_type qtype;
> +	int enable =3D 0;
>=20
> -	if (!usrquota && !grpquota)
> +	for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++)
> +		if (quota_enable[qtype] !=3D 0)
> +			break;
> +	if (qtype =3D=3D MAXQUOTAS)
> 		/* Nothing to do. */
> 		return;
>=20
> -	quota_init_context(&qctx, fs, -1);
> -
> -	if (usrquota =3D=3D QOPT_ENABLE || grpquota =3D=3D QOPT_ENABLE)
> -		quota_compute_usage(qctx);
> -
> -	if (usrquota =3D=3D QOPT_ENABLE && !fs->super->s_usr_quota_inum) =
{
> -		if ((qf_ino =3D quota_file_exists(fs, USRQUOTA)) > 0)
> -			quota_update_limits(qctx, qf_ino, USRQUOTA);
> -		quota_write_inode(qctx, USRQUOTA);
> -	} else if (usrquota =3D=3D QOPT_DISABLE) {
> -		quota_remove_inode(fs, USRQUOTA);
> +	quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
> +	for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++) {
> +		if (quota_enable[qtype] =3D=3D QOPT_ENABLE) {
> +			enable =3D 1;
> +			break;
> +		}
> 	}
> +	if (enable)
> +		quota_compute_usage(qctx);
>=20
> -	if (grpquota =3D=3D QOPT_ENABLE && !fs->super->s_grp_quota_inum) =
{
> -		if ((qf_ino =3D quota_file_exists(fs, GRPQUOTA)) > 0)
> -			quota_update_limits(qctx, qf_ino, GRPQUOTA);
> -		quota_write_inode(qctx, GRPQUOTA);
> -	} else if (grpquota =3D=3D QOPT_DISABLE) {
> -		quota_remove_inode(fs, GRPQUOTA);
> -	}
> +	for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++) {
> +		if (quota_enable[qtype] =3D=3D QOPT_ENABLE &&
> +		    *quota_sb_inump(fs->super, qtype) !=3D 0) {
> +			if ((qf_ino =3D quota_file_exists(fs, qtype)) > =
0)
> +				quota_update_limits(qctx, qf_ino, =
qtype);
> +			quota_write_inode(qctx, 1 << qtype);
> +		} else if (quota_enable[qtype] =3D=3D QOPT_DISABLE) {
> +			quota_remove_inode(fs, qtype);
> +		}
> + 	}
>=20
> 	quota_release_context(&qctx);
>=20
> -	if ((usrquota =3D=3D QOPT_ENABLE) || (grpquota =3D=3D =
QOPT_ENABLE)) {
> +	if (enable) {
> 		fs->super->s_feature_ro_compat |=3D =
EXT4_FEATURE_RO_COMPAT_QUOTA;
> 		ext2fs_mark_super_dirty(fs);
> -	} else if (!fs->super->s_usr_quota_inum &&
> -		   !fs->super->s_grp_quota_inum) {
> -		fs->super->s_feature_ro_compat &=3D =
~EXT4_FEATURE_RO_COMPAT_QUOTA;
> -		ext2fs_mark_super_dirty(fs);
> -	}
> +	} else {
> +		for (qtype =3D 0 ; qtype < MAXQUOTAS; qtype++)
> +			if (*quota_sb_inump(fs->super, qtype) !=3D 0)
> +				break;
> +		if (qtype =3D=3D MAXQUOTAS) {
> +			fs->super->s_feature_ro_compat &=3D =
~EXT4_FEATURE_RO_COMPAT_QUOTA;
> +			ext2fs_mark_super_dirty(fs);
> +		}
> + 	}
>=20
> 	return;
> }
> @@ -1483,13 +1493,13 @@ static void parse_quota_opts(const char *opts)

This function could move into lib/quota/ so that it can be used by =
mke2fs.c.

> 		}
>=20
> 		if (strcmp(token, "usrquota") =3D=3D 0) {
> -			usrquota =3D QOPT_ENABLE;
> +			quota_enable[USRQUOTA] =3D QOPT_ENABLE;
> 		} else if (strcmp(token, "^usrquota") =3D=3D 0) {
> -			usrquota =3D QOPT_DISABLE;
> +			quota_enable[USRQUOTA] =3D QOPT_DISABLE;
> 		} else if (strcmp(token, "grpquota") =3D=3D 0) {
> -			grpquota =3D QOPT_ENABLE;
> +			quota_enable[GRPQUOTA] =3D QOPT_ENABLE;
> 		} else if (strcmp(token, "^grpquota") =3D=3D 0) {
> -			grpquota =3D QOPT_DISABLE;
> +			quota_enable[GRPQUOTA] =3D QOPT_DISABLE;
> 		} else {
> 			fputs(_("\nBad quota options specified.\n\n"
> 				"Following valid quota options are =
available "
> --
> 1.7.1
>=20


Cheers, Andreas






--Apple-Mail=_E2E06F89-589F-4D65-BD91-E5B8C54CD0FC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmvpsnKl2rkXzB/gAQh2oRAAhGiQ/vaz1OsV6u4q04Bpdy/4ti6JafHV
rGtPsoD/5OcXPHvX2wn+PyEcT4cFRTpUe5Es/c9SodL9YWV4YNeb+91gNntoErEN
qCaPePk0xOrAh74dC/pQbQwv5EMOE5wz7kZcZc5Ij5UMHW0l0gmaL/b0ekPBt5uH
kJp+Cacyy+/AYeYZDCrQR0NBBcq+gmH9urgc3Zf5T+0Ho5IqelIuNUaKDgNR3aa2
9wP/QDVqfdYagnKwvs/uhLxtYH4lf87PN+rrctC5RgzmMmZWQ9TkSG5YEnPJ+AvQ
VYoHhWQrjDI4vp2HzFdRmVg7rMJG7TfrEC9Ssd+8plysVoSb/C+fi7CjKDewwWpL
0iXXoWV9CHXJr4u1y9pfbwiSEE3Qb0dpfruWdpq0ksLYDuVMz1bBvhhCyOjevtP7
1cpe4znVwV8FzVMkYtfFHK/fc0riygnhuVVLtLLVv7hzU4dJhIgSDtU7LSeGaDOm
lnLNlXppio7/7IY3obQ2vcyRPLyPgQRxbEPaiHHB5Eh9HBRFZftBWwTTqpbeMltw
KoGnvW2003uS7deYUlp1S9+9WvzFVzOf42skeY2IT/DM6e58no9MveOHH9ARxzBK
Ka3vL+I+AMNGP8cuQuwjHvU5x8tKsXdt2czBrs+OH5J9hhuLtvXv51PEfjzcQd5p
2e9HDk7eTts=
=gTTV
-----END PGP SIGNATURE-----

--Apple-Mail=_E2E06F89-589F-4D65-BD91-E5B8C54CD0FC--
