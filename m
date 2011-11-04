From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH v3] ext4: make quota as first class supported feature
Date: Thu, 3 Nov 2011 19:17:25 -0700
Message-ID: <CAGr1F2GOLBR0BKHP0t33cshJ65176tKoT9sUuSJBbaPKtEFj8A@mail.gmail.com>
References: <1320372920-21308-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Aditya Kali <adityakali@google.com>
To: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64526 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1KDCRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2011 22:17:47 -0400
Received: by iage36 with SMTP id e36so2020259iag.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Nov 2011 19:17:47 -0700 (PDT)
In-Reply-To: <1320372920-21308-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This version of the patch enables only the quota usage tracking at
mount time as suggested in previous patch. The quota limits
enforcement is turned on by calling quotaon quotactl.


On Thu, Nov 3, 2011 at 7:15 PM, Aditya Kali <adityakali@google.com> wro=
te:
> This patch is an attempt towards supporting quotas as first class
> feature in ext4. It is based on the proposal at:
> https://ext4.wiki.kernel.org/index.php/Design_For_1st_Class_Quota_in_=
Ext4
> This patch introduces a new feature - EXT4_FEATURE_RO_COMPAT_QUOTA wh=
ich, when
> turned on, enables quota accounting at mount time iteself. Also, the
> quota inodes are stored in two additional superblock fields.
> Some changes introduced by this patch that should be pointed out are:
> 1) Two new ext4-superblock fields - s_usr_quota_inum and s_grp_quota_=
inum
> =C2=A0 for storing the quota inodes in use.
> 2) Default quota inodes are: inode#3 for tracking userquota and inode=
#4 for
> =C2=A0 tracking group quota. The superblock fields can be set to use =
other inodes
> =C2=A0 as well.
> 3) If the QUOTA feature and corresponding quota inodes are set in sup=
erblock,
> =C2=A0 the quota usage tracking is turned on at mount time. On 'quota=
on' ioctl, the
> =C2=A0 quota limits enforcement is turned on. 'quotaoff' ioctl turns =
off only the
> =C2=A0 limits enforcement in this case.
> 4) When QUOTA feature is in use, the quota mount options 'quota', 'us=
rquota',
> =C2=A0 'grpquota' are ignored by the kernel..
> 5) mke2fs or tune2fs can be used to set the QUOTA feature and initial=
ize quota
> =C2=A0 inodes. The default reserved inodes will not be visible to use=
r as
> =C2=A0 regular files.
> 6) The quota-tools will need to be modified to support hidden quota f=
iles on
> =C2=A0 ext4. E2fsprogs will also include support for creating and fix=
ing quota
> =C2=A0 files.
> 7) Support is only for the new V2 quota file format.
>
> Signed-off-by: Aditya Kali <adityakali@google.com>
> ---
> =C2=A0fs/ext4/ext4.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A06 ++-
> =C2=A0fs/ext4/ext4_jbd2.h | =C2=A0 18 ++++++---
> =C2=A0fs/ext4/super.c =C2=A0 =C2=A0 | =C2=A0107 +++++++++++++++++++++=
++++++++++++++++++++++++++++--
> =C2=A03 files changed, 120 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5b0e26a..dccfe65 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1170,6 +1170,7 @@ struct ext4_sb_info {
> =C2=A0#ifdef CONFIG_QUOTA
> =C2=A0 =C2=A0 =C2=A0 =C2=A0char *s_qf_names[MAXQUOTAS]; =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Names of quota files with journalled quo=
ta */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int s_jquota_fmt; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Format of quota=
 to use */
> + =C2=A0 =C2=A0 =C2=A0 unsigned long s_qf_inums[MAXQUOTAS]; =C2=A0 =C2=
=A0/* Quota file inodes */
> =C2=A0#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int s_want_extra_isize; /* New in=
odes should reserve # bytes */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct rb_root system_blks;
> @@ -1269,6 +1270,8 @@ static inline struct timespec ext4_current_time=
(struct inode *inode)
> =C2=A0static inline int ext4_valid_inum(struct super_block *sb, unsig=
ned long ino)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return ino =3D=3D EXT4_ROOT_INO ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ino =3D=3D EXT4_US=
R_QUOTA_INO ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ino =3D=3D EXT4_GR=
P_QUOTA_INO ||
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ino =3D=3D EXT=
4_JOURNAL_INO ||
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ino =3D=3D EXT=
4_RESIZE_INO ||
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ino >=3D EXT4=
_FIRST_INO(sb) &&
> @@ -1440,7 +1443,8 @@ static inline void ext4_clear_state_flags(struc=
t ext4_inode_info *ei)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0E=
XT4_FEATURE_RO_COMPAT_BIGALLOC)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0E=
XT4_FEATURE_RO_COMPAT_BIGALLOC | \
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0E=
XT4_FEATURE_RO_COMPAT_QUOTA)
>
> =C2=A0/*
> =C2=A0* Default values for user and/or group using reserved blocks
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 5802fa1..45de190 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -87,14 +87,20 @@
> =C2=A0#ifdef CONFIG_QUOTA
> =C2=A0/* Amount of blocks needed for quota update - we know that the =
structure was
> =C2=A0* allocated so we need to update only data block */
> -#define EXT4_QUOTA_TRANS_BLOCKS(sb) (test_opt(sb, QUOTA) ? 1 : 0)
> +#define EXT4_QUOTA_TRANS_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_HAS_RO_COMPAT=
_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 : 0)
> =C2=A0/* Amount of blocks needed for quota insert/delete - we do some=
 block writes
> =C2=A0* but inode, sb and group updates are done only once */
> -#define EXT4_QUOTA_INIT_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_INI=
T_ALLOC*\
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (EXT4_SINGLEDATA_T=
RANS_BLOCKS(sb)-3)+3+DQUOT_INIT_REWRITE) : 0)
> -
> -#define EXT4_QUOTA_DEL_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_DEL_=
ALLOC*\
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (EXT4_SINGLEDATA_T=
RANS_BLOCKS(sb)-3)+3+DQUOT_DEL_REWRITE) : 0)
> +#define EXT4_QUOTA_INIT_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_HAS_RO_COMPAT=
_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (DQUOT_INIT_ALLOC*=
(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+3+DQUOT_INI=
T_REWRITE) : 0)
> +
> +#define EXT4_QUOTA_DEL_BLOCKS(sb) ((test_opt(sb, QUOTA) ||\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_HAS_RO_COMPAT=
_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA)) ?\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (DQUOT_DEL_ALLOC*(=
EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+3+DQUOT_DEL=
_REWRITE) : 0)
> =C2=A0#else
> =C2=A0#define EXT4_QUOTA_TRANS_BLOCKS(sb) 0
> =C2=A0#define EXT4_QUOTA_INIT_BLOCKS(sb) 0
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9953d80..eb40645 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1239,6 +1239,9 @@ static int ext4_mark_dquot_dirty(struct dquot *=
dquot);
> =C2=A0static int ext4_write_info(struct super_block *sb, int type);
> =C2=A0static int ext4_quota_on(struct super_block *sb, int type, int =
format_id,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 struct path *path);
> +static int ext4_quota_on_meta(struct super_block *sb, int type, int =
format_id);
> +static int ext4_quota_enable(struct super_block *sb, int type, int f=
ormat_id,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int flags);
> =C2=A0static int ext4_quota_off(struct super_block *sb, int type);
> =C2=A0static int ext4_quota_on_mount(struct super_block *sb, int type=
);
> =C2=A0static ssize_t ext4_quota_read(struct super_block *sb, int type=
, char *data,
> @@ -1266,6 +1269,16 @@ static const struct quotactl_ops ext4_qctl_ope=
rations =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.get_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_g=
et_dqblk,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.set_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_s=
et_dqblk
> =C2=A0};
> +
> +static const struct quotactl_ops ext4_new_qctl_operations =3D {
> + =C2=A0 =C2=A0 =C2=A0 .quota_on_meta =C2=A0=3D ext4_quota_on_meta,
> + =C2=A0 =C2=A0 =C2=A0 .quota_off =C2=A0 =C2=A0 =C2=A0=3D ext4_quota_=
off,
> + =C2=A0 =C2=A0 =C2=A0 .quota_sync =C2=A0 =C2=A0 =3D dquot_quota_sync=
,
> + =C2=A0 =C2=A0 =C2=A0 .get_info =C2=A0 =C2=A0 =C2=A0 =3D dquot_get_d=
qinfo,
> + =C2=A0 =C2=A0 =C2=A0 .set_info =C2=A0 =C2=A0 =C2=A0 =3D dquot_set_d=
qinfo,
> + =C2=A0 =C2=A0 =C2=A0 .get_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_get_d=
qblk,
> + =C2=A0 =C2=A0 =C2=A0 .set_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_set_d=
qblk
> +};
> =C2=A0#endif
>
> =C2=A0static const struct super_operations ext4_sops =3D {
> @@ -3610,6 +3623,15 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> =C2=A0#ifdef CONFIG_QUOTA
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_qcop =3D &ext4_qctl_operations;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->dq_op =3D &ext4_quota_operations;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATUR=
E_RO_COMPAT_QUOTA)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Use new qctl op=
erations with quota on function that does not
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* require us=
er specified quota file path. */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_qcop =3D &ex=
t4_new_qctl_operations;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_qf_inums[US=
RQUOTA] =3D es->s_usr_quota_inum;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sbi->s_qf_inums[GR=
PQUOTA] =3D es->s_grp_quota_inum;
> + =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(sb->s_uuid, es->s_uuid, sizeof(es->=
s_uuid));
>
> @@ -3815,8 +3837,21 @@ no_journal:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0descr =3D "out=
 journal";
>
> - =C2=A0 =C2=A0 =C2=A0 ext4_msg(sb, KERN_INFO, "mounted filesystem wi=
th%s. "
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Opts: %s%s%=
s", descr, sbi->s_es->s_mount_opts,
> +#ifdef CONFIG_QUOTA
> + =C2=A0 =C2=A0 =C2=A0 /* Enable quota usage during mount. */
> + =C2=A0 =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATUR=
E_RO_COMPAT_QUOTA) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !(sb->s_flags & MS_RDONLY)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_quota_enable(=
sb, USRQUOTA, QFMT_VFS_V1,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DQUOT_USAGE_ENABLED);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_quota_enable(=
sb, GRPQUOTA, QFMT_VFS_V1,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DQUOT_USAGE_ENABLED);
> + =C2=A0 =C2=A0 =C2=A0 }
> +#endif =C2=A0/* CONFIG_QUOTA */
> +
> + =C2=A0 =C2=A0 =C2=A0 ext4_msg(sb, KERN_INFO, "mounted filesystem wi=
th%s. quota=3D%s. "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Opts: %s%s%=
s", descr,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb_any_quota=
_loaded(sb) ? "on" : "off",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sbi->s_es->s=
_mount_opts,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *sbi->s_es->s=
_mount_opts ? "; " : "", orig_data);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (es->s_error_count)
> @@ -4183,6 +4218,12 @@ static int ext4_commit_super(struct super_bloc=
k *sb, int sync)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0es->s_free_inodes_count =3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_le32(pe=
rcpu_counter_sum_positive(
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&EXT4_SB(sb)->s_freeinodes_co=
unter));
> +#ifdef CONFIG_QUOTA
> + =C2=A0 =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATUR=
E_RO_COMPAT_QUOTA)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 es->s_usr_quota_in=
um =3D EXT4_SB(sb)->s_qf_inums[USRQUOTA];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 es->s_grp_quota_in=
um =3D EXT4_SB(sb)->s_qf_inums[GRPQUOTA];
> + =C2=A0 =C2=A0 =C2=A0 }
> +#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_dirt =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0BUFFER_TRACE(sbh, "marking dirty");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mark_buffer_dirty(sbh);
> @@ -4775,7 +4816,7 @@ static int ext4_quota_on_mount(struct super_blo=
ck *sb, int type)
> =C2=A0* Standard function to be called on quota_on
> =C2=A0*/
> =C2=A0static int ext4_quota_on(struct super_block *sb, int type, int =
format_id,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0struct path *path)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 struct path *path)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int err;
>
> @@ -4814,6 +4855,59 @@ static int ext4_quota_on(struct super_block *s=
b, int type, int format_id,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return dquot_quota_on(sb, type, format_id,=
 path);
> =C2=A0}
>
> +static int ext4_quota_enable(struct super_block *sb, int type, int f=
ormat_id,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int flags)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct ext4_sb_info *sbi =3D EXT4_SB(sb);
> + =C2=A0 =C2=A0 =C2=A0 struct inode *qf_inode;
> + =C2=A0 =C2=A0 =C2=A0 int err;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!sbi->s_qf_inums[type])
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EPERM;
> +
> + =C2=A0 =C2=A0 =C2=A0 qf_inode =3D ext4_iget(sb, sbi->s_qf_inums[typ=
e]);
> + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(qf_inode)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_error(sb, "Ba=
d quota inode # %lu", sbi->s_qf_inums[type]);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR(qf_=
inode);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* When we journal data on quota file, we=
 have to flush journal to see
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* all updates to the file when we bypass=
 pagecache...
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if (sbi->s_journal &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_should_journal_data(qf_inod=
e)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* We don't n=
eed to lock updates but journal_flush() could
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* otherwise =
be livelocked...
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jbd2_journal_lock_=
updates(sbi->s_journal);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D jbd2_journ=
al_flush(sbi->s_journal);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jbd2_journal_unloc=
k_updates(sbi->s_journal);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (err)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return err;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 err =3D dquot_enable(qf_inode, type, format_id=
, flags);
> + =C2=A0 =C2=A0 =C2=A0 iput(qf_inode);
> +
> + =C2=A0 =C2=A0 =C2=A0 return err;
> +}
> +
> +/*
> + * New quota_on function that is used when QUOTA feature is set.
> + */
> +static int ext4_quota_on_meta(struct super_block *sb, int type, int =
format_id)
> +{
> + =C2=A0 =C2=A0 =C2=A0 if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATU=
RE_RO_COMPAT_QUOTA))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* USAGE was enabled at mount time. Only =
need to enable LIMITS now.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 return ext4_quota_enable(sb, type, format_id, =
DQUOT_LIMITS_ENABLED);
> +}
> +
> =C2=A0static int ext4_quota_off(struct super_block *sb, int type)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D sb_dqopt(sb)->file=
s[type];
> @@ -4837,7 +4931,12 @@ static int ext4_quota_off(struct super_block *=
sb, int type)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_journal_stop(handle);
>
> =C2=A0out:
> - =C2=A0 =C2=A0 =C2=A0 return dquot_quota_off(sb, type);
> + =C2=A0 =C2=A0 =C2=A0 /* Disable only the limits if QUOTA feature is=
 set. */
> + =C2=A0 =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATUR=
E_RO_COMPAT_QUOTA))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return dquot_disab=
le(sb, type, DQUOT_LIMITS_ENABLED);
> + =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return dquot_disab=
le(sb, type,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DQUOT_USAGE_ENABLED | DQUOT_LIMITS_=
ENABLED);
> =C2=A0}
>
> =C2=A0/* Read data from quotafile - avoid pagecache and such because =
we cannot afford
> --
> 1.7.3.1
>
>



--=20
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
