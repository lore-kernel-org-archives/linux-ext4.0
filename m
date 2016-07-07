From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: add project quota mount options
Date: Thu, 7 Jul 2016 12:15:47 -0600
Message-ID: <E7AC1134-CDB5-4C28-B3B6-E9B79F01E591@dilger.ca>
References: <1467875386-28092-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2C06686B-B139-4C6D-B433-879BC33502B2"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org, Shuichi Ihara <sihara@ddn.com>,
	lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36862 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcGGSPz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2016 14:15:55 -0400
Received: by mail-it0-f66.google.com with SMTP id h190so4073325ith.3
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jul 2016 11:15:54 -0700 (PDT)
In-Reply-To: <1467875386-28092-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2C06686B-B139-4C6D-B433-879BC33502B2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 7, 2016, at 1:09 AM, Wang Shilong <wangshilong1991@gmail.com> =
wrote:
>=20
> From: Wang Shilong <wshilong@ddn.com>
>=20
> add prjquota, prjjquota, offprjjquota mount options
> for project quota.
>=20
> These kind of mount options are used for old
> quota design, and we can use quotas like these
> way:
>=20
> # mkfs.ext4 /dev/sda
> # mount /dev/sda -o prjquota /mnt/test
> # quotacheck -p /mnt/test
> # quotaon /mnt/test
>=20
> This new mount options are also useful to unify
> some generic tests for xfs and ext4.
>=20
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
> fs/ext4/ext4.h   |  1 +
> fs/ext4/ialloc.c |  4 ++--
> fs/ext4/inode.c  |  7 ++-----
> fs/ext4/ioctl.c  |  6 ++++--
> fs/ext4/super.c  | 43 +++++++++++++++++++++++++++++++++----------
> 5 files changed, 42 insertions(+), 19 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b84aa1c..315838a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1129,6 +1129,7 @@ struct ext4_inode_info {
> #define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control =
Lists */
> #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc =
mapping */
> #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
> +#define EXT4_MOUNT_PRJQUOTA		0x40000 /* "old" project quota =
*/
> #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set =
*/
> #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
> #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 3da4cf8..f7209fc 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -802,8 +802,8 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> 	} else
> 		inode_init_owner(inode, dir, mode);
>=20
> -	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, =
EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> -	    ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT))
> +	if ((EXT4_HAS_RO_COMPAT_FEATURE(sb, =
EXT4_FEATURE_RO_COMPAT_PROJECT) ||
> +	     test_opt(sb, PRJQUOTA)) && ext4_test_inode_flag(dir, =
EXT4_INODE_PROJINHERIT))

(style) line over 80 columns

It might be easier to change the code to enable the PRJQUOTA mount =
option
when EXT4_FEATURE_RO_COMPAT_PROJECT is in the superblock, and then check
only test_opt(sb, PRJQUOTA) in the code instead of checking both.

Cheers, Andreas

> 		ei->i_projid =3D EXT4_I(dir)->i_projid;
> 	else
> 		ei->i_projid =3D make_kprojid(&init_user_ns, =
EXT4_DEF_PROJID);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f7140ca..c407f9b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4385,7 +4385,8 @@ static inline void ext4_iget_extra_inode(struct =
inode *inode,
>=20
> int ext4_get_projid(struct inode *inode, kprojid_t *projid)
> {
> -	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, =
EXT4_FEATURE_RO_COMPAT_PROJECT))
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, =
EXT4_FEATURE_RO_COMPAT_PROJECT)
> +	     && !test_opt(inode->i_sb, PRJQUOTA))
> 		return -EOPNOTSUPP;
> 	*projid =3D EXT4_I(inode)->i_projid;
> 	return 0;
> @@ -4856,10 +4857,6 @@ static int ext4_do_update_inode(handle_t =
*handle,
> 		}
> 	}
>=20
> -	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> -			EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> -	       i_projid !=3D EXT4_DEF_PROJID);
> -
> 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> 	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
> 		raw_inode->i_projid =3D cpu_to_le32(i_projid);
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index b5a39b0..6062a81 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -311,7 +311,8 @@ static int ext4_ioctl_setproject(struct file =
*filp, __u32 projid)
> 	struct dquot *transfer_to[MAXQUOTAS] =3D { };
>=20
> 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> -			EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +			EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> +	    !test_opt(sb, PRJQUOTA)) {
> 		if (projid !=3D EXT4_DEF_PROJID)
> 			return -EOPNOTSUPP;
> 		else
> @@ -849,7 +850,8 @@ encryption_policy_out:
> 		fa.fsx_xflags =3D ext4_iflags_to_xflags(ei->i_flags & =
EXT4_FL_USER_VISIBLE);
>=20
> 		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> -				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
> +				EXT4_FEATURE_RO_COMPAT_PROJECT) ||
> +		    test_opt(inode->i_sb, PRJQUOTA)) {
> 			fa.fsx_projid =3D =
(__u32)from_kprojid(&init_user_ns,
> 				EXT4_I(inode)->i_projid);
> 		}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3822a5a..93a776f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1184,10 +1184,10 @@ enum {
> 	Opt_journal_path, Opt_journal_checksum, =
Opt_journal_async_commit,
> 	Opt_abort, Opt_data_journal, Opt_data_ordered, =
Opt_data_writeback,
> 	Opt_data_err_abort, Opt_data_err_ignore, =
Opt_test_dummy_encryption,
> -	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, =
Opt_offgrpjquota,
> -	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
> -	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
> -	Opt_usrquota, Opt_grpquota, Opt_i_version, Opt_dax,
> +	Opt_usrjquota, Opt_grpjquota, Opt_prjjquota, Opt_offusrjquota,
> +	Opt_offgrpjquota, Opt_offprjjquota, Opt_jqfmt_vfsold, =
Opt_jqfmt_vfsv0,
> +	 Opt_jqfmt_vfsv1, Opt_quota, Opt_noquota, Opt_barrier, =
Opt_nobarrier,
> +	Opt_err, Opt_usrquota, Opt_grpquota, Opt_prjquota, =
Opt_i_version, Opt_dax,
> 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
> 	Opt_lazytime, Opt_nolazytime,
> 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
> @@ -1240,6 +1240,8 @@ static const match_table_t tokens =3D {
> 	{Opt_usrjquota, "usrjquota=3D%s"},
> 	{Opt_offgrpjquota, "grpjquota=3D"},
> 	{Opt_grpjquota, "grpjquota=3D%s"},
> +	{Opt_prjjquota, "prjjquota=3D%s"},
> +	{Opt_offprjjquota, "prjjquota=3D"},
> 	{Opt_jqfmt_vfsold, "jqfmt=3Dvfsold"},
> 	{Opt_jqfmt_vfsv0, "jqfmt=3Dvfsv0"},
> 	{Opt_jqfmt_vfsv1, "jqfmt=3Dvfsv1"},
> @@ -1250,6 +1252,7 @@ static const match_table_t tokens =3D {
> 	{Opt_barrier, "barrier=3D%u"},
> 	{Opt_barrier, "barrier"},
> 	{Opt_nobarrier, "nobarrier"},
> +	{Opt_prjquota, "prjquota"},
> 	{Opt_i_version, "i_version"},
> 	{Opt_dax, "dax"},
> 	{Opt_stripe, "stripe=3D%u"},
> @@ -1466,12 +1469,17 @@ static const struct mount_opts {
> 							MOPT_SET | =
MOPT_Q},
> 	{Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
> 							MOPT_SET | =
MOPT_Q},
> +	{Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
> +							MOPT_SET | =
MOPT_Q},
> 	{Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
> -		       EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
> +		       EXT4_MOUNT_GRPQUOTA | EXT4_MOUNT_PRJQUOTA),
> +		       MOPT_CLEAR | MOPT_Q},
> 	{Opt_usrjquota, 0, MOPT_Q},
> 	{Opt_grpjquota, 0, MOPT_Q},
> +	{Opt_prjjquota, 0, MOPT_Q},
> 	{Opt_offusrjquota, 0, MOPT_Q},
> 	{Opt_offgrpjquota, 0, MOPT_Q},
> +	{Opt_offprjjquota, 0, MOPT_Q},
> 	{Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},
> 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
> 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
> @@ -1495,10 +1503,14 @@ static int handle_mount_opt(struct super_block =
*sb, char *opt, int token,
> 		return set_qf_name(sb, USRQUOTA, &args[0]);
> 	else if (token =3D=3D Opt_grpjquota)
> 		return set_qf_name(sb, GRPQUOTA, &args[0]);
> +	else if (token =3D=3D Opt_prjjquota)
> +		return set_qf_name(sb, PRJQUOTA, &args[0]);
> 	else if (token =3D=3D Opt_offusrjquota)
> 		return clear_qf_name(sb, USRQUOTA);
> 	else if (token =3D=3D Opt_offgrpjquota)
> 		return clear_qf_name(sb, GRPQUOTA);
> +	else if (token =3D=3D Opt_offprjjquota)
> +		return clear_qf_name(sb, PRJQUOTA);
> #endif
> 	switch (token) {
> 	case Opt_noacl:
> @@ -1757,19 +1769,26 @@ static int parse_options(char *options, struct =
super_block *sb,
> 	}
> #ifdef CONFIG_QUOTA
> 	if (ext4_has_feature_quota(sb) &&
> -	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
> -		ext4_msg(sb, KERN_INFO, "Quota feature enabled, usrquota =
and grpquota "
> +	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA) ||
> +	     test_opt(sb, PRJQUOTA))) {
> +		ext4_msg(sb, KERN_INFO, "Quota feature enabled, =
usrquota,grpquota,prjquota "
> 			 "mount options ignored.");
> 		clear_opt(sb, USRQUOTA);
> 		clear_opt(sb, GRPQUOTA);
> -	} else if (sbi->s_qf_names[USRQUOTA] || =
sbi->s_qf_names[GRPQUOTA]) {
> +		clear_opt(sb, PRJQUOTA);
> +	} else if (sbi->s_qf_names[USRQUOTA] || =
sbi->s_qf_names[GRPQUOTA] ||
> +		   sbi->s_qf_names[PRJQUOTA]) {
> 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
> 			clear_opt(sb, USRQUOTA);
>=20
> 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
> 			clear_opt(sb, GRPQUOTA);
>=20
> -		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
> +		if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
> +			clear_opt(sb, GRPQUOTA);
> +
> +		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA) ||
> +		    test_opt(sb, PRJQUOTA)) {
> 			ext4_msg(sb, KERN_ERR, "old and new quota "
> 					"format mixing");
> 			return 0;
> @@ -1829,6 +1848,9 @@ static inline void =
ext4_show_quota_options(struct seq_file *seq,
>=20
> 	if (sbi->s_qf_names[GRPQUOTA])
> 		seq_show_option(seq, "grpjquota", =
sbi->s_qf_names[GRPQUOTA]);
> +
> +	if (sbi->s_qf_names[PRJQUOTA])
> +		seq_show_option(seq, "prjjquota", =
sbi->s_qf_names[PRJQUOTA]);
> #endif
> }
>=20
> @@ -4992,7 +5014,8 @@ static int ext4_mark_dquot_dirty(struct dquot =
*dquot)
>=20
> 	/* Are we journaling quotas? */
> 	if (ext4_has_feature_quota(sb) ||
> -	    sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
> +	    sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA] ||
> +	    sbi->s_qf_names[PRJQUOTA]) {
> 		dquot_mark_dquot_dirty(dquot);
> 		return ext4_write_dquot(dquot);
> 	} else {
> --
> 2.7.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2C06686B-B139-4C6D-B433-879BC33502B2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV36cVXKl2rkXzB/gAQj+YxAAv05GLwgaTVYLqoZJdPvzv6Xsst2XmXIu
hUNoAVudWWrgDv6O8jruUDJm9/9NrcqqCAyjEirDncgJjJMwpK9SHpZvwUB88G+Z
FEy1Ezzq7yOs9egt/rEtPcCUJsUdAJb82admc94SIN0Gsy0+MFdLCWdFfzvqiAhY
JBTdtm0RT/0zaYMI+R9a+JUmCV3Q2bhYtUwEaYucw55zjkpMLs/bmwXiSlkvVzEq
g/vh6Xs5qH8yYYvNqU8goDbVVKUPENwXIJfeclSrbCLXUpXK247bOu0dGe/8NmU9
zUG+EGQNc4zuMARA6ujOFT9D/lpEtV8GYK54VtBQwBKrOh9QdqM11JnkmB0OomTy
OxrrBeOK0+VDrViX275cR86IVASnb5eKl257roe0xUUs/BYrlmwx4cola2NBMelc
GKzAlf9dzEN2CJfjtuJIbcV6l0W3iuA5jiel5IuD/aDk8GhTHg6Kkp1MbuEUguWO
SsOoz59efNWv8ekhhuvOCnTLY8eftAwtXILg2qmbam6Y4ScYSF0X4mhaUFmQUNf4
rUn3ylySbajLQqbnJPfTf6NaBJrQCYC/2wBAxwWNwKReJkmj27kjuJfbHd/q2l0R
PA3LNsNzCysYLxSx61g2xa6K6TXUGt6pJppsDB5jCMN8rQm3kc5wUj4bDAQOvELh
FPSUDwa6+5Q=
=Z6x7
-----END PGP SIGNATURE-----

--Apple-Mail=_2C06686B-B139-4C6D-B433-879BC33502B2--
