From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH v4] ext4: make quota as first class supported feature
Date: Fri, 9 Dec 2011 16:01:03 -0800
Message-ID: <CAGr1F2FWxJyjHFb92yYFxiWPu-pbwvCKprwkD5=5S+z7OSot_g@mail.gmail.com>
References: <1323474204-15465-1-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Aditya Kali <adityakali@google.com>
To: adilger@dilger.ca, tytso@mit.edu, dmonakhov@openvz.org,
	jack@suse.cz, johann@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58503 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1LJABZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2011 19:01:25 -0500
Received: by dajs34 with SMTP id s34so149464daj.19
        for <linux-ext4@vger.kernel.org>; Fri, 09 Dec 2011 16:01:25 -0800 (PST)
In-Reply-To: <1323474204-15465-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changes since v3:
- Fail mount if unable to load quotas at mount time
- Add ext4_quota_off_sysfile (quota-off function to be used when quota
inodes are hidden)
- Remove quota inode numbers from struct ext4_sb_info and use them
directly from sbi->s_es.
- Enable quotas on ro -> rw remount.


On Fri, Dec 9, 2011 at 3:43 PM, Aditya Kali <adityakali@google.com> wro=
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
> =C2=A0 'grpquota' are ignored by the kernel.
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
> =C2=A0fs/ext4/ext4.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A05 ++-
> =C2=A0fs/ext4/ext4_jbd2.h | =C2=A0 18 +++++--
> =C2=A0fs/ext4/super.c =C2=A0 =C2=A0 | =C2=A0130 +++++++++++++++++++++=
+++++++++++++++++++++++++++++-
> =C2=A03 files changed, 144 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5b0e26a..747e600 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1269,6 +1269,8 @@ static inline struct timespec ext4_current_time=
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
> @@ -1440,7 +1442,8 @@ static inline void ext4_clear_state_flags(struc=
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
> index 3858767..48267ba 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1239,12 +1239,18 @@ static int ext4_mark_dquot_dirty(struct dquot=
 *dquot);
> =C2=A0static int ext4_write_info(struct super_block *sb, int type);
> =C2=A0static int ext4_quota_on(struct super_block *sb, int type, int =
format_id,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 struct path *path);
> +static int ext4_quota_on_sysfile(struct super_block *sb, int type,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int format_id);
> =C2=A0static int ext4_quota_off(struct super_block *sb, int type);
> +static int ext4_quota_off_sysfile(struct super_block *sb, int type);
> =C2=A0static int ext4_quota_on_mount(struct super_block *sb, int type=
);
> =C2=A0static ssize_t ext4_quota_read(struct super_block *sb, int type=
, char *data,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size_t len, loff_t off);
> =C2=A0static ssize_t ext4_quota_write(struct super_block *sb, int typ=
e,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *data, size_t len,=
 loff_t off);
> +static int ext4_quota_enable(struct super_block *sb, int type, int f=
ormat_id,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int flags);
> +static int ext4_enable_quotas(struct super_block *sb);
>
> =C2=A0static const struct dquot_operations ext4_quota_operations =3D =
{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.get_reserved_space =3D ext4_get_reserved_=
space,
> @@ -1266,6 +1272,16 @@ static const struct quotactl_ops ext4_qctl_ope=
rations =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.get_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_g=
et_dqblk,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0.set_dqblk =C2=A0 =C2=A0 =C2=A0=3D dquot_s=
et_dqblk
> =C2=A0};
> +
> +static const struct quotactl_ops ext4_qctl_sysfile_operations =3D {
> + =C2=A0 =C2=A0 =C2=A0 .quota_on_meta =C2=A0=3D ext4_quota_on_sysfile=
,
> + =C2=A0 =C2=A0 =C2=A0 .quota_off =C2=A0 =C2=A0 =C2=A0=3D ext4_quota_=
off_sysfile,
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
> @@ -2713,6 +2729,16 @@ static int ext4_feature_set_ok(struct super_bl=
ock *sb, int readonly)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 "extents feature\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> +#ifndef CONFIG_QUOTA
> + =C2=A0 =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATUR=
E_RO_COMPAT_QUOTA) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !readonly) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_msg(sb, KERN_=
ERR,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0"Filesystem with quota feature cannot be mounted RDWR "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0"without CONFIG_QUOTA");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 }
> +#endif =C2=A0/* CONFIG_QUOTA */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
> =C2=A0}
>
> @@ -3610,6 +3636,11 @@ static int ext4_fill_super(struct super_block =
*sb, void *data, int silent)
> =C2=A0#ifdef CONFIG_QUOTA
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_qcop =3D &ext4_qctl_operations;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->dq_op =3D &ext4_quota_operations;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATUR=
E_RO_COMPAT_QUOTA)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Use qctl operat=
ions for hidden quota files. */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb->s_qcop =3D &ex=
t4_qctl_sysfile_operations;
> + =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(sb->s_uuid, es->s_uuid, sizeof(es->=
s_uuid));
>
> @@ -3815,6 +3846,16 @@ no_journal:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0descr =3D "out=
 journal";
>
> +#ifdef CONFIG_QUOTA
> + =C2=A0 =C2=A0 =C2=A0 /* Enable quota usage during mount. */
> + =C2=A0 =C2=A0 =C2=A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATUR=
E_RO_COMPAT_QUOTA) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !(sb->s_flags & MS_RDONLY)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D ext4_enabl=
e_quotas(sb);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto failed_mount7;
> + =C2=A0 =C2=A0 =C2=A0 }
> +#endif =C2=A0/* CONFIG_QUOTA */
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_msg(sb, KERN_INFO, "mounted filesyste=
m with%s. "
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Opts: %s%s%s=
", descr, sbi->s_es->s_mount_opts,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *sbi->s_es->s=
_mount_opts ? "; " : "", orig_data);
> @@ -4554,8 +4595,13 @@ static int ext4_remount(struct super_block *sb=
, int *flags, char *data)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0kfree(old_opts.s_qf_names[i]);
> =C2=A0#endif
> =C2=A0 =C2=A0 =C2=A0 =C2=A0unlock_super(sb);
> - =C2=A0 =C2=A0 =C2=A0 if (enable_quota)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dquot_resume(sb, -=
1);
> + =C2=A0 =C2=A0 =C2=A0 if (enable_quota) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sb_any_quota_s=
uspended(sb))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 dquot_resume(sb, -1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (EXT4_HAS_=
RO_COMPAT_FEATURE(sb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT4_FE=
ATURE_RO_COMPAT_QUOTA))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ext4_enable_quotas(sb);
I just realized that the ro -> rw remount should fail too if we are
unable to load quotas. I will fix this and send updated patch.
Sorry for the trouble.

> + =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ext4_msg(sb, KERN_INFO, "re-mounted. Opts:=
 %s", orig_data);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(orig_data);
> @@ -4814,6 +4860,74 @@ static int ext4_quota_on(struct super_block *s=
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
> + =C2=A0 =C2=A0 =C2=A0 int err;
> + =C2=A0 =C2=A0 =C2=A0 struct inode *qf_inode;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long qf_inums[MAXQUOTAS] =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le32_to_cpu(EXT4_S=
B(sb)->s_es->s_usr_quota_inum),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le32_to_cpu(EXT4_S=
B(sb)->s_es->s_grp_quota_inum)
> + =C2=A0 =C2=A0 =C2=A0 };
> +
> + =C2=A0 =C2=A0 =C2=A0 BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FE=
ATURE_RO_COMPAT_QUOTA));
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!qf_inums[type])
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EPERM;
> +
> + =C2=A0 =C2=A0 =C2=A0 qf_inode =3D ext4_iget(sb, qf_inums[type]);
> + =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(qf_inode)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_error(sb, "Ba=
d quota inode # %lu", qf_inums[type]);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return PTR_ERR(qf_=
inode);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 err =3D dquot_enable(qf_inode, type, format_id=
, flags);
> + =C2=A0 =C2=A0 =C2=A0 iput(qf_inode);
> +
> + =C2=A0 =C2=A0 =C2=A0 return err;
> +}
> +
> +/* Enable usage tracking for all quota types. */
> +static int ext4_enable_quotas(struct super_block *sb)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int type, err =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long qf_inums[MAXQUOTAS] =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le32_to_cpu(EXT4_S=
B(sb)->s_es->s_usr_quota_inum),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le32_to_cpu(EXT4_S=
B(sb)->s_es->s_grp_quota_inum)
> + =C2=A0 =C2=A0 =C2=A0 };
> +
> + =C2=A0 =C2=A0 =C2=A0 sb_dqopt(sb)->flags |=3D DQUOT_QUOTA_SYS_FILE;
> + =C2=A0 =C2=A0 =C2=A0 for (type =3D 0; type < MAXQUOTAS; type++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (qf_inums[type]=
) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 err =3D ext4_quota_enable(sb, type, QFMT_VFS_V1,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 DQUOT_USAGE_ENABLED);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (err) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ext4_warning(sb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Failed=
 to enable quota (type=3D%d) "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "tracki=
ng. Please run e2fsck to fix.",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 type);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return err;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/*
> + * quota_on function that is used when QUOTA feature is set.
> + */
> +static int ext4_quota_on_sysfile(struct super_block *sb, int type,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int format_id)
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
> @@ -4840,6 +4954,18 @@ out:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return dquot_quota_off(sb, type);
> =C2=A0}
>
> +/*
> + * quota_off function that is used when QUOTA feature is set.
> + */
> +static int ext4_quota_off_sysfile(struct super_block *sb, int type)
> +{
> + =C2=A0 =C2=A0 =C2=A0 if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATU=
RE_RO_COMPAT_QUOTA))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* Disable only the limits. */
> + =C2=A0 =C2=A0 =C2=A0 return dquot_disable(sb, type, DQUOT_LIMITS_EN=
ABLED);
> +}
> +
> =C2=A0/* Read data from quotafile - avoid pagecache and such because =
we cannot afford
> =C2=A0* acquiring the locks... As quota files are never truncated and=
 quota code
> =C2=A0* itself serializes the operations (and no one else should touc=
h the files)
> --
> 1.7.3.1
>



--=20
Aditya
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
